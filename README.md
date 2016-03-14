XMonad Dependent:
===========

Install [ohmyzsh](https://github.com/robbyrussell/oh-my-zsh) because it's
awesome!

Add the repos for
[insync](https://www.insynchq.com/downloads),
[Screencloud](https://screencloud.net/#download),
and [Synapse](https://launchpad.net/~synapse-core/+archive/ubuntu/testing).


Update sources and install packages:
```
sudo apt-get update
sudo apt-get install xmonad xmobar numlockx trayer synapse screencloud insync git tree xbacklight php5-cli
```

Note: xbacklight is only necessary on laptops.

Install [volnoti](https://github.com/hcchu/volnoti#compilation-from-source-archive)
after installing installing the dependencies: `sudo apt-get install libgtk2.0-dev libdbus-glib-1-dev libdbus-1-dev`

If on X1 Carbon 3rd Gen, make sure to read that [section](#x1-carbon-3rd-gen-ubuntu-1404-specific)
before continuing!

I'm using the excellent [dotbot](https://github.com/anishathalye/dotbot) to
manage everything. Just git clone, and run the `./install` script!

Common Software
===============

PPAs:
[Darktable](https://launchpad.net/~pmjdebruijn/+archive/ubuntu/darktable-release)
[Mumble](https://wiki.mumble.info/wiki/Installing_Mumble#Ubuntu)

```
sudo apt-get update
sudo apt-get install darktable pidgin keepass2 filezilla mumble
```

Install [Sublime](http://www.sublimetext.com/) and its [Package Control](https://packagecontrol.io/installation)

Go to Google Chrome settings and check "Use system title bar and borders"

The `git update-submodules` command is failing currently!

## X1 Carbon 3rd Gen Ubuntu 14.04 Specific:

#### 3.19 Kernel
The trackpoint needs linux kernel 3.19+ in order to work properly. Ubuntu 14.04
has kernel 3.16.

Follow [this post](http://askubuntu.com/questions/636221/ubuntu-14-04-with-3-19-kernel-wants-to-update-to-3-16)
to get 3.19 installed on Ubuntu 14.04:
```
sudo apt-get install linux-generic-lts-vivid
```

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
