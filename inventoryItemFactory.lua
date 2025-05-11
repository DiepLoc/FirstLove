InventoryItemFactory = Object:extend()


function InventoryItemFactory.getSword(dmg)
    local item = WeaponItem(Constants.ITEM_SWORD, dmg or 1, 0, Constants.WEAPON_TYPE_MELEE_2D)
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
    local item = BasicItem(Constants.ITEM_ARROW):setStackable()
    return item
end

local blockNameToItemNameMapping = {
    [Constants.OBJ_NAME_BLOCK] = { Constants.ITEM_BLOCK_DIRT, Factory.getGrassBlock },
    [Constants.OBJ_NAME_BLOCK_LEAF] = { Constants.ITEM_BLOCK_LEAF, Factory.getLeafBlock },
    [Constants.OBJ_NAME_BLOCK_WOOD] = { Constants.ITEM_WOOD, Factory.getTreeBlock },
}

function InventoryItemFactory.getBlockItem(objName)
    local itemInfo = blockNameToItemNameMapping[objName]
    return BlockItem(itemInfo[1], itemInfo[2]):setStackable()
end

function InventoryItemFactory.getAppleItem()
    return ConsumableItem(Constants.ITEM_APPLE, 1, 1):setStackable()
end

function InventoryItemFactory.getMeatItem()
    return ConsumableItem(Constants.ITEM_MEAT, 0, 3):setStackable()
end

function InventoryItemFactory.getEyeOfEnderItem()
    local onConsume = function(subject)
        local subjectPos = subject.positionComp:getCollisionCenter()
        local obj = Factory.getEyeOfEnderObj(subjectPos.x, subjectPos.y)
        MyLocator.gameObjectManager:addGameObject(obj)
    end
    return ConsumableItem(Constants.ITEM_EYE_OF_ENDER, 0, 0, onConsume):setStackable()
end

return InventoryItemFactory
