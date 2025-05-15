require "requireAll"
require "gameObject"
require "locator"

math.randomseed(os.time())
local debugContents = {}
GameTimer = {
    s = 0,
    m = 0,
    h = 0
}

local background = {
    R = 120,
    G = 160,
    B = 180,
}
if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.wheelmoved(x, y)
    if y >= 1 then
        MyLocator.gameObjectManager.player.inventoryComp:onChangeCurrentValidItem(-1)
    elseif y <= -1 then
        MyLocator.gameObjectManager.player.inventoryComp:onChangeCurrentValidItem(1)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "z" then
        MyLocator.camera:setScale(MyLocator.camera.scale * 2)
    end
    if key == "x" then
        MyLocator.camera:setScale(MyLocator.camera.scale / 2)
    end

    if key == "space" and MyLocator.gameObjectManager:checkIsPlayerDestroyed() then
        MyLocator.gameObjectManager:onSpawnPlayer()
    end

    if key == "rshift" then
        local a = 1
    end

    if not Constants.DEBUG_BACKGROUND_COLOR then return end

    local changeVal = 5
    if key == "1" then
        background.R = CommonHelper.clamp(background.R + changeVal, 0, 255)
    end
    if key == "4" then
        background.R = CommonHelper.clamp(background.R - changeVal, 0, 255)
    end
    if key == "2" then
        background.G = CommonHelper.clamp(background.G + changeVal, 0, 255)
    end
    if key == "5" then
        background.G = CommonHelper.clamp(background.G - changeVal, 0, 255)
    end
    if key == "3" then
        background.B = CommonHelper.clamp(background.B + changeVal, 0, 255)
    end
    if key == "6" then
        background.B = CommonHelper.clamp(background.B - changeVal, 0, 255)
    end
end

function love.load()
    -- Load resources here
    love.graphics.setBackgroundColor(100 / 255, 150 / 255, 200 / 255)
    love.graphics.setBlendMode("alpha")
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT, { resizable = false })
    love.window.setTitle("Minelove 2D")

    ---@type Locator
    MyLocator = Locator()
    MyLocator:onSetup()
    -- local ter = GameObjectFactory.generateTerrain(100, 10, 0.1, 0)
end

function AddDebugStr(str)
    table.insert(debugContents, str)
end

function love.update(dt)
    love.graphics.setBackgroundColor(background.R / 255, background.G / 255, background.B / 255)
    debugContents = {}
    -- Update logic here
    MyLocator:update(dt)
    AddDebugStr("(" .. background.R .. "," .. background.G .. "," .. background.B .. ")")
    GameTimerUpdate(dt)
end

function GameTimerUpdate(dt)
    GameTimer.s = GameTimer.s + dt
    if GameTimer.s >= 60 then
        GameTimer.m = GameTimer.m + 1
        GameTimer.s = 0
    end

    if GameTimer.m >= 60 then
        GameTimer.h = GameTimer.h + 1
        GameTimer.m = 0
    end
end

function love.draw()
    MyLocator:draw()
    local gameTimeText = "      Game time: " ..
        GameTimer.h .. "h " .. GameTimer.m .. "m " .. math.floor(GameTimer.s) .. "s"
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()) .. gameTimeText, 0, 0)

    if Constants.DISPLAY_DEBUG_INFO then
        for i = 1, #debugContents do
            love.graphics.print(tostring(debugContents[i]), 0, i * 20)
        end
    end
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
