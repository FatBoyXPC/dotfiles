autoperipherals

# Load X resources (fixes some font issues)
xrdb -merge .Xresources

#
# SCREEN CONFIGURATION
#
if [ "`hostname`" == "jamespc" ]; then
    xrandr --output DVI-I-1 --auto --output DVI-D-0 --auto --right-of DVI-I-1 --output HDMI-0 --auto --right-of DVI-D-0
fi

if [ "`hostname`" == "fatboyxpc" ]; then
    xrandr --output eDP1 --auto --output DP5 --auto
fi

# volume & brightness notification daemon
volnoti -t 1

# Enable numlock on boot (thanks me!)
numlockx on

# Restore brightness to previous level
xbacklight -set `cat ~/.brightness`

# seems like /etc/default/keyboard is getting ignored, so let's set this here
setxkbmap -option compose:rctrl

xmodmap ~/.Xmodmap
xcape

if [ -x /usr/bin/nm-applet ]; then
    nm-applet &
fi

if [ -x /usr/bin/dunst ]; then
    dunst -force_xinerama &
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
