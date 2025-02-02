inoremap <silent> jj <ESC>

" 基本設定
set fenc=utf-8                  " 文字コードをUTF-8に設定
set nobackup                    " バックアップファイルを作らない
set noswapfile                   " スワップファイルを作らない
set autoread                    " 編集中のファイルが変更されたら自動で読み直す
set hidden                      " 編集中でも他のファイルを開けるように
set showcmd                     " コマンド入力をステータスバーに表示
set backspace=start,eol,indent  " バックスペースの動作を拡張
set mouse=a                     " マウス操作を有効化
set clipboard+=unnamedplus      " システムクリップボードと共有

" 表示設定
set number                  " 行番号を表示
set cursorline              " 現在の行をハイライト
set smartindent             " 改行時に自動でインデント
set visualbell              " ビープ音を可視化
set showmatch               " 対応する括弧をハイライト
set laststatus=2            " ステータスラインを常に表示
set wildmode=list:longest   " コマンド補完をリスト表示
set nowrap                  " 行を折り返さない

set expandtab      " タブをスペースに変換
set shiftwidth=2   " 自動インデントの幅を2スペースに設定
set softtabstop=2  " タブキーを押したときのスペース数を2に設定
set tabstop=2      " タブを2スペース幅に設定


nmap <Esc><Esc> :nohlsearch<CR><Esc> " ESCを2回押すと検索ハイライトを解除
