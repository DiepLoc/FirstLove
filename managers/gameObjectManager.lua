require "managers.baseManager"

---@class GameObjectManager
GameObjectManager = BaseManager:extend()

function GameObjectManager:new()
    self.gameObjects = {}
    self.blocks = nil
    return self
end

function GameObjectManager:addGameObject(gameObject)
    table.insert(self.gameObjects, gameObject)
end

function GameObjectManager:onSetup()
    ---@type GameObject
    self.player = Factory.getPlayer(1, 0)
    table.insert(self.gameObjects, self.player)
    -- table.insert(self.gameObjects, Factory.getZombie(10, 10))
    table.insert(self.gameObjects, Factory.getSkeleton(20, 10))

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
function GameObjectManager:checkAndHandleCollision(obj, dx, dy)
    local collisionRect = obj.positionComp:getWorldCollisionRect()
    local collisionRect2 = Rectangle(collisionRect.x + dx, collisionRect.y + dy, collisionRect.width,
        collisionRect.height)
    local tileRect = CommonHelper.getTileRect(Rectangle(collisionRect.x + dx, collisionRect.y + dy, collisionRect.width,
        collisionRect.height))
    local isBlocked = false

    -- check with map tiles
    for x = tileRect.x - 1, tileRect.right + 2 do
        for y = tileRect.y - 1, tileRect.bottom + 2 do
            if self.blocks[x] and self.blocks[x][y] then
                local block = self.blocks[x][y]
                if block.positionComp.isBlocked or block.positionComp.isCollidable then
                    if block.positionComp:getWorldCollisionRect():collidesWith(collisionRect2) then
                        if block.positionComp.isBlocked and obj.positionComp.isBlocked then
                            isBlocked = true
                        end
                        if block.positionComp.isCollidable and obj.positionComp.isCollidable then
                            obj:handleCollision(block)
                            block:handleCollision(obj)
                        end
                    end
                end
            end
        end
    end

    -- check with other objects
    for _, other in pairs(self.gameObjects) do
        if other ~= obj and not other.isDestroyed then
            local otherBounds = other.positionComp:getWorldCollisionRect()

            if collisionRect2:collidesWith(otherBounds) then
                if obj.positionComp.isBlocked and other.positionComp.isBlocked then
                    isBlocked = true
                end

                if obj.positionComp.isCollidable and other.positionComp.isCollidable then
                    obj:handleCollision(other)
                    other:handleCollision(obj)
                end
            end
        end
    end
    return isBlocked
end

-- return newDx, newDy, isGrounded
function GameObjectManager:handleMoving(obj, dx, dy)
    if dx == 0 and dy == 0 then
        return 0, 0, true
    end
    local xyMove = not self:checkAndHandleCollision(obj, dx, dy)
    if xyMove then
        return dx, dy, false
    else
        local xMove = not self:checkAndHandleCollision(obj, dx, 0)
        if xMove then
            return dx, 0, dy >= 0
        else
            local yMove = not self:checkAndHandleCollision(obj, 0, dy)
            if yMove then
                return 0, dy, false
            else
                return 0, 0, dy >= 0
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
        if (block.isDestroyed) then
            if y > (Constants.MAP_HEIGHT - Constants.MAP_WATER_HEIGHT) then
                self.blocks[x][y] = GameObjectFactory.getWaterBlock(x, y)
            else
                self.blocks[x][y] = nil
            end
        end
    end)

    if self.player and self.player.isDestroyed then
        self.player = nil
    end

    AddDebugStr("GameObj: " .. #self.gameObjects .. " blocks:" .. #self.blocks)
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
