# book <title>
#
# Kindle の本を1冊、画像化 → OCR → Cosense プロジェクト作成 → 章まとめ生成 → まとめの公開
# まで通しで実行する。
#
# 状態はすべてファイルシステムに置く。各工程は「出力が既にあるならスキップ」で判定するので、
# 途中で失敗しても同じコマンドを叩き直せば続きから再開する。

usage() {
  cat <<'EOS'
book - Kindle の本を Cosense に流し込む

Usage:
  book <title>

Arguments:
  <title>   本のタイトル。kindle2image の出力ディレクトリ名、pdf2cosense の
            workspace 内ディレクトリ名、zatsu の books/<title> にそのまま使われる。

工程 (それぞれ出力が揃っていればスキップ):
  1 capture    kindle2image  → out/<title>/*.png
  2 stage      mv            → pdf2cosense/workspace/<title>/
  3 convert    pdf2cosense   → .isbn / .project / <title>-ocr.json / Cosense プロジェクト
  4 summarize  claude        → zatsu/books/<title>/chapters/ch*.md
  5 publish    md2cosense    → Cosense プロジェクトへアップロード
  6 archive    mv            → 作業ディレクトリを workspace から退避

Environment:
  BOOK_KINDLE2IMAGE_DIR   default: $(ghq root)/github.com/mrsekut/kindle2image
  BOOK_PDF2COSENSE_DIR    default: $(ghq root)/github.com/mrsekut/pdf2cosense
  BOOK_ZATSU_DIR          default: $(ghq root)/github.com/mrsekut/zatsu
  BOOK_STATE_DIR          default: ${XDG_STATE_HOME:-~/.local/state}/book
                          完了マーカーの置き場。消えると工程1からやり直しになるので
                          永続する場所に置くこと。
  BOOK_ARCHIVE_DIR        default: /tmp/book-archive
                          退避したページ画像と OCR JSON の置き場 (1冊 100MB 前後)。
                          macOS は /private/tmp を起動時に空にするので、再起動までの
                          猶予つきで自動的に消える。永久に残したいなら別の場所を指定する。
  BOOK_FORCE=1            完了済みでも最初から確認し直す

1 と 3 は画面を操作する (Kindle アプリの前面化、Playwright によるブラウザ操作)。
投げっぱなしにはできないので、そばにいること。
EOS
}

# --- 引数 -------------------------------------------------------------------

case "${1:-}" in
  -h | --help)
    usage
    exit 0
    ;;
esac

if [ $# -ne 1 ]; then
  usage >&2
  exit 1
fi

title="$1"

case "$title" in
  '' | */* | .*)
    echo "book: タイトルに / や先頭の . は使えない: $title" >&2
    exit 1
    ;;
esac

# --- パス -------------------------------------------------------------------

base="$(ghq root)/github.com/mrsekut"
k2i="${BOOK_KINDLE2IMAGE_DIR:-$base/kindle2image}"
p2c="${BOOK_PDF2COSENSE_DIR:-$base/pdf2cosense}"
zatsu="${BOOK_ZATSU_DIR:-$base/zatsu}"
state="${BOOK_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/book}"
# 実体は再起動で消えてよいが、完了マーカーは消えては困る (工程1の再キャプチャに戻る)
archive_root="${BOOK_ARCHIVE_DIR:-/tmp/book-archive}"

ws="$p2c/workspace"
image_dir="$ws/$title"
json_path="$ws/$title-ocr.json"
book_dir="$zatsu/books/$title"
chapters_dir="$book_dir/chapters"
published_marker="$state/$title/published"
archive_dir="$archive_root/$title"

# --- 出力 -------------------------------------------------------------------

step() { printf '\n\033[1;34m[%s]\033[0m %s\n' "$1" "$2"; }
skip() { printf '\033[2m  skip: %s\033[0m\n' "$1"; }
info() { printf '  %s\n' "$1"; }
warn() { printf '\033[1;33m  ! %s\033[0m\n' "$1" >&2; }
die() {
  printf '\033[1;31mbook: %s\033[0m\n' "$1" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "$1 が PATH にない ($2 に必要)"
}

require_dir() {
  [ -d "$1" ] || die "ディレクトリがない: $1"
}

# --- 事前チェック -----------------------------------------------------------

require_cmd ghq "リポジトリのパス解決"
require_dir "$k2i"
require_dir "$p2c"
require_dir "$zatsu"
mkdir -p "$ws"

if [ -f "$published_marker" ] && [ -z "${BOOK_FORCE:-}" ]; then
  echo "book: '$title' は完了済み"
  info "$(cat "$published_marker")"
  info "やり直すなら BOOK_FORCE=1 book '$title'"
  exit 0
fi

# --- 1. capture -------------------------------------------------------------

step 1/6 "capture: Kindle を画像化する"
if [ -d "$image_dir" ]; then
  skip "$image_dir が既にある"
elif [ -d "$k2i/out/$title" ]; then
  skip "$k2i/out/$title が既にある"
else
  require_cmd rye "kindle2image の実行"
  warn "Kindle アプリを開き、取り込みたい本の最初のページを表示して前面にしてください"
  warn "10 秒以内にアクティブにならないと失敗します"
  (cd "$k2i" && rye run python -m kindle2image --title "$title")
  [ -d "$k2i/out/$title" ] || die "kindle2image が $k2i/out/$title を作らなかった"
fi

# --- 2. stage ---------------------------------------------------------------

step 2/6 "stage: workspace へ移す"
if [ -d "$image_dir" ]; then
  skip "$image_dir が既にある"
else
  mv "$k2i/out/$title" "$image_dir"
  info "→ $image_dir"
fi

# --- 3. convert -------------------------------------------------------------

step 3/6 "convert: ISBN 検索 → OCR → Cosense プロジェクト作成"
if [ -f "$json_path" ]; then
  skip "$json_path が既にある"
else
  require_cmd bun "pdf2cosense の実行"

  # pdf2cosense は workspace 全体を走査するので、他に未処理のものがあれば巻き込む
  others="$(find "$ws" -mindepth 1 -maxdepth 1 -type d ! -name "$title" -exec basename {} \; | sort)"
  if [ -n "$others" ]; then
    warn "workspace に他のディレクトリがあります。これらも同時に処理されます:"
    printf '%s\n' "$others" | sed 's/^/      /' >&2
  fi

  warn "Cosense のプロジェクト作成とインポートでブラウザが自動操作されます"
  (cd "$p2c" && bun start)
  [ -f "$json_path" ] || die "pdf2cosense が $json_path を作らなかった"
fi

# プロジェクト名を解決する。pdf2cosense が .project を書いていればそれを使い、
# なければ .isbn から組み立てる (prefix は pdf2cosense の AppConfig と揃える必要がある)。
if [ -f "$image_dir/.project" ]; then
  project="$(tr -d '[:space:]' <"$image_dir/.project")"
elif [ -f "$image_dir/.isbn" ]; then
  isbn="$(tr -d '[:space:]' <"$image_dir/.isbn")"
  project="mrsekut-book-$isbn"
  warn ".project がないので .isbn から組み立てました: $project"
else
  die ".project も .isbn も見つからない: $image_dir"
fi
[ -n "$project" ] || die "プロジェクト名が空"
info "project: https://scrapbox.io/$project/"

# --- 4. summarize -----------------------------------------------------------

step 4/6 "summarize: 章ごとのまとめを書く"
if [ -f "$chapters_dir/overview.md" ]; then
  skip "$chapters_dir/overview.md が既にある"
else
  require_cmd claude "章まとめの生成"
  mkdir -p "$book_dir"
  info "zatsu で claude を回します。本の長さによっては数十分かかります"
  # OCR JSON は zatsu の外 (pdf2cosense/workspace) にあるので、--add-dir で読めるようにする。
  # これがないと claude -p は非対話ゆえパーミッションを承認できず、原文を1行も読めずに終わる。
  #
  # プロンプトは引数ではなく stdin で渡す。--add-dir は可変長引数なので、
  # 後ろに置いた文字列をディレクトリとして飲み込んでしまう。
  prompt="$json_path はある書籍の OCR 結果 (Cosense インポート用 JSON) です。
book-chapter-summary スキルに従って、この本の章ごとの解説を
$chapters_dir/ 配下に ch01.md, ch02.md, ... として書き出し、
最後に $chapters_dir/overview.md を作成してください。"

  (
    cd "$zatsu" &&
      printf '%s' "$prompt" |
      claude -p --permission-mode acceptEdits --add-dir "$ws"
  )
  [ -f "$chapters_dir/overview.md" ] || die "章まとめが生成されなかった ($chapters_dir/overview.md がない)"
fi

# --- 5. publish -------------------------------------------------------------

step 5/6 "publish: Cosense へアップロード"
require_cmd md2cosense "まとめのアップロード"
md2cosense "$chapters_dir" --project "$project" --yes

mkdir -p "$(dirname "$published_marker")"
printf 'https://scrapbox.io/%s/\n' "$project" >"$published_marker"

# --- 6. archive -------------------------------------------------------------

step 6/6 "archive: workspace を片付ける"
mkdir -p "$archive_dir"
chmod 700 "$archive_root"
mv "$image_dir" "$archive_dir/"
mv "$json_path" "$archive_dir/"
info "→ $archive_dir (再起動で消えます)"

printf '\n\033[1;32m完了\033[0m %s\n' "https://scrapbox.io/$project/"
