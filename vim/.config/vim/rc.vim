""""""""""""""""""""""""""""""""""""""""
" Runtime Environment                  "
""""""""""""""""""""""""""""""""""""""""
if !isdirectory($XDG_CACHE_HOME . "/vim/swap")
  call mkdir($XDG_CACHE_HOME . "/vim/swap", "p")
endif
set directory=$XDG_CACHE_HOME/vim/swap,/var/tmp,/tmp
if !isdirectory($XDG_CACHE_HOME . "/vim/backup")
  call mkdir($XDG_CACHE_HOME . "/vim/backup", "p")
endif
set backupdir=$XDG_CACHE_HOME/vim/backup,/var/tmp,/tmp
if !isdirectory($XDG_CACHE_HOME . "/vim")
  call mkdir($XDG_CACHE_HOME . "/vim", "p")
endif
set viminfo+=n$XDG_CACHE_HOME/vim/info
set runtimepath=$XDG_CONFIG_HOME/vim,$VIM,$VIMRUNTIME
let $MYVIMRC="$XDG_CONFIG_HOME/vim/rc"

""""""""""""""""""""""""""""""""""""""""
" Appearance                           "
""""""""""""""""""""""""""""""""""""""""
colorscheme koehler
set background=dark "'dark' or 'light', used for highlight colors
set number "print the line number in front of each line
set ruler "show cursor line and column in the status line
set laststatus=2
set scrolloff=8 "minimum nr. of lines above and below cursor
syntax enable

""""""""""""""""""""""""""""""""""""""""
" Configuration                        "
""""""""""""""""""""""""""""""""""""""""
set exrc "read .vimrc and .exrc in the current directory
set secure "secure mode for reading .vimrc in current dir

""""""""""""""""""""""""""""""""""""""""
" Formatting                           "
""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8 "encoding used internally
set endofline "write <EOL> for last line in file
set wrap "long lines wrap and continue on the next line
set textwidth=72

""""""""""""""""""""""""""""""""""""""""
" Indenting                            "
""""""""""""""""""""""""""""""""""""""""
set autoindent "take indent for new line from previous line
set copyindent "make 'autoindent' use existing indent structure
set expandtab "use spaces when <Tab> is inserted
" set smartindent "smart autoindenting for C programs
set shiftwidth=4 "number of spaces to use for (auto)indent step
set softtabstop=4 "number of spaces that <Tab> uses while editing
set tabstop=4 "number of spaces that <Tab> in file uses
set list listchars=tab:>-,trail:.,extends:>,precedes:<

autocmd FileType python set sw=4
autocmd FileType python set ts=4
autocmd FileType python set sts=4
" autocmd FileType javascript set sw=2
" autocmd FileType javascript set ts=2
" autocmd FileType javascript set sts=2

""""""""""""""""""""""""""""""""""""""""
" Search                               "
""""""""""""""""""""""""""""""""""""""""
set incsearch "highlight match while typing search pattern
set hlsearch "highlight matches with last search pattern

filetype on
""""""""""""""""""""""""""""""""""""""""
" Shortcuts                            "
""""""""""""""""""""""""""""""""""""""""
let mapleader = ","
" buffers
nmap <leader>q :q<cr>
nmap <leader>w :w!<cr>
nmap <leader>x :bdelete<cr>
nmap <leader>N :next<cr>
nmap <leader>M :previous<cr>
" change window
nmap <leader>j <C-W>j
nmap <leader>k <C-W>k
nmap <leader>h <C-W>h
nmap <leader>l <C-W>l
" change tab
nmap <leader>m :tabprevious<cr>
nmap <leader>n :tabnext<cr>
" move window
nmap <leader>J <C-W>J
nmap <leader>K <C-W>K
nmap <leader>H <C-W>H
nmap <leader>L <C-W>L
nmap <leader>T <C-W>T
" rotate windows
nmap <leader>r <C-W>r
nmap <leader>R <C-W>R
" exchange window
nmap <leader>x <C-W>x
" resize window
nmap <leader>- <C-W>-
nmap <leader>+ <C-W>+
nmap <leader>= <C-W>=
nmap <leader>< <C-W><
nmap <leader>> <C-W>>
" create window/tab
" intentional trailing spaces
nmap <leader>s :split 
nmap <leader>t :tabnew 
nmap <leader>v :vsplit 
" Highlight search on/off behavior
map <silent> <leader><cr> :nohlsearch<cr>

nmap <leader>ga <Plug>GitGutterStageHunk
nmap <leader>gx <Plug>GitGutterUndoHunk
nmap <leader>gb :Gblame<cr>
nmap <leader>gs :Gstatus<cr>
" let g:gitgutter_highlight_lines = 1

" OSX-specific copy/paste
nmap <leader>P :set paste!<cr>
nmap <leader>y :.w !pbcopy<cr><cr>
vmap <leader>y :w !pbcopy<cr><cr>
nmap <leader>p :r !pbpaste<cr>

nmap Y y$


function! MergeCommitMessages()
    let g:git_ci_msg_user = substitute(system("git config --get user.name"), '\n$', '', '')
    let g:git_ci_msg_email = substitute(system("git config --get user.email"), '\n$', '', '')
    nmap S GoSigned-off-by: <C-R>=printf("%s <%s>", g:git_ci_msg_user, g:git_ci_msg_email)<CR><ESC>
    nmap CO GoCo-authored-by: <C-R>=printf("%s <%s>", g:git_ci_msg_user, g:git_ci_msg_email)<CR><ESC>
    nmap R GoReviewed-by: <C-R>=printf("%s <%s>", g:git_ci_msg_user, g:git_ci_msg_email)<CR><ESC>
    nmap PR gg0Cmerge: PR #<ESC>JJo<CR>commits<CR>=======<ESC>gg$x2F ct 
endf
autocmd BufNewFile,BufRead COMMIT_EDITMSG,*.diff,*.patch,*.patches.txt,*.merge call MergeCommitMessages()
autocmd BufWinEnter COMMIT_EDITMSG,*.diff,*.patch,*.patches.txt call MergeCommitMessages()
autocmd BufWinEnter MERGE_MSG,*.merge call MergeCommitMessages()
autocmd FileType gitcommit call MergeCommitMessages()

if &diff
    " colorscheme slate
endif

let g:lightline = {
        \ 'colorscheme': 'jellybeans',
        \ }

set timeoutlen=1000 ttimeoutlen=0

""""""""""""""""""""""""""""""""""""""""
" Plugins                              "
""""""""""""""""""""""""""""""""""""""""
if filereadable(expand("$XDG_CONFIG_HOME/vim/bundle/pathogen/autoload/pathogen.vim"))
    runtime bundle/pathogen/autoload/pathogen.vim
    if exists("g:loaded_pathogen")
        execute pathogen#infect()
    endif
endif

autocmd BufNewFile,BufRead *.html set syntax=mako
augroup templates
    au!
    " read in templates files
    autocmd BufNewFile *.* silent! execute '0r $XDG_CONFIG_HOME/vim/templates/skeleton.'.expand("<afile>:e")
augroup END
