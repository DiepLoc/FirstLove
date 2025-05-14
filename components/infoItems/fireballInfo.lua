FireballInfo = BaseInfo:extend()

function FireballInfo:new()
    self.isExploded = false
    return self
end

function FireballInfo:update(subject, dt)
    -- Update logic for the base info
    -- This method should be overridden in derived classes
end

---@param subject GameObject
---@param otherObj GameObject
---@param dt any
function FireballInfo:handleCollision(subject, otherObj, dt)
    if otherObj.positionComp.isBlocked and not self.isExploded then
        self.isExploded = true
        MyLocator:notify(Constants.EVENT_EXPLODE, subject)
        subject.isDestroyed = true
    end
end

function FireballInfo:draw()
    -- Draw logic for the base info
    -- This method should be overridden in derived classes
end

return FireballInfo
