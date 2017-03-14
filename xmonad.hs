import XMonad
import XMonad.Actions.UpdatePointer
import XMonad.Config.Gnome
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Spacing (smartSpacing)
import XMonad.Layout.Simplest
import XMonad.Layout.Named
import XMonad.Util.EZConfig ( additionalKeys )
import XMonad.Util.Font
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.ResizableTile
-- Boring windows doesn't update some subtabs
-- when I change workspaces
import XMonad.Layout.BoringWindows
import XMonad.Layout.Grid

myTheme = def {  
            activeColor = "#0066aa",
            inactiveColor = "#444444",
            inactiveTextColor = "#cccccc",
            activeTextColor = "#dddddd",
            urgentColor = "red",
--            decoHeight = 30,
            fontName = "xft:DejaVu Sans:size=10" }

myLayout = avoidStruts  -- Makes gnome panel visible
         $ windowNavigation 
         $ addTabs shrinkText myTheme -- def: default
         $ boringWindows $ tall 
              where 
                rt = ResizableTall 1 (3/100) (1/2) []
                tall =  subLayout [] 
                  (Simplest ||| spiral (6/7) ||| Grid) 
                  $ spiral (6/7) ||| rt 
                   -- ||| Mirror(rt) 
                   ||| Full

-- width of border around windows
myBorderWidth = 5

-- color of focused/inactive border
myFocusedBorderColor = "#0066aa"
myNormalBorderColor = "#cccccc"
--

myStartupHook     = do
  startupHook gnomeConfig
  spawn "xcompmgr -cfF -t-9 -l-11 -r9 -o.95 -D6 &" -- for transparencies
 -- setWMName "HM"

myModMask = mod1Mask
modm      = myModMask

myKeys = 
  [ --((myModMask, xK_p), spawn myLauncher)
    ((modm .|. controlMask, xK_Left), sendMessage $ pullGroup L)
    --Group to Right
    , ((modm .|. controlMask, xK_Right), sendMessage $ pullGroup R)
    --Group Above
    , ((modm .|. controlMask, xK_Up), sendMessage $ pullGroup U)
    --Group Below
    , ((modm .|. controlMask, xK_Down), sendMessage $ pullGroup D)
   -- resize windows
    , ((modm,               xK_a), sendMessage MirrorShrink)
    , ((modm,               xK_z), sendMessage MirrorExpand)
    --Merge/UnMerge
    , ((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
    , ((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
    , ((modm .|. controlMask, xK_v), withFocused (sendMessage . UnMergeAll))
    --Focus between tabs
    --also swapped j and k to be more vim-like
    , ((modm .|. controlMask, xK_k), onGroup W.focusUp')
    , ((modm .|. controlMask, xK_j), onGroup W.focusDown')
    , ((modm .|. controlMask, xK_space),  toSubl NextLayout)
    --BoringWindows: groups clustered windows
    , ((modm, xK_k), focusUp)
    , ((modm, xK_j), focusDown)
    , ((modm, xK_m), focusMaster)
   --Launcher
    , ((modm, xK_p), spawn myLauncher)
  ]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]

myLogHook = 
      updatePointer (0.25, 0.25) (0.25, 0.25) -- near the top-left

myLauncher = "$(/home/varao/.cabal/bin/yeganesh -x -- -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*')"

main = do
     xmonad $ gnomeConfig 
      { layoutHook         = smartBorders $ myLayout
      , borderWidth        = myBorderWidth
      , focusedBorderColor = myFocusedBorderColor
      , normalBorderColor  = myNormalBorderColor
      , logHook            = myLogHook
      , startupHook        = myStartupHook
      , mouseBindings      = myMouseBindings
      }  `additionalKeys` myKeys
