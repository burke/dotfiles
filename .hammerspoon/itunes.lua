-- suggested usage:
--   local itunes = require("itunes")
--   hs.hotkey.bind({"cmd", "ctrl"}, "2", itunes.toggleLibrary)
--   hs.hotkey.bind({"cmd", "ctrl"}, "m", itunes.toggleMiniPlayer)

local _M = {}

local iTunesID = "com.apple.Music"

function ensureRunning(bundleID)
  local apps = hs.application.applicationsForBundleID(bundleID)
  if #apps == 0 then
    return hs.application.launchOrFocusByBundleID(bundleID)
  end
  apps = hs.application.applicationsForBundleID(bundleID)
  return apps[1]
end

-- iTunes: hs.application for iTunes
-- want:   bool, indicating whether we want miniplayer (true) or library (false)
-- return: bool, indicating whether we changed views
function setMiniPlayerState(iTunes, want)
  local wins = iTunes:allWindows()
  local have= #wins ~= 0 and wins[1]:title() == "MiniPlayer"

  if want and not have then
    iTunes:activate()
    iTunes:selectMenuItem({"Window", "Switch to MiniPlayer"})
    return true
  end

  if have and not want then
    iTunes:activate()
    iTunes:selectMenuItem({"Window", "Switch from MiniPlayer"})
    return true
  end

  return false -- state not changed
end

function toggleVisibility(app)
  if app:isHidden() then
    app:unhide()
  else
    app:hide()
  end
end

-- launch itunes if it isn't running
-- show and focus the iTunes main window (e.g. library)
-- toggle visibility if pressed again while library is active
-- toggle back to library if miniplayer is active
function _M.toggleLibrary()
  local prevApp = hs.application.frontmostApplication()
  local iTunesApp = ensureRunning(iTunesID)

  if setMiniPlayerState(iTunesApp, false) then
    return
  end

  if prevApp == iTunesApp then
    return iTunesApp:hide()
  end

  if #iTunesApp:allWindows() == 0 then
    -- if there were no windows, press Cmd-0 to show the library
    iTunesApp:selectMenuItem({"Window", "iTunes"})
  end

  iTunesApp:activate()
end

-- This is meant to be used with:
--    Preferences > Advanced > Keep MiniPlayer on top of other windows
--
-- launch itunes if it isn't running
-- switch to miniplayer if not currently active
-- toggle visibility of miniplayer if active without stealing focus from current app
function _M.toggleMiniPlayer()
  local prevApp = hs.application.frontmostApplication()
  local iTunesApp = ensureRunning(iTunesID)

  if setMiniPlayerState(iTunesApp, true) then
    return prevApp:activate()
  end

  prevApp:activate()
  toggleVisibility(iTunesApp)
end

return _M

