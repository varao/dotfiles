xterm +hm -name fzf_term -e '

function run_sel() {
  f_fzf=$1
  f_fzf=${f_fzf// /\\ }

  if [ -z "${f_fzf// }" ]; then 
    spwn_cmd="" 
  elif [ -d "$f_fzf" ]; then 
    spwn_cmd="gnome-terminal --working-directory=$f_fzf"
  elif [ ${f_fzf: -4} == ".pdf" ]; then
    spwn_cmd="nohup zathura-tabbed $f_fzf &> /dev/null &"
  else 
    spwn_cmd="gnome-terminal -e \"$HOME/git/vim/src/vim $f_fzf\"" 
  fi
  eval $spwn_cmd
}
export -f run_sel

stdir=$HOME
stdir_o=$(dirname $stdir)  # get parent dir
f_fzf="tmp"

while [ ! -z "${f_fzf// }" ]; do
  echo $f_fzf
  f_fzf="$({ echo $stdir_o; 
             $HOME/git/bfs/bfs "$stdir" -color -exclude -name .git 2> /dev/null | tail -n +2 ; } | $HOME/.fzf/bin/fzf +s --ansi --color=fg+:-1,spinner:5,hl:1,hl+:1,info:5,bg+:7 --bind "tab:accept,enter:execute(run_sel {} &)")"
  stdir=$f_fzf
  # Need quotes inside $() (and above) for whitespaces in filenames 
  stdir_o=$(dirname "$stdir") 
done
# installed bfs from https://github.com/tavianator/bfs, branch exclude

'

