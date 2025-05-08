CommonCharInfo = BaseInfo:extend()

function CommonCharInfo:new(health)
    self.health = health or 5
    self.maxHealth = self.health
    self.hunger = 10
    self.maxHunger = self.hunger
    self.isHungryable = false
    self.remainingHungerDmgTime = 0
    return self
end

function CommonCharInfo:setHungryable()
    self.isHungryable = true
    return self
end

function CommonCharInfo:update(subject, dt)
    -- Update logic for the base info
    -- This method should be overridden in derived classes
    if self.health <= 0 then
        subject.isDestroyed = true
    end

    if not self.isHungryable then return end

    if self.hunger > 0 then
        self.hunger = self.hunger - dt * Constants.HUNGER_SPEED
    end

    if self.hunger <= 0 then
        self.remainingHungerDmgTime = self.remainingHungerDmgTime - dt
        if self.remainingHungerDmgTime <= 0 then
            self:onDamaged(subject, 1)
            self.remainingHungerDmgTime = Constants.HUNGER_DMG_DELAY_TIME
        end
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
end

---@param subject GameObject
---@param otherObj GameObject
function CommonCharInfo:handleCollision(subject, otherObj, dt)

end

return CommonCharInfo
