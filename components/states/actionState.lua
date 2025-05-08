ActionState = BaseState:extend()

function ActionState:new(parentState, targetPosition)
    self.remainingTime = 1 / Constants.COMMON_ACTION_FPS * 3
    self.isActionPerformed = false
    self.faceDirection = nil
    self.targetPosition = targetPosition or nil
    self.parentState = parentState or NullState()
    self.animName = nil
    return self
end

---@param subject GameObject
function ActionState:update(subject, dt)
    self.remainingTime = self.remainingTime - dt
    if self.remainingTime <= 0 then
        return self.parentState
    end

    if self.faceDirection == nil then
        local targetPos = self:getTargetPosition()
        local worldPlayerCenter = subject.positionComp.displayRect:getCenter()
        local faceVector = CommonHelper.get2dDirectionFromDirection(targetPos.x, targetPos.y, worldPlayerCenter.x,
            worldPlayerCenter.y)
        self.faceDirection = faceVector.x > 0 and "right" or "left"
    end

    self:checkAction(subject)

    if self.animName == nil then
        local currentItem = subject.inventoryComp:getCurrentItemOrNull()
        self.animName = currentItem:checkHasLeftAction()
    end


    subject.animComp:setCurrentAnim(self.animName .. "-" .. self.faceDirection)
    return nil
end

function ActionState:getTargetPosition()
    local targetPos = self.targetPosition or nil
    if not targetPos then
        local _, _, _, worldRect = MyLocator:checkMousePress(1)
        targetPos = Vector2(worldRect.x, worldRect.y)
    end
    return targetPos
end

---@param subject GameObject
function ActionState:checkAction(subject)
    if self.isActionPerformed then
        return
    end

    local targetPos = self:getTargetPosition()
    if self.remainingTime < 0.1 then
        self.isActionPerformed = true

        local currentItem = subject.inventoryComp:getCurrentItemOrNull()
        if currentItem then
            currentItem:onLeftAction(subject, { targetPos = targetPos })
        end
    end
end

return ActionState
