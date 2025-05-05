---@class InfoComp
InfoComp = Object:extend()

function InfoComp:new()
    self.info = {}
    return self
end

function InfoComp:addInfo(value)
    if value then
        if (self:checkHasInfo(value)) then
            error("InfoComp: Info already exists")
        end
        table.insert(self.info, value)
    end
end

function InfoComp:checkHasInfo(infoType)
    local hasInfo = false
    for _, info in pairs(self.info) do
        if info:is(infoType) then
            hasInfo = true
            break
        end
    end
    return hasInfo
end

function InfoComp:getInfo(infoType)
    for _, info in pairs(self.info) do
        if info:is(infoType) then
            return info
        end
    end
    return nil
end

function InfoComp:update(subject, dt)
    for _, info in pairs(self.info) do
        info:update(subject, dt)
    end
end

function InfoComp:handleCollision(subject, otherObj, dt)
    for _, info in pairs(self.info) do
        info:handleCollision(subject, otherObj, dt)
    end
end

function InfoComp:draw()
    for _, info in pairs(self.info) do
        info:draw()
    end
end

return InfoComp
