#!/usr/bin/env bash
set -euo pipefail

# claude-codeを最新バージョンに更新
echo "Fetching latest claude-code version..."
LATEST_VERSION=$(npm view @anthropic-ai/claude-code version)
echo "Latest version: $LATEST_VERSION"

# 現在のバージョンを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_NIX="$SCRIPT_DIR/default.nix"
CURRENT_VERSION=$(grep 'version = "' "$DEFAULT_NIX" | sed 's/.*version = "\([^"]*\)".*/\1/')
echo "Current version: $CURRENT_VERSION"

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
  echo "Already up to date!"
  exit 0
fi

# バージョンを更新
echo "Updating version to $LATEST_VERSION..."
sed -i.bak "s/version = \"$CURRENT_VERSION\"/version = \"$LATEST_VERSION\"/" "$DEFAULT_NIX"
rm "$DEFAULT_NIX.bak"

# 一時的に間違ったハッシュを設定
sed -i.bak 's/hash = "sha256-[^"]*"/hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="/' "$DEFAULT_NIX"
sed -i.bak 's/npmDepsHash = "sha256-[^"]*"/npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="/' "$DEFAULT_NIX"
rm "$DEFAULT_NIX.bak"

echo "Building to get correct hashes..."

# ビルドを実行して正しいハッシュを取得
if ! nix build .#homeConfigurations.mrsekut.activationPackage 2>&1 | tee /tmp/claude-update.log; then
  # srcのハッシュを抽出して更新
  SRC_HASH=$(grep -A2 "hash mismatch in fixed-output derivation" /tmp/claude-update.log | grep "got:" | head -1 | awk '{print $2}')
  if [ -n "$SRC_HASH" ]; then
    echo "Updating src hash to: $SRC_HASH"
    sed -i.bak "s|hash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\"|hash = \"$SRC_HASH\"|" "$DEFAULT_NIX"
    rm "$DEFAULT_NIX.bak"
  fi

  # 再度ビルドしてnpmDepsHashを取得
  if ! nix build .#homeConfigurations.mrsekut.activationPackage 2>&1 | tee /tmp/claude-update2.log; then
    NPM_HASH=$(grep -A2 "hash mismatch in fixed-output derivation" /tmp/claude-update2.log | grep "got:" | tail -1 | awk '{print $2}')
    if [ -n "$NPM_HASH" ]; then
      echo "Updating npmDepsHash to: $NPM_HASH"
      sed -i.bak "s|npmDepsHash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\"|npmDepsHash = \"$NPM_HASH\"|" "$DEFAULT_NIX"
      rm "$DEFAULT_NIX.bak"
    fi
  fi
fi

# クリーンアップ
rm -f /tmp/claude-update.log /tmp/claude-update2.log

echo "Update complete! Running final build..."
nix build .#homeConfigurations.mrsekut.activationPackage
echo "claude-code has been updated to version $LATEST_VERSION"