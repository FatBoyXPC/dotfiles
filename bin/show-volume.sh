#!/bin/bash
VOLUME=`get-volume.py`
if [ $VOLUME == 'Mute' ]; then
    volnoti-show -m
else
    volnoti-show $VOLUME
fi