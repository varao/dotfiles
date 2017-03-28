{-# LANGUAGE PackageImports, OverloadedStrings #-}

import XMonad
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.UpdatePointer
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

import XMonad.Layout.BoringWindows
import XMonad.Layout.Grid

import qualified "dbus" DBus as D
import qualified "dbus" DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

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
                  $  rt ||| Mirror(rt)
                   -- |||spiral (6/7) ||| Mirror(rt) 
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
 
myManageHook = composeAll
   [ (role =? "gimp-toolbox" <||> role =? "gimp-image-window") --> 
          doFloat
   , className =? "Xmessage"  --> doFloat
   , className =? "R_x11"  --> doFloat
   , className =? "XTerm"  --> doCenterFloat
   , manageDocks
   ]
  where role = stringProperty "WM_WINDOW_ROLE"

myModMask = mod1Mask

myKeys = 
  [ --((myModMask, xK_p), spawn myLauncher)
    ((myModMask .|. controlMask, xK_Left), sendMessage $ pullGroup L)
    --Group to Right
    , ((myModMask .|. controlMask, xK_Right), sendMessage $ pullGroup R)
    --Group Above
    , ((myModMask .|. controlMask, xK_Up), sendMessage $ pullGroup U)
    --Group Below
    , ((myModMask .|. controlMask, xK_Down), sendMessage $ pullGroup D)
   -- resize windows
    , ((myModMask,               xK_a), sendMessage MirrorShrink)
    , ((myModMask,               xK_z), sendMessage MirrorExpand)
    --Merge/UnMerge
    , ((myModMask .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
    , ((myModMask .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
    , ((myModMask .|. controlMask, xK_v), withFocused (sendMessage . UnMergeAll))
    --Focus between tabs
    --also swapped j and k to be more vim-like
    , ((myModMask .|. controlMask, xK_k), onGroup W.focusUp')
    , ((myModMask .|. controlMask, xK_j), onGroup W.focusDown')
    , ((myModMask .|. controlMask, xK_space),  toSubl NextLayout)
    --BoringWindows: groups clustered windows
    , ((myModMask                , xK_k), focusUp)
    , ((myModMask                , xK_j), focusDown)
    , ((myModMask                , xK_m), focusMaster)
   --Launcher
    , ((myModMask                , xK_p), spawn myLauncher)
    , ((myModMask                , xK_f), spawn myFzf)
  ]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]

myLauncher = "$(/home/varao/.cabal/bin/yeganesh -x -- -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*')"
myFzf = "$(/home/varao/git/dotfiles/search.sh)"


main :: IO ()
main = do
    dbus <- D.connectSession
    getWellKnownName dbus
    xmonad $ gnomeConfig
         { 
           logHook = dynamicLogWithPP (prettyPrinter dbus)
                      >> updatePointer (0.25, 0.25) (0.25, 0.25) -- near the top-left
           , layoutHook         = smartBorders $ myLayout
           , borderWidth        = myBorderWidth
           , focusedBorderColor = myFocusedBorderColor
           , normalBorderColor  = myNormalBorderColor
           , startupHook        = myStartupHook
           , manageHook         = myManageHook <+> manageHook defaultConfig -- uses default too
           , mouseBindings      = myMouseBindings
         } `additionalKeys` myKeys

prettyPrinter :: D.Client -> PP
prettyPrinter dbus = defaultPP
    { ppOutput   = dbusOutput dbus
    , ppLayout   = pangoColor "orange" . myLayoutPrinter
    , ppTitle    = pangoColor "skyblue" . pangoSanitize  . shorten 100
    , ppCurrent  = pangoColor "#00aacc" . wrap "[" "*]" . pangoSanitize
    , ppVisible  = pangoColor "#00aacc" . wrap "[" "]" . pangoSanitize
    , ppHidden   = pangoColor "grey70" . wrap "[" "]" . pangoSanitize
    , ppUrgent   = pangoColor "red"
    , ppSep      = " "
    }

getWellKnownName :: D.Client -> IO ()
getWellKnownName dbus = do
  D.requestName dbus (D.busName_ "org.xmonad.Log")
                [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
  return ()
  
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal "/org/xmonad/Log" "org.xmonad.Log" "Update") {
            D.signalBody = [D.toVariant ("<b>" ++ (UTF8.decodeString str) ++ "</b>")]
        }
    D.emit dbus signal

pangoColor :: String -> String -> String
pangoColor fg = wrap left right
  where
    left  = "<span foreground=\"" ++ fg ++ "\">"
    right = "</span>"

pangoSanitize :: String -> String
pangoSanitize = foldr sanitize ""
  where
    sanitize '>'  xs = "&gt;" ++ xs
    sanitize '<'  xs = "&lt;" ++ xs
    sanitize '\"' xs = "&quot;" ++ xs
    sanitize '&'  xs = "&amp;" ++ xs
    sanitize x    xs = x:xs

myLayoutPrinter :: String -> String
myLayoutPrinter "Tabbed Full" = "F"
myLayoutPrinter "Tabbed ResizableTall" = "|"
myLayoutPrinter "Tabbed Mirror ResizableTall" = "-"
myLayoutPrinter x = x
