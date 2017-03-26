xterm -e '.fzf/bin/fzf > /tmp/found 

f_fzf=$(</tmp/found)

if [ -z "${f_fzf// }" ]; then 
 echo "abc"
elif [ ${f_fzf: -4} == ".pdf" ]; then
  echo "evince $f_fzf" > /tmp/found
else 
  echo "gnome-terminal -e \"/home/varao/git/vim/src/vim $f_fzf\"" > /tmp/found
fi

chmod +x /tmp/found
'

/tmp/found
