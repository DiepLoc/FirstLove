CommonBlockInfo = BaseInfo:extend()

function CommonBlockInfo:new(isWater, isExploitable, hardness)
    self.isWater = isWater or false
    self.isExploitable = isExploitable or false
    self.hardness = hardness or 3
end

---@param subject GameObject
---@param otherObj GameObject
function CommonBlockInfo:handleCollision(subject, otherObj, dt)
    if self.isWater then
        otherObj.positionComp:onInWaterHandle(dt)
    end

    if self.isExploitable and otherObj.infoComp:checkHasInfo(DmgInfo) then
        local dmgInfo = otherObj.infoComp:getInfo(DmgInfo)
        if dmgInfo and dmgInfo.exploitDmg > 0 then
            self.hardness = self.hardness - dmgInfo.exploitDmg
            MyLocator:notify(Constants.EVENT_DAMAGED_BLOCK, subject)
            subject.animComp.color = Constants.BLOCK_DAMAGED_COLOR
            if self.hardness <= 0 then
                subject.isDestroyed = true
                MyLocator:notify(Constants.EVENT_GAMEOBJ_DESTROYED, subject)
            end
        end
    end
end

return CommonBlockInfo
