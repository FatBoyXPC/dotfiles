function! StripTrailingWhitespace()
    let _s=@/ " Preparation: save last search, and cursor position.
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    let @/=_s " clean up: restore previous search history, and cursor position
    call cursor(l, c)
endfunction

function! ShtuffStrategy(cmd)
  call system("shtuff into " . shellescape(g:shtuff_receiver) . " " . shellescape("clear;" . a:cmd))
endfunction

function! ExpandSnippet(snippet)
    execute 'normal! a'.a:snippet."\<c-r>=UltiSnips#ExpandSnippet()\<cr>"
endfunction

function! DuplicateCurrentFile(path)
    let path = "%:h/" . a:path
    execute "saveas " . path
    execute "edit " . path
endfunction

command! -bar -nargs=1 Duplicate call DuplicateCurrentFile(<q-args>)

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
