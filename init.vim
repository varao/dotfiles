set nocompatible
filetype off

call plug#begin('~/.local/share/nvim/plugged')

Plug 'lervag/vimtex'
"Bundle 'ctrlp.vim'
Plug 'flazz/vim-colorschemes'

Plug 'roxma/nvim-completion-manager'
Plug 'jalvesaq/Nvim-R', { 'for' : 'r' }
"Bundle 'gaalcaras/ncm-R'

Plug 'godlygeek/tabular'
"       Bundle 'vim-scripts/Vim-R-plugin'
"       Bundle 'vim-scripts/Screen-vim---gnu-screentmux'
"Bundle 'joequery/Stupid-EasyMotion'
Plug 'Lokaltog/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
"       Bundle 'kien/ctrlp.vim'
Plug 'sjl/gundo.vim'
"       Bundle 'vim-syntastic/syntastic'

Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-dispatch'
"Plug 'oblitum/frawor'
"Plug 'vim-scripts/aurum'
let g:dispatch_quickfix_height=3

Plug 'jpalardy/vim-slime'
let g:slime_target = "tmux"

Plug 'Valloric/YouCompleteMe'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
" Don't suggest completions shorter than 5 characters
let g:ycm_min_num_identifier_candidate_charsum_identifier_candidate_chars = 5

Plug 'wellle/tmux-complete.vim'  
" Call this with <C-x><C-u>
" I commented out lines in Youcompleteme/autoload/youcompleteme.vim
" so that the line below isn't overwritten
execute "set completefunc=tmuxcomplete#complete"
" Actually I uncommented it, and added this shortcut
" nnoremap <leader><Tab> :set completefunc=tmuxcomplete#complete<CR>
"
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Need to both install at .fzf and in .vim/bundle
"set rtp+=~/.fzf
"Bundle 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

call plug#end()

"let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsListSnippets="<c-s>"

let g:UltiSnipsExpandTrigger = "<nop>"
let g:ulti_expand_or_jump_res = 0
function ExpandSnippetOrCarriageReturn()
  let snippet = UltiSnips#ExpandSnippetOrJump()
  if g:ulti_expand_or_jump_res > 0
    return snippet
  else
    return "\<CR>"
  endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"


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
set backspace=indent,eol,start
nmap <CR> i<CR><Esc>

" Vim loads slowly trying to connct to X
" To highlight, copy or paste, hold shift down
" set clipboard=exclude:.*  

filetype on
filetype plugin indent on
syntax enable

let mapleader=","
let maplocalleader=","


" Actually I uncommented it, and added this shortcut
" See comment earlier, I need this after I define mapleader
nnoremap <leader><Tab> :set completefunc=tmuxcomplete#complete<CR>

" Navigate tabs firefox style
nnoremap <C-W><C-T> :tabprevious<CR>
nnoremap <C-W>t   :tabnext<CR>

" Tabs to splits and back
function MoveToPrevTab()

" Alt keys
  let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

set timeout ttimeoutlen=50
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
" let c='a'
" while c <= 'z'
"   exec "set <A-".c.">=\e".c
"   exec "imap \e".c." <A-".c.">"
"   let c = nr2char(1+char2nr(c))
" endw

set timeout ttimeoutlen=50
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP
"let g:ctrlp_map = '<c-p>'
"let g:ctrlp_prompt_mappings = {
"    \ 'AcceptSelection("h")': ['<cr>', '<2-LeftMouse>'],
"    \ 'AcceptSelection("e")': ['<c-x>'],
"    \ 'AcceptSelection("t")': ['<c-t>'],
"    \ 'AcceptSelection("v")': ['<NL>', '<RightMouse>'],
"    \ }
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
let NERDTreeMapOpenSplit='"'
let NERDTreeMapOpenVSplit='%'
"""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
let g:syntastic_enable_r_svtools_checker = 1
let g:syntastic_r_checkers=['lint']
"""""""""""""""""""""""""""""""""""""""""""""""""

"au BufRead,BufNewFile *.tex setlocal makeprg=pdflatex\ %
"au BufRead,BufNewFile *.tex setlocal makeprg=xelatex\ -shell-escape\ %
"% filename %:r filename modifier that discards extension
au BufRead,BufNewFile *.cc  set makeprg=g++\ -Wall\ -I/usr/local/include\ -lgsl\ -lgslcblas\ -lm\ %\ -o\ %:r
" automatically add newline if length greater than 74
" au BufRead,BufNewFile *.tex setlocal textwidth=74
set textwidth=74

nnoremap <leader>m :Make<CR>
nnoremap <leader>w :w<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""
" Backup
set undofile
set undodir=~/.local/share/nvim/tmp/undo/   " Have to make this folder
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" Session management
let g:session_directory = "~/.local/share/nvim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1
nnoremap <leader>so :OpenSession<CR>
nnoremap <leader>ss :SaveSession<CR>
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""

" Change Leader and LocalLeader keys:
let maplocalleader = ","
let mapleader = ";"

" Use Ctrl+Space to do omnicompletion:
if has("gui_running")
  inoremap <C-Space> <C-x><C-o>
else
  inoremap <Nul> <C-x><C-o>
endif

" Press the space bar to send lines and selection to R:
vmap <Space> <Plug>RDSendSelection
nmap <Space> <Plug>RDSendLine
"
" The lines below are suggestions for Vim in general and are not
" specific to the improvement of Nvim-R.
"
" Show where the next pattern is as you type it:
set incsearch

" Nfor Nvim-R
let R_in_buffer = 0
let R_applescript = 0
let R_tmux_split = 0

"""""""""""""""""""""""""""""""""""""""""""""""""
" Gundo
nnoremap <F6> :GundoToggle<CR>
set undofile
set history=100
set undolevels=100
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" R script settings
" let maplocalleader = ","
" vmap <Space> <Plug>RDSendSelection
" nmap <Space> <Plug>RDSendLine
" let vimrplugin_applescript=0
" let vimrplugin_vsplit=1
" let vimrplugin_assign = 0
" let g:vimrplugin_insert_mode_cmds = 0

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

"By default vim organizes undo into actions (e.g. entering and
"leaving insert mode). The options below break this up, and add
"entered text into the undo tree whenever you hit space, tab or return
inoremap <Space> <Space><C-g>u
"inoremap <Return> <Return><C-g>u  " This messes up vimtex autocomplete
inoremap <Tab> <Tab><C-g>u

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

autocmd ColorScheme * hi Sneak guifg=black guibg=red ctermfg=black ctermbg=red

"colorscheme pyte

hi Search ctermfg=Black ctermbg=DarkGrey
hi Visual ctermbg=Black
hi Error ctermfg=Red  ctermbg=Black gui=bold,underline
hi ErrorMsg ctermfg=1  ctermbg=8 gui=bold,underline
hi SpellBad ctermfg=Black  ctermbg=Red gui=bold,underline
hi Folded ctermbg=DarkGrey

" Disable folding by vimlatex
" autocmd Filetype tex setlocal nofoldenable

" Run Space
" Helps to select the text
xmap <leader><Space> <Plug>SlimeRegionSend
nmap <leader><Space> <Plug>SlimeLineSend
nmap <c-c>v     <Plug>SlimeConfig
let g:slime_default_config = {"socket_name": "default", "target_pane": "1"}

" Vinayak: Hacked up a little arrow for the vim rulerformat
hi VinArrow1 ctermfg=236 ctermbg=232
hi VinArrow2 ctermfg=31 ctermbg=236

function GitStat()
    let gitstat = system("git status --porcelain " . shellescape(expand("%")))[0:1]
    if gitstat ==? "fa"  
      return " "
    elseif gitstat ==? "??"
      return "?"
    elseif gitstat ==? ""
      return "✓"
    else
      return substitute(gitstat, " ", "","")
    endif
endfunction

let b:gitstat = GitStat()
set  rulerformat=%35(%=%#VinArrow1#\%#VinArrow2#\ %t\ %l,%c\ %2P\ %{b:gitstat}%)
autocmd BufReadPost,FileReadPost,Winenter,BufWritePost,FileWritePost * let b:gitstat = GitStat()


" This is the default extra key bindings
let g:fzf_action = {
   \ 'return': 'split',
   \ 'ctrl-t': 'tab split',
   \ 'ctrl-x': 'split',
   \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound
"                             to next-history and
" previous-history instead of down and up. If
"                             you don't like the change,
" explicitly bind the keys to down and up in
"                             your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
nnoremap <c-p> :FZF<cr>
nnoremap <c-a> :FZF ~<cr>

hi StatusLine  ctermfg=31 ctermbg=232 cterm=NONE
hi StatusLineNC  ctermfg=4 ctermbg=236 cterm=NONE

let g:vimtex_latexmk_build_dir = './build'
let g:latex_view_general_viewer = 'zathura'
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = "zathura"
hi MatchParen ctermbg=239
let g:vimtex_quickfix_open_on_warning=0

" Do we want quickfix on warnings?
nnoremap <localleader>lw :let g:vimtex_quickfix_open_on_warning = !g:vimtex_quickfix_open_on_warning<CR>

" Navigate quickfix
map <C-j> :cn<CR>
" map <C-k> :cp<CR> Never use this and have now remapped <C-k>
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

highlight Pmenu ctermbg=238 ctermfg=202 gui=bold
highlight PmenuSel  ctermbg=240 ctermfg=202 gui=bold

autocmd BufEnter * call system("tmux rename-window " . expand("%:t"). '\ ['. expand(v:servername).']')
autocmd VimLeave * call system("tmux rename-window bash")
" autocmd BufEnter * let &titlestring = ' ' . expand("%:t")                                                                 
" set title


map <Leader> <Plug>(easymotion-prefix)
map <leader><leader>w <Plug>(easymotion-bd-w)
map <leader><leader>e <Plug>(easymotion-bd-e)
map <leader><leader>f <Plug>(easymotion-bd-f)

let g:EasyMotion_disable_two_key_combo = 1
let g:EasyMotion_grouping = 1

map /  <Plug>(incsearch-forward)
map '/ <Plug>(incsearch-fuzzy-/)

hi EasyMotionTarget2First ctermbg=none ctermfg=red
hi EasyMotionTarget2Second ctermbg=none ctermfg=lightred

map f <Plug>Sneak_f
nmap <Tab> <Plug>SneakNext
nmap <Backspace> <Plug>SneakPrevious

" Vinayak (Rhistory)
inoremap <expr> <c-k> fzf#complete({
   \ 'source': 'cat ~/.Rhistory',
   \ 'down': '~30%',
   \ 'options': '--reverse --margin 15%,0' })
