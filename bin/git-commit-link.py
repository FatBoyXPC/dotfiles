#!/usr/bin/python2
#
# Git Commit Link
# That pun on git/get! LOLOL!

from subprocess import check_output
import sys

commit = sys.argv[1]
remoteOrigin = check_output('git config --get remote.origin.url', shell=True).rstrip()
url = remoteOrigin.replace(':', '/').replace('git@', 'https://').replace('.git', '/')
url = url + 'commit/' + commit
print url
