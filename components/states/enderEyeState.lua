EnderEyeState = BaseState:extend()

function EnderEyeState:new()
    self.dXY = nil
    self.speed = Constants.ENDER_EYE_SPEED
    self.willReach = false
    return self
end

---@param subject GameObject
---@param dt any
function EnderEyeState:update(subject, dt)
    if not self.dXY then
        local currentPos = Vector2(subject.positionComp.displayRect.x, subject.positionComp.displayRect.y)
        local enderPos = MyLocator.gameObjectManager.enderDragonSpawnPosition
        local dx = enderPos.x - currentPos.x

        local flyX = math.min(dx, Constants.ENDER_EYE_FLY_RANGE[1])
        flyX = math.max(flyX, -Constants.ENDER_EYE_FLY_RANGE[1])
        local flyY = -Constants.ENDER_EYE_FLY_RANGE[2]
        self.dXY = Vector2(flyX, flyY)
        self.willReach = Constants.ENDER_EYE_FLY_RANGE[1] > math.abs(dx)
    end

    if self.dXY.x > 0 then
        local dx = self.speed * dt
        if self.dXY.x <= dx then
            dx = self.dXY.x
            self.dXY.x = 0
        else
            self.dXY.x = self.dXY.x - dx
        end
        subject.positionComp.displayRect.x = subject.positionComp.displayRect.x + dx
    end
    if self.dXY.x < 0 then
        local dx = -self.speed * dt
        if math.abs(self.dXY.x) <= math.abs(dx) then
            dx = self.dXY.x
            self.dXY.x = 0
        else
            self.dXY.x = self.dXY.x - dx
        end
        subject.positionComp.displayRect.x = subject.positionComp.displayRect.x + dx
    end

    if self.dXY.y ~= 0 then
        local dy = -self.speed * dt
        if math.abs(self.dXY.y) <= math.abs(dy) then
            dy = self.dXY.y
            self.dXY.y = 0
        else
            self.dXY.y = self.dXY.y - dy
        end
        subject.positionComp.displayRect.y = subject.positionComp.displayRect.y + dy
    end

    if self.dXY and self.dXY:length() == 0 then
        return self:onComplete(subject)
    end


    self:updateSimpleAnim(subject, dt)
    return nil
end

---@param subject GameObject
function EnderEyeState:onComplete(subject)
    local center = subject.positionComp:getCollisionCenter()
    local isBreak = not self.willReach and math.random() < Constants.ENDER_EYE_BREAK_RATE
    if isBreak then
        MyLocator:notify(Constants.EVENT_EYE_BREAK)
        return DyingState()
    else
        local dropItem = Factory.getLootObj(center.x, center.y,
            InventoryItemFactory.getEyeOfEnderItem())
        MyLocator.gameObjectManager:addGameObject(dropItem)
        subject.isDestroyed = true
        if self.willReach then
            MyLocator:notify(Constants.EVENT_EYE_REACHED)
        end
        return NullState()
    end
end

return EnderEyeState
