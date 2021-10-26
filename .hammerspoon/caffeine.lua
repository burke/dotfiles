local _M = {}

-- initially borrowed from
-- https://github.com/cmsj/hammerspoon-config/blob/master/init.lua

local Caffeinator = {}

local function setState(menubarItem, state)
  if state then
    menubarItem:setIcon("/Users/burke/.hammerspoon/caffeine-on.pdf")
  else
    menubarItem:setIcon("/Users/burke/.hammerspoon/caffeine-off.pdf")
  end
end

function Caffeinator:clicked()
  setState(self.menubarItem, hs.caffeinate.toggle("displayIdle"))
end

function Caffeinator:start()
  self.menubarItem = hs.menubar.new()
  setState(self.menubarItem, hs.caffeinate.get("displayIdle"))
  self.menubarItem:setClickCallback(function() self:clicked() end)
end

function _M.new()
  return setmetatable({}, {__index = Caffeinator})
end

local globalCaffeinator

function _M.start()
  globalCaffeinator = _M.new()
  globalCaffeinator:start()
end

function _M.clicked()
  globalCaffeinator:clicked()
end

return _M
