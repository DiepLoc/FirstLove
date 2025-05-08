---@class InventoryComp
InventoryComp = Object:extend()

function InventoryComp:new()
    self.items = {}
    self.maxSlots = 10
    self.currentItemIndex = 0
    return self
end

function InventoryComp:addItem(item, equidItem)
    local existingItem, ind = self:findItem(item.name)
    if existingItem and existingItem.isStackable then
        existingItem.stack = existingItem.stack + item.stack
        if equidItem then
            self.currentItemIndex = ind
        end
        return true
    else
        return self:addNewItem(item, equidItem)
    end
end

function InventoryComp:onChangeCurrentItem(indChange)
    self.currentItemIndex = self.currentItemIndex + indChange
    if self.currentItemIndex > self.maxSlots then
        self.currentItemIndex = self.currentItemIndex - self.maxSlots
    end
    if self.currentItemIndex <= 0 then
        self.currentItemIndex = self.currentItemIndex + self.maxSlots
    end
end

function InventoryComp:addNewItem(item, equidItem)
    if #self.items >= self.maxSlots then
        print("Inventory is full! Cannot add more items.")
        -- MyLocator:notify(Constants.EVENT_DROP_ITEM, {item = item, x = })
        return false
    end
    table.insert(self.items, item)
    if equidItem then
        self.currentItemIndex = #self.items
    end
    return true
end

function InventoryComp:getCurrentItemOrNull()
    if self.currentItemIndex > 0 then
        return self.items[self.currentItemIndex]
    end
    return nil
end

---@return BaseInvItem
function InventoryComp:findItem(itemName)
    for ind, item in pairs(self.items) do
        if item.name == itemName then
            return item, ind
        end
    end
    return nil, nil
end

---@param subject GameObject
function InventoryComp:update(subject, dt)
    for key, item in pairs(self.items) do
        if item.stack <= 0 then
            self.items[key] = nil
        end
    end
end

---@param subject GameObject
function InventoryComp:draw(subject)
    -- Draw inventory UI here
end

return InventoryComp
