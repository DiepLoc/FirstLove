DrawHelper = Object:extend()

local generalImg = love.graphics.newImage("assets/images/MinecraftContent.png")
generalImg:setFilter("nearest", "nearest")
local spritebatch = love.graphics.newSpriteBatch(generalImg, 1000)
function DrawHelper.drawSpriteBatch()
    love.graphics.draw(spritebatch)
end

function DrawHelper.clearSpritebatch()
    spritebatch:clear()
end

function DrawHelper.addSpriteToSpritebatch(quad, x, y, sx, sy)
    spritebatch:add(quad, x, y, 0, sx, sy)
end

function DrawHelper.drawImage(imageName, sourceRect, destRect, color, flipX, flipY)
    local screenRect = MyLocator.camera:worldToScreenOrNull(destRect)
    if not screenRect then
        return
    end
    local image = MyLocator.imageManager:getImage(imageName)
    local quad = love.graphics.newQuad(sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height,
        image:getDimensions())
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

    -- if (imageName == "general") then
    --     DrawHelper.addSpriteToSpritebatch(quad, math.floor(drawX), math.floor(drawY), scaleX, scaleY)
    -- else
    --     love.graphics.draw(image, quad, math.floor(drawX), math.floor(drawY), 0, scaleX, scaleY)
    -- end
    love.graphics.draw(image, quad, drawX, drawY, 0, scaleX, scaleY)
    love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
end

function DrawHelper.drawRect(x, y, width, height, color)
    local screenRect = MyLocator.camera:worldToScreenOrNull(Rectangle(x, y, width, height))
    if not screenRect then
        return
    end

    if color then
        love.graphics.setColor(color[1], color[2], color[3], color[4] or 1)
    else
        love.graphics.setColor(1, 1, 1, 1) -- Default: white
    end

    love.graphics.rectangle("fill", screenRect.x, screenRect.y, screenRect.width, screenRect.height)

    love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
end

return DrawHelper
