--
-- xmonad.hs by P0ly
-- Last edit: 02/02/2010
--
import XMonad
import System.Exit
import System.IO
import Graphics.X11.Xlib
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified XMonad.Actions.Submap as SM
import qualified XMonad.Actions.Search as S
-- Hooks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
--import XMonad.Hooks.InsertPosition
--import XMonad.Hooks.Place
--import XMonad.Hooks.PositionStoreHooks
import XMonad.Layout.Magnifier
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Util.EZConfig 
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.LayoutScreens
import XMonad.Layout.TwoPane

main = do
	xmproc <- spawnPipe "xmobar"  -- start xmobar
	xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig {
	terminal   = "rxvt -e screen"
	, modMask  = mod4Mask
	, workspaces = myWorkspaces
	, keys       = myKeys
	, logHook = myLogHook xmproc
	, manageHook = composeAll [ className =? "Iceweasel" --> doShift "2:net" -- Move things to correct workspace
							  , className =? "Icedove" --> doShift "3:mail"
							  , className =? "OpenOffice.org 3.1" --> doShift "4:docs"
							  , className =? "Acroread-en" --> doShift "4:docs"
							  , className =? "Songbird" --> doShift "5:multimedia"
							  , className =? "Eclipse" --> doShift "6:code"
							  , className =? "VirtualBox" --> doShift "7:VM"
							  , title =? "vim" --> doShift "8"
							  ] <+> manageDocks
	, layoutHook = avoidStruts $ Mirror tiled ||| magnifiercz 1.1 (Mirror tiled) ||| Full }

tiled :: Tall a
tiled = Tall 1 (3/100) (1/2)

myWorkspaces :: [WorkspaceId]
myWorkspaces = ["1:main","2:net","3:mail","4:docs","5:multimedia","6:code","7:VM","8","9"]

myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ customPP { ppOutput = hPutStrLn h }

-- bar
customPP :: PP
customPP = defaultPP { ppHidden = xmobarColor "#00FF00" ""
					 , ppCurrent = xmobarColor "#FF0000" "" . wrap "[" "]"
					 , ppUrgent = xmobarColor "#FF0000" "" . wrap "*" "*"
                     , ppLayout = xmobarColor "#FF0000" ""
                     , ppTitle = xmobarColor "#00FF00" "" . shorten 80
                     , ppSep = "<fc=#0033FF> | </fc>"
		 }

xpc :: XPConfig
xpc = defaultXPConfig { bgColor  = "black"
                      , fgColor  = "grey"
                      , promptBorderWidth = 0
                      , position = Bottom
                      , height   = 15
                      , historySize = 256 }

myKeys c = mkKeymap c $                                 -- keys; uses EZConfig
    [ ("M-S-<Return>",  spawn $ XMonad.terminal c)       -- spawn terminal
    , ("M-r"         ,  shellPrompt xpc)                 -- spawn menu program, uses Shell
    , ("M-s"         ,  search)                          -- search websites, uses Search & Submap
    , ("M-S-s"       ,  sshPrompt xpc)                   -- spawn ssh, uses Ssh
    , ("M-S-c"       ,  kill)                            -- kill window
    , ("M-<Space>"   ,  sendMessage NextLayout)          -- next layout
    , ("M-S-<Space>" ,  setLayout $ XMonad.layoutHook c) -- default layout
    , ("M-n"         ,  refresh)                         -- resize to correct size
    , ("M-j"         ,  windows W.focusDown)             -- move focus; next window
    , ("M-k"         ,  windows W.focusUp)               -- move focus; prev. window
    , ("M-m"         ,  windows W.focusMaster)           -- focus on master
    , ("M-<Return>"  ,  windows W.swapMaster)            -- swap current with master
    , ("M-S-j"       ,  windows W.swapDown)              -- swap focused with next window
    , ("M-S-k"       ,  windows W.swapUp)                -- swap focused with prev. window
    , ("M-h"         ,  sendMessage Shrink)              -- shrink master area
    , ("M-e"         ,  sendMessage Expand)              -- expand master area
    , ("M-l"         ,  spawn "gnome-screensaver-command -l")              -- expand master area
    , ("M-t"         ,  withFocused $ windows . W.sink)  -- put window back on tiling layer
    , ("M-,"         ,  sendMessage (IncMasterN 1))      -- increase number of windows in master pane
    , ("M-."         ,  sendMessage (IncMasterN (-1)))   -- decrease number of windows in master pane
    , ("M-b"         ,  sendMessage ToggleStruts)        -- toggle status bar gap, uses ManageDocks
    , ("M-S-q"       ,  broadcastMessage ReleaseResources
                        >> restart "xmonad" True)        -- restart xmonad
    , ("C-S-q"       ,  io (exitWith ExitSuccess))       -- exit xmonad
    ] ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [(m ++ k, windows $ f w)
        | (w, k) <- zip (XMonad.workspaces c) (map show [1..9])
        , (m, f) <- [("M-",W.greedyView), ("M-S-",W.shift)]]

 where searchSite = S.promptSearchBrowser xpc "firefox"
       search     = SM.submap . mkKeymap c $
                     [("g", searchSite S.google)
                     ,("h", searchSite S.hoogle)
                     ,("a", searchSite S.amazon)
                     ,("i", searchSite S.imdb)
                     ,("y", searchSite S.youtube)]
