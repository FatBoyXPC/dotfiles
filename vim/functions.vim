function! StripTrailingWhitespace()
    let _s=@/ " Preparation: save last search, and cursor position.
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    let @/=_s " clean up: restore previous search history, and cursor position
    call cursor(l, c)
endfunction

function! FatRunnerStrategy(cmd)
  call system("fat-runner run " . shellescape("clear;" . a:cmd))
endfunction

function! ExpandSnippet(snippet)
    execute 'normal! a'.a:snippet."\<c-r>=UltiSnips#ExpandSnippet()\<cr>"
endfunction

"function! Shtuff(...)
    "if exists(a:1)
        "echo a:1
        "let g:shtuff = a:1
        "return
    "endif

    "if !exists('g:shtuff')
        "echo 'shtuff command not defined'
        "return
    "endif

    "call system("fat-runner run '" . g:shtuff . "'")
"endfunction
