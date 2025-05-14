FlyState = BaseState:extend()

function FlyState:new(directionVector, speed)
    local nomalizedVector = directionVector:normalize()
    self.vx = nomalizedVector.x * speed
    self.vy = nomalizedVector.y * speed
    self.speed = speed
    self.remainingLifeTime = 5
    return self
end

function FlyState:update(subject, dt)
    -- gravity
    -- subject.positionComp.gravity = subject.positionComp.gravity + self.vy
    -- self.vy = 0
    self.remainingLifeTime = self.remainingLifeTime - (self.remainingLifeTime > 0 and dt or 0)
    if self.remainingLifeTime <= 0 then
        subject.isDestroyed = true
    end

    subject.positionComp.velocity = Vector2(self.vx, self.vy)
    -- subject.positionComp.speed = self.vx
    subject.positionComp.speed = self.speed

    if (subject.positionComp.isGrounded) then
        self.vx = 0
    end

    return nil
end

function FlyState:onStop()
    -- Handle any cleanup or state transition logic here
end

return FlyState
