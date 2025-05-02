GameObjectFactory = Object:extend()

function GameObjectFactory.getSolidBlock(tileX, tileY, column, row)
    local anim = AnimComp("idle", Sprite("general", 16, 16, 1, row, 1, column))
    local positionComp = PositionComp(tileX * Constants.TILE_SIZE, tileY * Constants.TILE_SIZE, Constants.TILE_SIZE,
        Constants.TILE_SIZE):setZeroGravity()
    local obj = GameObject(anim, positionComp)
    return obj
end

function GameObjectFactory.getChar(tileX, tileY)
    local anim = AnimComp.new(AnimComp, "idle-right", Sprite("characters", 16, 16, 1, 0, 1, 0))
        :addAnim("idle-left", Sprite("characters", 16, 16, 1, 0, 1, 0):setFlipX())
        :addAnim("run-right", Sprite("characters", 16, 16, 4, 1, 10, 0))
        :addAnim("run-left", Sprite("characters", 16, 16, 4, 1, 10, 0):setFlipX())
        :addAnim("attack", Sprite("characters", 16, 16, 3, 2, 10, 0))
    local positionComp = PositionComp(tileX * Constants.TILE_SIZE, tileY * Constants.TILE_SIZE, Constants.PLAYER_SIZE,
        Constants.PLAYER_SIZE)
    local stateComp = StateComp(MoveState())
    local obj = GameObject(anim, positionComp, stateComp, Constants.OBJ_NAME_PLAYER)
    return obj
end

function GameObjectFactory.getTopGrassBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 0, 0)
end

function GameObjectFactory.getGrassBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 1, 0)
end

function GameObjectFactory.getWaterBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 0, 1)
end

function GameObjectFactory.getTreeBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 2, 0)
end

function GameObjectFactory.getLeafBlock(tileX, tileY)
    return GameObjectFactory.getSolidBlock(tileX, tileY, 3, 0)
end

function GameObjectFactory.getArrow(tileX, tileY, directionVec, speed)
    local anim = AnimComp("idle", Sprite("general", 16, 16, 1, 2, 1, 0))
    local positionComp = PositionComp(tileX * Constants.TILE_SIZE, tileY * Constants.TILE_SIZE, Constants.TILE_SIZE,
        Constants.TILE_SIZE):setCollisionRect(6 * Constants.TILE_SIZE, 6 * Constants.TILE_SIZE, 4 * Constants.TILE_SIZE,
        4 * Constants.TILE_SIZE):setZeroGravity()
    local stateComp = StateComp(FlyState(directionVec, speed or 100))
    local obj = GameObject(anim, positionComp, stateComp)
    return obj
end

function GameObjectFactory.generateTerrain(width, height, scale, offset, waterHeight)
    local terrain = {}

    for x = 1, width do
        local noiseValue = love.math.noise(x * scale + offset) -- Generate smooth height values
        local terrainHeight = math.floor(noiseValue * height)  -- Scale to game world height
        terrain[x] = terrainHeight
    end
    -- for x = 1, #terrain do
    --     for y = terrain[x], height do
    --         love.graphics.setColor(0.4, 0.3, 0.2) -- Brown color for dirt
    --         love.graphics.rectangle("fill", x * 10, y * 10, 10, 10)
    --     end
    -- end

    local blocks = {}

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
                table.insert(blocks, block)
            elseif y == terrain[x] then
                local block = GameObjectFactory.getTopGrassBlock(x, actualY)
                table.insert(blocks, block)
            elseif y < waterHeight then
                local block = GameObjectFactory.getWaterBlock(x, actualY)
                table.insert(blocks, block)
            end
        end
    end
    return blocks
end

return GameObjectFactory
