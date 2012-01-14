--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
-- References:
--  * http://www.haskell.org/haskellwiki/Xmonad/Using_xmonad_in_Gnome
--  * http://d.hatena.ne.jp/mono-hate/20081210/1228915177
--
--

import XMonad
import System.Exit

import XMonad.Actions.CycleWS
import XMonad.Config.Gnome
import XMonad.Hooks.ManageHelpers 
import XMonad.Util.EZConfig

-- import XMonad.Prompt
-- import XMonad.Prompt.Shell


-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
-- modMask' = mod1Mask
modMask' = mod4Mask


-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
numlockMask' = mod2Mask


-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
workspaces' = map show [1..5]


myKeymaps = [
             ("M-<F2>", gnomeRun)
            ,("M-C-<Left>", prevWS )
            ,("M-C-<Right>", nextWS )
            ,("M-S-<Left>", shiftToPrev )
            ,("M-S-<Right>", shiftToNext )
            ,("M-S-q", spawn "gnome-session-save --gui --kill")
            ,("M-S-l", spawn "gnome-screensaver-command -l")
            ]


main = xmonad $ gnomeConfig
    {
     terminal           = "gnome-terminal"
    ,focusFollowsMouse  = True
    ,borderWidth        = 1
    ,modMask            = modMask'
    ,numlockMask        = numlockMask'
    ,workspaces         = workspaces'
    ,normalBorderColor  = "#dddddd"
    ,focusedBorderColor = "#3366cc"
    ,logHook            = logHook gnomeConfig
    ,manageHook         = composeAll
        [
         manageHook gnomeConfig
        ,isFullscreen                  --> doFullFloat
        ,className =? "MPlayer"        --> doFloat
        ,className =? "Gimp"           --> doFloat
        ,className =? "Gnome-terminal" --> doShift "1"
        ,className =? "Firefox"        --> doShift "2"
        ,className =? "Thunderbird"    --> doShift "3"
        ]
    }
    `additionalKeysP` myKeymaps


-- vim:sw=4 ts=4 et:
