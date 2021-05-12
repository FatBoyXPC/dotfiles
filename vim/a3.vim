let g:vdebug_options.path_maps = {"/var/www/html": "/home/james/dev/aware3/web"}
let test#php#codeception#executable = 'codecept'

function! s:xdebug(toggle)
	let xdebug_config = shellescape("XDEBUG_CONFIG=remote_enable=" . a:toggle)
	call system("shtuff into " . shellescape(g:shtuff_receiver) . " 'export " . xdebug_config . "'")
endfunction

function! DisableXdebug()
	call s:xdebug('off')
endfunction

function! EnableXdebug()
	call s:xdebug('on')
endfunction
