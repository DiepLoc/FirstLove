---@class PositionComp
PositionComp = Object:extend()

function PositionComp:new(x, y, width, height, isBlocked, isCollidable, isVisible, speed)
    ---@type Rectangle
    self.displayRect = Rectangle(x, y, width, height)
    self.collisionRect = Rectangle(0, 0, width, height)
    self.isBlocked = isBlocked or true
    self.isCollidable = isCollidable or true
    self.isVisible = isVisible or true
    self.speed = speed or Constants.PLAYER_SPEED
    self.jump_gravity = Constants.PLAYER_GRAVITY_JUMP
    self.speedRate = 1
    self.velocity = Vector2(0, 0)
    self.gravity = 0
    self.isGrounded = false
    self.isZeroGravity = false
    self.lastDirection = "right"
    self.inertia = Vector2(0, 0)
    return self
end

function PositionComp:setZeroGravity()
    self.isZeroGravity = true
    return self
end

function PositionComp:onJump(dt)
    -- Handle jump logic here
    if self.isGrounded then
        self.gravity = self.jump_gravity
    end
end

function PositionComp:addInertia(x, y)
    self.inertia.x = self.inertia.x + x
    self.inertia.y = self.inertia.y + y
end

function PositionComp:update(obj, dt)
    -- Update logic for position component if needed
    self.gravity = self.gravity + Constants.GRAVITY * dt
    local normalize = self.velocity:normalize()
    local dx = normalize.x * self.speed * self.speedRate * dt
    local dy = normalize.y * self.speed * self.speedRate * dt
    if not self.isZeroGravity then
        dy = dy + self.gravity * self.speedRate * dt
    end
    -- inertia
    if self.inertia:length() > 0 then
        local frameInertiaX = CommonHelper.lerpValue(0, self.inertia.x, 0.1)
        local frameInertiaY = CommonHelper.lerpValue(0, self.inertia.y, 0.1)
        dx = dx + frameInertiaX
        dy = dy + frameInertiaY
        self.inertia.x = self.inertia.x - frameInertiaX
        self.inertia.y = self.inertia.y - frameInertiaY
        if math.abs(self.inertia.x) < 0.5 then self.inertia.x = 0 end
        if math.abs(self.inertia.y) < 0.5 then self.inertia.y = 0 end
    end

    self.speedRate = 1
    -- if dx == 0 and dy == 0 and self.isGrounded then
    --     return
    -- end
    local dx, dy, isGrounded = MyLocator.gameObjectManager:handleMoving(obj, dx, dy)
    self.displayRect:move(dx, dy)

    self.isGrounded = isGrounded
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

---@return Rectangle
function PositionComp:getWorldCollisionRect()
    return Rectangle(self.collisionRect.x + self.displayRect.x, self.collisionRect.y + self.displayRect.y,
        self.collisionRect.width, self.collisionRect.height)
end

---@return Vector2
function PositionComp:getCollisionCenter()
    return self:getWorldCollisionRect():getCenter()
end

function PositionComp:setCollisionRect(x, y, width, height)
    self.collisionRect = Rectangle(x, y, width, height)
    return self
end

return PositionComp
