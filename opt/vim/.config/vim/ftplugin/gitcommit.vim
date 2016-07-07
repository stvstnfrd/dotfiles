if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1 " Don't load twice in one buffer

let g:git_ci_msg_user = substitute(system("git config --get user.name"), '\n$', '', '')
let g:git_ci_msg_email = substitute(system("git config --get user.email"), '\n$', '', '')

nmap S oSigned-off-by: <C-R>=printf("%s <%s>", g:git_ci_msg_user, g:git_ci_msg_email)<CR><CR><ESC>
nmap R oReviewed-by: <C-R>=printf("%s <%s>", g:git_ci_msg_user, g:git_ci_msg_email)<CR><ESC>
nmap PR iMerge pull request #<CR><CR>from Stanford-Online:<CR>into Stanford-Online:master<CR><ESC>ggA
