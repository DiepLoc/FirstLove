-- rectangle.lua
require("utils.vector2")
require("classic")

Rectangle = Object:extend()

-- Constructor
function Rectangle:new(x, y, width, height)
    self.position = Vector2(x or 0, y or 0)  -- Position stored as Vector2
    self.width = width or 0
    self.height = height or 0
end

-- Set Position
function Rectangle:setPosition(x, y)
    self.position.x = x
    self.position.y = y
end

-- Move Rectangle by dx, dy
function Rectangle:move(dx, dy)
    self.position = self.position + Vector2(dx, dy)
end

-- Get the top-left corner as Vector2
function Rectangle:getPosition()
    return self.position
end

function Rectangle:getSize()
    return Vector2(self.width, self.height)
end

-- Check for collision with another rectangle
function Rectangle:collidesWith(other)
    return not (self.position.x + self.width < other.position.x or
                self.position.x > other.position.x + other.width or
                self.position.y + self.height < other.position.y or
                self.position.y > other.position.y + other.height)
end

-- Resize the rectangle
function Rectangle:resize(width, height)
    self.width = width
    self.height = height
end

-- String representation (optional)
function Rectangle:__tostring()
    return "Rectangle(" .. self.position.x .. ", " .. self.position.y .. ", " .. self.width .. ", " .. self.height .. ")"
end

return Rectangle