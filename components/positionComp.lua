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
    self.speedRate = 1 -- (for slow or speedup)
    self.velocity = Vector2(0, 0)
    self.gravity = 0
    self.isGrounded = false
    self.isZeroGravity = false
    self.lastDirection = "right"
    self.swimFactor = 0
    self.inertia = Vector2(0, 0)
    self.isFlying = false
    self.flyingAnim = nil
    return self
end

function PositionComp:setSpeed(speed)
    self.speed = speed
    return self
end

function PositionComp:setZeroGravity()
    self.isZeroGravity = true
    return self
end

function PositionComp:onInWaterHandle(dt)
    self.speedRate = Constants.WATER_SPEED_RATE
    if self.swimFactor <= 0.5 then
        self.swimFactor = self.swimFactor + dt * 2
    end
end

function PositionComp:setFying()
    self.isFlying = true
    self.flyingAnim = AnimComp("flying-idle", Sprite("general", 16, 16, 1, 5, 1, 0))
        :addAnim("flying", Sprite("general", 16, 16, 4, 5, Constants.COMMON_ACTION_FPS, 0))
end

function PositionComp:onJump(dt)
    -- Handle jump logic here
    if self.swimFactor > 0.25 or self.isGrounded then
        self.gravity = self.jump_gravity
        self.swimFactor = 0
    elseif self.isFlying then
        self.gravity = self.jump_gravity / 2
    end
end

function PositionComp:addInertia(x, y)
    self.inertia.x = self.inertia.x + x
    self.inertia.y = self.inertia.y + y
end

---@param obj GameObject
---@param dt any
function PositionComp:update(obj, dt)
    if self:getWorldCollisionRect().bottom > (Constants.MAP_HEIGHT - Constants.MAP_WATER_HEIGHT + 1) * Constants.TILE_SIZE then
        self:onInWaterHandle(dt)
    end
    self.gravity = self.gravity + Constants.GRAVITY * self.speedRate * dt

    local normalize = self.velocity:normalize()
    local dx = normalize.x * self.speed * self.speedRate * dt
    local dy = normalize.y * self.speed * self.speedRate * dt
    if not self.isZeroGravity then
        dy = dy + self.gravity * self.speedRate * dt
    end

    -- inertia (knockback)
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
    local finalDx, finalDy, isGrounded = MyLocator.gameObjectManager:handleMoving(obj, dx, dy)
    self.displayRect:move(finalDx, finalDy)

    self.isGrounded = isGrounded
    if self.isGrounded or dy < 0 and finalDy == 0 then
        self.gravity = 0
    end

    -- handle falling off map
    if obj.stateComp and obj.stateComp.currentState
        and not obj.stateComp.currentState:is(DyingState)
        and self.displayRect.y > Constants.MAP_HEIGHT * 2 * Constants.TILE_SIZE then
        obj.stateComp:setState(DyingState())
    end

    -- reset

    self.speedRate = 1
    self.swimFactor = self.swimFactor - (self.swimFactor > 0 and dt or 0)
    self.lastDirection = normalize.x > 0 and "right" or (normalize.x < 0 and "left" or self.lastDirection)

    self:updateFyingAnim(obj, dt)
end

function PositionComp:updateFyingAnim(obj, dt)
    if self.isFlying then
        if self.isGrounded then
            self.flyingAnim:setCurrentAnim("flying-idle")
        else
            self.flyingAnim:setCurrentAnim("flying")
        end
        self.flyingAnim:update(obj, dt)
    end
end

function PositionComp:move(x, y)
    self.displayRect:move(x, y)
end

function PositionComp:draw()
    if self.isFlying and self.flyingAnim then
        self.flyingAnim:draw(self)
    end
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
