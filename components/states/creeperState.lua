CreeperState = BaseState:extend()

function CreeperState:new()
    self.waitTime = 0
    self.remainingExlodeTime = nil
    return self
end

---@param subject GameObject
---@param dt any
function CreeperState:update(subject, dt)
    subject.positionComp.velocity = Vector2(0, 0)

    if self.remainingExlodeTime ~= nil then
        self.remainingExlodeTime = self.remainingExlodeTime - dt
        if self.remainingExlodeTime <= 0 then
            subject.infoComp:getInfo(CommonCharInfo):onDamaged(subject, 100)
            MyLocator:notify(Constants.EVENT_EXPLODE, subject)
        end
        return nil
    end

    local player = MyLocator.gameObjectManager.player
    if not player then return nil end

    local playerCenter = player.positionComp.displayRect:getCenter()
    local subjectCenter = subject.positionComp.displayRect:getCenter()

    local distance, dxVal, dyVal = CommonHelper.getDistance(playerCenter.x, playerCenter.y, subjectCenter.x,
        subjectCenter.y)
    if distance < Constants.MOD_TRACKING_DISTANCE then
        local direction = CommonHelper.get2dDirectionFromDirection(playerCenter.x, playerCenter.y, subjectCenter.x,
            subjectCenter.y)
        -- random attack
        if dxVal < 64 and dyVal < 100 then
            -- start explo
            self:updateSimpleAnim(subject)
            self.waitTime = self.waitTime + dt
            if self.waitTime > Constants.TIME_TO_CREEPER_EXPLODE then
                self.remainingExlodeTime = 0.5
                return nil
            end
            subject.animComp:setCurrentAnim("attack-right")
            return nil
        else
            self.waitTime = 0
        end
        -- tracking
        self:simpleTracking(subject, direction, dxVal, dyVal)
    else
        self:randomMoving(subject, dt)
    end

    self:updateSimpleAnim(subject)

    return nil
end

return CreeperState
