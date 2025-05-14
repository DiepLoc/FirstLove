ShortLifeState = BaseState:extend()

function ShortLifeState:new(lifeTime, shouldRunDying)
    self.remainingLifeTime = lifeTime or 0.0001
    self.shouldRunDying = shouldRunDying or false
    self.switchToDying = false
    return self
end

---@param subject GameObject
---@param dt any
function ShortLifeState:update(subject, dt)
    self.remainingLifeTime = self.remainingLifeTime - dt
    if self.switchToDying then
        return DyingState()
    end
    if self.remainingLifeTime <= 0 then
        if self.shouldRunDying then
            self.switchToDying = true
        else
            subject.isDestroyed = true
        end
    end
end

return ShortLifeState
