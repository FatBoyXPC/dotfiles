autoperipherals sync

# Load X resources (fixes some font issues)
xrdb -merge .Xresources

# volume & brightness notification daemon
volnoti -t 1

# Enable numlock on boot (thanks me!)
numlockx on

# Restore brightness to previous level
xbacklight -set `cat ~/.brightness`

if command -v pasystray; then
    pasystray &
fi

if command -v nm-applet; then
    nm-applet &
fi

# REMOVE when moving to nixos!
if command -v xcape; then
    xcape
fi

if command -v xsettingsd; then
    touch ~/.xsettingsd
    xsettingsd &
fi

if command -v polybar; then
    polybar &
fi

if command -v flameshot; then
    flameshot &
fi

# From https://wiki.archlinux.org/index.php/GNOME/Keyring#xinitrc_method
if [ -x /usr/bin/gnome-keyring-daemon ]; then
    dbus-update-activation-environment --systemd DISPLAY
    eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    export SSH_AUTH_SOCK
fi

# xmonad doesn't set a cursor
xsetroot -cursor_name left_ptr

# Now, finally, start xmonad
exec xmonad
