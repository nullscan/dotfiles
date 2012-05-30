import XMonad hiding ( (|||) )
import XMonad.Layout.LayoutCombinators
import System.Exit
import XMonad.Hooks.SetWMName

--dzen nessesesity's
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Util.Dzen
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import System.IO

--For the Keybindings
import XMonad.Actions.CycleWS
import XMonad.Util.EZConfig
import XMonad.Actions.SinkAll

--Layouts
--import XMonad.Layout.Grid

--Java issues
import XMonad.Hooks.SetWMName

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

modm = mod4Mask
--myStatusBar = "~/.xmonad/dzen.sh | dzen2 -w 1024 -h 14 -fg '#DDEEDD' -fn '-*-terminus-medium-*-*-*-12-*-*-*-*-*-*-*' -bg '#000000'"
myStatusBar = "dzen2 -ta l -w 512 -h 14 -fg '#DDEEDD' -fn '-*-terminus-medium-*-*-*-12-*-*-*-*-*-*-*' -bg '#000000'"

--Urgency hint options:
myUrgencyHook = withUrgencyHook dzenUrgencyHook { args = ["-y 1000"] }

myLayout = tall ||| Full ||| Mirror tall
	where
		tall = Tall 1 (3/100) (1/2)

--dynamicLog pretty printer for dzen:
myDzenPP h = defaultPP
	{
	ppCurrent = wrap "^fg(#00aaff)^bg(#333333)^fg(white)" "^bg()^fg()"
	, ppVisible = wrap "^fg(#00aa00)^fg(white)" "^fg()"
	, ppHidden = wrap "^fg(white)" "^fg()"
	, ppHiddenNoWindows = wrap "^fg(#444444)" "^fg()"
	, ppUrgent = wrap "^fg(#ff0000)" "^fg()"
	, ppSep = " "
	, ppWsSep = " "
	, ppTitle = dzenColor ("white") "" . wrap "-[ " " ]-"
	, ppLayout = dzenColor ("#a0a0a0") ""
	, ppOutput = hPutStrLn h
	}
    
staticWs = ["main","www","three","four","five","six"]
main :: IO ()
main = do 
    dzen <- spawnPipe myStatusBar
    xmproc <- spawnPipe "xbindkeys"
    xmonad $ myUrgencyHook $ defaultConfig
     {
         -- simple stuff
        terminal           = "urxvt"
        ,focusFollowsMouse  = True
        ,borderWidth        = 1
        ,modMask            = mod1Mask
        ,workspaces         = ["main","www","three","four","five","six"]
        ,normalBorderColor  = "#555b2f"
        ,focusedBorderColor = "#333333"
        -- hooks, layouts
        ,layoutHook         = avoidStruts $ myLayout
        ,manageHook            = composeAll     [ className =? "Chrome" --> doF(W.shift "www"), className =? "TeamViewer.exe" --> doF(W.shift "six") ]
                              <+> manageDocks
        ,logHook             = dynamicLogWithPP $ myDzenPP dzen
        ,startupHook        = setWMName "LG3D"
        }
        `additionalKeys`
        [
        -- Move focus in workspace
          ((modm, xK_Right ), windows W.focusDown)                 
         ,((modm, xK_Left ), windows W.focusUp)
        -- Moce windows in workspace
        ,((modm .|. shiftMask, xK_Right), windows W.swapDown)
        ,((modm .|. shiftMask, xK_Left ), windows W.swapUp)
        -- Move screenfocus    
          ,((controlMask, xK_Right), nextScreen)    
        ,((controlMask, xK_Left ), prevScreen)
          -- Move windows across screens    
        ,((controlMask .|. shiftMask, xK_Right), shiftNextScreen)
        ,((controlMask .|. shiftMask, xK_Left), shiftPrevScreen)
        -- Switch workspace
        ,((controlMask .|. modm, xK_Right), nextWS)
        ,((controlMask .|. modm, xK_Left), prevWS)
        -- Move windows across workspaces
        ,((controlMask .|. modm .|. shiftMask, xK_Right), shiftToNext)
        ,((controlMask .|. modm .|. shiftMask, xK_Left), shiftToPrev)
        -- Sink all windows into tiling
        ,((modm, xK_t), sinkAll)
        -- Java hack
        ,((modm, xK_F12), setWMName "LG3D")
        --Commands
        ,((modm, xK_Return), spawn "urxvt -e screen")
        ,((modm, xK_b), spawn "/opt/google/chrome/chrome")
        ,((modm, xK_r), spawn "dmenu_run -fn '-*-montecarlo-medium-*-*-*-11-110-*-*-*-*-*-*' -b -p 'Run: ' -nb black -nf grey -sb darkblue -sf darkgrey")
        ,((modm, xK_c), kill)
		,((modm .|. shiftMask, xK_q), io (exitWith ExitSuccess))
        ]
