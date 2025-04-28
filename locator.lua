Object = require "classic"

Locator = Object:extend()

function Locator:new(x, y)
    self.x = x or 0
    self.y = y or 0
end

return Locator