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

"""""""""""""""""""""""""""""""
"" Unit.vimの設定
"""""""""""""""""""""""""""""""
"" バッファ一覧
"noremap <C-P> :Unite buffer<CR>
"" ファイル一覧
"noremap <C-N> :Unite -buffer-name=file file<CR>
"" 最近使ったファイルの一覧
"noremap <C-Z> :Unite file_mru<CR>
"" sourcesを「今開いているファイルのディレクトリ」とする
"noremap :uff :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
"" ウィンドウを分割して開く
"au FileType unite nnoremap <silent> <buffer> <expr> <C-J>
"unite#do_action('split')
"au FileType unite inoremap <silent> <buffer> <expr> <C-J>
"unite#do_action('split')
"" ウィンドウを縦に分割して開く
"au FileType unite nnoremap <silent> <buffer> <expr> <C-K>
"unite#do_action('vsplit')
"au FileType unite inoremap <silent> <buffer> <expr> <C-K>
"unite#do_action('vsplit')
"" ESCキーを2回押すと終了する
"au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
"au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

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

"" 起動時にruntimepathにNeoBundleのパスを追加する
"if has('vim_starting')
"  if &compatible
"    set nocompatible
"  endif
"  set runtimepath+=~/.vim/bundle/neobundle.vim/
"endif
"
"" NeoBundle設定の開始
"call neobundle#begin(expand('~/.vim/bundle/'))
"
"" NeoBundleのバージョンをNeoBundle自身で管理する
"NeoBundleFetch 'Shougo/neobundle.vim'
"
"" インストールしたいプラグインを記述
"
"let g:user_emmet_leader_key='<c-z>'
"
"" 括弧補完
"NeoBundle 'Townk/vim-autoclose'
"
"
"" NeoBundle設定の終了
"call neobundle#end()
"
"filetype plugin indent on
"
"" vim起動時に未インストールのプラグインをインストールする
"NeoBundleCheck
"
"" インクリメンタル検索を有効化
"set incsearch
"" 補完時の一覧表示機能有効化
"set wildmenu wildmode=list:full
"" 自動的にファイルを読み込むパスを設定 ~/.vim/userautoload/*vim
"set runtimepath+=~/.vim/
"runtime! userautoload/*.vim
"
"if !has('gui_running')
"    augroup seiya
"        autocmd!
"        autocmd VimEnter,ColorScheme * highlight Normal ctermbg=none
"        autocmd VimEnter,ColorScheme * highlight LineNr ctermbg=none
"        autocmd VimEnter,ColorScheme * highlight SignColumn ctermbg=none
"        autocmd VimEnter,ColorScheme * highlight VertSplit ctermbg=none
"        autocmd VimEnter,ColorScheme * highlight NonText ctermbg=none
"    augroup END
"endif
"
"プラグイン管理に NeoBundle を使用している場合
"NeoBundle 'scrooloose/syntastic'
"NeoBundle 'pmsorhaindo/syntastic-local-eslint.vim'
"
"let g:syntastic_javascript_checkers=['eslint']
"
"" ここから下は Syntastic のおすすめの設定
"" ref. https://github.com/scrooloose/syntastic#settings
"
"" エラー行に sign を表示
"let g:syntastic_enable_signs = 1
"" location list を常に更新
"let g:syntastic_always_populate_loc_list = 0
"" location list を常に表示
"let g:syntastic_auto_loc_list = 0
"" ファイルを開いた時にチェックを実行する
"let g:syntastic_check_on_open = 1
"" :wq で終了する時もチェックする
"let g:syntastic_check_on_wq = 0
"
"" TABキーを押した際にタブ文字の代わりにスペースを入れる
"set expandtab
"set tabstop=2
"set shiftwidth=2
"
"NeoBundle 'scrooloose/nerdtree'
