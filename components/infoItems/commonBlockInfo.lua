CommonBlockInfo = BaseInfo:extend()

function CommonBlockInfo:new(isWater, isExploit)
    self.isWater = isWater or false
    self.isExploitable = isExploit or false
end

---@param subject GameObject
---@param otherObj GameObject
function CommonBlockInfo:handleCollision(subject, otherObj, dt)
    if self.isWater then
        otherObj.positionComp.speedRate = Constants.WATER_SPEED_RATE
    end

    if self.isExploitable and otherObj.infoComp:checkHasInfo(DmgInfo) then
        local dmgInfo = otherObj.infoComp:getInfo(DmgInfo)
        if dmgInfo and dmgInfo.exploitDmg > 0 then
            subject.isDestroyed = true
        end
    end
end

return CommonBlockInfo
