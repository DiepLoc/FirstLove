GameObjectFactory = Object:extend()

function GameObjectFactory.getSolidBlock(tileX, tileY, column, row, cb)
    local anim = AnimComp("idle", Sprite("general", 16, 16, 1, row, 1, column))
    local positionComp = StaticPositionComp(tileX * Constants.TILE_SIZE, tileY * Constants.TILE_SIZE, Constants
        .TILE_SIZE,
        Constants.TILE_SIZE):setZeroGravity()
    local obj = GameObject(anim, positionComp, nil, Constants.OBJ_NAME_BLOCK)
    if cb then
        cb(obj)
    end
    return obj
end

function GameObjectFactory.getPlayer(tileX, tileY)
    local anim = AnimComp("idle-right", Sprite("characters", 16, 16, 1, 0, 1, 0))
        :addAnim("idle-left", Sprite("characters", 16, 16, 1, 0, 1, 0):setFlipX())
        :addAnim("run-right", Sprite("characters", 16, 16, 4, 1, Constants.COMMON_ACTION_FPS, 0))
        :addAnim("run-left", Sprite("characters", 16, 16, 4, 1, Constants.COMMON_ACTION_FPS, 0):setFlipX())
        :addAnim("attack-right", Sprite("characters", 16, 16, 3, 2, Constants.COMMON_ACTION_FPS, 0))
        :addAnim("attack-left", Sprite("characters", 16, 16, 3, 2, Constants.COMMON_ACTION_FPS, 0):setFlipX())
        :addAnim("attack-range-right", Sprite("characters", 16, 16, 3, 3, Constants.COMMON_ACTION_FPS, 0))
        :addAnim("attack-range-left", Sprite("characters", 16, 16, 3, 3, Constants.COMMON_ACTION_FPS, 0):setFlipX())
        :addDyingAnim()
    local positionComp = PositionComp(tileX * Constants.TILE_SIZE, tileY * Constants.TILE_SIZE, Constants.PLAYER_SIZE,
        Constants.PLAYER_SIZE):setCollisionRect(5 / 16 * Constants.PLAYER_SIZE, 3 / 16 * Constants.PLAYER_SIZE,
        6 / 16 * Constants.PLAYER_SIZE, 13 / 16 * Constants.PLAYER_SIZE)
    local stateComp = StateComp(PlayerState())
    local obj = GameObject(anim, positionComp, stateComp, Constants.OBJ_NAME_PLAYER)
    obj.infoComp:addInfo(CommonCharInfo():setHungryable())
    obj.inventoryComp = InventoryComp()
    obj.inventoryComp:addItem(InventoryItemFactory.getSword(), true)
    obj.inventoryComp:addItem(InventoryItemFactory.getPickaxe())
    obj.inventoryComp:addItem(InventoryItemFactory.getBow())
    obj.inventoryComp:addItem(InventoryItemFactory.getArrow():setStack(5))
    if Constants.DEBUG_DRAGON_OR_CRYSTAL then
        obj.inventoryComp:addItem(InventoryItemFactory.getEyeOfEnderItem():setStack(10))
        obj.inventoryComp:addItem(InventoryItemFactory.getBlockItem(Constants.OBJ_NAME_BLOCK):setStack(50))
        obj.inventoryComp:addItem(InventoryItemFactory.getWing())
    end

    return obj
end

-- function GameObjectFactory.getMobObj(tileX, tileY, row, attackAnim, name, attkRange, isHuge, idleFrameNum)
---@return GameObject
function GameObjectFactory.getMobObj(tileX, tileY, row, name, data)
    data = data or {}
    local frameHeight = (data.yScale or 1) * 16
    local frameWidth = (data.xScale or 1) * 16
    local anim = AnimComp("idle-right",
            Sprite("characters", frameWidth, frameHeight, data.idle and data.idle.frame or 1, row,
                data.idle and data.idle.fps or 1, 0))
        :addAnim("idle-left",
            Sprite("characters", frameWidth, frameHeight, data.idle and data.idle.frame or 1, row,
                data.idle and data.idle.fps or 1, 0):setFlipX())
        :addAnim("run-right", Sprite("characters", frameWidth, frameHeight, 4, row + 1, Constants.COMMON_ACTION_FPS, 0))
        :addAnim("run-left",
            Sprite("characters", frameWidth, frameHeight, 4, row + 1, Constants.COMMON_ACTION_FPS, 0):setFlipX())
        :addDyingAnim()
    if data.attackAnim then
        anim:addAnim(data.attackAnim .. "-right",
            Sprite("characters", frameWidth, frameHeight, 3, row + 2, Constants.COMMON_ACTION_FPS, 0))
        anim:addAnim(data.attackAnim .. "-left",
            Sprite("characters", frameWidth, frameHeight, 3, row + 2, Constants.COMMON_ACTION_FPS, 0):setFlipX())
    end

    local displayXScale = (data.xScale or 1) * (data.sizeScale or 1)
    local displayYScale = (data.yScale or 1) * (data.sizeScale or 1)
    local positionComp = PositionComp(tileX * Constants.TILE_SIZE, tileY * Constants.TILE_SIZE,
        Constants.PLAYER_SIZE * displayXScale,
        Constants.PLAYER_SIZE * displayYScale):setCollisionRect(
        5 / 16 * Constants.PLAYER_SIZE * displayXScale,
        3 / 16 * Constants.PLAYER_SIZE * displayYScale,
        6 / 16 * Constants.PLAYER_SIZE * displayXScale,
        13 / 16 * Constants.PLAYER_SIZE * displayYScale)
    positionComp.speed = Constants.MOD_SPEED
    positionComp.jump_gravity = Constants.MOB_GRAVITY_JUMP
    local getAttkStateCb = data.attackAnim and (function(parent, direction) return ActionState(parent, direction) end) or
        nil
    local stateComp = StateComp(SimpleAiState(getAttkStateCb, data.attkRange, data.getTrackingCb))
    local obj = GameObject(anim, positionComp, stateComp, name)
    obj.infoComp:addInfo(CommonCharInfo())
    return obj
end

function GameObjectFactory.getZombie(tileX, tileY)
    local obj = GameObjectFactory.getMobObj(tileX, tileY, 4, Constants.OBJ_NAME_ZOMBIE)
    obj.infoComp:addInfo(DmgInfo(1, 0, { Constants.OBJ_NAME_PLAYER }, false))
    obj.infoComp:getInfo(CommonCharInfo):setBaseHealth(4)
    return obj
end

function GameObjectFactory.getSkeleton(tileX, tileY)
    local obj = GameObjectFactory.getMobObj(tileX, tileY, 6, Constants.OBJ_NAME_SKELETON,
        { attackAnim = "attack-range", attkRange = 200 })
    obj.inventoryComp = InventoryComp()
    obj.inventoryComp:addItem(InventoryItemFactory.getBow(), true)
    obj.inventoryComp:addItem(InventoryItemFactory.getArrow():setStack(1000))
    return obj
end

function GameObjectFactory.addFlyingAbility(obj)
    obj.positionComp:setFying()
    return obj
end

function GameObjectFactory.getCreeper(tileX, tileY)
    local obj = GameObjectFactory.getMobObj(tileX, tileY, 9, Constants.OBJ_NAME_CREEPER, { attackAnim = "attack" })
    obj.inventoryComp = InventoryComp()
    obj.infoComp:getInfo(CommonCharInfo):setBaseHealth(4)
    obj.stateComp = StateComp(CreeperState())
    return obj
end

function GameObjectFactory.getEnderman(tileX, tileY)
    local obj = GameObjectFactory.getMobObj(tileX, tileY, 7, Constants.OBJ_NAME_ENDERMAN,
        {
            attackAnim = "attack",
            yScale = 2,
            getTrackingCb = (function(parent, direction)
                return FaceToFaceTeleportState(parent,
                    direction)
            end)
        })
    obj.infoComp:addInfo(DmgInfo(1, 0, { Constants.OBJ_NAME_PLAYER }, false))
    obj.inventoryComp = InventoryComp()
    obj.inventoryComp:addItem(InventoryItemFactory.getSword(2), true)
    return obj
end

function GameObjectFactory.getEnderDragon(tileX, tileY)
    local obj = GameObjectFactory.getMobObj(tileX, tileY, 20, Constants.OBJ_NAME_ENDER_DRAGON,
        { xScale = 2, yScale = 1, sizeScale = 2, idle = { frame = 4, fps = Constants.COMMON_ACTION_FPS } })
    obj.infoComp:addInfo(DmgInfo(1, 0, { Constants.OBJ_NAME_PLAYER }, false))
    obj.infoComp:getInfo(CommonCharInfo):setBaseHealth(Constants.ENDER_DRAGON_HEALTH)
    obj.positionComp:setZeroGravity()
    obj.positionComp.isBlocked = false
    obj.positionComp.speed = 500
    obj.stateComp = StateComp(EnderDragonState())
    obj.inventoryComp = InventoryComp()

    if MyLocator.gameObjectManager.winTimestamp then
        obj.animComp:setBaseColor({ 1, 0, 0, 1 })
    end
    return obj
end

function GameObjectFactory.getTopGrassBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 0, 0, function(obj)
        obj.infoComp:addInfo(CommonBlockInfo(true))
    end)
end

function GameObjectFactory.getGrassBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 1, 0, function(obj)
        obj.infoComp:addInfo(CommonBlockInfo(true))
    end)
end

function GameObjectFactory.getTreeBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 2, 0, function(obj)
        obj.positionComp.isBlocked = false
        obj.infoComp:addInfo(CommonBlockInfo(true, 2))
        obj.name = Constants.OBJ_NAME_BLOCK_WOOD
    end)
end

function GameObjectFactory.getLeafBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 3, 0, function(obj)
        obj.infoComp:addInfo(CommonBlockInfo(true, 1))
        obj.name = Constants.OBJ_NAME_BLOCK_LEAF
    end)
end

function GameObjectFactory.getAppleBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 4, 0, function(obj)
        obj.infoComp:addInfo(CommonBlockInfo(true, 1))
        obj.name = Constants.OBJ_NAME_BLOCK_APPLE
    end)
end

function GameObjectFactory.getDmgObj(x, y, dmgInfo, dmgSize)
    dmgSize = dmgSize or Constants.EXPLOIT_SIZE
    local anim = AnimComp("idle-right", Sprite("general", 16, 16, 1, 1, 1, 0)):setBaseColor(Constants.SHOW_DMG_OBJ and
        { 1, 1, 1, 1 } or { 1, 1, 1, 0 })
    local positionComp = PositionComp(x - dmgSize / 2, y - dmgSize / 2, dmgSize, dmgSize)
    positionComp.isBlocked = false
    local stateComp = StateComp(ShortLifeState())
    local obj = GameObject(anim, positionComp, stateComp, Constants.OBJ_NAME_DMG)
    obj.infoComp:addInfo(dmgInfo or DmgInfo(0, 1))
    return obj
end

-- data: {size, dmg, exploitDmg}
function GameObjectFactory.getExplosionObj(x, y, data)
    data = data or {}
    local size = data.size or Constants.TILE_SIZE
    local anim = AnimComp("idle-right", Sprite("general", 16, 16, 1, 1, 1, 9))
        :addAnim("dying", Sprite("characters", 16, 16, 5, 12, 5, 0))
    local positionComp = PositionComp(x - size / 2, y - size / 2, size,
        size):setZeroGravity()
    positionComp.isBlocked = false
    local stateComp = StateComp(ShortLifeState(nil, true))
    local obj = GameObject(anim, positionComp, stateComp, Constants.OBJ_NAME_DMG)
    obj.infoComp:addInfo(data.dmgInfo or DmgInfo(data.dmg or 3, data.exploitDmg or 10, AllTargetNames, false))
    return obj
end

function GameObjectFactory.getArrow(x, y, directionVec, speed, dmgInfo)
    local anim = AnimComp("idle-right", Sprite("general", 16, 16, 1, 2, 1, 0))
    local positionComp = PositionComp(x - Constants.TILE_SIZE / 2, y - Constants.TILE_SIZE / 2, Constants.TILE_SIZE,
        Constants.TILE_SIZE):setCollisionRect(6 * 2, 6 * 2, 4 * 2,
        4 * 2)
    positionComp.isBlocked = false
    local stateComp = StateComp(FlyState(directionVec, speed or Constants.ARROW_SPEED))
    local obj = GameObject(anim, positionComp, stateComp)
    obj.infoComp:addInfo(dmgInfo or DmgInfo(1, 0))
    return obj
end

function GameObjectFactory.getFireball(x, y, directionVec, speed)
    local anim = AnimComp("idle-right", Sprite("general", 16, 16, 1, 2, 1, 4))
    local positionComp = PositionComp(x - Constants.TILE_SIZE / 2, y - Constants.TILE_SIZE / 2, Constants.TILE_SIZE,
        Constants.TILE_SIZE):setCollisionRect(4 * 2, 4 * 2, 8 * 2,
        8 * 2):setZeroGravity()
    positionComp.isBlocked = false
    local stateComp = StateComp(FlyState(directionVec, speed or 500))
    local obj = GameObject(anim, positionComp, stateComp)
    obj.infoComp:addInfo(FireballInfo())
    return obj
end

function GameObjectFactory.getEndCrystal(x, y)
    local anim = AnimComp("idle-right", Sprite("general", 16, 16, 3, 4, Constants.COMMON_ACTION_FPS, 0))
        :addDyingAnim()
    local positionComp = PositionComp(x - Constants.TILE_SIZE / 2, y - Constants.TILE_SIZE / 2, Constants.TILE_SIZE,
        Constants.TILE_SIZE):setZeroGravity()
    positionComp.isBlocked = false
    local stateComp = StateComp(NullState())
    local obj = GameObject(anim, positionComp, stateComp, Constants.OBJ_NAME_END_CRYSTAL)
    obj.infoComp:addInfo(CommonCharInfo(1))
    return obj
end

function GameObjectFactory.getEyeOfEnderObj(x, y)
    local anim = AnimComp("idle-right", Sprite("general", 16, 16, 1, 3, 1, 6))
        :addDyingAnim()
    local positionComp = PositionComp(x - Constants.TILE_SIZE / 2, y - Constants.TILE_SIZE / 2, Constants.TILE_SIZE,
        Constants.TILE_SIZE):setCollisionRect(4 * 2, 4 * 2, 6 * 2,
        6 * 2):setZeroGravity()
    positionComp.isBlocked = false
    local stateComp = StateComp(EnderEyeState())
    local obj = GameObject(anim, positionComp, stateComp)
    return obj
end

function GameObjectFactory.getLootObj(x, y, lootItem)
    local randomX = math.random(-3, 3)
    local frame = Constants.ITEM_IMAGE_MAPPING[lootItem.name]
    local anim = AnimComp("idle", Sprite("general", 16, 16, 1, frame[2], 1, frame[1]))
    local positionComp = PositionComp(x + randomX - Constants.ITEM_OBJECT_SIZE / 2, y - Constants.ITEM_OBJECT_SIZE / 2,
        Constants.ITEM_OBJECT_SIZE,
        Constants.ITEM_OBJECT_SIZE)
    local obj = GameObject(anim, positionComp)
    obj.infoComp:addInfo(LootInfo(lootItem))
    return obj
end

function GameObjectFactory.generateTree(blocks, x, y, height)
    for i = y, y - height, -1 do
        blocks[x][i] = GameObjectFactory.getTreeBlock(x, i)
    end

    local leafHeight = height < 3 and 2 or math.random() < 0.3 and 3 or 2
    local leafWidthLeft = height < 3 and 2 or math.random() < 0.3 and 3 or 2
    local leafWidthRight = leafWidthLeft
    for k = y - height - 1, y - height - 1 - leafHeight, -1 do
        for i = x - leafWidthLeft, x + leafWidthRight do
            if blocks[i] then
                if k == y - height - 1 and math.random() < Constants.APPLE_SPAWN_RATE then
                    blocks[i][k] = GameObjectFactory.getAppleBlock(i, k)
                else
                    blocks[i][k] = GameObjectFactory.getLeafBlock(i, k)
                end
            end
        end
        if leafWidthLeft > 0 and math.random() < 0.6 then
            leafWidthLeft = leafWidthLeft - 1
            leafWidthRight = leafWidthRight - 1
        end
    end
end

function GameObjectFactory.generateTerrain(width, height, scale, offset, waterHeight)
    local terrain = {}

    for x = 1, width do
        local noiseValue = love.math.noise(x * scale + offset) -- Generate smooth height values
        local terrainHeight = math.floor(noiseValue * height)  -- Scale to game world height
        terrain[x] = terrainHeight
    end

    local blocks = {}
    for i = 1, width do
        blocks[i] = {}
        for k = 1, height do
            blocks[i][k] = nil
        end
    end

    for x = 1, #terrain do
        for y = 1, terrain[x] do
            love.graphics.setColor(0.4, 0.3, 0.2) -- Brown color for dirt
            love.graphics.rectangle("fill", x * 10, height * 10 - y * 10, 10, 10)
        end
    end

    for x = 1, #terrain do
        for y = 1, height do
            local actualY = height - y + 1
            if y < terrain[x] then
                local block = GameObjectFactory.getGrassBlock(x, actualY)
                blocks[x][actualY] = block
            elseif y == terrain[x] then
                if y <= waterHeight then
                    local block = GameObjectFactory.getGrassBlock(x, actualY)
                    blocks[x][actualY] = block
                else
                    local block = GameObjectFactory.getTopGrassBlock(x, actualY)
                    blocks[x][actualY] = block
                end
            elseif y == terrain[x] + 1 and y - 1 > waterHeight and love.math.random() < 0.1 then
                GameObjectFactory.generateTree(blocks, x, actualY, love.math.random(3, 6))
            end
        end
    end
    return blocks
end

return GameObjectFactory
