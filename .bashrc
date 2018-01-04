# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

## Launch tmux on start
#if command -v tmux>/dev/null; then
#  [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
#fi
[ -z "$TMUX"  ] && { tmux new-session;}  # This was: [ -z "$TMUX"  ] && { tmux attach || tmux new-session;}

alias tma='tmux attach -d -t'
alias git-tmux='tmux new -s $(basename $(pwd))'
alias zathur='zathura-tabbed 2> /dev/null'
alias rm='rm -I'

#so as not to be disturbed by Ctrl-S ctrl-Q in terminals:
stty -ixon

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Vinayak: to get a shorter bash prompt
export MYPS='$(echo -n "${PWD/#$HOME/\~}" | awk -F "/" '"'"'{
if (length($0) > 14) { if (NF>4) print $1 "/" $2 "/.../" $(NF-1) "/" $NF;
else if (NF>3) print $1 "/" $2 "/.../" $NF;
else print $1 "/.../" $NF; }
else print $0;}'"'"')'
#PS1='$(eval "echo $USER:${MYPS}")$ '
PS1='$(eval "echo ${MYPS}")$ '

#   if [ "$color_prompt" = yes ]; then
#   #    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#       PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#   else
#   #    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#       PS1='${debian_chroot:+($debian_chroot)}\u:\w\$ '
#   fi
   unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        #alias dir='dir --color=auto'
        #alias vdir='vdir --color=auto'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi

eval `dircolors /home/varao/.dir_colors/dircolors_vin`

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias ls='ls --color'
#LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
#export LS_COLORS

set -o vi

ev() (evince "$@" &>/dev/null )
alias evince="ev"

# Rplugin

   # Change the TERM environment variable (to get 256 colors) and make Vim
   # connecting to X Server even if running in a terminal emulator (to get
   # dynamic update of syntax highlight and Object Browser):
   if [ "x$DISPLAY" != "x" ]
   then
       if [ "screen" = "$TERM" ]
       then
           export TERM=screen-256color
       else
           export TERM=xterm-256color
       fi
       alias vi='vim --servername VIM'
       # Add a -X option below to avoid delay opening a file because
       # vim tries to connect to X
       #alias vi='~/git/vim/src//vim --servername VIM'
       # actually now I'm using nvim
       alias vi='nvim'
       if [ "x$TERM" == "xxterm" ] || [ "x$TERM" == "xxterm-256color" ]
       then
           function tvim(){ tmux -2 new-session "TERM=screen-256color vim --servername VIM $@" ; }
       else
           function tvim(){ tmux new-session "vim --servername VIM $@" ; }
       fi
   else
       if [ "x$TERM" == "xxterm" ] || [ "x$TERM" == "xxterm-256color" ]
       then
           function tvim(){ tmux -2 new-session "TERM=screen-256color vim $@" ; }
       else
           function tvim(){ tmux new-session "vim $@" ; }
       fi
   fi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_COMPLETION_TRIGGER="''"
export FZF_TMUX=1

# create a global per-pane variable that holds the pane's PWD
# Vinayak: I hacked this up a bit
export PS1=$PS1'$( [  $TMUX ] && eval tmxJNK=$MYPS && tmux setenv -g TMUX_PWD_$(tmux display -p "#D" | tr -d %) "$tmxJNK" && unset tmxJNK)'

pdfcat () {
    gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
        -sOutputFile=concatenated.pdf "$@"
  }
PATH=$PATH:$HOME/bin
MANPATH=$MANPATH:$HOME/share/man

# added by Miniconda2 4.0.5 installer
export PATH="/home/varao/Python/miniconda2/bin:$PATH"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export POWERLINE_CONFIG_COMMAND=powerline-config

#if [ -f `which powerline-daemon` ]; then
#    powerline-daemon -q
#    POWERLINE_BASH_CONTINUATION=1
#    POWERLINE_BASH_SELECT=1
#    .  /home/varao/Python/miniconda2/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
#fi
export PATH=$PATH:~/.cabal/bin:~/.xmonad/bin

export R_HISTFILE=~/.Rhistory
