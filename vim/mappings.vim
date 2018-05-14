let mapleader = ','
nnoremap Y y$
nmap <silent> <leader>/ :set invhlsearch<CR>

" Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

nnoremap <silent> <leader>tt :TagbarToggle<CR>
nnoremap <Leader>u :UndotreeToggle<CR>

nnoremap <silent> <leader>gb :Gblame<CR>

inoremap ;; <ESC>A;<ESC>
inoremap ,, <ESC>A,<ESC>
nnoremap <leader>b :Buffers<CR>
nnoremap <C-p> :Files<CR>
nnoremap <Leader>fu :BTags<CR>
nnoremap 1<Backspace> :set background=dark<CR>
nnoremap 2<Backspace> :set background=light<CR>
nnoremap <Leader>cf :let @+ = expand("%")<CR>
nnoremap <Leader>sp :e ~/scratchpad<CR>
nnoremap <Leader>sv :source ~/.vimrc<CR>
xmap S <Plug>(operator-sandwich-add)
nnoremap <Leader>ut :UndotreeToggle<CR>

" - Move lines
nnoremap <C-J> :m .+1<CR>==
nnoremap <C-K> :m .-2<CR>==
inoremap <C-J> <Esc>:m .+1<CR>==gi
inoremap <C-K> <Esc>:m .-2<CR>==gi
vnoremap <C-J> :m '>+1<CR>gv=gv
vnoremap <C-K> :m '<-2<CR>gv=gv

" - Testing goodness!
nnoremap <leader>ts :w<CR>:TestSuite<CR>
nnoremap <leader>tf :w<CR>:TestFile<CR>
nnoremap <leader>tl :w<CR>:TestLast<CR>
nnoremap <leader>tn :w<CR>:TestNearest<CR>
nnoremap <leader>tv :w<CR>:TestVisit<CR>

" - Refactoring Tools
nnoremap <Leader>u :call phpactor#UseAdd()<CR>
nnoremap <Leader>e :call phpactor#ClassExpand()<CR>
vnoremap <silent><Leader>em :call phpactor#ExtractMethod()<CR>
"nnoremap <Leader>pp :call phpactor#ContextMenu()<CR>
nnoremap <Leader>o :call phpactor#GotoDefinition()<CR>
"nnoremap <Leader>pd :call phpactor#OffsetTypeInfo()<CR>
"nnoremap <Leader>pfm :call phpactor#MoveFile()<CR>
"nnoremap <Leader>pfc :call phpactor#CopyFile()<CR>
"nnoremap <Leader>tt :call phpactor#Transform()<CR>
"nnoremap <Leader>cc :call phpactor#ClassNew()<CR>
"nnoremap <Leader>fr :call phpactor#FindReferences()<CR>
