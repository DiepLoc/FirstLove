SimpleAiState = BaseState:extend()


function SimpleAiState:new(getAttackStateCb, attackRange)
    self.getAttackStateCb = getAttackStateCb or nil
    self.attackRange = attackRange or 33
end

---@param subject GameObject
function SimpleAiState:update(subject, dt)
    local player = MyLocator.gameObjectManager.player
    if not player then return nil end

    local playerCenter = player.positionComp.displayRect:getCenter()
    local subjectCenter = subject.positionComp.displayRect:getCenter()

    local velocity = Vector2(0, 0)
    local distance, dx, dy = CommonHelper.getDistance(playerCenter.x, playerCenter.y, subjectCenter.x,
        subjectCenter.y)
    if distance < Constants.MOD_TRACKING_DISTANCE then
        local direction = CommonHelper.get2dDirectionFromDirection(playerCenter.x, playerCenter.y, subjectCenter.x,
            subjectCenter.y)
        if direction.x > 0 and dx > 5 then
            velocity.x = 1
        elseif direction.x < 0 and dx > 5 then
            velocity.x = -1
        end

        local isJump = (dx > 33 or dy > 70) and math.random() < 0.01
        if isJump then
            subject.positionComp:onJump()
        end

        if dx < self.attackRange and self.getAttackStateCb and CommonHelper.getRandomResultByTime(Constants.RAMDOM_MOB_ATTACK_TIME, dt) then
            return self.getAttackStateCb(self, playerCenter)
        end
    end
    subject.positionComp.velocity = velocity
    self:updateSimpleAnim(subject)

    return nil
end

return SimpleAiState
