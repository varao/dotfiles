set nocompatible
filetype off
set shell=/usr/local/bin/fish

call plug#begin('/home/varao/.local/share/nvim/plugged')

  Plug 'dag/vim-fish'
  Plug 'lervag/vimtex'
  Plug 'flazz/vim-colorschemes'
  
  Plug 'roxma/nvim-completion-manager'
  Plug 'jalvesaq/Nvim-R', { 'for' : 'r' }
  Plug 'bfredl/nvim-ipy'

  Plug 'godlygeek/tabular'
  Plug 'Lokaltog/vim-easymotion'
  Plug 'justinmk/vim-sneak'
  Plug 'haya14busa/incsearch.vim'
  Plug 'haya14busa/incsearch-fuzzy.vim'
  "Plug 'vim-syntastic/syntastic'
  
  Plug 'skywind3000/asyncrun.vim'
  "Plug 'plasticboy/vim-markdown'
  "Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
  Plug 'vim-pandoc/vim-pandoc'
  Plug 'vim-pandoc/vim-pandoc-syntax'
  Plug 'vim-pandoc/vim-rmarkdown'
 " Plug '~/.local/share/nvim/plugged/vim-bookdown'

  Plug 'scrooloose/nerdtree'
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-dispatch'
  let g:dispatch_quickfix_height=3

  Plug 'Valloric/YouCompleteMe'

  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'

  " Need to both install at .fzf and in .vim/bundle
  "Bundle 'junegunn/fzf.vim'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

  Plug 'lynnard/pandoc-preview.vim'
call plug#end()

set  hlsearch
set  expandtab
set  tabstop=4
set  shiftwidth=2
set  laststatus=0

set  wrap
set  lbr
set  breakindent 
set  breakindentopt=shift:1
set  breakat+='~'
"call matchadd('Error', '\(^\)\@<!\s\{2,\}')  " To highlight extra whitespaces vs 'blanks' displayed due to wrapping at words

set  ruler
set  lazyredraw
set  mouse=a
" A hack for when I call nvim directly from gnome-terminal without bash
let $PATH .= ":/home/varao/Python/anaconda3/bin"

set  relativenumber
set  number
set backspace=indent,eol,start
nmap <CR> i<CR><Esc>

" copy and paste to clipboard
vmap <C-c> "+yi
vmap <C-x> "+d

nnoremap E ge
vnoremap E ge
nnoremap R <c-r>

" Vim loads slowly trying to connct to X
" To highlight, copy or paste, hold shift down
" set clipboard=exclude:.*  

filetype on
filetype plugin indent on
syntax enable

let maplocalleader = ","
let mapleader = ","
""""""""""""""""""
" nnoremap <C-Left> <C-w>h
" nnoremap <C-Right> <C-w>l
" nnoremap <C-Up> <C-w>k
" nnoremap <C-Down> <C-w>j
" nnoremap <C-=> <C-w>=

nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j

nnoremap <leader>sh <C-w>h
nnoremap <leader>sl <C-w>l
nnoremap <leader>sk <C-w>k
nnoremap <leader>sj <C-w>j
nnoremap <leader>sH <C-w>H
nnoremap <leader>sL <C-w>L
nnoremap <leader>sK <C-w>K
nnoremap <leader>sJ <C-w>J
nnoremap <leader>s= <C-w>=

nnoremap <C-Left> :vertical resize -1<CR>
nnoremap <C-Right> :vertical resize +1<CR>
nnoremap <C-Up> :resize -1<CR>
nnoremap <C-Down> :resize +1<CR>

" mapping to make movements operate on 1 screen line in wrap mode
function! ScreenMovement(movement)
   if &wrap
      return "g" . a:movement
   else
      return a:movement
   endif
endfunction
onoremap <silent> <expr> j ScreenMovement("j")
onoremap <silent> <expr> k ScreenMovement("k")
onoremap <silent> <expr> 0 ScreenMovement("0")
onoremap <silent> <expr> ^ ScreenMovement("^")
onoremap <silent> <expr> $ ScreenMovement("$")
nnoremap <silent> <expr> j ScreenMovement("j")
nnoremap <silent> <expr> k ScreenMovement("k")
nnoremap <silent> <expr> 0 ScreenMovement("0")
nnoremap <silent> <expr> ^ ScreenMovement("^")
nnoremap <silent> <expr> $ ScreenMovement("$")
vnoremap <silent> <expr> j ScreenMovement("j")
vnoremap <silent> <expr> k ScreenMovement("k")
vnoremap <silent> <expr> 0 ScreenMovement("0")
vnoremap <silent> <expr> ^ ScreenMovement("^")
vnoremap <silent> <expr> $ ScreenMovement("$")
""""""""""""""""""

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

nnoremap <leader>tk :call MoveToNextTab()<CR>
nnoremap <leader>tj :call MoveToPrevTab()<CR>

" Also, :<C-W><C-T> creates a new tab
nnoremap <leader>tt  :tabnew<CR>
"
" Navigate tabs firefox style
nnoremap <leader>tl   :tabnext<CR>
nnoremap <leader>th   :tabprevious<CR>

""""""""""""""""""""""

set timeout ttimeoutlen=50

"au BufRead,BufNewFile *.tex setlocal makeprg=pdflatex\ %
"au BufRead,BufNewFile *.tex setlocal makeprg=xelatex\ -shell-escape\ %
"% filename %:r filename modifier that discards extension
au BufRead,BufNewFile *.cc  set makeprg=g++\ -Wall\ -I/usr/local/include\ -lgsl\ -lgslcblas\ -lm\ %\ -o\ %:r
" automatically add newline if length greater than 74
" au BufRead,BufNewFile *.tex setlocal textwidth=74
" set textwidth=74

"""""""""""""""""""""""""""""""""""""""""""""""""

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

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
" Don't suggest completions shorter than 5 characters
let g:ycm_min_num_identifier_candidate_charsum_identifier_candidate_chars = 5

"""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
let g:syntastic_enable_r_svtools_checker = 1
let g:syntastic_r_checkers=['lint']
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>m :Make<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""
" Backup
set undofile
set undodir=~/.local/share/nvim/tmp/undo/   " Have to make this folder
set undolevels=5000
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" Session management
" let g:session_directory = "~/.local/share/nvim/session"
" let g:session_autoload = "no"
" let g:session_autosave = "no"
" let g:session_command_aliases = 1
" nnoremap <leader>so :OpenSession<CR>
" nnoremap <leader>ss :SaveSession<CR>
" nnoremap <leader>sd :DeleteSession<CR>
" nnoremap <leader>sc :CloseSession<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""

" Change Leader and LocalLeader keys:
let maplocalleader = ";"
let mapleader = ","

" Use Ctrl+Space to do omnicompletion:
if has("gui_running")
  inoremap <C-Space> <C-x><C-o>
else
  inoremap <Nul> <C-x><C-o>
endif

" Show where the next pattern is as you type it:
set incsearch

""""""""""""""""""""
" for Nvim-R
let R_in_buffer = 0
let R_applescript = 0
"let R_tmux_split = 0

" Press the space bar to send lines and selection to R:
vmap <Space> <Plug>RDSendSelection
nmap <Space> <Plug>RDSendLine

""""""""""""""""""""
" for nvim-ipy
let g:nvim_ipy_perform_mappings = 0

vmap <Space> <Plug>(IPy-Run)j
nmap <Space> <Plug>(IPy-Run)j
nmap <C-Space> <Plug>(IPy-Complete)j
nmap ? <Plug>(IPy-WordObjInfo)

""""""""""""""""""""
" For neovim terminal
tnoremap <Esc> <C-\><C-n>

command! -nargs=* T split | terminal <args>
command! -nargs=* VT vsplit | terminal <args>

autocmd TermOpen * startinsert
"autocmd BufWinEnter,WinEnter term://* startinsert

au TermOpen * setlocal nonumber norelativenumber

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

" Select buffers with FZF
" @see https://github.com/junegunn/fzf/wiki/Examples-(vim)#select-buffer
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-h': 'sbuffer',
      \ 'ctrl-v': 'vert sbuffer',
      \ 'ctrl-t': 'tab sb',
      \ 'ctrl-d': 'bd'}, a:lines[0], 'buffer')
  let list = a:lines[1:]

  let first = list[0]
  execute cmd matchstr(first, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader>b :call fzf#run({
  \   'source':  reverse(<sid>buflist()),
  \   'sink*':    function('<sid>bufopen'),
  \   'options': '+m --ansi --expect=ctrl-t,ctrl-v,ctrl-x,ctrl-d',
  \   'down':    len(<sid>buflist()) + 2
  \ })<CR>

""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
"""   Tabular
vnoremap <leader>t :Tabular<space>/
"""""""""""""""""""""""""""""""""""""""""""""""""

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

" Inherit the colorscheme from the terminal 
let g:solarized_termcolors=256

autocmd ColorScheme * hi Sneak guifg=black guibg=red ctermfg=black ctermbg=red

hi Search ctermfg=Black ctermbg=DarkGrey
hi Visual ctermbg=Black
hi Error ctermfg=Red  ctermbg=Black gui=bold,underline
hi ErrorMsg ctermfg=1  ctermbg=8 gui=bold,underline
hi SpellBad ctermfg=Red  ctermbg=black gui=underline
hi Folded ctermbg=DarkGrey
hi Visual ctermbg=Black

hi TabLineFill ctermfg=232 ctermbg=232
hi TabLine ctermfg=Blue ctermbg=232
hi TabLineSel ctermfg=Blue ctermbg=Black
hi clear ModeMsg  " So -- INSERT -- etc aren't bright

" Run Space
" Helps to select the text
xmap <localleader><Space> <Plug>SlimeRegionSend
nmap <localleader><Space> <Plug>SlimeLineSend
nmap <c-c>v     <Plug>SlimeConfig
let g:slime_default_config = {"socket_name": "default", "target_pane": "1"}

" Vinayak: Hacked up a little arrow for the vim rulerformat
hi VinArrow1 ctermfg=236 ctermbg=232
hi VinArrow2 ctermfg=31 ctermbg=236

"set  rulerformat=%35(%=%#VinArrow1#\%#VinArrow2#\ %t\ %l,%c\ %2P%) "\ %{b:gitstat}%)
set  rulerformat=%35(%=%#VinArrow1#\%#VinArrow2#\ %t\ %l,%c\ %2P%) "\ %{b:gitstat}%)


" This is the default extra key bindings
let g:fzf_action = {
   \ 'return': 'split',
   \ 'ctrl-t': 'tab split',
   \ 'ctrl-x': 'split',
   \ 'ctrl-v': 'vsplit',
   \ 'ctrl-z': 'silent !zathura_bg '}

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
nnoremap <leader>n :FZF<cr>
nnoremap <leader>~ :FZF ~<cr>
" NERDTree
" I have also added a custom file gx.vim
let NERDTreeMapOpenSplit='s'
let NERDTreeMapOpenVSplit='v'
let NERDTreeMinimalUI = 1
let NERDTreeHijackNetrw=1

nnoremap <leader>N :NERDTreeToggle<CR>
" Close vim if only NERDTree
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"""""""""""""""""""""""""""""""""""""""""""""""""
let g:vim_markdown_folding_disabled = 1

let g:mkdp_browser = 'firefox'
let g:mkdp_refresh_slow=1
"let g:pandoc#folding#fdc = 0
hi! link FoldColumn Normal
let g:pandoc#folding#level = 3
"let g:pandoc#modules#disabled = ["folding", "spell"]
let g:pandoc#syntax#conceal#use = 0

let g:pandoc_preview_pdf_cmd = "zathura" 


hi StatusLine  ctermfg=31 ctermbg=232 cterm=NONE
hi StatusLineNC  ctermfg=4 ctermbg=236 cterm=NONE

let g:vimtex_quickfix_mode=2
let g:vimtex_latexmk_build_dir = './build'
let g:latex_view_general_viewer = 'zathura'
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = "zathura"
hi MatchParen ctermbg=239
let g:vimtex_quickfix_open_on_warning=0
let g:vimtex_quickfix_blgparser = {'disable':1}
let g:vimtex_latexmk_progname = '/home/varao/git/neovim-remote'
let g:vimtex_complete_recursive_bib = 1

" Do we want quickfix on warnings?
nnoremap <localleader>lw :let g:vimtex_quickfix_open_on_warning = !g:vimtex_quickfix_open_on_warning<CR>

" Navigate quickfix
map <C-q> :cn<CR>
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

highlight Pmenu ctermbg=238 ctermfg=202 gui=bold
highlight PmenuSel  ctermbg=240 ctermfg=202 gui=bold


""""""""""""""""""""""""""""""""""""""""""""
" Shortcuts for easy navigation
"
"map <Leader> <Plug>(easymotion-prefix)
map <localleader>w <Plug>(easymotion-bd-w)
map <localleader>e <Plug>(easymotion-bd-e)
map <localleader>f <Plug>(easymotion-bd-f)

let g:EasyMotion_disable_two_key_combo = 1
let g:EasyMotion_grouping = 1

map /  <Plug>(incsearch-forward)
map '/ <Plug>(incsearch-fuzzy-/)

hi EasyMotionTarget2First ctermbg=none ctermfg=red
hi EasyMotionTarget2Second ctermbg=none ctermfg=lightred

map f <Plug>Sneak_f
nmap <Tab> <Plug>SneakNext
nmap <Backspace> <Plug>SneakPrevious
"
""""""""""""""""""""""""""""""""""""""""""""
" Markdown
"map <localleader>m :call mkdp#util#open_preview_page()<CR><CR>
"map <localleader>m :PandocPreview <CR>
"map <localleader>m :RMarkdown pdf<CR>
map <localleader>m :call ToggleRMarkdown()<CR> 
let s:Rmd_on = 0
function! ToggleRMarkdown()
    if s:Rmd_on
      let s:Rmd_on = 0
      augroup RMarkdown_auto
        autocmd!
      augroup END
    else
      let s:Rmd_on = 1
      augroup RMarkdown_auto
        RMarkdown pdf
        autocmd!
        autocmd BufWritePost <buffer> :silent! RMarkdown pdf
      augroup END
    endif
endfunction

let g:asyncrun_exit = "if g:asyncrun_status == 'failure' | call asyncrun#quickfix_toggle(8, 1) | else | echo 'complete' | end"

map <localleader>M :silent! call ToggleBookdown()<CR> 
let s:Bmd_on = 0
function! ToggleBookdown()
    if s:Bmd_on
      let s:Bmd_on = 0
      augroup Bookdown_auto
        autocmd!
      augroup END
    else
      let s:Bmd_on = 1
      augroup Bookdown_auto
        " Bookdown pdf
       AsyncRun Rscript -e 'bookdown::preview_chapter("%:p", "bookdown::pdf_book")' 
        autocmd!
       autocmd BufWritePost <buffer> :AsyncRun Rscript -e 'bookdown::preview_chapter("%:p", "bookdown::pdf_book")' 
"        autocmd BufWritePost <buffer> :silent! Bookdown pdf
      augroup END
    endif
  endfunction

" Vinayak (Rhistory)
inoremap <expr> <c-k> fzf#complete({
   \ 'source': 'cat ~/.Rhistory',
   \ 'down': '~30%',
   \ 'options': '--reverse --margin 15%,0' })
