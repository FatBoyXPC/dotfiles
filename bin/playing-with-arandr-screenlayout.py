#!/usr/bin/env python3

from pprint import pprint
import screenlayout.xrandr
from edid import Edid
from screenlayout.auxiliary import Position, NORMAL, InadequateConfiguration

import gi
gi.require_version('Notify', '0.7')
from gi.repository import Notify

from os.path import expanduser
import subprocess

# desks = [
    # Desk(stuff),
    # Desk(stuff2),
# ]

# desks_by_name = {desk.name: desk for desk in desks}

# setup_things = {
    # 'callyo_code': {
        # video_outputs: [
            # {name: 'eDP1', mode: '1280x1024'},
            # {name: 'BenQ', right_of: 'eDP1', mode: '1280x1024'},
        # ]
    # }
    # 'callyo_present': Layout(
        # name='callyo present',
    # )
    # 'st_code': ...,
    # 'st_present': ...,
    # 'docked': {
        # monitor: 'BenQ',
        # trayer: ...,
        # xmobar: ...,
        # dpi: ...,
        # layout: ...,
        # video_outputs: [
            # {name: 'eDP1'},
        # ]
    # },
    # 'mobile': ...,
# }

# my_foo.setup(setup_things)

xrandr = None
def main():
    global xrandr
    xrandr = screenlayout.xrandr.XRandR()
    xrandr.load_from_x()

    outputs_by_name = xrandr.state.outputs
    for output in outputs_by_name.values():
        activate_output(output, make_active=False)

    def find_output(monitor_name):
        output_name = find_monitor(monitor_name)
        return outputs_by_name[output_name] if output_name else None

    benq_output = find_output('BenQ XL2420T')
    laptop_output = outputs_by_name['eDP1']
    if benq_output:
        trayer_height = 19
        xmobar_font_size = 6
        xft_dpi = 96
        layout_name = 'docked'

        activate_output(benq_output, make_active=True)
    else:
        trayer_height = 25
        xmobar_font_size = 9
        xft_dpi = 133
        layout_name = 'mobile'

        activate_output(laptop_output, make_active=True)


    xrandr_cmd = " ".join(xrandr.configuration.commandlineargs())
    # print(xrandr_cmd)
    run_xrandr(xrandr_cmd)
    size_tray(trayer_height, xmobar_font_size)
    xsettings(xft_dpi)
    send_notification(layout_name)
    fix_inputs()
    dunst()

def run_xrandr(cmd):
    subprocess.check_output("xrandr " + cmd, shell=True)

def size_tray(trayer_height, xmobar_font_size):
    subprocess.run('killall -q trayer', shell=True)
    # trayer -l --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --height 25 --transparent true --alpha 0 --tint 0 &
    trayer_cmd = [
        'trayer',
        '-l',
        '--edge',
        'top',
        '--align',
        'right',
        '--SetDockType',
        'true',
        '--SetPartialStrut',
        'true',
        '--expand',
        'true',
        '--widthtype',
        'request',
        '--height',
        str(trayer_height),
        '--transparent',
        'true',
        '--alpha',
        '0',
        '--tint',
        '0',
    ]
    subprocess.Popen(trayer_cmd)
    subprocess.run('sleep 0.1', shell=True)

    # To resize our xmobar, we must edit our xmobarrc and then restart xmonad.
    # We also must restart xmobar to get it below trayer (xmobar lowers itself to the bottom when it starts up).
    xmobarrc_sed_cmd = f'sed -i "s/size=[^:]*:/size={xmobar_font_size}:/" ~/.xmobarrc'
    subprocess.check_output(xmobarrc_sed_cmd, shell=True)
    subprocess.check_output('xmonad --restart', shell=True)

def xsettings(dpi):
    # Change DPI and notify everyone via XSETTINGS.
    # See https://utcc.utoronto.ca/~cks/space/blog/linux/XSettingsNotes?showcomments
    # and https://github.com/GNOME/gtk/blob/1a1373779f87ce928a45a9371512d207445f615f/gdk/x11/xsettings-client.c#L399
    XFT_DPI = 1024 * dpi

    f = open(expanduser('~/.xsettingsd'), 'w+')
    f.write(f"Xft/DPI {XFT_DPI}\n")
    f.close()

    subprocess.check_output('killall -HUP xsettingsd', shell=True)

def send_notification(layout):
    Notify.init('autoperipherals')
    Notify.Notification.new('Detected Environment', layout).show()

def fix_inputs():
    # Note, we intentionally run fixinputs last, because xmodmap blocks if you're holding any keys down.
    # See: https://forums.fedoraforum.org/showthread.php?296298-xmodmap-please-release-the-following-keys-within-2-seconds
    subprocess.check_output('fixinputs', shell=True)

def dunst():
    # Note, we intentionally run fixinputs last, because xmodmap blocks if you're holding any keys down.
    # See: https://forums.fedoraforum.org/showthread.php?296298-xmodmap-please-release-the-following-keys-within-2-seconds
    subprocess.check_output('killall -q dunst', shell=True)

def activate_output(output, make_active):
    output_config = xrandr.configuration.outputs[output.name]
    output_config.active = make_active
    if make_active:
        # Copied from
        # /usr/lib/python3.7/site-packages/screenlayout/widget.py
        # ARandRWidget::set_active
        output_config.position = Position((0, 0))

        virtual_state = xrandr.state.virtual
        for mode in output.modes:
            # determine first possible mode
            if mode[0] <= virtual_state.max[0] and mode[1] <= virtual_state.max[1]:
                first_mode = mode
                break
            else:
                raise InadequateConfiguration(
                    "Smallest mode too large for virtual.")

        output_config.mode = first_mode
        output_config.rotation = NORMAL

def get_edids():
    output = xrandr._output("--verbose")
    display = None
    edid = None
    edids_by_display = {}

    for line in output.split('\n'):
        if 'connected' in line:
            display = line.split(' ')[0]
        elif line.startswith('\tEDID'):
            edid = ""
        elif line.startswith('\t\t') and edid is not None:
            edid += line.strip()
        elif not line.startswith('\t\t') and edid is not None:
            edid = bytes([ int("".join(pair), 16) for pair in zip(*[iter(edid)]*2) ])
            edids_by_display[display] = Edid(edid)
            edid = None
            display = None

    return edids_by_display

def find_monitor(monitor_name):
    for display_name, edid in get_edids().items():
        if edid.name == monitor_name:
            return display_name

    return None

if __name__ == "__main__":
    main()
