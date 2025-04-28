Object = require "classic"

Block = Object:extend()

function Block:new(x, y)
  self.x = x or 0
  self.y = y or 0
end

return Block