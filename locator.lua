require "managers.imageManager"
require "camera"
require "managers.gameObjectManager"

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

    self.managers = {
        self.imageManager,
        self.gameObjectManager,
    }
    return self
end

function Locator:onSetup()
    for _, value in pairs(self.managers) do
        value:onSetup()
    end
end

function Locator:update(dt)
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
