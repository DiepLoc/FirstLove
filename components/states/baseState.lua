---@class BaseState
BaseState = Object:extend()

function BaseState:update(subject, dt)
    -- Update logic for the base state
    -- This method should be overridden in derived classes
end

function BaseState:onStop()
    -- Handle any cleanup or state transition logic here
end

function BaseState:simpleTracking(subject, direction, dxVal, dyVal)
    local velocity = Vector2(0, 0)
    -- basic following
    if direction.x > 0 and dxVal > 5 then
        velocity.x = 1
    elseif direction.x < 0 and dxVal > 5 then
        velocity.x = -1
    end

    if direction.y > 0 and dyVal > 5 then
        velocity.y = 1
    elseif direction.y < 0 and dyVal > 5 then
        velocity.y = -1
    end
    subject.positionComp.velocity = velocity

    -- random jump
    local isJump = (dxVal > 33 or dyVal > 70) and math.random() < 0.01
    if isJump then
        subject.positionComp:onJump()
    end
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
