LootInfo = BaseInfo:extend()

function LootInfo:new(item)
    self.item = item
    return self
end

---@param subject GameObject
---@param otherObj GameObject
---@param dt any
function LootInfo:handleCollision(subject, otherObj, dt)
    if otherObj.name == Constants.OBJ_NAME_PLAYER and not subject.isDestroyed then
        if otherObj.inventoryComp:addItem(self.item) then
            MyLocator:notify(Constants.EVENT_PICKUP_ITEM)
            subject.isDestroyed = true
        end
    end
end

return LootInfo
