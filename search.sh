
xterm -e '

function run_sel() {
  f_fzf=$1
  f_fzf=${f_fzf// /\\ }

  if [ -z "${f_fzf// }" ]; then 
    spwn_cmd="" 
  elif [ -d "$f_fzf" ]; then 
    spwn_cmd="gnome-terminal --working-directory=$f_fzf"
  elif [ ${f_fzf: -4} == ".pdf" ]; then
    spwn_cmd="nohup zathura $f_fzf &> /dev/null &"
  else 
    spwn_cmd="gnome-terminal -e \"/home/varao/git/vim/src/vim $f_fzf\"" 
  fi
  eval $spwn_cmd
}
export -f run_sel

stdir="/home/varao"
stdir_o=$(dirname $stdir)  # get parent dir
f_fzf="tmp"

while [ ! -z "${f_fzf// }" ]; do
  f_fzf="$({ echo $stdir_o; /home/varao/git/bfs/bfs $stdir -exclude -name .git 2> /dev/null | tail -n +2 ; } | /home/varao/.fzf/bin/fzf +s --bind "tab:accept,enter:execute(run_sel {} &)")"
  stdir=$f_fzf
  stdir_o=$(dirname $stdir)
done
# installed bfs from https://github.com/tavianator/bfs, branch exclude

'
