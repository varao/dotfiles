set fish_greeting ""
set fish_color_search_match --background='444'
fish_vi_key_bindings

alias zathur='/home/varao/git/zathura-tabbed/zathura-tabbed 2> /dev/null'
alias rm='rm -I'
function qp 
  qpdfview --unique $argv ^ /dev/null &
end

# some more ls aliases
alias ll='ls -alFN'
alias la='ls -AN'
alias l='ls -CFN'
alias pu='pushd'
alias po='popd'
# also useful is rg instead of grep and fd instead of find

alias ev="evince"
alias jl="jupyter-lab"
alias vi="nvim"

#so as not to be disturbed by Ctrl-S ctrl-Q in terminals:
stty -ixon

set FZF_COMPLETE = 2


# Vinayak: to get a shorter prompt
function fish_prompt
 echo "~$PWD\$ " | sed "s#^~$HOME##g" | awk -F "/" '{
  if (length($0) > 14) { 
    if (NF>4 && length($(NF-1)) < 8) print "/.../" $(NF-1) "/" $NF;
#    else if (NF>3) print "/.../" $NF;
    else print "/.../" $NF; 
    }
  else print $0;
  }'
end
function fish_right_prompt
  set_color $fish_color_autosuggestion 2> /dev/null; or set_color 555
  date "+%H:%M"
  set_color normal
end

function fish_mode_prompt
  # NOOP - Disable vim mode indicator
end

function c
    set -l dir (fasd -Rd "$argv$1" | fzf -1 -0 --no-sort +m); and cd "$dir"; or return 1
end
function cc
    set -l dir (fasd -Rdl "$argv$1" | fzf -1 -0 --no-sort +m); and cd "$dir"; or return 1
end

function v 
  set -l file (fasd -Rfl "$argv$1" | fzf -1 -0 --no-sort +m); and vi "$file"; or return 1
end
function z 
  set -l file (fasd -Rfl "$argv$1 .pdf\$" | fzf -1 -0 --no-sort +m); and zathur "$file"; or return 1
end
function q 
  set -l file (fasd -Rfl "$argv$1 .pdf\$" | fzf -1 -0 --no-sort +m); and qp "$file"; or return 1
end
