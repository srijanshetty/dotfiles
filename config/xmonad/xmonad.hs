import XMonad
import XMonad.Actions.GridSelect (defaultGSConfig, goToSelected)
import XMonad.Actions.Search (google, wayback, wikipedia, wiktionary, selectSearch, promptSearch)
import XMonad.Config.Gnome (gnomeConfig)
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops (ewmhDesktopsLogHook)
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks)
import XMonad.Hooks.UrgencyHook (withUrgencyHook, FocusHook(..))
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Prompt (greenXPConfig)
import XMonad.Prompt.Shell (shellPrompt, prompt, safePrompt)
import XMonad.StackSet as W (focusUp, focusDown, focusMaster,sink,swapMaster)
import XMonad.Util.Run (unsafeSpawn, runInTerm, safeSpawnProg)
import XMonad.Util.XSelection (safePromptSelection)
import XMonad.Prompt.AppendFile
import qualified Data.Map as M

main :: IO ()
main = spawn "killall unclutter;unclutter;" >> spawn "killall urxvtd;urxvtd -q -f -o" >> xmonad myConfig
 where myConfig = withUrgencyHook FocusHook $ gnomeConfig { 
                          focusedBorderColor = "red"
                          , focusFollowsMouse = False
                          , keys = \c -> myKeys c `M.union` keys defaultConfig c
                          , layoutHook =  avoidStruts $ smartBorders (Full ||| tiled ||| Mirror tiled)
                          , logHook    = ewmhDesktopsLogHook
                          , manageHook = myManageHook
                          , modMask = mod4Mask
                          , normalBorderColor  = "grey"
                          , terminal = "urxvtc"
                          , XMonad.workspaces = ["read", "web", "code" ,"explorer", "media", "skype","torrent", "background-process"] 
                        }
                          where tiled = Tall 1 0.03 0.5

myManageHook :: ManageHook
myManageHook = composeAll [
                            moveC "Vlc" "media"
                            , moveC "Google-chrome" "web"
                            , moveC "Firefox" "web"
                            , moveC "Transmission-gtk" "torrent"
                            , moveC "Nautilus" "explorer"
                            , moveC "Banshee" "media"
                            , moveC "Evince" "read"
                            , moveC "Chmsee" "read"
                            , moveC "Linuxdcpp" "torrent"
                            , moveC "Anki" "read"
                            , moveC "Skype" "skype"
                            , className =? "gnome-panel" --> doIgnore
                            , className =? "Mnemosyne" --> unfloat
                            , className =? "Gimp"	--> doFloat
                            , className =? "Gwibber" --> doFloat
                            , isFullscreen --> doFullFloat
                          ]
                           <+> manageDocks
          where moveC c w = className =? c --> doShift w
                moveT t w = title     =? t --> doShift w
                unfloat = ask >>= doF . W.sink
                
myKeys :: XConfig t -> M.Map (KeyMask, KeySym) (X ())
myKeys (XConfig {modMask = m, terminal = term}) = M.fromList
                          [((m .|. shiftMask,xK_p), shellPrompt greenXPConfig)
                          , ((m,              xK_c), kill)
                          , ((m,              xK_s), goToSelected defaultGSConfig)
                          , ((m,              xK_z), withFocused $ windows . W.sink)
                          , ((m,              xK_w), windows W.swapMaster)
                          , ((m,              xK_g), promptSearch greenXPConfig google)
                          , ((m .|. shiftMask,xK_g), selectSearch google)
                          , ((m,              xK_a), sendMessage Shrink)
                          , ((m,              xK_d), sendMessage Expand)]
