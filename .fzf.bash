# Setup fzf
# ---------
if [[ ! "$PATH" == */home/varao/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/varao/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/varao/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/varao/.fzf/shell/key-bindings.bash"
