let mapleader = ' '

nnoremap <Leader>fr :w<CR>:call system("fat-rerunner " . shellescape(g:shtuff_receiver))<CR>
nnoremap <Leader>tw :w<CR>:call system("fat-rerunner " . shellescape(g:shtuff_receiver))<CR>
nnoremap <Leader>tw "ayy:call system("shtuff into " . shellescape(g:shtuff_receiver) . ' ' . shellescape(trim("<C-r>a")))<CR>
vnoremap <Leader>tw "ayiw:call agriculture#trim_and_escape_register_a()<CR>:call system("shtuff into " . shellescape(g:shtuff_receiver) . ' ' . <C-r>a)<CR>

nnoremap <Leader>c :update\|bd<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

nnoremap <Leader>mp :MarkdownPreview<CR>
nnoremap <Leader>ms :w<CR>:MarkdownPreviewStop<CR>:bd<CR>

" Files: {
    nnoremap <Leader>pc :let @+ = fnamemodify(expand("%"), ":~:.")<CR> " copy file path

    nnoremap <Leader>sp :e ~/scratchpad<CR>

    nnoremap <Leader>vf :e ~/.vim/functions.vim<CR>
    nnoremap <Leader>vm :e ~/.vim/mappings.vim<CR>
    nnoremap <Leader>vr :e ~/.vim/myrc.vim<CR>
    nnoremap <Leader>vp :e ~/.vim/plugins.vim<CR>
" }

" Editing: {
    inoremap ;; <ESC>A;<ESC>
    inoremap ,, <ESC>A,<ESC>

    " Surround in visual/selection mode
    xmap S <Plug>(operator-sandwich-add)

    nnoremap Y y$

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    nnoremap <Leader>tw :set wrap!<CR>

    " I had this as <C-/> but my terminal/vim combo seems to not like that.
    " Apparently now I have to change it back ater changing to nix alacritty?
    nmap <C-/> <Plug>NERDCommenterToggle
    xmap <C-/> <Plug>NERDCommenterToggle

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " MoveLines: {
        nnoremap <C-J> :m .+1<CR>==
        nnoremap <C-K> :m .-2<CR>==
        inoremap <C-J> <Esc>:m .+1<CR>==gi
        inoremap <C-K> <Esc>:m .-2<CR>==gi
        vnoremap <C-J> :m '>+1<CR>gv=gv
        vnoremap <C-K> :m '<-2<CR>gv=gv
    " }
" }

" Formatting: {
    nnoremap <Leader>fj :%!python -m json.tool<CR>
    xnoremap <Leader>fj :!python -m json.tool<CR>
    nnoremap <Leader>fx :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"<CR>
    xnoremap <Leader>fx :!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"<CR>
    nnoremap <leader>x12 :%s/\n//g<cr>:%s/\~/\~\r/g<cr>gg:nohlsearch<cr>
" }

" NavigationTelescope: {
    nnoremap <leader>b :Telescope buffers sort_lastused=true<CR>
    nnoremap <leader><leader> <C-^>
    nnoremap <C-P> :Telescope git_files<CR>
    nnoremap <Leader>af :Telescope find_files<CR>
    nnoremap <Leader>mf :Telescope git_status<CR>
    nnoremap <Leader>fu :Telescope lsp_document_methods<CR>
    nnoremap <Leader>ut :UndotreeToggle<CR>
    nnoremap <Leader>T :Telescope<CR>
    nnoremap <Leader>R :Telescope resume<CR>
    nnoremap <Leader>lf :Telescope laravel_picker<CR>

    " Display all lines with keyword under cursor " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
" }

" Git: {
    " Find merge conflict markers
    nnoremap <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    nnoremap <leader>dg2 :diffget //2<CR>:diffupdate<CR>
    nnoremap <leader>dg3 :diffget //3<CR>:diffupdate<CR>
    nnoremap <leader>gd :Gvdiffsplit!<CR>
    nnoremap <silent> <leader>gb :Git blame<CR>
" }

" Testing: {
    nnoremap <leader>ts :w<CR>:TestSuite<CR>
    nnoremap <leader>tf :w<CR>:TestFile<CR>
    nnoremap <leader>tl :w<CR>:TestLast<CR>
    nnoremap <leader>tn :w<CR>:TestNearest<CR>
    nnoremap <leader>tv :w<CR>:TestVisit<CR>
" }

" Search: {
    nnoremap <silent><leader>t/ :set invhlsearch<CR>
    nmap <Leader>/ <Plug>AgRawSearch
    vmap <Leader>/ <Plug>AgRawVisualSelection
    nmap <Leader>* <Plug>AgRawWordUnderCursor
" }

" UI: {
    nnoremap 1<Backspace> :set background=dark<CR>
    nnoremap 2<Backspace> :set background=light<CR>
" }

" LSP: {
    nmap <silent> gd :lua vim.lsp.buf.definition()<CR>
    nmap <silent> <Leader>gt :lua vim.lsp.buf.type_definition()<CR>
    nmap <silent> <Leader>gi :lua vim.lsp.buf.implementation()<CR>
    nmap <silent> <Leader>gr :lua vim.lsp.buf.references()<CR>
    nmap <silent> <Leader>ac :lua vim.lsp.buf.code_action()<CR>

    nnoremap <silent> K :call ShowDocumentation()<CR>

    "inoremap <silent><expr> <C-I> coc#refresh()
    "inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    "inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-y>"
    "This is the right now:
    "inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"
" }

" Refactoring: {
    augroup PhpactorMappings
        au!
        au FileType php nmap <buffer> <Leader>ic :PhpactorImportClass<CR>
        au FileType php nmap <buffer> <Leader>ec :PhpactorClassExpand<CR>
        au FileType php nmap <buffer> <Leader>mi :PhpactorImportMissingClasses<CR>
        au FileType php nmap <buffer> <Leader>im :PhpactorImportMissingClasses<CR>
        au FileType php nmap <buffer> <Leader>mm :PhpactorContextMenu<CR>
        au FileType php nmap <buffer> <silent> <Leader>ee
                    \ :PhpactorExtractExpression<CR>
        au FileType php vmap <buffer> <silent> <Leader>ee
                    \ :<C-u>PhpactorExtractExpression<CR>
        au FileType php vmap <buffer> <silent> <Leader>em
                    \ :<C-u>PhpactorExtractMethod<CR>
    augroup END
" }

function! VimrcOnlyMappings()
    nnoremap <buffer> <Leader>pa :call AddPluginFromClipboard()<CR>
    nnoremap <buffer> <Leader>pc :let @+ = GetLinkForPlugin()<CR>
    nnoremap <buffer> <Leader>po :call system("xdg-open " . GetLinkForPlugin())<CR>
    nnoremap <buffer> <Leader>pr :call RemovePlugin()<CR>
endfunction
