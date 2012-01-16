--
-- xmonad config file:
--
-- * w/o gnome
-- * w/ xmobar
-- * w/ trayer
-- * w/ yeganesh + dmenu
--
-- References:
--  * https://gist.github.com/1136051
--  * http://www.vicfryzel.com/2010/06/27/obtaining-a-beautiful-usable-xmonad-configuration
--
import XMonad
import System.Exit
import System.IO

import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers 
import XMonad.Prompt(defaultXPConfig)
import XMonad.Prompt.Shell(shellPrompt)
import XMonad.Util.EZConfig
import XMonad.Util.Run(spawnPipe)


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


workspaces' = ["1:home", "2:web", "3:mail"] ++ map show [4..7]


-- dmenu' = "dmenu_run -nb black -nf white")
dmenu' = "exe=`yeganesh -x -- -nb black -nf white` && eval \"exec $exe\""


-- see xrandr(1)
toggleVgaOutput = vgaEnabled ++ " && " ++ disableVga ++ " || " ++ enableVga
    where mode = "800x600"
          layout = "--right-of LVDS"
          vgaEnabled = "xrandr -q | grep -q \"current " ++ mode ++ "\" >/dev/null 2>/dev/null"
          disableVga = "xrandr --output VGA --off"
          enableVga = "xrandr --output VGA --auto " ++ layout ++ " --mode " ++ mode


--
-- See http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html
-- for keycode names.
--
myKeymaps = [
             ("M-<F2>", spawn dmenu')
            ,("M-C-<Left>", prevWS )
            ,("M-C-<Right>", nextWS )
            ,("M-S-<Left>", shiftToPrev )
            ,("M-S-<Right>", shiftToNext )
            ,("M-S-l", spawn "xscreensaver-command -lock")
            ,("<XF86AudioMute>", spawn "amixer -q set Master toggle")
            ,("<XF86AudioLowerVolume>", spawn "amixer -q set Master 10%-")
            ,("<XF86AudioRaiseVolume>", spawn "amixer -q set Master 10%+")
            ,("<XF86Display>", spawn toggleVgaOutput)
            ]


defaults = defaultConfig {
     terminal           = "urxvt"
    ,focusFollowsMouse  = True
    ,borderWidth        = 1
    ,modMask            = modMask'
    ,numlockMask        = numlockMask'
    ,workspaces         = workspaces'
    ,normalBorderColor  = "#dddddd"
    ,focusedBorderColor = "#3366cc"
    ,manageHook         = composeAll
        [
         manageDocks
        ,isFullscreen                  --> doFullFloat
        ,className =? "MPlayer"        --> doFloat
        ,className =? "Gimp"           --> doFloat
        ,className =? "Firefox"        --> doShift "2:web"
        ,className =? "Thunderbird"    --> doShift "3:mail"
        ]
    }
    `additionalKeysP` myKeymaps

myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)


main = xmonad =<< statusBar "xmobar" myPP toggleStrutsKey defaults


-- vim:sw=4 ts=4 et:
