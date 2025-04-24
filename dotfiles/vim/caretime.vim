function! CaretimeTransform(cmd) abort
  return 'docker compose exec -t laravel.test ' . a:cmd
endfunction

let g:test#php#phpunit#executable = './vendor/bin/phpunit'
let g:test#custom_transformations = {'caretime': function('CaretimeTransform')}
let g:test#transformation = 'caretime'
