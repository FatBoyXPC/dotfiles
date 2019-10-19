import Data.List
import Graphics.X11.ExtraTypes.XF86
import System.IO
import XMonad hiding ( (|||) ) -- don't use the normal ||| operator
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.UpdatePointer
import XMonad.Config.Desktop
import XMonad.Layout.LayoutCombinators
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.PerWorkspace

-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Layout-NoBorders.html
import XMonad.Layout.NoBorders

import Config.Keys
import Config.Terminal

tall = Tall 1 (3/100) (1/2)
devTall = Tall 1 (3/100) (59.45/100)
chatLayout = avoidStruts $ smartBorders $ tall ||| Full
defaultLayout = avoidStruts $ smartBorders $ Full ||| tall ||| Mirror tall
devLayout = avoidStruts $ smartBorders $ devTall ||| Full
serverLayout = avoidStruts $ smartBorders $ Mirror tall ||| Full
myLayout = onWorkspace "2" devLayout $
    onWorkspace "3" chatLayout $
    onWorkspace "5" serverLayout $
    defaultLayout

myBorderWidth = 2

windowPlacement = composeAll [
            -- use `xprop` to get window information

            role =? "dev-window" --> doShift "2",
            role =? "server-window" --> doShift "5",

            -- Float flameshot's imgur window
            className =? "flameshot" <&&> fmap (isInfixOf "Upload to Imgur") title --> doFloat,

            -- Fix for GIMP windows
            className =? "Gimp" --> doFloat,

            -- Emoji picker!
            role =? "picker" --> doFloat
        ] where role = stringProperty "WM_WINDOW_ROLE"

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ desktopConfig {
        manageHook = manageDocks <+> manageHook desktopConfig <+> windowPlacement,
        layoutHook = myLayout,
        logHook = logHook desktopConfig <+> dynamicLogWithPP xmobarPP {
            ppOutput = hPutStrLn xmproc,
            ppTitle = xmobarColor "green" "" . shorten 100
        },

        modMask = myModMask,
        XMonad.terminal = myTerminal,
        XMonad.borderWidth = myBorderWidth,
        startupHook = do
            setWMName "LG3D"
    } `additionalKeys` myKeys
