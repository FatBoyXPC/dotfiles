module Config.Keys (myModMask, myKeys) where

import Config.Terminal

import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.Actions.CycleWS
import qualified XMonad.StackSet as W

-- Sensible key names, rather than "modNmask"
altMask = mod1Mask
winMask = mod4Mask

-- Rebind Mod to the Windows key
myModMask = winMask

-- https://github.com/hcchu/dotfiles/blob/master/.xmonad/xmonad.hs
muteAndShowVolume = "set_volume.py toggle-mute; show-volume.sh"
changeVolume s = "set_volume.py " ++ s ++ "; show-volume.sh"
-- https://obsproject.com/forum/threads/hotkey-to-mute-mic-input.22852/
toggleMicMute = "pactl set-source-mute $(pacmd list-sources|awk '/\\* index:/{ print $3 }') toggle; show-mic-mute.sh"
changeBrightness s = "xbacklight " ++ s ++ "; show-brightness.sh; xbacklight > ~/.brightness"

myKeys :: [((KeyMask, KeySym), X ())]
myKeys =
    [
        -- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-ManageDocks.html
        --((myModMask, xK_b), sendMessage ToggleStruts),

        -- Launch a terminal (changed from return to semicolon)
        ((myModMask .|. shiftMask, xK_semicolon), spawn myTerminal),

        ((myModMask .|. shiftMask, xK_Return), spawn "emoji"),

        -- Swap the focused window and the master window
        -- The default uses return, but semicolon is easier, and
        -- doesn't conflict with browers =)
        ((myModMask, xK_semicolon), windows W.swapMaster),

        -- Jump directly to the Full layout
        --((myModMask, xK_m), sendMessage $ JumpToLayout "Full"),
        --((myModMask, xK_t), sendMessage $ JumpToLayout "Tall"),

        -- We stole this shortcut above (to emulate DWM's monocle shortcut)
        -- Lets add a shift modifier.
        -- Move focus to the master window
        ((myModMask .|. shiftMask, xK_m), windows W.focusMaster),

        -- Force window back to tiling mode
        ((myModMask .|. shiftMask, xK_t), withFocused $ windows . W.sink),

        -- Toggle last workspace
        ((myModMask, xK_z), toggleWS),

        -- Run dmenu2 with custom font
        ((myModMask, xK_p), spawn "dmenu_run -fn 'Ubuntu Mono Regular:size=8:bold:antialias=true'"),

        ((0, xF86XK_AudioMute), spawn muteAndShowVolume),
        ((0, xF86XK_AudioRaiseVolume), spawn $ changeVolume "5+"),
        ((0, xF86XK_AudioLowerVolume), spawn $ changeVolume "5-"),
        ((0, xF86XK_AudioMicMute), spawn toggleMicMute),

        ((0, xF86XK_MonBrightnessUp), spawn $ changeBrightness "+5%"),
        ((0, xF86XK_MonBrightnessDown), spawn $ changeBrightness "-5%"),
        ((shiftMask, xF86XK_MonBrightnessUp), spawn "colorscheme light"),
        ((shiftMask, xF86XK_MonBrightnessDown), spawn "colorscheme dark"),
        ((controlMask, xF86XK_MonBrightnessUp), spawn "xbacklight -set 100"),
        ((controlMask, xF86XK_MonBrightnessDown), spawn "xbacklight -set `cat ~/.brightness`"),

        ((controlMask .|. altMask, xK_2), spawn "flameshot gui"),
        ((controlMask .|. altMask, xK_4), spawn "jscrot --video"),

        ((0, xF86XK_Display), spawn $ "toggle-display"),
        ((controlMask .|. altMask, xK_Left), spawn "xrandr -o right"),
        ((controlMask .|. altMask, xK_Right), spawn "xrandr -o left"),
        ((controlMask .|. altMask, xK_Down), spawn "xrandr -o normal"),
        ((controlMask .|. altMask, xK_Up), spawn "xrandr -o inverted"),

        ((altMask, xK_v), spawn "middle-paste")
    ]
    ++
    -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
    [((m .|. myModMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_r, xK_e] [0..]
      , (f, m) <- [(W.view, 0), ((\t -> W.view t . W.shift t), shiftMask)]]
