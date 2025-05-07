ActionState = BaseState:extend()

function ActionState:new(parentState, targetPosition)
    self.remainingTime = 1 / Constants.COMMON_ACTION_FPS * 3
    self.isActionPerformed = false
    self.faceDirection = nil
    self.targetPosition = targetPosition or nil
    self.parentState = parentState or NullState()
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


    subject.animComp:setCurrentAnim("attack-" .. self.faceDirection)
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

        local dmgInfo = nil
        local currentItem = subject.inventoryComp:getCurrentItemOrNull()
        if currentItem and currentItem:is(WeaponItem) then
            local targetDmgNames = subject.name == Constants.OBJ_NAME_PLAYER and
                { Constants.OBJ_NAME_ZOMBIE, Constants.OBJ_NAME_SKELETON } or { Constants.OBJ_NAME_PLAYER }
            dmgInfo = DmgInfo(currentItem.dmg, currentItem.exploitDmg, targetDmgNames)
        else
            return
        end

        local subjectCenter = subject.positionComp.displayRect:getCenter()
        local directionFunc = currentItem and currentItem:getTranformDirectionCb() or
            CommonHelper.get2dDirectionFromDirection
        local actionDirection = directionFunc(targetPos.x, targetPos.y, subjectCenter.x,
            subjectCenter.y)
        -- local worldPlayerTile = worldPlayerCenter.toWorldTile()
        local performActionPos = subjectCenter +
            Vector2(actionDirection.x * Constants.ACTION_DISTANCE, actionDirection.y * Constants.ACTION_DISTANCE)


        if currentItem and currentItem.weaponType == Constants.WEAPON_TYPE_RANGE then
            local arrowObj = GameObjectFactory.getArrow(subjectCenter.x, subjectCenter.y, actionDirection, nil,
                dmgInfo)
            MyLocator.gameObjectManager:addGameObject(arrowObj)
        else
            dmgInfo.dmgSource = subject
            local dmgObj = GameObjectFactory.getDmgObj(performActionPos.x, performActionPos.y, dmgInfo,
                currentItem:getActionSize())
            MyLocator.gameObjectManager:addGameObject(dmgObj)
        end
    end
end

return ActionState
