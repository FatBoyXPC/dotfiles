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

# Run the gnome-keyring-daemon to avoid issues you otherwise may encounter
# when using gnome applications which expect access to the keyring, such
# as Empathy. This prevents prompts you may otherwise get for invalid
# certificates and the like. On login, we unlock the ssh keychain so we're not
# prompted for  passphrases later. We pipe /dev/null to ssh-add to make it
# realize it's not running in a terminal. Otherwise, it won't launch the prompt.
gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh
cat /dev/null | ssh-add &

# volume & brightness notification daemon
volnoti -t 1

# seems like /etc/default/keyboard is getting ignored, so let's set this here
setxkbmap -option compose:lwin

xmodmap ~/.Xmodmap

# xmonad doesn't set a cursor
xsetroot -cursor_name left_ptr

# Now, finally, start xmonad
exec xmonad
