
xterm -e '

function run_sel() {
  f_fzf=$1
  f_fzf=${f_fzf// /\\ }

  if [ -z "${f_fzf// }" ]; then 
    echo "" > /tmp/found
  elif [ -d "$f_fzf" ]; then 
    echo "gnome-terminal --working-directory=$f_fzf" > /tmp/found
  elif [ ${f_fzf: -4} == ".pdf" ]; then
    echo "nohup zathura $f_fzf &> /dev/null &" > /tmp/found
  else 
    echo "gnome-terminal -e \"/home/varao/git/vim/src/vim $f_fzf\"" > /tmp/found
  fi
  chmod +x /tmp/found
  /tmp/found
}
export -f run_sel

stdir="/home/varao"
stdir_o=$(dirname $stdir)  # get parent dir
f_fzf="tmp"

while [ ! -z "${f_fzf// }" ]; do
  echo $f_fzf
  f_fzf="$({ echo $stdir_o; /home/varao/git/bfs/bfs $stdir -exclude -name .git 2> /dev/null | tail -n +2 ; } | /home/varao/.fzf/bin/fzf --bind "tab:accept,enter:execute(run_sel {} &)")"
  stdir=$f_fzf
  stdir_o=$(dirname $stdir)
done
# installed bfs from https://github.com/tavianator/bfs, branch exclude

'

