require "requireAll"
require "gameObject"
require "locator"

local debugContents = {}

if arg[2] == "debug" then
    require("lldebugger").start()
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

    if key == "rshift" then
        local a = 1
    end
end

function love.load()
    -- Load resources here
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
    love.graphics.setBlendMode("alpha")
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT, { resizable = true })
    love.window.setTitle("Hello World")

    ---@type Locator
    MyLocator = Locator()
    MyLocator:onSetup()
    -- local ter = GameObjectFactory.generateTerrain(100, 10, 0.1, 0)
end

function AddDebugStr(str)
    table.insert(debugContents, str)
end

function love.update(dt)
    debugContents = {}
    -- Update logic here
    MyLocator:update(dt)
end

function love.draw()
    MyLocator:draw()
    love.graphics.print("FPS" .. tostring(love.timer.getFPS()), 0, 0)
    for i = 1, #debugContents do
        love.graphics.print(tostring(debugContents[i]), 0, i * 20)
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
