local _M = {}

local util = require("util")

function _M.setup(mods, binds)
  for i, bundleID in pairs(binds) do
    if bundleID then
      hs.hotkey.bind(mods, tostring(i), util.hideShowHotkey(bundleID))
    end
  end
end

return _M
