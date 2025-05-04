---@class StateComp
StateComp = Object:extend()

function StateComp:new(baseState)
    self.currentState = baseState
    return self
end

function StateComp:update(subject, dt)
    if self.currentState then
        local newState = self.currentState:update(subject, dt)
        if newState then
            self.currentState:onStop()
            self.currentState = newState
        end
    end
end

function StateComp:draw()
end

return StateComp
