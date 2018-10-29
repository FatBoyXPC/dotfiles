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
