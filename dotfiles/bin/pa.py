#!/usr/bin/python3

from subprocess import check_output, check_call, CalledProcessError

def _pamixer(args):
    output = None
    try:
        output = check_output(['pamixer'] + args)
    except CalledProcessError as e:
        output = e.output

    return output.decode('utf-8')

def _pamixer_with_sink(args):
    return _pamixer(args)

    # With this fresh install of Arch on breq (x1 carbon gen5), I'm only
    # seeing 1 sink at a time, and you select the output via profiles instead.
    # This makes this code simpler =)
    #<<<return _pamixer(['--sink', _sink()] + args)

def _sink():
    sinks_precedence = [
        'alsa_output.pci-0000_00_1f.3.hdmi-stereo',
        'alsa_output.pci-0000_00_1f.3.analog-stereo',
    ]
    sinks_list = _pamixer(['--list-sinks'])
    for potential_sink in sinks_precedence:
        if potential_sink in sinks_list:
            return potential_sink
    return None

def volume():
    return int(_pamixer_with_sink(['--get-volume']).strip())

def set_volume(new_volume):
    _pamixer_with_sink(['--set-volume', str(new_volume)])

def increase_volume(delta):
    _pamixer_with_sink(['--increase', str(delta)])

def decrease_volume(delta):
    _pamixer_with_sink(['--decrease', str(delta)])

def is_muted():
    return _pamixer_with_sink(['--get-mute']).strip() == "true"

def set_mute(mute):
    _pamixer_with_sink(['--mute' if mute else '--unmute'])

def toggle_mute():
    _pamixer_with_sink(['--toggle-mute'])
