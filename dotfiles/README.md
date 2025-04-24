I REALLY need to update this file!

Download the UHK Agent: https://github.com/ultimateHackingKeyboard/agent/

# Install [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) because it's awesome :)

XMonad Dependent
================

Add the repo for [Synapse](https://launchpad.net/~synapse-core/+archive/ubuntu/testing).

Update sources and install packages:
```
sudo apt-get update
sudo apt-get install xmonad xmobar numlockx trayer synapse git xbacklight php5-cli xvkbd xsel silversearcher-ag
```

Install [spf13-vim](https://github.com/spf13/spf13-vim)

Note: xbacklight is only necessary on laptops.

Install [volnoti](https://github.com/hcchu/volnoti#compilation-from-source-archive)
after installing installing these dependencies: `sudo apt-get install libgtk2.0-dev libdbus-glib-1-dev libdbus-1-dev`

If on X1 Carbon 3rd Gen, make sure to read that [section](#x1-carbon-3rd-gen-ubuntu-1404-specific)
before continuing!

I'm using the excellent [dotbot](https://github.com/anishathalye/dotbot) to
manage everything. Just git clone, and run the `./install` script!

~/.vimrc\*local ~/.agignore
`gem install tmuxinator`


Common Software
===============

PPAs:
[insync](https://www.insynchq.com/downloads),
[Screencloud](https://screencloud.net/#download),
[Darktable](https://launchpad.net/~pmjdebruijn/+archive/ubuntu/darktable-release),
[Mumble](https://wiki.mumble.info/wiki/Installing_Mumble#Ubuntu)

```
sudo apt-get update
sudo apt-get install insync screencloud tree roxterm darktable pidgin keepass2 filezilla mumble
```

Install [Sublime](http://www.sublimetext.com/) and its [Package Control](https://packagecontrol.io/installation)

The `git update-submodules` command is failing currently!

install emacs:
``````
sudo add-apt-repository ppa:ubuntu-elisp/ppa
sudo apt-get update
sudo apt-get install emacs-snapshot
```

Make sure the correct alternatives version is used:
```
sudo update-alternatives --config emacs
```

Dealing with `xdg-open`:
```
xdg-mime query filetype /path/to/file
xdg-mime default eog.desktop image/x-apple-ios-png
```
Or the appropriate `.desktop` file and mime type can be added to `mimeapps.list`
in the `[Default Applications]` section

## X1 Carbon 3rd Gen Ubuntu 14.04 Specific:

To avoid headphone popping:
```
sudo vi /usr/lib/pm-utils/power.d/intel-audio-powersave
Change: INTEL_AUDIO_POWERSAVE=${INTEL_AUDIO_POWERSAVE:-true}
To: INTEL_AUDIO_POWERSAVE=false
Reboot

Install compton: `sudo apt-get install compton`
```

#### Kernel
Ubuntu 14.04 ships with kernel 3.16, but the trackpoint doesn't work with this
version. It does with 3.19, however this version seems to cause random freezes,
and 4.5 seems to have issues with volnoti. 4.0 seems to be the sweet spot.

Download the linux-headers-all, linux-headers-generic, and linux-image-generic
amd_64 packages [here](http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.0-vivid/).

Install them with `sudo dpkg -i package-name`. Start with headers-all, then
generic, and ending with image.

Note: At the time of writing, 4.0 kernel isn't available in the apt repos. It
might be worth checking if they are available when this is setup again.

Reboot and ensure you're on the right kernel with `uname -r` and remove old kernels:
```
sudo apt-get purge linux-generic linux-image-generic linux-headers-generic linux-signed-generic
```

Check for other packages with 3.16 or older kernels:
```
dpkg -l | grep -E "linux-(generic|headers|image|signed)" | colrm 80
```

Remove packages that were found with `sudo apt-get purge`

#### xmobar

xmobar 0.19 with kernel 3.19 seems to have [a bug](https://github.com/jaor/xmobar/issues/170) when checking memory usage.
Install cabal-install/Hackage, and libxpm-dev and install xmobar:
```
sudo apt-get install cabal-install libxpm-dev
cabal update
cabal install xmobar
sudo rm /usr/bin/xmobar
sudo cp ~/.cabal/bin/xmobar /usr/bin/xmobar
```


#### NOTE
With xmonad > 0.11, this change is relevant:
https://wiki.haskell.org/Xmonad/Notable_changes_since_0.11#updatePointer

This means the updatePointer (Relative x y) line needs to change!

DONT FORGET /usr/lib/ssh/x11-ssh-askpass
`pacman -Ql x11-ssh-askpass`
`pacman -S expect xcape`
