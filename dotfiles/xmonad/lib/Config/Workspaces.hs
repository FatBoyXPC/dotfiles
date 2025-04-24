module Config.Workspaces (meWs, devWs, chatWs, workWs, serverWs, musicWs, videoWs, backspaceWs, myWorkspaces, myWorkspaceKeys) where

import XMonad

meWs = "👨"
devWs = "💻"
chatWs = "💬"
workWs = "⛏"
serverWs = "💿"
musicWs = "🎶"
videoWs = "📹"
backspaceWs = "👈"
myWorkspaces = ["`", meWs, devWs, chatWs, workWs, serverWs, "6", "7", "8", videoWs, "0", "-", "=", backspaceWs, musicWs]
myWorkspaceKeys = [xK_grave] ++ [xK_1 .. xK_9] ++ [xK_0, xK_minus, xK_equal, xK_BackSpace, xK_m]
