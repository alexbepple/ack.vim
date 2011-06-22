runtime! plugin/*.vim

function! s:describe__ack()
    It inits global settings to default values
        Should g:ackprg =~# '^ack'
        Should g:ackdir == '.'
        Should g:ack_list_height == ''

    It opens quickfix list
        Should ack#OpenListCoreCommand('grep ...') == 'copen'
        Should ack#OpenListCommand('grep …') =~# 'botright copen'

    It opens results list to specified height
        let old = g:ack_list_height
        let g:ack_list_height = 40
        Should ack#OpenListCommand('grep …') =~# 'open 40'
        let g:ack_list_height = old
endfunction

function! s:describe__lack()
    It opens location list
        Should ack#OpenListCoreCommand('lgrep …') == 'lopen'
endfunction
