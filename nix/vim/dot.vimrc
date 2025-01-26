call plug#begin('~/.vim/plugged')

" プラグインリスト
Plug 'scrooloose/nerdtree'
Plug 'othree/yajs.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mattn/emmet-vim'

call plug#end()


" 基本設定
set number                 " 行番号を表示
set cursorline             " 現在の行をハイライト
set smartindent            " 自動インデント
set clipboard+=unnamedplus " システムクリップボードと共有
set mouse=a                " マウスを有効化

" 表示設定
set nowrap                 " 行末を折り返さない
set showmatch              " 対応する括弧をハイライト

" タブ設定
set expandtab              " タブをスペースに変換
set tabstop=4              " タブの幅
set shiftwidth=4           " 自動インデントの幅

" 検索設定
set hlsearch               " 検索結果をハイライト
set wrapscan               " 検索時に最後まで行ったら先頭に戻る
nnoremap <Esc> :nohlsearch<CR><Esc>

" カラースキーム
syntax on
colorscheme monokai

" NERDTreeのショートカット
nnoremap <silent> <Space>t :NERDTreeToggle<CR>
