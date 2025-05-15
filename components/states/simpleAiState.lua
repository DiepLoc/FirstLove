SimpleAiState = BaseState:extend()


function SimpleAiState:new(getAttackStateCb, attackRange, getTrackingStateCb)
    self.getAttackStateCb = getAttackStateCb or nil
    self.attackRange = attackRange or 100
    self.getTrackingStateCb = getTrackingStateCb or nil
    self.trackingState = nil
    self.remainingAttackDelayTime = 0
    return self
end

---@param subject GameObject
function SimpleAiState:update(subject, dt)
    self.remainingAttackDelayTime = self.remainingAttackDelayTime - (self.remainingAttackDelayTime > 0 and dt or 0)

    subject.positionComp.velocity = Vector2(0, 0)
    local player = MyLocator.gameObjectManager.player
    if not player then return nil end

    local playerCenter = player.positionComp.displayRect:getCenter()
    local subjectCenter = subject.positionComp.displayRect:getCenter()

    local distance, dxVal, dyVal, dx, dy = CommonHelper.getDistance(playerCenter.x, playerCenter.y, subjectCenter.x,
        subjectCenter.y)
    if distance < Constants.MOD_TRACKING_DISTANCE then
        -- local moveXDirection = CommonHelper.get2dDirectionFromDirection(playerCenter.x, playerCenter.y, subjectCenter.x,
        --     subjectCenter.y)
        -- random attack
        if dxVal < self.attackRange and CommonHelper.getRandomResultByTime(Constants.RAMDOM_MOB_ATTACK_TIME, dt) then
            if self.getAttackStateCb and self.remainingAttackDelayTime <= 0 then
                self.remainingAttackDelayTime = Constants.COMMON_ENEMY_ATTACK_DELAY
                return self.getAttackStateCb(self, playerCenter)
            else
                subject.positionComp:onJump()
            end
        end

        -- tracking
        if self.getTrackingStateCb then
            if self.trackingState == nil then
                self.trackingState = self.getTrackingStateCb(self, playerCenter)
            end
            self.trackingState:update(subject, dt)
        else
            self:simpleTracking(subject, playerCenter - subjectCenter, dxVal, dyVal)
        end
    else
        self:randomMoving(subject, dt)
    end

    self:updateSimpleAnim(subject)

    return nil
end

return SimpleAiState
