call plug#begin(g:configPath . '/plugged')

Plug 'windwp/nvim-autopairs'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'mbbill/undotree'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'lambdalisue/vim-gista'
Plug 'scrooloose/nerdcommenter'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'vim-vdebug/vdebug', { 'for': 'php' }
Plug 'janko-m/vim-test'
Plug 'phpactor/phpactor', { 'for': 'php', 'do': 'composer install' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'markonm/traces.vim'
Plug 'sheerun/vim-polyglot'
Plug 'machakann/vim-sandwich'
Plug 'SirVer/ultisnips'
Plug 'jesseleite/vim-agriculture'
Plug 'noahfrederick/vim-laravel'
Plug 'tpope/vim-projectionist'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'metakirby5/codi.vim'
Plug 'kamykn/spelunker.vim'
Plug 'jeffkreeftmeijer/vim-dim', {'branch': 'main'}

" Let's move this to neovim (init.vim or something after?) specifically sometime
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim',
Plug 'nvim-telescope/telescope-live-grep-args.nvim',
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make', 'branch': 'main' }
Plug 'nvim-telescope/telescope-ui-select.nvim',
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

set rtp+=~/dotfiles/my-nix/result/share/vim-plugins/fzf
let g:fzf_layout = { 'down': '~40%' }

let g:ale_fixers = {
\   'php': [ 'php_cs_fixer' ],
\}

let g:ale_linters = {
\ 'php': ['php', 'phpcs', 'phpmd'],
\ 'bash': ['shellcheck'],
\ }

let g:ale_fix_on_save = 1
let g:ale_php_phpcs_standard = getcwd() . '/phpcs_ruleset.xml'

if filereadable(".php_cs.dist")
    let g:php_cs_fixer_config_file = '.php_cs.dist'
endif

if filereadable(".php_cs")
    let g:php_cs_fixer_config_file = '.php_cs'
endif

let g:ale_haskell_ghc_options = '-fno-code -v0 -dynamic'

let g:NERDCreateDefaultMappings = 0

let g:vdebug_options = {"break_on_open": 0}
let g:vdebug_features = {'max_children': 1024}
let g:phpactorPhpBin = '/usr/bin/php'
let g:phpactorBranch = 'develop'
let g:phpactorOmniAutoClassImport = 1
let g:gista#command#post#default_public = 0
let test#strategy = "shtuff"

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

let g:mkdp_auto_close = 0
