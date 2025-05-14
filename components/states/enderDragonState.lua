EnderDragonState = BaseState:extend()

function EnderDragonState:new()
    self.pos1 = nil
    self.targetPos = nil
    self.requiredRefresh = true
    self.remainingShootBulletWaitTime = 1
    self.remainingShootFireballWaitTime = 5
    return self
end

---@param subject GameObject
---@param dt any
function EnderDragonState:update(subject, dt)
    subject.positionComp.velocity = Vector2(0, 0)
    local player = MyLocator.gameObjectManager.player

    local playerCenter = player and player.positionComp.displayRect:getCenter()
    local subjectCenter = subject.positionComp.displayRect:getCenter()

    -- local distance, dxVal, dyVal = CommonHelper.getDistance(playerCenter.x, playerCenter.y, subjectCenter.x,
    --     subjectCenter.y)

    if self.requiredRefresh then
        if playerCenter then
            self.targetPos = Vector2(playerCenter.x + (math.random() < 0.5 and 800 or -800),
                playerCenter.y + math.random(-400, 200))
        else
            self.targetPos = subjectCenter
        end

        self.requiredRefresh = false
    end

    local isReached = self:flying(subject, self.targetPos)
    if isReached then
        self.requiredRefresh = true
    end

    -- shoot
    if playerCenter then
        local direction = playerCenter - subjectCenter
        if math.abs(direction.x) < 400
            and math.abs(direction.x) > 100
            and direction.y > 100
            and self.remainingShootFireballWaitTime <= 0
            and CommonHelper.getRandomResultByTime(1, dt)
        then
            self:shootFireBall(subject, direction)
            self.remainingShootFireballWaitTime = 5
            self.remainingShootBulletWaitTime = 1
        elseif math.abs(direction.x) < 400
            and direction.y > 50
            and self.remainingShootBulletWaitTime <= 0
        then
            self:shootBullet(subject, direction)
            self.remainingShootBulletWaitTime = 1
        end
    end

    self.remainingShootFireballWaitTime = self.remainingShootFireballWaitTime -
        (self.remainingShootFireballWaitTime > 0 and dt or 0)
    self.remainingShootBulletWaitTime = self.remainingShootBulletWaitTime -
        (self.remainingShootBulletWaitTime > 0 and dt or 0)
    subject.positionComp.velocity = self.targetPos - subjectCenter
    self:updateSimpleAnim(subject)
end

---@param subject GameObject
---@param targetPos any
function EnderDragonState:flying(subject, targetPos)
    local targetTile = CommonHelper.getTilePos(targetPos)

    local subjectCenter = subject.positionComp:getCollisionCenter()
    local currentTile = CommonHelper.getTilePos(subjectCenter)
    local isReached = (currentTile - targetTile):length() < 2

    return isReached
end

---@param subject GameObject
---@param direction any
function EnderDragonState:shootBullet(subject, direction)
    local center = subject.positionComp:getCollisionCenter()
    local bullet = Factory.getArrow(center.x, center.y, direction, 400, DmgInfo(1, 0, { Constants.OBJ_NAME_PLAYER }))
    MyLocator.gameObjectManager:addGameObject(bullet)
end

function EnderDragonState:shootFireBall(subject, direction)
    local center = subject.positionComp:getCollisionCenter()
    local fireball = Factory.getFireball(center.x, center.y, direction, 500)
    MyLocator:notify(Constants.EVENT_SHOOT_FIREBALL)
    MyLocator.gameObjectManager:addGameObject(fireball)
end

return EnderDragonState
