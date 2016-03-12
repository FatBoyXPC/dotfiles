#!/bin/bash
VOLUME=`get-volume.sh`
if [ $VOLUME == '[M]' ]; then
    volnoti-show -m
else
    volnoti-show $VOLUME
fi