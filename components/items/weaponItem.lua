WeaponItem = BaseInvItem:extend()

function WeaponItem:new(name, dmg, exploitDmg, weaponType, range)
    WeaponItem.super.new(self, name)
    self.dmg = dmg or 0
    self.exploitDmg = exploitDmg or 0
    self.weaponType = weaponType or Constants.WEAPON_TYPE_MELEE_4D
    self.range = range or 33
    return self
end

function WeaponItem:getLeftActionAnim()
    if self.weaponType == Constants.WEAPON_TYPE_RANGE then
        return "attack-range"
    end
    return "attack"
end

function WeaponItem:onStartAction(subject)
    local arrowItem = subject.inventoryComp:findItem(Constants.ITEM_ARROW)
    local hasArrow = arrowItem and arrowItem.stack >= 1
    if self.weaponType == Constants.WEAPON_TYPE_MELEE_2D or (self.weaponType == Constants.WEAPON_TYPE_RANGE and hasArrow) then
        MyLocator:notify(Constants.EVENT_ATTACK_ACTION, self)
    end
end

function WeaponItem:getTranformDirectionCb()
    if self.weaponType == Constants.WEAPON_TYPE_MELEE_2D then
        return CommonHelper.get2dDirectionFromDirection
    elseif self.weaponType == Constants.WEAPON_TYPE_MELEE_4D then
        return CommonHelper.get4dDirectionFromDirection
    else
        return CommonHelper.getDirection
    end
end

AllTargetNames = { Constants.OBJ_NAME_ZOMBIE,
    Constants.OBJ_NAME_SKELETON,
    Constants.OBJ_NAME_CREEPER,
    Constants.OBJ_NAME_ENDERMAN,
    Constants.OBJ_NAME_ENDER_DRAGON,
    Constants.OBJ_NAME_END_CRYSTAL,
    Constants.OBJ_NAME_PLAYER,
}

-- data {targetPos = Vector2}
function WeaponItem:onLeftAction(subject, data)
    local targetDmgNames = subject.name == Constants.OBJ_NAME_PLAYER and
        { Constants.OBJ_NAME_ZOMBIE,
            Constants.OBJ_NAME_SKELETON,
            Constants.OBJ_NAME_CREEPER,
            Constants.OBJ_NAME_ENDERMAN,
            Constants.OBJ_NAME_ENDER_DRAGON,
            Constants.OBJ_NAME_END_CRYSTAL }
        or { Constants.OBJ_NAME_PLAYER }
    local dmgInfo = DmgInfo(self.dmg, self.exploitDmg, targetDmgNames)

    local subjectCenter = subject.positionComp.displayRect:getCenter()
    local directionFunc = self:getTranformDirectionCb() or
        CommonHelper.get2dDirectionFromDirection
    local actionDirection = directionFunc(data.targetPos.x, data.targetPos.y, subjectCenter.x,
        subjectCenter.y)
    -- local worldPlayerTile = worldPlayerCenter.toWorldTile()
    local performActionPos = subjectCenter +
        Vector2(actionDirection.x * Constants.ACTION_DISTANCE, actionDirection.y * Constants.ACTION_DISTANCE)


    -- shoot arrow
    if self.weaponType == Constants.WEAPON_TYPE_RANGE then
        local arrowItem = subject.inventoryComp:findItem(Constants.ITEM_ARROW)
        if arrowItem and arrowItem.stack >= 1 then
            local arrowObj = GameObjectFactory.getArrow(subjectCenter.x, subjectCenter.y, actionDirection, nil,
                dmgInfo)
            MyLocator.gameObjectManager:addGameObject(arrowObj)
            arrowItem.stack = arrowItem.stack - 1
        end
        -- swing melee tools
    else
        dmgInfo.dmgSource = subject
        local dmgObj = GameObjectFactory.getDmgObj(performActionPos.x, performActionPos.y, dmgInfo,
            self:getActionSize())
        MyLocator.gameObjectManager:addGameObject(dmgObj)
    end
end

function WeaponItem:getActionSize()
    if self.weaponType == Constants.WEAPON_TYPE_MELEE_2D then
        return Constants.MELEE_ATTACK_SIZE
    elseif self.weaponType == Constants.WEAPON_TYPE_MELEE_4D then
        return Constants.EXPLOIT_SIZE
    end
    error("invalid weapon type")
end

return WeaponItem
