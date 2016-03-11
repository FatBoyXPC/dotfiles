How To Use
===========

Install [ohmyzsh](https://github.com/robbyrussell/oh-my-zsh) because it's
awesome!

Add the repos for
[insync](https://www.insynchq.com/downloads),
[Screencloud](https://screencloud.net/#download),
and [Synapse](https://launchpad.net/~synapse-core/+archive/ubuntu/ppa).


Update sources and install packages:
```
sudo apt-get update
sudo apt-get install xmonad xmobar numlockx trayer synapse screencloud insync git
```

Install [Sublime](http://www.sublimetext.com/) and its [Package Control](https://packagecontrol.io/installation)

I'm using the excellent [dotbot](https://github.com/anishathalye/dotbot) to
manage everything. Just git clone, and run the `./install` script!

The `git update-submodules` command is failing currently!

## X1 Carbon 3rd Gen Specific:

#### 3.19 Kernel
The trackpoint needs linux kernel 3.19+ in order to work properly. At the time
of writing this, I was using Ubuntu 14.04 (LTS), which runs 3.16.

Follow [this post](http://askubuntu.com/questions/636221/ubuntu-14-04-with-3-19-kernel-wants-to-update-to-3-16)
to get 3.19 installed on Ubuntu 14.04:
```
sudo apt-get install linux-generic-lts-vivid
```

Reboot and ensure you're on the right kernel with ```uname -r``` and remove old kernels:
```
sudo apt-get purge linux-generic linux-image-generic linux-headers-generic linux-signed-generic
```

Check for other packages with 3.16 or older kernels:
```
dpkg -l | grep -E "linux-(generic|headers|image|signed)" | colrm 80
```

Remove packages that were found with ```sudo apt-get purge```