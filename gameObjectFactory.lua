GameObjectFactory = Object:extend()

function GameObjectFactory.getSolidBlock(tileX, tileY, column, row, cb)
    local anim = AnimComp("idle", Sprite("general", 16, 16, 1, row, 1, column))
    local positionComp = PositionComp(tileX * Constants.TILE_SIZE, tileY * Constants.TILE_SIZE, Constants.TILE_SIZE,
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
    local positionComp = PositionComp(tileX * Constants.TILE_SIZE, tileY * Constants.TILE_SIZE, Constants.PLAYER_SIZE,
        Constants.PLAYER_SIZE):setCollisionRect(5 / 16 * Constants.PLAYER_SIZE, 3 / 16 * Constants.PLAYER_SIZE,
        6 / 16 * Constants.PLAYER_SIZE, 13 / 16 * Constants.PLAYER_SIZE)
    local stateComp = StateComp(PlayerState())
    local obj = GameObject(anim, positionComp, stateComp, Constants.OBJ_NAME_PLAYER)
    obj.infoComp:addInfo(CommonCharInfo():setHungryable())
    obj.inventoryComp = InventoryComp()
    obj.inventoryComp:addItem(InventoryItemFactory.getPickaxe(), true)
    -- obj.inventoryComp:addItem(InventoryItemFactory.getSword())
    -- obj.inventoryComp:addItem(InventoryItemFactory.getBlock(Constants.BLOCK_ITEM_DIRT), true)
    return obj
end

function GameObjectFactory.getMobObj(tileX, tileY, row, hasAttack, name, attkRange)
    local anim = AnimComp("idle-right", Sprite("characters", 16, 16, 1, row, 1, 0))
        :addAnim("idle-left", Sprite("characters", 16, 16, 1, row, 1, 0):setFlipX())
        :addAnim("run-right", Sprite("characters", 16, 16, 4, row + 1, Constants.COMMON_ACTION_FPS, 0))
        :addAnim("run-left", Sprite("characters", 16, 16, 4, row + 1, Constants.COMMON_ACTION_FPS, 0):setFlipX())
    if hasAttack then
        anim:addAnim("attack-right", Sprite("characters", 16, 16, 3, row + 2, Constants.COMMON_ACTION_FPS, 0))
        anim:addAnim("attack-left", Sprite("characters", 16, 16, 3, row + 2, Constants.COMMON_ACTION_FPS, 0):setFlipX())
    end

    local positionComp = PositionComp(tileX * Constants.TILE_SIZE, tileY * Constants.TILE_SIZE, Constants.PLAYER_SIZE,
        Constants.PLAYER_SIZE):setCollisionRect(5 / 16 * Constants.PLAYER_SIZE, 3 / 16 * Constants.PLAYER_SIZE,
        6 / 16 * Constants.PLAYER_SIZE, 13 / 16 * Constants.PLAYER_SIZE)
    positionComp.speed = Constants.MOD_SPEED
    positionComp.jump_gravity = Constants.MOB_GRAVITY_JUMP
    local getAttkStateCb = hasAttack and (function(parent, direction) return ActionState(parent, direction) end) or nil
    local stateComp = StateComp(SimpleAiState(getAttkStateCb, attkRange))
    local obj = GameObject(anim, positionComp, stateComp, name)
    obj.infoComp:addInfo(CommonCharInfo())
    return obj
end

function GameObjectFactory.getZombie(tileX, tileY)
    local obj = GameObjectFactory.getMobObj(tileX, tileY, 4, false, Constants.OBJ_NAME_ZOMBIE)
    obj.infoComp:addInfo(DmgInfo(1, 0, { Constants.OBJ_NAME_PLAYER }, false))
    return obj
end

function GameObjectFactory.getSkeleton(tileX, tileY)
    local obj = GameObjectFactory.getMobObj(tileX, tileY, 6, true, Constants.OBJ_NAME_SKELETON, 200)
    obj.inventoryComp = InventoryComp()
    obj.inventoryComp:addItem(InventoryItemFactory.getBow(), true)
    return obj
end

function GameObjectFactory.getTopGrassBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 0, 0, function(obj)
        obj.infoComp:addInfo(CommonBlockInfo(false, true))
    end)
end

function GameObjectFactory.getGrassBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 1, 0, function(obj)
        obj.infoComp:addInfo(CommonBlockInfo(false, true))
    end)
end

function GameObjectFactory.getWaterBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 0, 1, function(obj)
        obj.positionComp.isBlocked = false
        obj.infoComp:addInfo(CommonBlockInfo(true, false))
        obj.name = Constants.OBJ_NAME_WATER
    end)
end

function GameObjectFactory.getTreeBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 2, 0, function(obj)
        obj.positionComp.isBlocked = false
        obj.infoComp:addInfo(CommonBlockInfo(false, true))
    end)
end

function GameObjectFactory.getLeafBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 3, 0, function(obj)
        obj.infoComp:addInfo(CommonBlockInfo(false, true))
    end)
end

function GameObjectFactory.getAppleBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 4, 0, function(obj)
        obj.infoComp:addInfo(CommonBlockInfo(false, true))
        obj.name = Constants.OBJ_NAME_APPLE
    end)
end

function GameObjectFactory.getDmgObj(x, y, dmgInfo, dmgSize)
    dmgSize = dmgSize or Constants.EXPLOIT_SIZE
    local anim = AnimComp("idle-right", Sprite("general", 16, 16, 1, 0, 1, 3))
    local positionComp = PositionComp(x - dmgSize / 2, y - dmgSize / 2, dmgSize, dmgSize)
    positionComp.isBlocked = false
    local stateComp = StateComp(ShortLifeState())
    local obj = GameObject(anim, positionComp, stateComp, Constants.OBJ_NAME_DMG)
    obj.infoComp:addInfo(dmgInfo or DmgInfo(0, 1))
    return obj
end

function GameObjectFactory.getArrow(x, y, directionVec, speed, dmgInfo)
    local anim = AnimComp("idle", Sprite("general", 16, 16, 1, 2, 1, 0))
    local positionComp = PositionComp(x - Constants.TILE_SIZE / 2, y - Constants.TILE_SIZE / 2, Constants.TILE_SIZE,
        Constants.TILE_SIZE):setCollisionRect(6 * 2, 6 * 2, 4 * 2,
        4 * 2)
    positionComp.isBlocked = false
    local stateComp = StateComp(FlyState(directionVec, speed or Constants.ARROW_SPEED))
    local obj = GameObject(anim, positionComp, stateComp)
    obj.infoComp:addInfo(dmgInfo or DmgInfo(1, 0))
    return obj
end

function GameObjectFactory.getLootObj(x, y, lootItem)
    local randomX = math.random(-10, 10)
    local anim = AnimComp("idle", Sprite("general", 16, 16, 1, 2, 1, 0))
    local positionComp = PositionComp(x + randomX - Constants.TILE_SIZE / 2, y - Constants.TILE_SIZE / 2,
        Constants.TILE_SIZE,
        Constants.TILE_SIZE):setCollisionRect(6 * 2, 6 * 2, 4 * 2,
        4 * 2)
    local obj = GameObject(anim, positionComp)
    obj.infoComp:addInfo(LootInfo(lootItem or InventoryItemFactory.getBlockItem(Constants.BLOCK_ITEM_DIRT)))
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
        else
            -- if leafWidthRight >= 0 and math.random() < 0.4 then leafWidthRight = leafWidthRight - 1 end
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
                if y < waterHeight then
                    local block = GameObjectFactory.getGrassBlock(x, actualY)
                    blocks[x][actualY] = block
                else
                    local block = GameObjectFactory.getTopGrassBlock(x, actualY)
                    blocks[x][actualY] = block
                end
            elseif y <= waterHeight then
                local block = GameObjectFactory.getWaterBlock(x, actualY)
                blocks[x][actualY] = block
            elseif y == terrain[x] + 1 and y > waterHeight and love.math.random() < 0.1 then
                GameObjectFactory.generateTree(blocks, x, actualY, love.math.random(3, 6))
            end
        end
    end
    return blocks
end

return GameObjectFactory
