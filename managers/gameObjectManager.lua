require "managers.baseManager"

---@class GameObjectManager
GameObjectManager = BaseManager:extend()

function GameObjectManager:new()
    self.gameObjects = {}
    self.blocks = nil
    self.wonShowTime = 0
    return self
end

function GameObjectManager:addGameObject(gameObject)
    table.insert(self.gameObjects, gameObject)
end

function GameObjectManager:checkValidLinkedBlock(x, y)
    if x < 1 or x > #self.blocks or y < 1 or y > #self.blocks[x] then
        return false
    end
    return self.blocks[x][y] ~= nil
end

function GameObjectManager:addBlock(block, x, y, shouldOverwrite, addMidAir)
    if x < 1 or x > #self.blocks or y < 1 or y > #self.blocks[x] then
        return false
    end

    if not addMidAir and not self:checkValidLinkedBlock(x, y - 1) and not self:checkValidLinkedBlock(x, y + 1)
        and not self:checkValidLinkedBlock(x - 1, y) and not self:checkValidLinkedBlock(x + 1, y) then
        return false
    end

    if block.positionComp.isBlocked then
        for _, obj in pairs(self.gameObjects) do
            local collisionRect = obj.positionComp:getWorldCollisionRect()
            local blockRect = block.positionComp:getWorldCollisionRect()
            if obj.positionComp.isBlocked and collisionRect:collidesWith(blockRect) then
                return false
            end
        end
    end

    if self.blocks[x][y] then
        if shouldOverwrite or self.blocks[x][y].name == Constants.OBJ_NAME_WATER then
            self.blocks[x][y] = block
            return true
        else
            return false
        end
    else
        self.blocks[x][y] = block
        return true
    end
end

function GameObjectManager:onSpawnPlayer()
    ---@type GameObject
    self.player = Factory.getPlayer(Constants.MAP_WIDTH / 2, -10)
    table.insert(self.gameObjects, self.player)
    MyLocator:notify(Constants.EVENT_PlAYER_SPAWN)
end

function GameObjectManager:onSetup()
    self:onSpawnPlayer()
    self:onSpawnEndCystal()

    -- table.insert(self.gameObjects, Factory.getCreeper(30, 0))
    -- table.insert(self.gameObjects, Factory.getCreeper(32, 0))
    -- table.insert(self.gameObjects, Factory.getCreeper(34, 0))
    -- table.insert(self.gameObjects, Factory.getCreeper(36, 0))
    -- table.insert(self.gameObjects, Factory.getEnderman(40, 0))
    -- table.insert(self.gameObjects, Factory.getSkeleton(50, 0))

    local randomOffset = math.random() * 100
    self.blocks = GameObjectFactory.generateTerrain(Constants.MAP_WIDTH, Constants.MAP_HEIGHT,
        Constants.MAP_GENERATE_SCALE, randomOffset, Constants.MAP_WATER_HEIGHT)
end

function GameObjectManager:onSpawnEndCystal()
    local spawnOffset = 100 * Constants.TILE_SIZE
    local x1 = math.random(spawnOffset, Constants.TILE_SIZE * Constants.MAP_WIDTH / 2 - spawnOffset)
    local finalX = x1 + (math.random() < 0.5 and Constants.TILE_SIZE * Constants.MAP_WIDTH / 2 or 0)
    local endCrystal = Factory.getEndCrystal(finalX, 0)
    -- local endCrystal = Factory.getEndCrystal(Constants.TILE_SIZE * Constants.MAP_WIDTH / 2 + 500, 0)
    self.enderDragonSpawnPosition = endCrystal.positionComp:getCollisionCenter()
    table.insert(self.gameObjects, endCrystal)
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

function GameObjectManager:onNotify(event, data)
    -- spawn ender dragon
    if event == Constants.EVENT_GAMEOBJ_DESTROYED and data.name == Constants.OBJ_NAME_END_CRYSTAL then
        table.insert(self.gameObjects,
            Factory.getEnderDragon(
                self.enderDragonSpawnPosition.x / Constants.TILE_SIZE -
                (Constants.ENDER_DRAGON_TRACKING_RANGE / Constants.TILE_SIZE / 2), 0))
    end

    -- respawn crystal and show winning message
    if event == Constants.EVENT_GAMEOBJ_DESTROYED and data.name == Constants.OBJ_NAME_ENDER_DRAGON then
        self.wonShowTime = 5
        self:onSpawnEndCystal()
    end

    -- creeper explode
    if event == Constants.EVENT_EXPLODE then
        local creeperPos = data.positionComp:getCollisionCenter()
        local explosion = Factory.getExplosionObj(creeperPos.x, creeperPos.y,
            { size = Constants.TILE_SIZE * 4, dmg = 3, exploitDmg = 5 })
        MyLocator.gameObjectManager:addGameObject(explosion)
    end
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

---@param collisionRect Rectangle
function GameObjectManager:checkNonblockingRect(collisionRect, isOnGround, ignoreObjs)
    if not ignoreObjs then
        for key, obj in pairs(self.gameObjects) do
            if obj.positionComp.isBlocked and obj.positionComp:getWorldCollisionRect():collidesWith(collisionRect) then
                return false
            end
        end
    end

    local tileRect = CommonHelper.getTileRect(collisionRect)

    --- check non blocking
    for x = tileRect.x - 1, tileRect.right + 2 do
        for y = tileRect.y - 1, tileRect.bottom + 2 do
            if self.blocks[x] and self.blocks[x][y] then
                local block = self.blocks[x][y]
                if block.positionComp.isBlocked then
                    if block.positionComp:getWorldCollisionRect():collidesWith(collisionRect) then
                        return false
                    end
                end
            end
        end
    end

    --- check is on ground
    if isOnGround then
        for x = tileRect.x, tileRect.right do
            local y = tileRect.bottom + 1
            if self.blocks[x] and self.blocks[x][y] and self.blocks[x][y].positionComp.isBlocked then
                return true
            end
        end
        return false
    end
    return true
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
        if other ~= obj and not other.isDestroyed and not other:checkIsDying() then
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
---@param obj GameObject
---@param dx any
---@param dy any
function GameObjectManager:handleMoving(obj, dx, dy)
    if obj:checkIsDying() then return 0, 0, true end
    if dx == 0 and dy == 0 and string.find(obj.name, "BLOCK") then
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
    AddDebugStr("cam tile size: " .. x1 .. "-" .. x2 .. "," .. y1 .. "-" .. y2 .. "_draw blocks: " .. count)
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

    self.wonShowTime = self.wonShowTime - (self.wonShowTime > 0 and dt or 0)
    AddDebugStr("GameObj: " .. #self.gameObjects .. " mapTileWidth: " .. #self.blocks)
    AddDebugStr("Crystal: " .. tostring(self.enderDragonSpawnPosition))
end

function GameObjectManager:checkIsPlayerDestroyed()
    return not self.player or self.player.isDestroyed
end

function GameObjectManager:drawPlayerRespawnMessage()
    if self:checkIsPlayerDestroyed() then
        DrawHelper.drawText("You Died! Hit 'space' to Respawn", Constants.WINDOW_WIDTH / 2 - 300,
            Constants.WINDOW_HEIGHT - 100, 3)
    end
end

function GameObjectManager:drawWinningMessage()
    if self.wonShowTime > 0 then
        DrawHelper.drawText("VICTORY!", Constants.WINDOW_WIDTH / 2 - 100,
            Constants.WINDOW_HEIGHT / 2 - 100, 4, { 1, 85 / 255, 0, 1 })
        DrawHelper.drawText("Thanks for playing", Constants.WINDOW_WIDTH / 2 - 100,
            Constants.WINDOW_HEIGHT / 2 - 50, 4, { 1, 85 / 255, 0, 1 })
    end
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
    self:drawPlayerRespawnMessage()
    self:drawWinningMessage()
end

return GameObjectManager
