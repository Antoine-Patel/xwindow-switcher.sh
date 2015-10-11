#!/usr/bin/env bash

# Antoine Patel (antoine.patel.fr@gmail.com)
#
# Licence: MIT (http://opensource.org/licenses/MIT)
#
# xwindow-switcher:
#
# A <20 LOC x11 window switcher (ALT+TAB replacement) written in BASH,
# with a Graphical User Interface (no mouse required, however),
# powered by wmctrl [https://sites.google.com/site/tstyblo/wmctrl/]
# and Zenity [https://wiki.gnome.org/Projects/Zenity].
#
# Please install wmctrl and Zenity first.
#
# Note that you can type the beginning of the TITLE of the window in
# the choice list, then type ENTER to switch to it: no mouse needed to
# control the GUI.
#
# For a GUI-less version, use 'wmctrl' directly.

# First command options for Zenity are stored as a string.
options=$@
if [[ "$options" = "--help" ]]
then
    printf "Note: Options passed to $0 are forwared to Zenity. 
Its help is shown below.\n$(zenity --help-general)\n$(zenity --help-list)\n"
    exit
fi

# Using an array to store the options.
arguments=(${options:="--width=600 --height=400"})

# Most windows manager have multiple workspaces aka desktops. We get
# the id of the current one.
current_desktop_id=$(wmctrl -d | grep '*' | cut -f1 -d' ')

# wmctrl -l produces something like:
#
# 0x01800007 -1 antoine-mint1 Desktop
# 0x01e00080  0 antoine-mint1 Inbox - someone@email.com - ...
# 0x02400008  1 antoine-mint1 Terminal
# 0x02400e62  1 antoine-mint1 Terminal
# 0x034002f8  1 antoine-mint1 Note from 2015-10-06 11:03:29.700
# 0x022000a3  1 antoine-mint1 emacs@antoine-mint1

# Now we only want the TITLEs and IDs of the windows, ie. the last
# part and the first column. We reorder by putting the TITLEs first,
# then the IDs. This to allow users to choose their window by typing
# the beginning to its TITLE == No mouse needed.
window_names=$(wmctrl -l | \
    grep -e "[0-9]x[0-9a-zA-Z]\+[ \t]* $current_desktop_id " | \
    cut -f'1,5-' -d' ' | \
    sed 's;\([^ \t]\+\) \(.*\);\2 ([\1]);g')
# sed: reorder the two columns.

# Use Zenity to provide a GUI to choose the window to switch to.
choice=$(echo "$window_names" | zenity --list --title 'Switch to window' \
    --column 'Windows' "${arguments[@]}")

# Extract the ID of the choosed window (the hexadecimal number looking
# like 0x02400008).
choice=$(echo "$choice" | cut -f1 -d'|' | awk -F'(' '{print $NF}')

# Finally switch to the window. We need to use its ID to target it
# exactly when multiple ones have the same TITLE in *different*
# desktops. $choice is something like "[0x022000a3])" at this point, so
# we trim it a little.
wmctrl -i -a "${choice:1:(-2)}"

