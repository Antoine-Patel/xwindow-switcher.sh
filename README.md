# xwindow-switcher.sh

A minimalist (<20 LOC) x11 window switcher (ALT+TAB replacement) in BASH.

Powered by [wmctrl](https://sites.google.com/site/tstyblo/wmctrl/) and
[Zenity](https://wiki.gnome.org/Projects/Zenity).

License: [MIT](LICENSE)

![xwindow-switcher screenshot](screenshot.png)

## Installation

1. Make sure you have
[wmctrl](https://sites.google.com/site/tstyblo/wmctrl/) and
[Zenity](https://wiki.gnome.org/Projects/Zenity) installed first (Use
you package manager if not).

2. Run [xwindow-switcher.sh](xwindow-switcher.sh) in a terminal
   (`./xwindow-switcher.sh`).

## Usage

###### `xwindow-switcher.sh`

Can be called without any options (defaults to a 600*400 GUI).

###### `xwindow-switcher.sh --help`

Shows the relevant parts of the help of Zenity. `xwindow-switcher.sh`
accepts the same arguments as `zenity --list ...`.

###### `xwindow-switcher.sh --width=800 --height=600 --title="My Custom Title"`

Set the width, height and title of `xwindow-switcher.sh`'s GUI.

