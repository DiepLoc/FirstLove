---@class EnemySpawnManager
EnemySpawnManager = BaseManager:extend()

function EnemySpawnManager:new()
    self.remainingCheckWaitTime = 0
    self.checkDelayTime = 1
    return self
end

function EnemySpawnManager:onNotify(event, data)

end

local basicMobGenerates = {
    Factory.getSkeleton,
    Factory.getZombie,
    Factory.getEnderman,
    Factory.getCreeper,
}

function EnemySpawnManager:update(dt)
    local existingObjs = MyLocator.gameObjectManager:getObjByCondition(function(subject)
        return Constants.COMMON_ENEMY_NAMES[subject.name] ~= nil
    end)

    self.remainingCheckWaitTime = self.remainingCheckWaitTime - (self.remainingCheckWaitTime > 0 and dt or 0)

    AddDebugStr("Common Mobs: " .. #existingObjs)
    if self.remainingCheckWaitTime > 0 then
        return
    end

    self.remainingCheckWaitTime = self.checkDelayTime
    local windowRect = MyLocator.camera:getBaseWindowRect()
    local rectTile = CommonHelper.getTileRect(windowRect)

    local enderDragon = MyLocator.gameObjectManager:getObjByNameOrNull(Constants.OBJ_NAME_ENDER_DRAGON)


    local camCenter = MyLocator.camera:getRect():getCenter()

    for _, obj in pairs(existingObjs) do
        if not obj.stateComp.currentState:is(DyingState) and math.abs(obj.positionComp:getCollisionCenter().x - camCenter.x) > 1200 then
            obj.stateComp:setState(DyingState(3))
        end
    end

    local isReverse = math.random() < 0.5

    local startX = isReverse and rectTile.x - 10 or rectTile.right + 10
    local endX = isReverse and rectTile.right + 10 or rectTile.x - 10
    local dx = isReverse and 3 or -3

    local startY = isReverse and rectTile.y - 10 or rectTile.bottom + 10
    local endY = isReverse and rectTile.bottom + 10 or rectTile.y - 10
    local dy = isReverse and 3 or -3
    local spawnReductionByDragonFactor = enderDragon and 4 or 1


    if #existingObjs < 5 and CommonHelper.getRandomResultByTime((#existingObjs + 1) * 0.75 * spawnReductionByDragonFactor, dt + self.checkDelayTime) then
        for x = startX, endX, dx do
            if (x < rectTile.x or x > rectTile.right) and x > 0 and x < Constants.MAP_WIDTH then
                for y = startY, endY, dy do
                    if (y < rectTile.y or y > rectTile.bottom) and y > 0 and y < Constants.MAP_HEIGHT then
                        local obj = basicMobGenerates[math.random(1, #basicMobGenerates)](x, y)
                        -- post end game mods
                        if MyLocator.gameObjectManager.winTimestamp and obj.name == Constants.OBJ_NAME_SKELETON then
                            obj = Factory.addFlyingAbility(obj)
                        end
                        local collisionRect = obj.positionComp:getWorldCollisionRect()
                        if MyLocator.gameObjectManager:checkNonblockingRect(collisionRect, true) then
                            MyLocator.gameObjectManager:addGameObject(obj)
                            return
                        end
                    end
                end
            end
        end
    end
end

function EnemySpawnManager:onSetup()

end

return EnemySpawnManager
