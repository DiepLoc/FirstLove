WeaponItem = BaseInvItem:extend()

function WeaponItem:new(dmg, exploitDmg, weaponType, range)
    self.dmg = dmg or 0
    self.exploitDmg = exploitDmg or 0
    self.weaponType = weaponType or Constants.WEAPON_TYPE_MELEE_4D
    self.range = range or 33
    return self
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

function WeaponItem:getActionSize()
    if self.weaponType == Constants.WEAPON_TYPE_MELEE_2D then
        return Constants.MELEE_ATTACK_SIZE
    elseif self.weaponType == Constants.WEAPON_TYPE_MELEE_4D then
        return Constants.EXPLOIT_SIZE
    end
    error("invalid weapon type")
end

return WeaponItem
