#! /usr/bin/env bash

# Antoine Patel (antoine.patel.fr@gmail.com)
#
# Licence: http://opensource.org/licenses/MIT (See also at the end of
# this file)
#
# xwindow-switcher:
#
# A <20 LOC x11 window switcher (ALT+TAB replacement) written in BASH,
# with a Graphical User Interface (no mouse needed), powered by wmctrl
# [https://sites.google.com/site/tstyblo/wmctrl/] and Zenity
# [https://wiki.gnome.org/Projects/Zenity].
#
# Note that you can type the beginning of the TITLE of the window in
# the choice list to select it, then type ENTER to switch to it: no
# mouse needed to control the GUI.
#
# For a GUI-less version, use 'wmctrl' directly.


# Most windows manager of multiple workspaces aka desktops. We get the
# id of the current one.
current_desktop_id=$(wmctrl -d | grep '*' | cut -f1 -d' ')

# We retrieve a list of the open windows for the current desktop. It
# looks like:
#
# 0x02400008  1 antoine-mint1 Terminal
# 0x02400e62  1 antoine-mint1 Terminal
# 0x034002f8  1 antoine-mint1 Note from 2015-10-06 11:03:29.700
# 0x022000a3  1 antoine-mint1 emacs@someone
# 0x0360009a  1 antoine-mint1 *Untitled Document 1 - gedit
# 0x02e00001  1 antoine-mint1 wmctrl - Chromium
this_desktop_windows=$(wmctrl -l | grep " "$current_desktop_id" ")

# Now we only want the TITLEs of the windows, ie. the last part. We
# need this to allow users to choose their window by typing the
# beginning to its TITLE == No mouse needed.
window_names=$(echo "$this_desktop_windows" | cut -f'5-' -d' ')
wids=$(echo "$this_desktop_windows" | cut -f1 -d' ')


# A GUI to choose the window to switch to.
choice=$(echo "$window_names" | \
    zenity --list --title 'Switch to window' --column 'Windows')

# Now we have the TITLE of the choosen window: get its ID (the
# hexadecimal number looking like 0x02400008).
choice=$(echo "$choice" | cut -f1 -d'|')
choice=$(echo "$this_desktop_windows" | grep "$choice" | cut -f1 -d' ')

# Finally switch to the Window. We need to use its ID to target the
# correct window when multiple ones have the same TITLE in *different*
# desktops.
wmctrl -i -a $choice


# Note: below I didn't specify the Copyright correctly. I don't care.
#
# =======================================================================
#
# The MIT License (MIT)

# Copyright (c) <year> <copyright holders>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
