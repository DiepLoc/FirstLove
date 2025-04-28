require "classic"
require "utils.rectangle"

PosisionComp = Object:extend()

function PosisionComp:new(x, y, width, height)
    self.rect = Rectangle(x, y, width, height)
end

return PosisionComp