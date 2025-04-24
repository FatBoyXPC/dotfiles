import Data.List
import System.IO
import XMonad hiding ( (|||) ) -- don't use the normal ||| operator
import XMonad.Config.Desktop
import XMonad.Layout.LayoutCombinators
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.PerWorkspace

-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Layout-NoBorders.html
import XMonad.Layout.NoBorders

import Config.Keys
import Config.Terminal
import Config.Workspaces

tall = Tall 1 (3/100) (1/2)
devTall = Tall 1 (3/100) (59.45/100)
chatLayout = avoidStruts $ smartBorders $ tall ||| Full
defaultLayout = avoidStruts $ smartBorders $ Full ||| tall ||| Mirror tall
devLayout = avoidStruts $ smartBorders $ devTall ||| Full
serverLayout = avoidStruts $ smartBorders $ Mirror tall ||| Full
myLayout = onWorkspace devWs devLayout $
    onWorkspace chatWs chatLayout $
    onWorkspace serverWs serverLayout $
    defaultLayout

myBorderWidth = 2

windowPlacement = composeAll [
            -- use `xprop` to get window information

            appName =? "dev-window" --> doShift devWs,
            appName =? "server-window" --> doShift serverWs,

            -- Float flameshot's imgur window
            className =? "flameshot" <&&> fmap (isInfixOf "Upload to Imgur") title --> doFloat,

            -- Fix for GIMP windows
            className =? "Gimp" --> doFloat,

            className =? "Slack" --> doShift chatWs,

            className =? "kittypicker" --> doFloat,

            -- Emoji picker!
            role =? "picker" --> doFloat
        ] where role = stringProperty "WM_WINDOW_ROLE"

main = do
    xmonad $ ewmh desktopConfig {
        manageHook = manageDocks <+> manageHook desktopConfig <+> windowPlacement,
        layoutHook = myLayout,

        modMask = myModMask,
        XMonad.terminal = myTerminal,
        XMonad.borderWidth = myBorderWidth,
        workspaces = myWorkspaces,
        startupHook = do
            setWMName "LG3D"
    } `additionalKeys` myKeys
