local _M = {}

local urlevent = hs.urlevent

function _M.setup(mods, binds)
  for key, url in pairs(binds) do
    hs.hotkey.bind(mods, key, function() urlevent.openURL(url) end)
  end
end

return _M
