DyingState = BaseState:extend()

function DyingState:new()
    self.remainingTime = 1
    return self
end

---@param subject GameObject
---@param dt any
function DyingState:update(subject, dt)
    self.remainingTime = self.remainingTime - (self.remainingTime > 0 and dt or 0)

    if subject.animComp:checkHasAnim("dying") and self.remainingTime > 0 then
        subject.animComp:setCurrentAnim("dying")
    else
        subject.isDestroyed = true
    end
    return nil
end

return DyingState
