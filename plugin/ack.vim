if !exists("g:ackprg")
	let g:ackprg="ack -H --nocolor --nogroup --column"
endif
if !exists("g:ackdir")
    let g:ackdir="."
endif
if !exists("g:ack_list_height")
    let g:ack_list_height=""
endif

function! ack#OpenListCoreCommand(ack_cmd)
    if a:ack_cmd =~# '^l'
        return "lopen"
    endif
    return "copen"
endfunction

function! ack#OpenListCommand(ack_cmd)
    let l:position = "botright"
    return join([l:position, ack#OpenListCoreCommand(a:ack_cmd), g:ack_list_height])
endfunction

function! s:Ack(cmd, args)
    redraw
    echo "Searching " . g:ackdir . " ..."

    " If no pattern is provided, search for the word under the cursor
    if empty(a:args)
        let l:grepargs = expand("<cword>")
    else
        let l:grepargs = a:args
    end

    " Format, used to manage column jump
    if a:cmd =~# '-g$'
        let g:ackformat="%f"
    else
        let g:ackformat="%f:%l:%c:%m"
    end

    let grepprg_bak=&grepprg
    let grepformat_bak=&grepformat
    try
        let &grepprg=g:ackprg
        let &grepformat=g:ackformat
        silent execute a:cmd . " " . l:grepargs . " " . g:ackdir
    finally
        let &grepprg=grepprg_bak
        let &grepformat=grepformat_bak
    endtry

    silent execute ack#OpenListCommand(a:cmd)

    " TODO: Document this!
    exec "nnoremap <silent> <buffer> q :ccl<CR>"
    exec "nnoremap <silent> <buffer> t <C-W><CR><C-W>T"
    exec "nnoremap <silent> <buffer> T <C-W><CR><C-W>TgT<C-W><C-W>"
    exec "nnoremap <silent> <buffer> o <CR>"
    exec "nnoremap <silent> <buffer> go <CR><C-W><C-W>"

    " If highlighting is on, highlight the search keyword.
    if exists("g:ackhighlight")
        let @/=a:args
        set hlsearch
    end

    redraw!
endfunction

function! s:AckFromSearch(cmd, args)
    let search =  getreg('/')
    " translate vim regular expression to perl regular expression.
    let search = substitute(search,'\(\\<\|\\>\)','\\b','g')
    call s:Ack(a:cmd, '"' .  search .'" '. a:args)
endfunction

command! -bang -nargs=* -complete=file Ack call s:Ack('grep<bang>',<q-args>)
command! -bang -nargs=* -complete=file AckAdd call s:Ack('grepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file AckFromSearch call s:AckFromSearch('grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LAck call s:Ack('lgrep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LAckAdd call s:Ack('lgrepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file AckFile call s:Ack('grep<bang> -g', <q-args>)
