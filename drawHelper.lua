DrawHelper = Object:extend()

function DrawHelper.drawImage(imageName, sourceRect, destRect, color, flipX, flipY)
    local screenRect = MyLocator.camera:worldToScreenOrNull(destRect)
    if not screenRect then
        return
    end
    local image = MyLocator.imageManager:getImage(imageName)
    local quad = love.graphics.newQuad(sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height, image:getWidth(),
        image:getHeight())
    if color then
        love.graphics.setColor(color[1], color[2], color[3], color[4] or 1)
    else
        love.graphics.setColor(1, 1, 1, 1) -- Default: white
    end

    local drawX = screenRect.x
    local drawY = screenRect.y
    local scaleX = screenRect.width / sourceRect.width
    local scaleY = screenRect.height / sourceRect.height

    -- Flip
    if flipX then
        scaleX = -scaleX
        drawX = drawX + screenRect.width -- move origin to the right edge
    end

    if flipY then
        scaleY = -scaleY
        drawY = drawY + screenRect.height -- move origin to the bottom edge
    end

    love.graphics.draw(image, quad, drawX, drawY, 0, scaleX, scaleY)

    love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
end

return DrawHelper
