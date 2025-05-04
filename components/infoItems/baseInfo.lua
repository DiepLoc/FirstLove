---@class BaseInfo
BaseInfo = Object:extend()

function BaseInfo:update(subject, dt)
    -- Update logic for the base info
    -- This method should be overridden in derived classes
end

function BaseInfo:handleCollision(subject, otherObj, dt)
    -- Handle collision logic for the base info
    -- This method should be overridden in derived classes
end

function BaseInfo:draw()
    -- Draw logic for the base info
    -- This method should be overridden in derived classes
end

return BaseInfo
