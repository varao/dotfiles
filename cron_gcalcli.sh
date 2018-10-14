#!/bin/bash
/home/varao/Python/anaconda3/bin/gcalcli --conky --nocolor --lineart unicode --calendar "vinayak.apr" agenda  "7am" "next 7 days" > /home/varao/.gcalcli_tmp 
if test $? -eq 0 
then 
  mv /home/varao/.gcalcli_tmp /home/varao/.gcalcli 
else 
  rm /home/varao/.gcalcli_tmp 
fi
