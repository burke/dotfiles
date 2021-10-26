local _M = {}

function _M.hideShowHotkey(bundleID)
  return function()
    -- if the app is already focused, hide it
    local focus = hs.window.focusedWindow()
    if focus and focus:application():bundleID() == bundleID then
      if hs.application.applicationsForBundleID("com.amethyst.Amethyst")[1]:isRunning() then
        return
      else
        return focus:application():hide()
      end
    end

    -- if the app is running and has at least one window, just activate it
    local running = hs.application.applicationsForBundleID(bundleID)
    if #running > 0 and #running[1]:allWindows() > 0 then
      return running[1]:activate()
    end

    -- launch the app if it's not already running or has no active windows
    hs.application.launchOrFocusByBundleID(bundleID)
  end
end

function _M.setFrameForCurrent(cb)
  local win = hs.window.focusedWindow()
  if win then
    local screenFrame = win:screen():frame()
    local x, y, w, h = cb(screenFrame.x, screenFrame.y, screenFrame.w, screenFrame.h)
    win:setFrame(hs.geometry.rect(x, y, w, h))
  end
end


return _M

