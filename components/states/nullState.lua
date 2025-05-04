NullState = BaseState:extend()

function NullState:new()
    return self
end

function NullState:update(subject, dt)
    return nil
end

function NullState:onStop()
    -- Handle any cleanup or state transition logic here
end

return NullState
