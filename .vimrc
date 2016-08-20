set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'Lokaltog/vim-easymotion'
Bundle 'kien/ctrlp.vim'
Bundle 'sjl/gundo.vim'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'vim-scripts/Vim-R-plugin'
Bundle 'vim-scripts/Screen-vim---gnu-screentmux'
Bundle 'yegappan/mru'
Bundle 'xolox/vim-session'
Bundle 'xolox/vim-misc'
Bundle 'flazz/vim-colorschemes'
Bundle 'jcf/vim-latex'
Bundle 'godlygeek/tabular'

set  hlsearch
set  expandtab
set  tabstop=4
set  shiftwidth=2
set  nowrap
set  ruler
set  lazyredraw
set  mouse=a

set  relativenumber
set  number

filetype on
filetype plugin indent on
syntax enable

let mapleader=","
let maplocalleader=","

" Navigate tabs firefox style
nnoremap <C-W><C-T> :tabprevious<CR>
nnoremap <C-W>t   :tabnext<CR>

" Tabs to splits and back
function MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    sp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    sp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

nnoremap <C-W>s :call MoveToNextTab()<CR>
nnoremap <C-W>S :call MoveToPrevTab()<CR>
" Also, <C-W><C-T> creates a new tab
""""""""""""""""""""""

"execute pathogen#infect()


"""""""""""""""""""""""""""""""""""""""""""""""""
" Allow vim to see Alt
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

set timeout ttimeoutlen=50
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("h")': ['<cr>', '<2-LeftMouse>'],
    \ 'AcceptSelection("e")': ['<c-x>'],
    \ 'AcceptSelection("t")': ['<c-t>'],
    \ 'AcceptSelection("v")': ['<NL>', '<RightMouse>'],
    \ }
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
let NERDTreeMapOpenSplit='"'
let NERDTreeMapOpenVSplit='%'
"""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
let g:syntastic_enable_r_svtools_checker = 1
let g:syntastic_r_checkers=['svtools']
"""""""""""""""""""""""""""""""""""""""""""""""""

au BufRead,BufNewFile *.tex setlocal makeprg=pdflatex\ %
"% filename %:r filename modifier that discards extension
au BufRead,BufNewFile *.cc  set makeprg=g++\ -Wall\ -I/usr/local/include\ -lgsl\ -lgslcblas\ -lm\ %\ -o\ %:r

nnoremap <leader>m :make<CR>
nnoremap <leader>w :w<CR>

set runtimepath^=~/.vim/ctrlp/ctrlp.vim

"""""""""""""""""""""""""""""""""""""""""""""""""
" Backup
set undodir=~/.vim/tmp/undo//
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" Session management
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1
nnoremap <leader>so :OpenSession<CR>
nnoremap <leader>ss :SaveSession<CR>
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""



"""""""""""""""""""""""""""""""""""""""""""""""""
" Gundo
nnoremap <F6> :GundoToggle<CR>
set undofile
set history=100
set undolevels=100
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" R script settings
let maplocalleader = ","
vmap <Space> <Plug>RDSendSelection
nmap <Space> <Plug>RDSendLine
let vimrplugin_applescript=0
let vimrplugin_vsplit=1
let vimrplugin_assign = 0
let g:vimrplugin_insert_mode_cmds = 0

highlight Pmenu ctermbg=238 gui=bold
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
"""   Tabular
vnoremap <leader>t :Tabular<space>/
"""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""
"""   Ignore
"""""""""""""""""""""""""""""""""""""""""""""""""
"Set line numbering to take up 5 spaces
"set numberwidth=5 

"Highlight current line
"set cursorline

"Turn on spell checking with English dictionary
"set spell
"set spelllang=en
"set spellsuggest=9 "show only 9 suggestions for misspelled words

" Lines added by the Vim-R-plugin command :RpluginConfig (2014-Nov-16 20:06):
filetype plugin on
" Use Ctrl+Space to do omnicompletion:
" Vinayak: the last <C-p> is to navigate the dropdown menu by adding new
"          characters
if has("gui_running")
    inoremap <C-Space> <C-x><C-o><C-p>
else
    inoremap <Nul> <C-x><C-o><C-p>
endif

" Force Vim to use 256 colors if running in a capable terminal emulator:
if &term =~ "xterm" || &term =~ "256" || $DISPLAY != "" || $HAS_256_COLORS == "yes"
    set t_Co=256
endif

" There are hundreds of color schemes for Vim on the internet, but you can
" start with color schemes already installed.
" Click on GVim menu bar "Edit / Color scheme" to know the name of your
" preferred color scheme, then, remove the double quote (which is a comment
" character, like the # is for R language) and replace the value "not_defined"
" below:
"colorscheme not_defined
"
   let g:solarized_termcolors=256

"   set background=light
"   let g:solarized_visibility = "high"
"   let g:solarized_contrast = "high"
"   se t_Co=256
"colorscheme pyte

hi Search cterm=None ctermfg=White ctermbg=LightBlue
