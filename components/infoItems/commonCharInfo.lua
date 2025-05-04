CommonCharInfo = BaseInfo:extend()

---@param subject GameObject
---@param otherObj GameObject
function CommonCharInfo:handleCollision(subject, otherObj, dt)
    if otherObj.infoComp:checkHasInfo(WaterInfo) then
        subject.positionComp.speedRate = Constants.WATER_SPEED_RATE
    end
end

return CommonCharInfo
