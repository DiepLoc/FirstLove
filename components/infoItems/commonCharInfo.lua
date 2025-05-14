CommonCharInfo = BaseInfo:extend()

function CommonCharInfo:new(health)
    self:setBaseHealth(health or 5)
    self.hunger = 5
    self.maxHunger = self.hunger
    self.isHungryable = false
    self.remainingHungerDmgTime = 0
    self.remainingInvincibleTime = 0
    return self
end

function CommonCharInfo:setBaseHealth(val)
    self.health = val
    self.maxHealth = val
    return self
end

function CommonCharInfo:isHungry()
    return self.isHungryable and self.hunger <= 0
end

function CommonCharInfo:isInvincible()
    return self.remainingInvincibleTime > 0
end

function CommonCharInfo:setHungryable()
    self.isHungryable = true
    return self
end

function CommonCharInfo:isHealing()
    return self.hunger >= 3
end

---@param subject GameObject
---@param dt any
function CommonCharInfo:update(subject, dt)
    -- Update logic for the base info
    -- This method should be overridden in derived classes
    if self.health <= 0 and not subject.stateComp.currentState:is(DyingState) then
        subject.stateComp:setState(DyingState())
        MyLocator:notify(Constants.EVENT_GAMEOBJ_DESTROYED, subject)
    end

    if self.remainingInvincibleTime > 0 then
        self.remainingInvincibleTime = self.remainingInvincibleTime - dt
    end

    if not self.isHungryable then return end

    if self.hunger > 0 then
        self.hunger = self.hunger - dt * Constants.HUNGER_SPEED
    end

    if self:isHungry() then
        self.remainingHungerDmgTime = self.remainingHungerDmgTime - dt
        if self.remainingHungerDmgTime <= 0 then
            if self.health > 1 then self:onDamaged(subject, 0.5) end
            self.remainingHungerDmgTime = Constants.HUNGER_DMG_DELAY_TIME
        end
    end

    if self:isHealing() then
        self.health = math.min(self.health + Constants.HEAL_WHEN_FULL * dt, self.maxHealth)
    end
end

function CommonCharInfo:onHeal(healVal)
    self.health = math.min(self.health + healVal, self.maxHealth)
end

function CommonCharInfo:onEat(foodVal)
    self.hunger = math.min(self.hunger + foodVal, self.maxHunger)
end

function CommonCharInfo:onDamaged(subject, dmgVal)
    self.health = self.health - dmgVal
    subject.animComp.color = Constants.OBJ_DAMAGED_COLOR
    self.remainingInvincibleTime = Constants.INVINCIBLE_TIME
    MyLocator:notify(Constants.EVENT_DAMAGED_OBJECT, subject)
end

---@param subject GameObject
---@param otherObj GameObject
function CommonCharInfo:handleCollision(subject, otherObj, dt)

end

return CommonCharInfo
