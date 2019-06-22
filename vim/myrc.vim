runtime! functions.vim
runtime! plugins.vim
runtime! mappings.vim

" General: {
    syntax on
    filetype plugin indent on
    set hidden
    set history=1000
    set nrformats="alpha,bin,hex" " Let ^A^X work with binary, hex or single letters
    set wildmenu
    set wildmode=list:longest,full
    set backspace=indent,eol,start
    set nobackup
    let &directory=g:configPath . '/swap//'
    let &undodir=g:configPath . '/undo//'
    set undofile
    set undolevels=1000
    set undoreload=10000
    "set ttimeout
    "set ttimeoutlen=50
    let g:shtuff_receiver = 'devrunner'

    " maybe?
    "set iskeyword-=.                    " '.' is an end of word designator
    "set iskeyword-=#                    " '#' is an end of word designator
    "set iskeyword-=-                    " '-' is an end of word designator

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif
" }

" UI: {
    set background=dark
    colorscheme solarized
    set number
    set relativenumber
    set showmatch
    set cursorline
    set title
    set laststatus=2
    set t_Co=256
    set showcmd                 " Show partial commands in status line and
    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode
    set colorcolumn=80,120
    set splitbelow
    set splitright
    set nofoldenable

    let g:airline_theme = 'solarized'
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1

    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
" }

" Formatting: {
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
    set nowrap
    set shiftwidth=4
    set expandtab
    set tabstop=4
    set softtabstop=4
    set nojoinspaces
    set pastetoggle=<F12>
" }

" Search: {
    set incsearch
    set hlsearch
    set ignorecase
    set smartcase
" }

" Encoding: {
    scriptencoding utf-8
" }

" Files: {
    "autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    "autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    "autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    "autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    "autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    "autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

    autocmd BufWritePre * call StripTrailingWhitespace()

    augroup autosource_vimrc
        autocmd!
        autocmd autosource_vimrc BufWritePost $MYVIMRC,{myrc,plugins,functions,mappings}.vim nested source $MYVIMRC | AirlineRefresh
        autocmd BufReadPost plugins.vim call VimrcOnlyMappings()
    augroup END
" }
