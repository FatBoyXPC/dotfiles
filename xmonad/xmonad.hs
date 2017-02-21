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
import qualified XMonad.StackSet as W

-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Layout-NoBorders.html
import XMonad.Layout.NoBorders

-- Sensible key names, rather than "modNmask"
altMask = mod1Mask
winMask = mod4Mask

-- Rebind Mod to the Windows key
myModMask = altMask

myTerminal = "roxterm"
tall = Tall 1 (3/100) (1/2)
myLayout = avoidStruts $ smartBorders $ Full ||| Mirror tall ||| tall

myBorderWidth = 2

windowPlacement = composeAll [
            -- use `xprop` to get window information

            -- Skype Conversations
            role =? "conversation" --> doShift "3",

            -- Pidgin Conversations
            role =? "ConversationsWindow" --> doShift "3",

            -- Steam Login
            className =? "Steam" <&&> fmap (isInfixOf "Steam Login") title --> doShift "1",

            -- Steam Chat
            className =? "Steam" <&&> fmap (isInfixOf "Chat") title --> doShift "3",

            -- All Steam Windows (except Game Info & previously mentioned)
            className =? "Steam" <&&> fmap (not . isInfixOf "Game Info") title --> doShift "9",

            className =? "Google-chrome" --> doShift "1",
            className =? "Slack" --> doShift "3",
            className =? "Sublime_text" --> doShift "2",
            className =? "Thunderbird" --> doShift "7",
            className =? "VirtualBox" --> doShift "8",

            -- Skype Windows (except previously mentioned)
            className =? "Skype" --> doShift "9",

            -- Pidgin Buddy List
            role =? "buddy_list" --> doShift "9",

            -- Fix for GIMP windows
            className =? "Gimp" --> doFloat,

            -- Fix for KeePass2
            className =? "KeePass2" --> doFloat
        ] where role = stringProperty "WM_WINDOW_ROLE"

-- https://github.com/hcchu/dotfiles/blob/master/.xmonad/xmonad.hs
showVolume = "toggle-mute.sh; show-volume.sh"
changeVolume s = "amixer -D pulse set Master " ++ s ++ "; show-volume.sh"
changeBrightness s = "xbacklight " ++ s ++ "; show-brightness.sh; xbacklight > ~/.brightness"

myKeys =
    [
        -- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-ManageDocks.html
        ((myModMask, xK_b), sendMessage ToggleStruts),

        -- Launch a terminal (changed from return to semicolon)
        ((myModMask .|. shiftMask, xK_semicolon), spawn myTerminal),

        -- Lock the screen using gnome-screensaver
        ((winMask, xK_l), spawn "gnome-screensaver-command -l"),

        -- Swap the focused window and the master window
        -- The default uses return, but semicolon is easier, and
        -- doesn't conflict with browers =)
        --((myModMask, xK_semicolon), windows W.swapMaster),

        -- Jump directly to the Full layout
        ((myModMask, xK_m), sendMessage $ JumpToLayout "Full"),
        --((myModMask, xK_t), sendMessage $ JumpToLayout "Tall"),

        -- We stole this shortcut above (to emulate DWM's monocle shortcut)
        -- Lets add a shift modifier.
        -- Move focus to the master window
        ((myModMask .|. shiftMask, xK_m), windows W.focusMaster),

        -- Force window back to tiling mode
         ((myModMask .|. shiftMask, xK_t), withFocused $ windows . W.sink),

        ((0, xF86XK_AudioMute), spawn showVolume),
        ((0, xF86XK_AudioRaiseVolume), spawn $ changeVolume "5%+"),
        ((0, xF86XK_AudioLowerVolume), spawn $ changeVolume "5%-"),

        ((0, xF86XK_MonBrightnessUp), spawn $ changeBrightness "+5%"),
        ((0, xF86XK_MonBrightnessDown), spawn $ changeBrightness "-5%"),
        ((shiftMask, xF86XK_MonBrightnessUp), spawn "colorscheme light"),
        ((shiftMask, xF86XK_MonBrightnessDown), spawn "colorscheme dark"),
        ((controlMask, xF86XK_MonBrightnessUp), spawn "xbacklight -set 100"),
        ((controlMask, xF86XK_MonBrightnessDown), spawn "xbacklight -set `cat ~/.brightness`"),

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

main = do 
    xmproc <- spawnPipe "xmobar"
    xmonad $ desktopConfig {
        manageHook = manageDocks <+> manageHook desktopConfig <+> windowPlacement,
        layoutHook = myLayout,
        logHook = logHook desktopConfig <+> dynamicLogWithPP xmobarPP {
            ppOutput = hPutStrLn xmproc,
            ppTitle = xmobarColor "green" "" . shorten 100
        } >> updatePointer (Relative 0.95 0.05),

        modMask = myModMask,
        XMonad.terminal = myTerminal,
        XMonad.borderWidth = myBorderWidth,
        startupHook = do
            setWMName "LG3D"
            spawn "trayer-fix"
            spawn "pgrep synapse || synapse -s"
            spawn "pgrep screencloud || screencloud"
            spawn "pgrep insync || insync start"
            spawn "pgrep nm-applet || nm-applet"
            spawn "pgrep compton || compton"
            spawn "numlockx on"
            spawn "xbacklight -set `cat ~/.brightness`"
    } `additionalKeys` myKeys
