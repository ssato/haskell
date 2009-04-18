--
-- http://www.haskell.org/haskellwiki/Xmonad/Config_archive/Template_xmonad.hs_%280.8%29
--

--
-- http://www.haskell.org/haskellwiki/Xmonad/Basic_Desktop_Environment_Integration
--
{-
import XMonad
import XMonad.Config.Gnome
 
main = xmonad gnomeConfig
-}

--
-- http://www.haskell.org/haskellwiki/Xmonad/Using_xmonad_in_Gnome
-- http://www.haskell.org/haskellwiki/Xmonad/General_xmonad.hs_config_tips
--
import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicWorkspaces
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig


-- myWorkspaces    = ["1","2","3","4","5"]
myWorkspaces    = ["1:term", "2:web", "3:mail", "4:misc", "5:other"]

myKeys = 
        [
        -- moving workspaces
          ("C-M-<Left>",  prevWS)
        , ("C-M-<Right>", nextWS)
        , ("M-S-<Left>",  shiftToPrev )
        , ("M-S-<Right>", shiftToNext )

        -- Make mod+shift+q to quit gnome-session
        , ("M-S-<Return>", spawn "gnome-terminal")

        -- Make mod+shift+q to quit gnome-session
        , ("M-S-q", spawn "gnome-session-save --gui --kill")

        -- Lock Screen
        , ("M-S-l", spawn "gnome-screensaver-command -l")
        ]


main = xmonad $ defaultConfig
                { manageHook = manageDocks <+> manageHook defaultConfig
                , logHook    = ewmhDesktopsLogHook
                , workspaces = myWorkspaces
                , layoutHook = ewmhDesktopsLayout $ avoidStruts $ layoutHook defaultConfig
                } `additionalKeysP` myKeys
