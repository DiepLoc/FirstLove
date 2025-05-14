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

function InventoryComp:onChangeCurrentValidItem(indChange)
    self:onChangeCurrentItem(indChange)

    local tryCount = 0
    while self:getCurrentItemOrNull() == nil do
        self:onChangeCurrentItem(indChange)
        tryCount = tryCount + 1
        if tryCount > 10 then
            error("Some error")
        end
    end
end

function InventoryComp:addNewItem(item, equidItem)
    for i = 1, self.maxSlots do
        if self.items[i] == nil then
            self.items[i] = item
            if equidItem then
                self.currentItemIndex = i
            end
            return true
        end
    end
    print("Inventory is full! Cannot add more items.")
    return false
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
