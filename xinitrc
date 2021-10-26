autoperipherals

# Load X resources (fixes some font issues)
xrdb -merge .Xresources

# volume & brightness notification daemon
volnoti -t 1

# Enable numlock on boot (thanks me!)
numlockx on

# Restore brightness to previous level
xbacklight -set `cat ~/.brightness`

if [ -x /usr/bin/pasystray ]; then
    pasystray &
fi

if [ -x /usr/bin/nm-applet ]; then
    nm-applet &
fi

if [ -x /usr/bin/xcape ]; then
    xcape
fi

if [ -x /usr/bin/xsettingsd ]; then
    touch ~/.xsettingsd
    /usr/bin/xsettingsd &
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
