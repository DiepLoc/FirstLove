---@class BaseState
BaseState = Object:extend()

function BaseState:update(subject, dt)
    -- Update logic for the base state
    -- This method should be overridden in derived classes
end

function BaseState:onStop()
    -- Handle any cleanup or state transition logic here
end

return BaseState
