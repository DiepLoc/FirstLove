InventoryItemFactory = Object:extend()


function InventoryItemFactory.getSword()
    local item = WeaponItem(1, 0, Constants.WEAPON_TYPE_MELEE_2D)
    return item
end

function InventoryItemFactory.getPickaxe()
    local item = WeaponItem(1, 1, Constants.WEAPON_TYPE_MELEE_4D)
    return item
end

function InventoryItemFactory.getBow()
    local item = WeaponItem(1, 0, Constants.WEAPON_TYPE_RANGE)
    return item
end

return InventoryItemFactory
