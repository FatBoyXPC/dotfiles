#!/usr/bin/python2
#
# Git Last Commit Link
# That pun on git/get! LOLOL!

from subprocess import check_output

lastCommit = check_output('git rev-parse HEAD', shell=True).rstrip()
remoteOrigin = check_output('git config --get remote.origin.url', shell=True).rstrip()
# print lastCommit
# print remoteOrigin
url = remoteOrigin.replace(':', '/').replace('git@', 'https://').replace('.git', '/')
url = url + 'commit/' + lastCommit
print url