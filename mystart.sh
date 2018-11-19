#!/bin/bash
# Add command to execute in SystemTools/Preferences/StartupApplications
#xmodmap ~/.Xmodmap 
#synclient TapButton3=2
xcape -e "Shift_R=Escape" #;Hyper_L=Tab"

sleep 1 && conky -x 500; sleep 1 && conky -x 2500
