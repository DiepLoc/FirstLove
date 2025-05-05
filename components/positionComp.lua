---@class PositionComp
PositionComp = Object:extend()

function PositionComp:new(x, y, width, height, isBlocked, isCollidable, isVisible)
    ---@type Rectangle
    self.displayRect = Rectangle(x, y, width, height)
    self.collisionRect = Rectangle(0, 0, width, height)
    self.isBlocked = isBlocked or true
    self.isCollidable = isCollidable or true
    self.isVisible = isVisible or true
    self.speed = Constants.PLAYER_SPEED
    self.speedRate = 1
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

function PositionComp:update(obj, dt)
    -- Update logic for position component if needed
    if self.isZeroGravity then
        return
    end
    self.gravity = self.gravity + Constants.GRAVITY * dt
    local normalize = self.velocity:normalize()
    local dx = normalize.x * self.speed * self.speedRate * dt
    local dy = normalize.y * self.speed * self.speedRate * dt
    if not self.isZeroGravity then
        dy = dy + self.gravity * self.speedRate * dt
    end
    self.speedRate = 1
    -- if dx == 0 and dy == 0 and self.isGrounded then
    --     return
    -- end
    local moveData = MyLocator.gameObjectManager:handleMoving(obj, dx, dy)
    self.displayRect:move(moveData[1], moveData[2])

    -- self.isGrounded = MyLocator.gameObjectManager:updateIsGrounded(obj)

    self.isGrounded = moveData[3]
    if self.isGrounded then
        self.gravity = 0
    end
    -- self.isGrounded = not self.isZeroGravity and self.displayRect.bottom >= Constants.GROUND_Y
    -- if self.isGrounded then
    --     self.gravity = 0
    --     self.displayRect.y = Constants.GROUND_Y - self.displayRect.height
    -- end

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
