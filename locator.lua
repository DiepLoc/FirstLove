require "managers.imageManager"
require "camera"
require "managers.gameObjectManager"
require "managers.uiManager"
require "managers.soundManager"

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

    self.managers = {
        self.imageManager,
        self.gameObjectManager,
        self.uiManager,
        self.soundManager,
    }

    self.observers = {
        self.soundManager,
        self.gameObjectManager,
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
    print("event-" .. event)

    -- notify to observers
    for _, observer in pairs(self.observers) do
        observer:onNotify(event, data)
    end

    self:handleLoot(event, data)
    if event == Constants.EVENT_DROP_ITEM then
        local item = data.item
        local loot = GameObjectFactory.getLootObj(data.x, data.y, item)
        self.gameObjectManager:addGameObject(loot)
    end
end

local lootMapping = {
    [Constants.OBJ_NAME_SKELETON] = function() return InventoryItemFactory.getArrow() end,
    [Constants.OBJ_NAME_BLOCK_APPLE] = function() return InventoryItemFactory.getAppleItem() end,
    [Constants.OBJ_NAME_BLOCK] = function() return InventoryItemFactory.getBlockItem(Constants.OBJ_NAME_BLOCK) end,
    [Constants.OBJ_NAME_ZOMBIE] = function() return InventoryItemFactory.getMeatItem end,
    [Constants.OBJ_NAME_ENDERMAN] = function() return InventoryItemFactory.getEyeOfEnderItem() end,
}

function Locator:handleLoot(event, data)
    if event == Constants.EVENT_GAMEOBJ_DESTROYED then
        local obj = data
        local center = obj.positionComp:getCollisionCenter()
        local cb = lootMapping[obj.name]
        if cb then
            local loot = GameObjectFactory.getLootObj(center.x, center.y, cb())
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
    AddDebugStr(mousePosX .. "-" .. mousePosY)
end

function Locator:update(dt)
    self:debugUpdate()
    for _, value in pairs(self.managers) do
        value:update(dt)
    end
    self.camera:update(dt)

    if MyLocator.gameObjectManager.player then
        AddDebugStr("current item ind" .. MyLocator.gameObjectManager.player.inventoryComp.currentItemIndex)
    end
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
