require "managers.imageManager"
require "camera"
require "managers.gameObjectManager"
require "managers.uiManager"

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

    self.managers = {
        self.imageManager,
        self.gameObjectManager,
        self.uiManager,
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
    if event == Constants.EVENT_GAMEOBJ_DESTROYED then
        local obj = data
        local center = obj.positionComp:getCollisionCenter()
        if obj.name == Constants.OBJ_NAME_BLOCK then
            local loot = GameObjectFactory.getLootObj(center.x, center.y)
            self.gameObjectManager:addGameObject(loot)
        elseif obj.name == Constants.OBJ_NAME_APPLE then
            local loot = GameObjectFactory.getLootObj(center.x, center.y, InventoryItemFactory.getAppleItem())
            self.gameObjectManager:addGameObject(loot)
        end
    end

    if event == Constants.EVENT_DROP_ITEM then
        local item = data.item
        local loot = GameObjectFactory.getLootObj(data.x, data.y, item)
        self.gameObjectManager:addGameObject(loot)
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
