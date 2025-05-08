CommonHelper = Object:extend()

function CommonHelper.getTileRect(rect)
    local tileRect = Rectangle(math.floor(rect.x / Constants.TILE_SIZE), math.floor(rect.y / Constants.TILE_SIZE),
        math.ceil(rect.width / Constants.TILE_SIZE), math.ceil(rect.height / Constants.TILE_SIZE))

    return tileRect
end

function CommonHelper.getDistance(x, y, x2, y2)
    local dx = x2 - x
    local dy = y2 - y
    return math.sqrt(dx * dx + dy * dy), math.abs(dx), math.abs(dy)
end

function CommonHelper.getRandomResultByTime(time, dt)
    return math.random() < dt / time
end

function CommonHelper.getDirection(x2, y2, x1, y1)
    return Vector2(x2 - x1, y2 - y1)
end

function CommonHelper.getTilePos(pos)
    return Vector2(math.floor(pos.x / Constants.TILE_SIZE), math.floor(pos.y / Constants.TILE_SIZE))
end

function CommonHelper.get4dDirectionFromDirection(x2, y2, x1, y1)
    local dx = x2 - x1
    local dy = y2 - y1
    local aTan = math.atan2(dy, dx)
    local degrees = math.deg(aTan)
    degrees = (degrees + 360) % 360
    if degrees > 315 or degrees < 45 then
        return Vector2(1, 0)  -- right
    elseif degrees >= 45 and degrees <= 135 then
        return Vector2(0, 1)  -- down
    elseif degrees > 135 and degrees < 225 then
        return Vector2(-1, 0) -- left
    elseif degrees >= 225 and degrees <= 315 then
        return Vector2(0, -1) -- up
    end
    error("Invalid angle: " .. degrees)
end

function CommonHelper.get2dDirectionFromDirection(x2, y2, x1, y1)
    local dx = x2 - x1
    local dy = y2 - y1
    local aTan = math.atan2(dy, dx)
    local degrees = math.deg(aTan)
    degrees = (degrees + 360) % 360
    if degrees > 270 or degrees < 90 then
        return Vector2(1, 0)  -- right
    else
        return Vector2(-1, 0) -- left
    end
    error("Invalid angle: " .. degrees)
end

function CommonHelper.lerpValue(initVal, targetVal, factor)
    return initVal + (targetVal - initVal) * factor
end

return CommonHelper
