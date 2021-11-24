" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif
"****************************************************
"NeoBundle Scripts
"****************************************************
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))
"****************************************************
"NeoBundle install packages
"****************************************************
" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'othree/yajs.vim'
NeoBundle 'maxmellon/vim-jsx-pretty'
NeoBundle 'mattn/emmet-vim'

call neobundle#end()

" Required:
filetype plugin indent on

NeoBundleCheck

"""""""""""""""""""""""""""""""
"" emmet-vimの設定
"""""""""""""""""""""""""""""""
let g:user_emmet_leader_key='<Tab>'

"****************************************************
"Mappings
"****************************************************
inoremap <silent> jj <ESC>
nnoremap <silent> <Space>t :NERDTreeToggle<CR>


"****************************************************
"Basic Setup
"****************************************************
"setting************
set fenc=utf-8 " 文字コードをUTF-8に設定
set nobackup " バックアップファイルを作らない
set noswapfile " スワップファイルを作らない
set autoread " 編集中のファイルが変更されたら自動で読み直す
set hidden " バッファが編集中でもその他のファイルを開けるように
set showcmd " 入力中のコマンドをステータスに表示する
set backspace=start,eol,indent
set mouse=a " マウス機能有効化
set clipboard+=unnamed

"visual************
set number " 行番号を表示
set cursorline " 現在の行を強調表示
set smartindent " 改行時などに自動でインデント
set visualbell " ビープ音を可視化
set showmatch " 括弧入力時の対応する括弧を表示
set laststatus=2 " ステータスラインを常に表示
set wildmode=list:longest " コマンドラインの補完
set nowrap " 行末を折り返さない

"tab************
set tabstop=4 " 行頭以外のTab文字の表示幅（スペースいくつ分）
set shiftwidth=4 " 行頭でのTab文字の表示幅

"search************
set wrapscan " 検索時に最後まで行ったら最初に戻る
set hlsearch " 検索語をハイライト表示
"ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"****************************************************
"ColorScheme
"****************************************************

syntax on
colorscheme monokai

"" ステータスラインを表示
set laststatus=2 " ステータスラインを常に表示
set statusline=%F%r%h%= " ステータスラインの内容

