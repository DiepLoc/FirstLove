---@class StaticPositionComp -- used for block to ignore update position logic
StaticPositionComp = PositionComp:extend()

---@param obj GameObject
---@param dt any
function StaticPositionComp:update(obj, dt)
end

return StaticPositionComp
