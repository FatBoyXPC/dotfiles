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

# seems like /etc/default/keyboard is getting ignored, so let's set this here
#setxkbmap -option compose:lwin

xmodmap ~/.Xmodmap
xcape

# xmonad doesn't set a cursor
xsetroot -cursor_name left_ptr

# Now, finally, start xmonad
exec xmonad
