{-# LANGUAGE PackageImports, OverloadedStrings, FlexibleInstances, MultiParamTypeClasses #-} 
import XMonad
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.UpdatePointer
import XMonad.Layout.Fullscreen
import XMonad.Actions.GridSelect
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Spacing (smartSpacing)
import XMonad.Layout.Simplest
import XMonad.Layout.Named
import XMonad.Layout.NoFrillsDecoration
import XMonad.Util.EZConfig ( additionalKeys )
import XMonad.Util.Font
import XMonad.Util.Scratchpad
import XMonad.Util.NamedScratchpad
import XMonad.Util.Loggers
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.ResizableTile

import XMonad.Layout.BoringWindows
import XMonad.Layout.Grid

import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances

import Data.List (isSuffixOf)
import Data.Maybe (fromJust)
import XMonad.Layout.LayoutModifier

import qualified "dbus" DBus as D
import qualified "dbus" DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

isSuffixOfQ :: String -> Query String -> Query Bool
isSuffixOfQ = fmap . isSuffixOf
pName = stringProperty "WM_NAME"

base00  = "#657b83"
yellow  = "#b58900"
red     = "#dc322f"
blue    = "#268bd2"
myFont = "xft:DejaVu Sans:size=10" 

myTheme = def {  
            activeColor = "#0066aa",
            inactiveColor = "#444444",
            inactiveTextColor = "#cccccc",
            activeTextColor = "#dddddd",
            urgentColor = "red",
--            decoHeight = 30,
            fontName = myFont }

-- Need to comment out addTopBar in myLayout and then uncomment
-- for changes to take effect for some reason
topBarTheme = def
    { fontName              = myFont
    , inactiveBorderColor   = base00
    , inactiveColor         = base00
    , inactiveTextColor     = base00
    , activeBorderColor     = blue
    , activeColor           = blue
    , activeTextColor       = blue
    , urgentBorderColor     = red
    , urgentTextColor       = yellow
    , decoHeight            = 4
}

---------------------------------
-- workaround of xmonad issue 4
-- https://wiki.haskell.org/Xmonad/Config_archive/hgabreu%27s_xmonad.hs 
data FixFocus a = FixFocus (Maybe a) deriving (Read, Show)
instance LayoutModifier FixFocus Window where
    modifyLayout (FixFocus mlf) ws@(W.Workspace id lay Nothing) r = runLayout ws r
    modifyLayout (FixFocus Nothing) ws r = runLayout ws r
    modifyLayout (FixFocus (Just lf)) (W.Workspace id lay (Just st)) r = do
        let stack_f = W.focus st  -- get current stack's focus
        mst <- gets (W.stack . W.workspace . W.current . windowset)
        let mreal_f = maybe Nothing (Just . W.focus) mst -- get Maybe current real focus
        is_rf_floating <- maybe (return False) (\rf -> withWindowSet $ return . M.member rf . W.floating) mreal_f -- real focused window is floating?
        let new_stack_f = if is_rf_floating then lf else stack_f --if yes: replace stack's focus with our last saved focus
        let new_st' = until (\s -> new_stack_f == W.focus s) W.focusUp' st -- new stack with focused new_stack_f
        let new_st = if (new_stack_f `elem` (W.integrate st)) then new_st' else st -- use it only when it's possible to
        runLayout (W.Workspace id lay (Just new_st)) r
 
    redoLayout (FixFocus mlf) r Nothing wrs = return (wrs, Just $ FixFocus mlf)
    redoLayout (FixFocus mlf) r (Just st) wrs = do
        let stack_f = W.focus st  -- get current stack's focus
        mst <- gets (W.stack . W.workspace . W.current . windowset)
        let mreal_f = maybe Nothing (Just . W.focus) mst -- get Maybe current real focus
        let crf_in_stack = maybe False ((flip elem) (W.integrate st)) mreal_f -- current real focus belongs to stack?
        let new_saved_f = if crf_in_stack then fromJust mreal_f else stack_f -- if yes: replace saved focus
        return (wrs, Just $ FixFocus $ Just new_saved_f)
 
fixFocus :: LayoutClass l a => l a -> ModifiedLayout FixFocus l a
fixFocus = ModifiedLayout $ FixFocus Nothing
---------------------------------
-- Show desktop
data EmptyLayout a = EmptyLayout deriving (Show, Read)

instance LayoutClass EmptyLayout a where
    doLayout a b _ = emptyLayout a b
    description _ = "*"

data HIDE = HIDE deriving (Read, Show, Eq, Typeable)
instance Transformer HIDE Window where
    transform _ x k = k (EmptyLayout) (\(EmptyLayout) -> x)

---------------------------------
myLayout = fixFocus $ avoidStruts  -- Makes gnome panel visible
         $ windowNavigation 
         $ boringWindows 
         $ mkToggle (single HIDE)  -- Shows desktop
         $ my_full ||| my_tall 
              where 
              -- Full can have tabs but no top bar
                my_full = addTabs shrinkText myTheme $ Full
              -- Tall (i.e. not full) will have a top bar with tabs 
                addTopBar = noFrillsDeco shrinkText topBarTheme
                rt = ResizableTall 1 (3/100) (1/2) []
                my_tall = addTopBar $ addTabs shrinkText myTheme 
                  $ subLayout [] (Simplest ||| spiral (6/7) ||| Grid) rt 
                   -- |||spiral (6/7) ||| Mirror(rt) 

-- width of border around windows
myBorderWidth = 1

-- color of focused/inactive border
myFocusedBorderColor = "#0066aa"
myNormalBorderColor = "#222222"
--

myStartupHook     = do
  startupHook gnomeConfig
  spawn "xcompmgr -c -t-9 -l-11 -r1 -o.05 -D0 &" -- for transparencies (add -fF for fade effects)
 -- setWMName "HM"
 
myManageHook = composeAll
   [ (role =? "gimp-toolbox" <||> role =? "gimp-image-window") --> 
          doFloat
   , className =? "Xmessage"  --> doFloat
   , className =? "R_x11"  --> doFloat
   , manageDocks
   ]
  where role = stringProperty "WM_WINDOW_ROLE"

-- GSConfig options:
myGSConfig = defaultGSConfig
    { gs_cellheight = 100
    , gs_cellwidth = 200
    , gs_cellpadding = 10
    , gs_font = "xft:DejaVu Sans:size=10" 
    }

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
   -- vertically resize windows
   -- (for horizontal resizing, use xK_h and xK_l)
    , ((myModMask,               xK_a), sendMessage MirrorShrink)
    , ((myModMask,               xK_s), sendMessage MirrorExpand)
    --Merge/UnMerge
    , ((myModMask .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
    , ((myModMask .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
    , ((myModMask .|. controlMask, xK_v), withFocused (sendMessage . UnMergeAll))
    --Focus between tabs
    --also swapped j and k to be more vim-like
    , ((myModMask .|. controlMask, xK_k), onGroup W.focusUp')
    , ((myModMask .|. controlMask, xK_j), onGroup W.focusDown')
    , ((myModMask .|. controlMask, xK_space),  toSubl NextLayout)
    --Show desktop
    , ((myModMask,               xK_d), sendMessage $ Toggle HIDE)
    --Grid of open windows
    , ((myModMask, xK_g), goToSelected myGSConfig)
    --BoringWindows: groups clustered windows
    , ((myModMask                , xK_k), focusUp)
    , ((myModMask                , xK_j), focusDown)
    , ((myModMask                , xK_m), focusMaster)
   --Launcher
    , ((myModMask                , xK_p), spawn myLauncher)
--    , ((myModMask                , xK_f), spawn myFzf)
    , ((myModMask                , xK_f), scratchFzf)
    , ((myModMask                , xK_z), scratchFfx)
    , ((myModMask .|. shiftMask  , xK_z), scratchZthr)
    , ((myModMask                , xK_x), scratchBrave)
    , ((myModMask .|. shiftMask  , xK_x), scratchFfxp)
    , ((myModMask .|. controlMask, xK_x), scratchChrm)
    , ((myModMask                , xK_r), scratchRemm)
    , ((myModMask                , xK_y), scratchSkype)
--    , ((myModMask .|. shiftMask  , xK_x), scratchWmail)
-- also gone: xK_b, xK_w, xK_e
  ]
  where
    -- this simply means "find the scratchpad in myScratchPads that is 
    -- named fuzzyfind and launch it"
    scratchFzf   = namedScratchpadAction myScratchPads "fuzzyfind"
    scratchZthr  = namedScratchpadAction myScratchPads "pdfviewer"
    scratchFfxp  = namedScratchpadAction myScratchPads "firefox-p"
    scratchBrave = namedScratchpadAction myScratchPads "brave-p"
    scratchFfx   = namedScratchpadAction myScratchPads "firefox"
    scratchChrm  = namedScratchpadAction myScratchPads "chromium"
    scratchRemm  = namedScratchpadAction myScratchPads "remmina"
    scratchSkype = namedScratchpadAction myScratchPads "skype"
--    scratchWmail  = namedScratchpadAction myScratchPads "wmail"

myScratchPads = [  NS "fuzzyfind"  myFzf  findFZ  (customFloating $ W.RationalRect (1/8) (1/6) (1/3) (2/3))  -- one scratchpad
                 , NS "brave-p"  "brave-browser --incognito" findBravep nonFloating  -- one scratchpad
                 , NS "firefox-p"  "firefox -private-window" findFfxp nonFloating  -- one scratchpad
                 , NS "chromium"   "chromium-browser" findChrm nonFloating  -- one scratchpad
                 , NS "firefox"   "firefox" findFfx nonFloating  -- one scratchpad
--                 , NS "wmail"   "~/git/INSTALL/WMail-linux-x64/WMail" findWmail nonFloating  -- one scratchpad
--                 , NS "pdfviewer"    "zathura-tabbed" findPdf nonFloating  -- one scratchpad
                 , NS "pdfviewer"    "qpdfview --unique" findPdf nonFloating  -- one scratchpad
                 , NS "remmina"    "remmina" findRemm nonFloating  -- one scratchpad
                 , NS "skype"    "skypeforlinux" findSkype nonFloating -- one scratchpad
                ]
  where
   findFZ     = resource  =? "fzf_term"  
--   findPdf  = className =? "tabbed"  
   findPdf    = className =? "qpdfview"  
   findFfxp = className =? "Firefox" <&&> ("Mozilla Firefox (Private Browsing)" `isSuffixOfQ` pName)
   findBravep = className =? "Brave-browser"
   findFfx    = className =? "Firefox" <&&> ("Mozilla Firefox" `isSuffixOfQ` pName)  
   findChrm   = className =? "Chromium-browser"  
   findRemm   = className =? "Remmina"  
   findSkype  = className =? "Skype"  
--   findWmail = className =? "wmail"  

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
myFzf = "$(/home/varao/git/dotfiles/search.sh )"


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
--           , focusFollowsMouse  = False
           , focusedBorderColor = myFocusedBorderColor
           , normalBorderColor  = myNormalBorderColor
           , startupHook        = myStartupHook
           , handleEventHook    = fullscreenEventHook -- For Firefox to stay in fullscreen
           , manageHook         = myManageHook 
                                    <+> namedScratchpadManageHook myScratchPads 
                                    <+> manageHook defaultConfig -- uses default too
           , mouseBindings      = myMouseBindings
--           , modMask = mod4Mask  -- Temp fix to make windows key the modifier if I really need Alt
         } `additionalKeys` myKeys

prettyPrinter :: D.Client -> PP
prettyPrinter dbus =  namedScratchpadFilterOutWorkspacePP $ defaultPP
    { ppOutput   = dbusOutput dbus
    , ppLayout   = pangoColor "orange" . myLayoutPrinter
    , ppTitle    = pangoColor "skyblue" . pangoSanitize  . shorten 100
    , ppCurrent  = pangoColor "#00aacc" . wrap "[" "*]" . pangoSanitize
    , ppVisible  = pangoColor "#00aacc" . wrap "[" "]" . pangoSanitize
    , ppHidden   = pangoColor "grey70" . wrap "[" "]" . pangoSanitize
    , ppUrgent   = pangoColor "red"
    , ppSep      = " "
--    , ppExtras   = [logCmd "date"]
--    , ppExtras   = [pangoColor "skyblue" `onLogger` lTitle]
    }
    where
       --lTitle = fixedWidthL AlignRight " " 199 . shortenL 80 $ logCmd "dropbox status"

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
myLayoutPrinter "NoFrillsDeco Tabbed ResizableTall" = "|"
myLayoutPrinter "NoFrillsDeco Tabbed Mirror ResizableTall" = "-"
myLayoutPrinter x = x
