local _M = {}

local LeaderMap = {}

function LeaderMap:bind(key, action)
  self.modal:bind({}, key, function()
    self.modal:exit()
    action()
  end)
end

function LeaderMap:bindall(binds)
  for key, action in pairs(binds) do
    self:bind(key, action)
  end
end

function _M.new(mods, key)
  local modal = hs.hotkey.modal.new(mods, key)
  modal:bind({}, "escape", function() modal:exit() end)
  return setmetatable({modal = modal}, {__index = LeaderMap})
end

return _M
