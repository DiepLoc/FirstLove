BlockItem = BaseInvItem:extend()

function BlockItem:new(name, generateBlockCb)
    BlockItem.super.new(self, name)
    self.generateBlockCb = generateBlockCb
end

function BlockItem:getLeftActionAnim()
    return "attack"
end

function BlockItem:onStartAction(subject)

end

function BlockItem:onLeftAction(subject, data)
    local subjectTile = CommonHelper.getTilePos(subject.positionComp:getCollisionCenter())
    local targetPos = data.targetPos
    local tilePos = CommonHelper.getTilePos(targetPos)

    if (subjectTile - tilePos):length() > 4 then
        return
    end
    local block = self.generateBlockCb(tilePos.x, tilePos.y)

    if MyLocator.gameObjectManager:addBlock(block, tilePos.x, tilePos.y) then
        MyLocator:notify(Constants.EVENT_PLACE_BLOCK, subject)
        self:onConsume()
    end
end

return BlockItem
