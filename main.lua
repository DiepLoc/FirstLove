require "block"
require "locator"
require "components/positionComp"


if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
    -- Load resources here
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
    love.window.setMode(800, 600, {resizable=true})
    love.window.setTitle("Hello World")
    MyLocator = Locator(100, 200)
end

function love.update(dt)
    -- Update logic here

end

function love.draw()
    love.graphics.print("Hello World", 400, 300)
    love.graphics.print("Hello World"..MyLocator.x, 600, 300)
end





local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end