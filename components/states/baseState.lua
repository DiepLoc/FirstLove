---@class BaseState
BaseState = Object:extend()

function BaseState:new()
    self.remainingChangeRandomDirection = 0
    self.randomMovingDirection = Vector2(1, 0)
    return self
end

function BaseState:update(subject, dt)
    -- Update logic for the base state
    -- This method should be overridden in derived classes
end

function BaseState:onStop()
    -- Handle any cleanup or state transition logic here
end

---@param subject GameObject
---@param direction any
---@param dxVal any
---@param dyVal any
function BaseState:simpleTracking(subject, direction, dxVal, dyVal)
    local velocity = Vector2(0, 0)
    -- basic following
    if direction.x > 0 and dxVal > 5 then
        velocity.x = 1
    elseif direction.x < 0 and dxVal > 5 then
        velocity.x = -1
    end

    subject.positionComp.velocity = velocity

    -- random jump
    local isJump = (dxVal > 33 or dyVal > 70) and math.random() < 0.01
    if subject.positionComp.isFlying and not isJump then
        isJump = direction.y < 0 and math.random() < 0.2
    end
    if isJump then
        subject.positionComp:onJump()
    end
end

function BaseState:randomMoving(subject, dt)
    if not self.remainingChangeRandomDirection then
        self.remainingChangeRandomDirection = 0
    end
    self.remainingChangeRandomDirection = self.remainingChangeRandomDirection - dt
    if self.remainingChangeRandomDirection <= 0 then
        self.randomMovingDirection = math.random() < 0.5 and Vector2(1, 0) or Vector2(-1, 0)
        self.remainingChangeRandomDirection = math.random(2, 5)
    end
    self:simpleTracking(subject, self.randomMovingDirection, 50, 0)
end

function BaseState:updateSimpleAnim(subject)
    local positionComp = subject.positionComp
    -- anim
    if positionComp.velocity.x > 0 then
        subject.animComp:setCurrentAnim("run-right")
    elseif positionComp.velocity.x < 0 then
        subject.animComp:setCurrentAnim("run-left")
    elseif subject.positionComp.lastDirection == "right" then
        subject.animComp:setCurrentAnim("idle-right")
    else
        subject.animComp:setCurrentAnim("idle-left")
    end
end

return BaseState
