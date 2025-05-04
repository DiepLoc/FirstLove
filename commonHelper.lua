CommonHelper = Object:extend()

function CommonHelper.getTileRect(rect)
    local tileRect = Rectangle(math.floor(rect.x / Constants.TILE_SIZE), math.floor(rect.y / Constants.TILE_SIZE),
        math.ceil(rect.width / Constants.TILE_SIZE), math.ceil(rect.height / Constants.TILE_SIZE))

    return tileRect
end

return CommonHelper
