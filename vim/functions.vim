function! StripTrailingWhitespace()
    let _s=@/ " Preparation: save last search, and cursor position.
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    let @/=_s " clean up: restore previous search history, and cursor position
    call cursor(l, c)
endfunction

function! ExpandSnippet(snippet)
    execute 'normal! a'.a:snippet."\<c-r>=UltiSnips#ExpandSnippet()\<cr>"
endfunction

function! DuplicateCurrentFile(path)
    let path = "%:h/" . a:path
    execute "saveas " . path
    execute "edit " . path
endfunction

command! -nargs=1 Duplicate call DuplicateCurrentFile(<q-args>)
command! MFiles call fzf#run(fzf#wrap({
    \ 'source': 'git ls-files --exclude-standard --others --modified',
    \ 'options': ['--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all'] }))

command! Mapsn call fzf#vim#maps('n', 0)
command! Mapsx call fzf#vim#maps('x', 0)
command! Mapso call fzf#vim#maps('o', 0)
command! Mapsi call fzf#vim#maps('i', 0)
command! Mapsv call fzf#vim#maps('v', 0)
command! Mapsa call fzf#vim#maps('a', 0)

function! GetLinkForPlugin()
    normal ^f/"ayi'
    return "https://www.github.com/" . @a
endfunction

function! AddPluginFromClipboard()
    let plugin = "Plug '" . substitute(@+, "https://github.com/", "", "") . "'"
    normal gg
    call search("nvim")
    call search("Plug ", 'b')
    execute "normal o" . plugin
    w
    PlugInstall
endfunction

function! RemovePlugin()
    normal dd
    w
    PlugClean
endfunction

function! ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
