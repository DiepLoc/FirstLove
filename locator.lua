require "managers.imageManager"
require "camera"
require "managers.gameObjectManager"
require "managers.uiManager"
require "managers.soundManager"
require "managers.enemySpawnManager"

---@class Locator
Locator = Object:extend()


function Locator:new()
    ---@type Camera
    self.camera = Camera(0, 0, Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT)
    self.lastInput = {}

    -- managers
    ---@type ImageManager
    self.imageManager = ImageManager()
    ---@type GameObjectManager
    self.gameObjectManager = GameObjectManager()
    ---@type UiManager
    self.uiManager = UiManager()
    ---@type SoundManager
    self.soundManager = SoundManager()
    ---@type EnemySpawnManager
    self.enemySpawnManager = EnemySpawnManager()

    self.managers = {
        self.imageManager,
        self.gameObjectManager,
        self.uiManager,
        self.soundManager,
        self.enemySpawnManager,
    }

    self.observers = {
        self.soundManager,
        self.gameObjectManager,
        self.enemySpawnManager,
    }
    return self
end

function Locator:onSetup()
    for _, value in pairs(self.managers) do
        value:onSetup()
    end
end

---@param event string
---@param data any
function Locator:notify(event, data)
    -- print("event-" .. event)

    -- notify to observers
    for _, observer in pairs(self.observers) do
        observer:onNotify(event, data)
    end

    self:handleLoot(event, data)
end

local lootMapping = {
    [Constants.OBJ_NAME_SKELETON] = function(obj)
        return InventoryItemFactory.getArrow():setStack(obj.positionComp
            .isFlying and 20 or 6)
    end,
    [Constants.OBJ_NAME_BLOCK_APPLE] = function(obj) return InventoryItemFactory.getAppleItem() end,
    [Constants.OBJ_NAME_ZOMBIE] = function(obj) return InventoryItemFactory.getMeatItem() end,
    [Constants.OBJ_NAME_ENDERMAN] = function(obj) return InventoryItemFactory.getEyeOfEnderItem() end,
    [Constants.OBJ_NAME_ENDER_DRAGON] = function(obj) return InventoryItemFactory.getWing() end,
}

function Locator:handleLoot(event, data)
    if event == Constants.EVENT_GAMEOBJ_DESTROYED then
        local obj = data
        local center = obj.positionComp:getCollisionCenter()
        local cb = lootMapping[obj.name]
        if cb then
            local loot = GameObjectFactory.getLootObj(center.x, center.y, cb(obj))
            self.gameObjectManager:addGameObject(loot)
            return
        elseif string.find(obj.name, "BLOCK") then
            local loot = GameObjectFactory.getLootObj(center.x, center.y, InventoryItemFactory.getBlockItem(obj.name))
            self.gameObjectManager:addGameObject(loot)
        end
    end
end

function Locator:debugUpdate()
    local mousePosX, mousePosY = love.mouse.getPosition()
    AddDebugStr("mouse pos: " .. mousePosX .. "," .. mousePosY)
end

function Locator:update(dt)
    self:debugUpdate()
    for _, value in pairs(self.managers) do
        value:update(dt)
    end
    self.camera:update(dt)
end

function Locator:checkKeyPress(key, isNew)
    local pressed = love.keyboard.isDown(key) and (not (isNew or false) or not self.lastInput[key])
    if love.keyboard.isDown(key) then
        self.lastInput[key] = true
    else
        self.lastInput[key] = false
    end
    return pressed
end

function Locator:draw()
    for _, value in pairs(self.managers) do
        value:draw()
    end
end

function Locator:checkMousePress(button)
    local isPressed = love.mouse.isDown(button)
    local posX, posY = love.mouse.getPosition()
    local worldRect = MyLocator.camera:screenToWorld(posX, posY, 0, 0)
    return isPressed, posX, posY, worldRect
end

return Locator
