DmgInfo = BaseInfo:extend()

function DmgInfo:new(damage, exploitDmg, targetNames, shouldRemoveAfterCollided)
    self.damage = damage or 0
    self.exploitDmg = exploitDmg or 0
    self.targetNames = {}
    self.dmgSource = nil
    if shouldRemoveAfterCollided ~= nil then
        self.shouldRemoveAfterCollided = shouldRemoveAfterCollided
    else
        self.shouldRemoveAfterCollided = true
    end
    for _, value in pairs(targetNames or {}) do
        self.targetNames[value] = value
    end
end

function DmgInfo:getDmgDirection(subject, otherObj)
    ---@type GameObject
    local source = self.dmgSource or subject
    local sourcePos = source.positionComp:getWorldCollisionRect():getCenter()
    return otherObj.positionComp:getWorldCollisionRect():getCenter() - sourcePos
end

---@param subject GameObject
---@param otherObj GameObject
function DmgInfo:handleCollision(subject, otherObj, dt)
    if self:checkIsTarget(otherObj.name) then
        local otherCharInfo = otherObj.infoComp:getInfo(CommonCharInfo)
        if otherCharInfo then
            otherCharInfo.health = otherCharInfo.health - self.damage
            otherObj.animComp.color = Constants.DAMAGED_COLOR
            local dmgInertia = self:getDmgDirection(subject, otherObj):normalize() * Constants.DMG_INERTIA
            otherObj.positionComp:addInertia(dmgInertia.x, dmgInertia.y)
        end
        if self.shouldRemoveAfterCollided then
            subject.isDestroyed = true
        end
    end

    if otherObj.positionComp.isBlocked and otherObj.infoComp:checkHasInfo(CommonBlockInfo) and self.shouldRemoveAfterCollided then
        subject.isDestroyed = true
    end
end

function DmgInfo:checkIsTarget(name)
    return self.targetNames[name] ~= nil
end

return DmgInfo
