CommonCharInfo = BaseInfo:extend()

function CommonCharInfo:new(health)
    self.health = health or 5
    return self
end

function CommonCharInfo:update(subject, dt)
    -- Update logic for the base info
    -- This method should be overridden in derived classes
    if self.health <= 0 then
        subject.isDestroyed = true
    end
end

---@param subject GameObject
---@param otherObj GameObject
function CommonCharInfo:handleCollision(subject, otherObj, dt)
    -- local dmgInfo = otherObj.infoComp:getInfo(DmgInfo)
    -- if dmgInfo and dmgInfo.damage > 0 then
    --     self.health = self.health - dmgInfo.damage
    -- end
end

return CommonCharInfo
