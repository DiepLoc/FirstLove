require "classic"

AimComp = Object:extend()

function AimComp:new(x, y, width, height)
    self.rect = Rectangle(x, y, width, height)
end

return AimComp