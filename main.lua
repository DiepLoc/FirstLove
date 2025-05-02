require "requireAll"
require "gameObject"
require "locator"

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
    love.window.setMode(800, 600, { resizable = true })
    love.window.setTitle("Hello World")
    love.graphics.setDefaultFilter("nearest", "nearest")

    ---@type Locator
    MyLocator = Locator()
    MyLocator:onSetup()
    -- local ter = GameObjectFactory.generateTerrain(100, 10, 0.1, 0)
end

function love.update(dt)
    -- Update logic here
    MyLocator:update(dt)
end

function love.draw()
    love.graphics.print("Hello World", 400, 300)
    MyLocator:draw()
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
