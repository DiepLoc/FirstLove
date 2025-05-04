require "managers.baseManager"

---@class GameObjectManager
GameObjectManager = BaseManager:extend()

function GameObjectManager:new()
    self.gameObjects = {}
    self.blocks = nil
    return self
end

function GameObjectManager:onSetup()
    self.player = Factory.getPlayer(1, 0)
    table.insert(self.gameObjects, self.player)

    self.blocks = GameObjectFactory.generateTerrain(Constants.MAP_WIDTH, Constants.MAP_HEIGHT,
        Constants.MAP_GENERATE_SCALE, Constants.MAP_GENERATE_OFFSET, Constants.MAP_WATER_HEIGHT)
end

function GameObjectManager:getObjByName(objName)
    local objs = {}
    for _, gameObject in pairs(self.gameObjects) do
        if gameObject.name == objName then
            table.insert(objs, gameObject)
        end
    end
    return objs
end

function GameObjectManager:getObjByCondition(func)
    local objs = {}
    for _, gameObject in pairs(self.gameObjects) do
        if func(gameObject) then
            table.insert(objs, gameObject)
        end
    end
    return objs
end

---@param obj GameObject
function GameObjectManager:checkIsCollision(obj, dx, dy)
    local collisionRect = obj.positionComp:getWorldCollisionRect()
    local collisionRect2 = Rectangle(collisionRect.x + dx, collisionRect.y + dy, collisionRect.width,
        collisionRect.height)
    local tileRect = CommonHelper.getTileRect(Rectangle(collisionRect.x + dx, collisionRect.y + dy, collisionRect.width,
        collisionRect.height))
    local isBlocked = false
    for x = tileRect.x - 1, tileRect.right + 2 do
        for y = tileRect.y - 1, tileRect.bottom + 2 do
            if self.blocks[x] and self.blocks[x][y] then
                local block = self.blocks[x][y]
                if block.positionComp.isBlocked or block.positionComp.isCollidable then
                    if block.positionComp:getWorldCollisionRect():collidesWith(collisionRect2) then
                        if block.positionComp.isBlocked then
                            isBlocked = true
                        end
                        if block.positionComp.isCollidable then
                            obj:handleCollision(block)
                        end
                    end
                end
            end
        end
    end
    return isBlocked
end

function GameObjectManager:updateIsGrounded(obj)
    local tileSize = Constants.TILE_SIZE
    local collisionRect = obj.positionComp:getWorldCollisionRect()
    local x1 = math.floor((collisionRect.x) / tileSize) + 1
    local x2 = math.floor((collisionRect.right - 1) / tileSize) + 1
    local y = math.floor((collisionRect.bottom + 1) / tileSize)

    AddDebugStr("x1:" .. x1 .. " x2:" .. x2 .. " y:" .. y)

    local isGrounded = false

    for x = x1, x2 do
        local column = self.blocks[x]
        if column then
            local blockBelow = column[y]
            if blockBelow and blockBelow.positionComp.isBlocked then
                isGrounded = true
                break
            end
        end
    end
    AddDebugStr("isGrounded:" .. tostring(isGrounded))
    return isGrounded
end

function GameObjectManager:handleMoving(obj, dx, dy)
    if dx == 0 and dy == 0 then
        return { 0, 0, true }
    end
    local xyMove = not self:checkIsCollision(obj, dx, dy)
    if xyMove then
        return { dx, dy, false }
    else
        local xMove = not self:checkIsCollision(obj, dx, 0)
        if xMove then
            return { dx, 0, true }
        else
            local yMove = not self:checkIsCollision(obj, 0, dy)
            if yMove then
                return { 0, dy, false }
            else
                return { 0, 0, true }
            end
        end
    end
    error("GameObjectManager:handleMoving: Invalid move")
end

function GameObjectManager:handleBlocksOnView(cb)
    local blocks = self.blocks
    local camera = MyLocator.camera:getRect()
    local tileRect = CommonHelper.getTileRect(camera)
    local x1 = tileRect.x
    local x2 = tileRect.right
    local y1 = tileRect.y
    local y2 = tileRect.bottom
    local count = 0
    for x = x1, x2 do
        for y = y1, y2 do
            if blocks[x] and blocks[x][y] then
                local block = blocks[x][y]
                cb(block, x, y)
                count = count + 1
            end
        end
    end
    AddDebugStr(x1 .. " " .. x2 .. "/" .. y1 .. " " .. y2 .. "_Count:" .. count)
end

function GameObjectManager:update(dt)
    for i = #self.gameObjects, 1, -1 do
        self.gameObjects[i]:update(dt)
        if self.gameObjects[i].isDestroyed then
            table.remove(self.gameObjects, i)
        end
    end
    self:handleBlocksOnView(function(block, x, y)
        block:update(dt)
        if (block.isdstroyed) then
            self.blocks[x][y] = nil
        end
    end)
end

function GameObjectManager:draw()
    DrawHelper.clearSpritebatch()
    for i = #self.gameObjects, 1, -1 do
        self.gameObjects[i]:draw()
    end
    self:handleBlocksOnView(function(block, x, y)
        block:draw()
    end)
    DrawHelper.drawSpriteBatch()
end

return GameObjectManager
