---@class ParallaxBackground
ParallaxBackground = Object:extend()

function ParallaxBackground:new(center)
    self.originCenter = center
    self.currentCenter = center
    self.parallaxFactor = 0.8
    return self
end

function ParallaxBackground:update(dt)
    local camCenter = MyLocator.camera:getRect():getCenter()
    local direction = camCenter - self.originCenter
    local parallaxDirection = Vector2(direction.x * self.parallaxFactor, direction.y * self.parallaxFactor)

    self.currentCenter = self.originCenter + parallaxDirection
end

function ParallaxBackground:draw()
    local parallaxScale = 4
    local size = Rectangle(0, 0, 1920 * parallaxScale, 1100 * parallaxScale)
    local center = Vector2(size.width / 2, size.height / 2)
    local move = self.currentCenter - center
    size:move(move.x, move.y)

    DrawHelper.drawImage("sky", nil, size)
end

return ParallaxBackground
