Vector2 = Object:extend()

-- Constructor
function Vector2:new(x, y)
    self.x = x or 0
    self.y = y or 0
    return self
end

-- Add operator
function Vector2.__add(a, b)
    return Vector2:new(a.x + b.x, a.y + b.y)
end

-- Subtract operator
function Vector2.__sub(a, b)
    return Vector2:new(a.x - b.x, a.y - b.y)
end

-- Multiply operator (scalar or component-wise)
function Vector2.__mul(a, b)
    if type(a) == "number" then
        return Vector2:new(a * b.x, a * b.y)
    elseif type(b) == "number" then
        return Vector2:new(b * a.x, b * a.y)
    else
        return Vector2:new(a.x * b.x, a.y * b.y)
    end
end

-- Divide operator (scalar or component-wise)
function Vector2.__div(a, b)
    if type(a) == "number" then
        return Vector2:new(a / b.x, a / b.y)
    elseif type(b) == "number" then
        return Vector2:new(a.x / b, a.y / b)
    else
        return Vector2:new(a.x / b.x, a.y / b.y)
    end
end

-- Length of vector
function Vector2:length()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

-- Squared length (faster, no sqrt)
function Vector2:lengthSquared()
    return self.x * self.x + self.y * self.y
end

-- Normalize vector
function Vector2:normalize()
    local len = self:length()
    if len == 0 then
        return Vector2:new(0, 0)
    else
        return self / len
    end
end

-- Dot product
function Vector2:dot(other)
    return self.x * other.x + self.y * other.y
end

-- Create copy
function Vector2:clone()
    return Vector2:new(self.x, self.y)
end

-- String representation (optional, for printing)
function Vector2:__tostring()
    return "(" .. self.x .. ", " .. self.y .. ")"
end

return Vector2
