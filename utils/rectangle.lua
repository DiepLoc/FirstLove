---@class Rectangle
Rectangle = Object:extend()

-- Constructor
function Rectangle:new(x, y, width, height)
    self.x = x
    self.y = y -- Position stored as Vector2
    self.width = width or 0
    self.height = height or 0
    return self
end

function Rectangle:setCenterPosition(x, y)
    self.x = x - self.width / 2
    self.y = y - self.height / 2
end

function Rectangle:getCenter()
    return Vector2(self.x + self.width / 2, self.y + self.height / 2)
end

function Rectangle:__index(key)
    if key == "Position" or key == "position" then
        return Vector2(self.x, self.y)
    elseif key == "Size" or key == "size" then
        return Vector2(self.width, self.height)
    elseif key == "right" then
        return self.x + self.width
    elseif key == "bottom" then
        return self.y + self.height
    else
        return rawget(getmetatable(self), key) or rawget(self, key)
    end
end

-- Set Position
function Rectangle:setPosition(x, y)
    self.x = x
    self.y = y
end

-- Move Rectangle by dx, dy
function Rectangle:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

-- Check for collision with another rectangle
function Rectangle:collidesWith(other)
    return not (self.x + self.width < other.x or
        self.x > other.x + other.width or
        self.y + self.height < other.y or
        self.y > other.y + other.height)
end

-- Resize the rectangle
function Rectangle:resize(width, height)
    self.width = width
    self.height = height
end

-- String representation (optional)
function Rectangle:__tostring()
    return "Rectangle(" .. self.x .. ", " .. self.y .. ", " .. self.width .. ", " .. self.height .. ")"
end

return Rectangle
