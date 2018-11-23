#!/bin/bash
# Add command to execute in SystemTools/Preferences/StartupApplications
#synclient TapButton3=2

syndaemon -i 1 -K -d  # disable touchpad for 1 sec while typing

xcape -e "Shift_R=Escape" #;Hyper_L=Tab"

sleep 1 && conky -x 500; sleep 1 && conky -x 2500


