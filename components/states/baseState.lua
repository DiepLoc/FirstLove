---@class BaseState
BaseState = Object:extend()

function BaseState:update(subject, dt)
    -- Update logic for the base state
    -- This method should be overridden in derived classes
end

function BaseState:onStop()
    -- Handle any cleanup or state transition logic here
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
