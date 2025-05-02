require "managers.baseManager"
---@class ImageManager
ImageManager = BaseManager:extend()

function ImageManager:new()
    self.images = {
        block = love.graphics.newImage("assets/images/yellowBlock.png"),
        general = love.graphics.newImage("assets/images/MinecraftContent.png"),
        characters = love.graphics.newImage("assets/images/MinecraftChars.png"),
    }
    return self
end

function ImageManager:getImage(name)
    return self.images[name]
end

return ImageManager
