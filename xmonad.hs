{-# LANGUAGE PackageImports, OverloadedStrings, FlexibleInstances, MultiParamTypeClasses #-} 
import XMonad
import XMonad.Config.Gnome
import Data.Monoid      -- Needed to act on release key events
import Control.Monad    -- Needed to act on release key events
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

import System.IO
import XMonad.Util.Run


isSuffixOfQ :: String -> Query String -> Query Bool
isSuffixOfQ = fmap . isSuffixOf
pName = stringProperty "WM_NAME"

base00  = "#656565"
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
    , decoHeight            = 6
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
    description _ = "[ * ]"

data HIDE = HIDE deriving (Read, Show, Eq, Typeable)
instance Transformer HIDE Window where
    transform _ x k = k (EmptyLayout) (\(EmptyLayout) -> x)

---------------------------------
--  Key release events
--  https://stackoverflow.com/questions/6605399/how-can-i-set-an-action-to-occur-on-a-key-release-in-xmonad
keyUpEventHook :: Event -> X All
keyUpEventHook e = handle e >> return (All True)

keyUpKeys (XConf{ config = XConfig {XMonad.modMask = modMask} }) = M.fromList $ 
    [ ((modMask, xK_Alt_R), sequence_ [sendMessage ToggleStruts, spawn "pkill compton; compton -cCGfF -b -I 0.1 -O 0.1 "] ) ]

handle :: Event -> X ()
handle (KeyEvent {ev_event_type = t, ev_state = m, ev_keycode = code})
    | t == keyRelease = withDisplay $ \dpy -> do
        s  <- io $ keycodeToKeysym dpy code 0
        mClean <- cleanMask m
        ks <- asks keyUpKeys
        userCodeDef () $ whenJust (M.lookup (mClean, s) ks) id
handle _ = return ()
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
myBorderWidth = 0

-- color of focused/inactive border
myFocusedBorderColor = "#0066aa"
myNormalBorderColor = "#222222"
--

myStartupHook     = do
  startupHook gnomeConfig
 -- spawn "xcompmgr -c -t-9 -l-11 -r1 -fF -o.0 -D0 &" -- for transparencies (add -fF -o.05 for fade effects)
 -- To change this, first pkill xcompmgr/compton
  spawn "compton -cCGfF -b -I 0.1 -O 0.1 &"

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
    , ((myModMask                , xK_z), scratchQpdf)
    , ((myModMask .|. shiftMask  , xK_z), scratchZthr)
--    , ((myModMask .|. shiftMask  , xK_z), scratchZthr)
    , ((myModMask                , xK_x), scratchViv)
    , ((myModMask .|. shiftMask  , xK_x), scratchBrave)
    , ((myModMask .|. controlMask, xK_x), scratchFfx)
    , ((myModMask                , xK_r), scratchRemm)
    , ((myModMask                , xK_y), scratchSkype)
-- Below toggles panel when Alt_R is held down. For a permanent 
-- change, hit Alt_R+Shift, and release Alt_R first
    , ((noModMask                , xK_Alt_R), 
                  sequence_ [sendMessage ToggleStruts, spawn "pkill compton; compton -cCGfF -b -I 0.1 -O 0.1 -i .04 --active-opacity .04"] ) 
--    , ((myModMask .|. shiftMask  , xK_x), scratchWmail)
-- also gone: xK_b, xK_w, xK_e
  ]
  where
    -- this simply means "find the scratchpad in myScratchPads that is 
    -- named fuzzyfind and launch it"
    scratchFzf   = namedScratchpadAction myScratchPads "fuzzyfind"
    scratchQpdf  = namedScratchpadAction myScratchPads "pdfviewer"
    scratchZthr  = namedScratchpadAction myScratchPads "zathura"
    scratchFfxp  = namedScratchpadAction myScratchPads "firefox-p"
    scratchBrave = namedScratchpadAction myScratchPads "brave-p"
    scratchFfx   = namedScratchpadAction myScratchPads "firefox"
    scratchViv   = namedScratchpadAction myScratchPads "vivaldi"
    scratchPm   = namedScratchpadAction myScratchPads "palemoon"
    scratchChrm  = namedScratchpadAction myScratchPads "chromium"
    scratchRemm  = namedScratchpadAction myScratchPads "remmina"
    scratchSkype = namedScratchpadAction myScratchPads "skype"
--    scratchWmail  = namedScratchpadAction myScratchPads "wmail"

myScratchPads = [  NS "fuzzyfind"  myFzf  findFZ  (customFloating $ W.RationalRect (1/8) (1/6) (1/3) (2/3))  -- one scratchpad
                 , NS "brave-p"  "brave-browser --incognito" findBravep nonFloating  -- one scratchpad
                 , NS "firefox-p"  "firefox -private-window" findFfxp nonFloating  -- one scratchpad
                 , NS "palemoon"  "palemoon" findPm nonFloating  -- one scratchpad
                 , NS "chromium"   "chromium-browser" findChrm nonFloating  -- one scratchpad
                 , NS "vivaldi"   "vivaldi-stable -incognito" findViv nonFloating  -- one scratchpad
                 , NS "firefox"   "firefox" findFfx nonFloating  -- one scratchpad
--                 , NS "wmail"   "~/git/INSTALL/WMail-linux-x64/WMail" findWmail nonFloating  -- one scratchpad
                 , NS "zathura"    "zathura-tabbed" findZthr nonFloating  -- one scratchpad
                 , NS "pdfviewer"    "qpdfview --unique" findPdf nonFloating  -- one scratchpad
                 , NS "remmina"    "remmina" findRemm nonFloating  -- one scratchpad
                 , NS "skype"    "skypeforlinux" findSkype nonFloating -- one scratchpad
                ]
  where
   findFZ     = resource  =? "fzf_term"  
   findZthr   = className =? "tabbed"  
   findPdf    = className =? "qpdfview"  
   findFfxp = className   =? "Firefox" <&&> ("Mozilla Firefox (Private Browsing)" `isSuffixOfQ` pName)
   findPm     = className =? "Pale moon"
   findBravep = className =? "Brave-browser"
   findFfx    = className =? "Firefox" <&&> ("Mozilla Firefox" `isSuffixOfQ` pName)  
   findChrm   = className =? "Chromium-browser"  
   findViv    = className =? "Vivaldi-stable"
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

-- Stolen from
-- https://wiki.haskell.org/Xmonad/Config_archive/rtalreja's_xmonad.hs
-- https://www.snip2code.com/Snippet/1092870/Xmonad-hs-works-with-lemonbar(-xft-slant/
myLogHook h = dynamicLogWithPP . namedScratchpadFilterOutWorkspacePP $ defaultPP
    {
        ppCurrent           =   wrap " %{F#DDDDDD}[" "]%{F#1B1D1E} " . pad 
      , ppVisible           =   wrap "%{F#FFFFFF}" "%{F#1B1D1E}" . pad 
      , ppHidden            =   wrap "%{F#888888}" "%{F#1B1D1E}" . pad 
 --     , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#1B1D1E" . pad
 --     , ppUrgent            =   dzenColor "#ff0000" "#1B1D1E" . pad
      , ppWsSep             =   ""
      , ppSep               =   " " -- " |  "
      , ppLayout            =  wrap "%{F#ebac54}" "%{F#1B1D1E}" . 
                                (\x -> case x of
                                    "NoFrillsDeco Tabbed ResizableTall"             ->      "[ + ]"
                                    "NoFrillsDeco Tabbed Mirror ResizableTall"      ->      "[ - ]"
                                    "Tabbed Full"      ->      "[ F ]"
                                    "Simple Float"              ->      "~"
                                    _                           ->      x
                                )
      , ppTitle             =   (" " ++) . wrap "%{F#CCCCCC}" "%{F#1B1D1E}" . dzenEscape
      , ppOutput            =   hPutStrLn h . wrap " " ""
    }

--myXmonadBar = "dzen2 -x '300' -y '0' -h '24' -w '800' -ta 'l' -fg '#FFFFFF' -bg '#1B1D1E' -fn '-misc-fixed-medium-r-normal--15-140-75-75-c-90-koi8-r'"
-- installed fork from https://github.com/krypt-n/bar for better font support
myXmonadBar = "/home/varao/git/lemonbar/lemonbar -g 800x24+300+0 -F '#FFFFFF' -B '#3F3B39' -f 'roboto'"
myXmonadBar2 = "/home/varao/git/lemonbar/lemonbar -g x24+1920+0 -F '#FFFFFF' -B '#3F3B39' -f 'roboto'"
myStatusBar = "conky -c /home/varao/git/dotfiles/.conkyrc -x 1000; conky -c /home/varao/git/dotfiles/.conkyrc -x 2900 " -- | dzen2 -x '1100' -w '40' -h '24' -ta 'r' -bg '#1B1D1E' -fg '#FFFFFF' -y '0'"

main :: IO ()
main = do
    dzenLeftBar  <- spawnPipe myXmonadBar 
    dzenLeftBar2 <- spawnPipe myXmonadBar2
    dzenRightBar <- spawnPipe myStatusBar
    xmonad $ gnomeConfig
         { 
             logHook             = myLogHook dzenLeftBar >> myLogHook dzenLeftBar2 >> updatePointer (0.25, 0.25) (0.25, 0.25)
           , layoutHook         = smartBorders $ myLayout
           , borderWidth        = myBorderWidth
--           , focusFollowsMouse  = False
           , focusedBorderColor = myFocusedBorderColor
           , normalBorderColor  = myNormalBorderColor
           , startupHook        = myStartupHook
           , handleEventHook    = handleEventHook defaultConfig `mappend`
                     keyUpEventHook `mappend` fullscreenEventHook -- For Firefox to stay in fullscreen
           , manageHook         = myManageHook 
                                    <+> namedScratchpadManageHook myScratchPads 
                                    <+> manageHook defaultConfig -- uses default too
           , mouseBindings      = myMouseBindings
--           , modMask = mod4Mask  -- Temp fix to make windows key the modifier if I really need Alt
         } `additionalKeys` myKeys

