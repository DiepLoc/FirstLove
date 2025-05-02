PositionComp = Object:extend()

function PositionComp:new(x, y, width, height, isBlocked, isCollidable, isVisible)
    self.displayRect = Rectangle(x, y, width, height)
    self.collisionRect = Rectangle(0, 0, width, height)
    self.isBlocked = isBlocked or true
    self.isCollidable = isCollidable or true
    self.isVisible = isVisible or true
    self.speed = Constants.PLAYER_SPEED
    self.velocity = Vector2(0, 0)
    self.gravity = 0
    self.isGrounded = false
    self.isZeroGravity = false
    self.lastDirection = "right"
    return self
end

function PositionComp:setZeroGravity()
    self.isZeroGravity = true
    return self
end

function PositionComp:onJump(dt)
    -- Handle jump logic here
    if self.isGrounded then
        self.gravity = Constants.GRAVITY_JUMP
    end
end

function PositionComp:update(dt)
    -- Update logic for position component if needed
    local normalize = self.velocity:normalize()
    local dx = normalize.x * self.speed * dt
    local dy = normalize.y * self.speed * dt
    if not self.isZeroGravity then
        dy = dy + self.gravity * dt
    end

    self.displayRect:move(dx, dy)
    self.gravity = self.gravity + Constants.GRAVITY
    self.isGrounded = not self.isZeroGravity and self.displayRect.bottom >= Constants.GROUND_Y
    if self.isGrounded then
        self.gravity = 0
        self.displayRect.y = Constants.GROUND_Y - self.displayRect.height
    end

    self.lastDirection = normalize.x > 0 and "right" or (normalize.x < 0 and "left" or self.lastDirection)
end

function PositionComp:move(x, y)
    self.displayRect:move(x, y)
end

function PositionComp:draw()
end

function PositionComp:getWorldCollisionRect()
    return Rectangle(self.collisionRect.x + self.displayRect.x, self.collisionRect.y + self.displayRect.y,
        self.collisionRect.width, self.collisionRect.height)
end

function PositionComp:setCollisionRect(x, y, width, height)
    self.collisionRect = Rectangle(x, y, width, height)
    return self
end

return PositionComp
