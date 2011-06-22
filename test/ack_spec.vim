runtime! plugin/*.vim

function! s:describe__ack_vim()
    It inits global settings to default values

    Should g:ackprg =~# '^ack'
    Should g:ackdir == '.'
    Should g:ack_list_height == ''
endfunction
