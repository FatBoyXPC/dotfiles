#!/usr/bin/python2

import re
from subprocess import check_output

amixerOutput = check_output(['amixer', '-D', 'pulse', 'sget', 'Master'])
volP = "[0-9]{1,3}%"
muteP = "on|off"

volInfoRegex = re.match(r".*\[(?P<left_vol>" + volP + ")\]"
    + ".*\[(?P<left_mute>" + muteP + ")\]"
    + ".*\[(?P<right_vol>" + volP + ")\]"
    + ".*\[(?P<right_mute>" + muteP + ")\]",
    amixerOutput,
    flags=re.DOTALL
)

volInfo = volInfoRegex.groupdict()

if ( len(volInfo) != 4
    or volInfo['left_vol'] != volInfo['right_vol']
    or volInfo['left_mute'] != volInfo['right_mute']
   ):
    print "ERR"
    exit(1)

if volInfo['left_mute'] == 'off':
    print "Mute"
    exit(0)

print volInfo['left_vol']
exit(0)
