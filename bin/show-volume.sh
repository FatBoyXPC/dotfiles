#!/bin/bash
VOLUME=`get-volume.py`
if [ $VOLUME == 'off' ]; then
    volnoti-show -m
else
    volnoti-show $VOLUME
fi