PlayerState = BaseState:extend()

function PlayerState:new()
    self.subState = NullState()
    self.remainingNextActionTime = 0
    return self
end

function PlayerState:update(subject, dt)
    local positionComp = subject.positionComp
    local newVelo = Vector2(0, 0)
    -- if love.keyboard.isDown("s") then
    --     newVelo.y = newVelo.y + 1
    -- end
    -- if love.keyboard.isDown("w") then
    --     newVelo.y = newVelo.y - 1
    -- end
    if love.keyboard.isDown("a") then
        newVelo.x = newVelo.x - 1
    end
    if love.keyboard.isDown("d") then
        newVelo.x = newVelo.x + 1
    end

    if positionComp.isGrounded and MyLocator:checkKeyPress("space", false) then
        positionComp:onJump(dt)
    end
    positionComp.velocity = newVelo

    self:checkAction(subject, dt)

    local newSubState = self.subState:update(subject, dt)
    if newSubState ~= nil then
        self.subState = newSubState
    end

    -- anim
    if self.subState:is(NullState) then
        self:updateSimpleAnim(subject)
    end

    return nil
end

---@param subject GameObject
function PlayerState:checkAction(subject, dt)
    if self.remainingNextActionTime > 0 then
        self.remainingNextActionTime = self.remainingNextActionTime - dt
    end
    local currentItem = subject.inventoryComp:getCurrentItemOrNull()
    if self.remainingNextActionTime > 0 or not self.subState:is(NullState) or not currentItem or not currentItem:is(WeaponItem) then
        return
    end

    local isMousePressed, mouseX, mouseY, worldRect = MyLocator:checkMousePress(1)
    if isMousePressed then
        self.subState = ActionState()
        self.remainingNextActionTime = Constants.PLAYER_ACTION_DELAY
    end
end

function PlayerState:onStop()
    -- Handle any cleanup or state transition logic here
end

return PlayerState
