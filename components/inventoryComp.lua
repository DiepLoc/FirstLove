---@class InventoryComp
InventoryComp = Object:extend()

function InventoryComp:new()
    return self
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
