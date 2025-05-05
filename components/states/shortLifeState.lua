ShortLifeState = BaseState:extend()

function ShortLifeState:new()
    self.remainingLifeTime = 0.01
end

function ShortLifeState:update(subject, dt)
    self.remainingLifeTime = self.remainingLifeTime - dt
    if self.remainingLifeTime <= 0 then
        subject.isDestroyed = true
    end
end

return ShortLifeState
