function! AllyTransform(cmd) abort
  return 'docker exec -t ally ' . a:cmd
endfunction

let g:test#php#phpunit#executable = './vendor/bin/phpunit'
let g:test#custom_transformations = {'ally': function('AllyTransform')}
let g:test#transformation = 'ally'
