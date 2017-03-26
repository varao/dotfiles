xterm -e 'find * | /home/varao/.fzf/bin/fzf > /tmp/found 

f_fzf=$(</tmp/found)
f_fzf=${f_fzf// /\\ }

if [ -z "${f_fzf// }" ]; then 
  echo " "
elif [ -d "$f_fzf" ]; then 
  echo "gnome-terminal --working-directory=$f_fzf" > /tmp/found
elif [ ${f_fzf: -4} == ".pdf" ]; then
  echo "evince $f_fzf" > /tmp/found
else 
  echo "gnome-terminal -e \"/home/varao/git/vim/src/vim $f_fzf\"" > /tmp/found
fi

chmod +x /tmp/found
'

/tmp/found
