ConsumableItem = BaseInvItem:extend()

-- consumeCb: (subject) =>
function ConsumableItem:new(name, healVal, foodVal, consumeCb)
    ConsumableItem.super.new(self, name)
    self.healVal = healVal or 0
    self.foodVal = foodVal or 0
    self.consumeCb = consumeCb or nil
    return self
end

function ConsumableItem:getLeftActionAnim()
    return "attack"
end

function ConsumableItem:onStartAction(subject)
    if self.healVal ~= 0 or self.foodVal ~= 0 then
        MyLocator:notify(Constants.EVENT_EATING)
    end
end

---@param subject GameObject
---@param data any
function ConsumableItem:onLeftAction(subject, data)
    local charInfo = subject.infoComp:getInfo(CommonCharInfo)
    if charInfo and (self.healVal ~= 0 or self.foodVal ~= 0) then
        charInfo:onHeal(self.healVal)
        charInfo:onEat(self.foodVal)
        self:onConsume()
    elseif self.consumeCb then
        self.consumeCb(subject)
        self:onConsume()
    end
end

return ConsumableItem
