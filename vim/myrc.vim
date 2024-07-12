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
    let g:shtuff_receiver = getcwd()
    set tags^=./.git/tags

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
    set notermguicolors
    set background=light
    colorscheme dim
    set number
    set relativenumber
    set showmatch
    set cursorline
    set title
    set laststatus=2
    set t_Co=256
    set showcmd                 " Show partial commands in status line and
    set tabpagemax=15               " Only show 15 tabs
    set noshowmode
    set colorcolumn=80,120
    set splitbelow
    set splitright
    set nofoldenable
    set showtabline=2

    let g:lightline = {'colorscheme': '16color'}
    let g:lightline.tabline = {
                \ 'left': [ [ 'buffers' ] ],
                \ 'right': [ [ 'close'] ] }
    let g:lightline.component_expand = { 'buffers': 'lightline#bufferline#buffers' }
    let g:lightline.component_type = { 'buffers': 'tabsel' }
    let g:lightline.separator = { 'left': '', 'right': '' }
    let g:lightline.subseparator = {'left': '', 'right': '' }
    " Only show the buffers if there's more than 1 open.
    " From https://github.com/mengelbrecht/lightline-bufferline/issues/99
    let g:lightline#bufferline#min_buffer_count = 1

    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1

    highlight SpelunkerSpellBad ctermfg=190
    highlight! link SignColumn LineNr
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
    "set shortmess-=S
" }

" Encoding: {
    scriptencoding utf-8
" }

" Files: {
    autocmd BufWritePre * call StripTrailingWhitespace()

    augroup autosource_vimrc
        autocmd!
        autocmd BufReadPost plugins.vim call VimrcOnlyMappings()
    augroup END
" }

if filereadable("project.vim")
    source project.vim
endif
