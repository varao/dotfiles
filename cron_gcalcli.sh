#!/bin/bash
/home/varao/Python/miniconda/bin/gcalcli --conky --nocolor --lineart unicode --calendar "vinayak.apr" agenda  "7am" "next 7 days" > /home/varao/.gcalcli_tmp 
if test $? -eq 0 
then 
  mv $HOME/.gcalcli_tmp $HOME/.gcalcli 
else 
  rm $HOME/.gcalcli_tmp 
fi
sleep 1

curl -B wttr.in/laf | sed 's/\x1b\[[0-9;]*m//g' > $HOME/.gcalcli_tmp 
if test $? -eq 0 && grep -q Purdue $HOME/.gcalcli_tmp
then 
  mv $HOME/.gcalcli_tmp $HOME/.wthr 
else 
  rm $HOME/.gcalcli_tmp 
fi
sleep 1
