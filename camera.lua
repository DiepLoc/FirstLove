---@class Camera
Camera = Object:extend()

function Camera:new(x, y, width, height)
    self.x = x or 0
    self.y = y or 0
    self.width = width or love.graphics.getWidth()
    self.height = height or love.graphics.getHeight()
    self.scale = 1
    return self
end

function Camera:update(dt)
    local player = MyLocator.gameObjectManager.player
    if not player then return end
    local playerCenter = player.positionComp.displayRect:getCenter()
    self:setCenterPosition(playerCenter.x, playerCenter.y)
end

function Camera:worldToScreen(x, y, width, height)
    local screenX = (x - self.x) * self.scale
    local screenY = (y - self.y) * self.scale
    local screenWidth = width * self.scale
    local screenHeight = height * self.scale
    return Rectangle(screenX, screenY, screenWidth, screenHeight)
end

function Camera:screenToWorld(x, y, width, height)
    local worldX = x / self.scale + self.x
    local worldY = y / self.scale + self.y
    local worldWidth = width / self.scale
    local worldHeight = height / self.scale
    return Rectangle(worldX, worldY, worldWidth, worldHeight)
end

function Camera:worldToScreenOrNull(rect)
    local camRect = self:getRect();
    if not camRect:collidesWith(rect) then
        return nil
    end
    return self:worldToScreen(rect.x, rect.y, rect.width, rect.height)
end

function Camera:setCenterPosition(x, y)
    self.x = x - self.width / self.scale / 2
    self.y = y - self.height / self.scale / 2
end

function Camera:setScale(scale)
    if scale < 0.5 or scale > 4 then
        return
    end
    local center = self:getRect():getCenter()
    self.scale = scale
    self:setCenterPosition(center.x, center.y)
end

---@return Rectangle
function Camera:getBaseWindowRect()
    local center = self:getRect():getCenter()
    return Rectangle(center.x - self.width / 2, center.y - self.height / 2, self.width, self.height)
end

---@return Rectangle
function Camera:getRect()
    return Rectangle(self.x, self.y, self.width / self.scale, self.height / self.scale)
end

return Camera
