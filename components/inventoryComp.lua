---@class InventoryComp
InventoryComp = Object:extend()

function InventoryComp:new()
    self.items = {}
    self.maxSlots = 3
    self.currentItemIndex = 0
    return self
end

function InventoryComp:addItem(item, equidItem)
    if #self.items >= self.maxSlots then
        print("Inventory is full! Cannot add more items.")
        return
    end
    table.insert(self.items, item)
    if equidItem then
        self.currentItemIndex = #self.items
    end
end

function InventoryComp:getCurrentItemOrNull()
    if self.currentItemIndex > 0 then
        return self.items[self.currentItemIndex]
    end
    return nil
end

---@param subject GameObject
function InventoryComp:update(subject, dt)
    -- Update inventory logic here
end

---@param subject GameObject
function InventoryComp:draw(subject)
    -- Draw inventory UI here
end

return InventoryComp
