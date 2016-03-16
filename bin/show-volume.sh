#!/bin/bash
VOLUME=`get-volume.sh`
if [ $VOLUME == 'off' ]; then
    volnoti-show -m
else
    volnoti-show $VOLUME
fi