ConsumableItem = BaseInvItem:extend()

function ConsumableItem:new(name, healVal, foodVal)
    ConsumableItem.super.new(self, name)
    self.healVal = healVal or 0
    self.foodVal = foodVal or 0
    return self
end

function ConsumableItem:checkHasLeftAction()
    return "attack"
end

---@param subject GameObject
---@param data any
function ConsumableItem:onLeftAction(subject, data)
    local charInfo = subject.infoComp:getInfo(CommonCharInfo)
    if charInfo then
        charInfo:onHeal(self.healVal)
        charInfo:onEat(self.foodVal)
        self:onConsume()
    end
end

return ConsumableItem
