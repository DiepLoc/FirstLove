InventoryItemFactory = Object:extend()


function InventoryItemFactory.getSword()
    local item = WeaponItem(Constants.ITEM_SWORD, 1, 0, Constants.WEAPON_TYPE_MELEE_2D)
    return item
end

function InventoryItemFactory.getPickaxe()
    local item = WeaponItem(Constants.ITEM_PICKAXE, 1, 1, Constants.WEAPON_TYPE_MELEE_4D)
    return item
end

function InventoryItemFactory.getBow()
    local item = WeaponItem(Constants.ITEM_BOW, 1, 0, Constants.WEAPON_TYPE_RANGE)
    return item
end

function InventoryItemFactory.getArrow()
    local item = BasicItem(Constants.ITEM_ARROW)
    return item
end

function InventoryItemFactory.getBlockItem(blockType)
    if blockType == Constants.BLOCK_ITEM_DIRT then
        return BlockItem(Constants.ITEM_BLOCK_DIRT, Factory.getGrassBlock):setStackable()
    elseif blockType == Constants.BLOCK_ITEM_LEAF then
        return BlockItem(Constants.ITEM_BLOCK_LEAF, Factory.getLeafBlock):setStackable()
    end
    error("invalid block type")
end

function InventoryItemFactory.getAppleItem()
    return ConsumableItem(Constants.ITEM_APPLE, 1, 1):setStackable()
end

return InventoryItemFactory
