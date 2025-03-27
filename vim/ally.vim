function! AllyTransform(cmd) abort
  return 'docker compose exec -t php ' . a:cmd
endfunction

let g:test#php#phpunit#executable = './vendor/bin/phpunit'
let g:test#custom_transformations = {'ally': function('AllyTransform')}
let g:test#transformation = 'ally'
