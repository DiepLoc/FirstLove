Sprite = Object:extend()

function Sprite:new(imageName, frameWidth, frameHeight, frameNum, row, fps, startColumn)
    self.imageName = imageName
    self.frameWidth = frameWidth or 16
    self.frameHeight = frameHeight or 16
    self.frames = {}
    self.isFlipX = false
    self.currentFrame = 1
    self.fps = fps
    self.remainingNextFrameTime = 1 / self.fps
    for i = 1, frameNum do
        local ind = i - 1 + (startColumn or 0)
        table.insert(self.frames, Rectangle(ind * frameWidth, row * frameHeight, frameWidth, frameHeight))
    end
end

function Sprite:setFlipX()
    self.isFlipX = true
    return self
end

function Sprite:refreshTime()
    self.remainingNextFrameTime = 1 / self.fps
end

function Sprite:getCurrentFrame()
    return self.frames[self.currentFrame]
end

function Sprite:update(dt)
    self.remainingNextFrameTime = self.remainingNextFrameTime - dt
    if (self.remainingNextFrameTime <= 0) then
        self:nextFrame()
        self:refreshTime()
    end
end

function Sprite:draw(x, y, width, height)
    local frame = self:getCurrentFrame()
    DrawHelper.drawImage(self.imageName, frame, Rectangle(x, y, width or self.frameWidth, height or self.frameHeight),
        nil, self.isFlipX, false)
end

function Sprite:nextFrame()
    self.currentFrame = self.currentFrame + 1
    if self.currentFrame > #self.frames then
        self.currentFrame = 1
    end
end

function Sprite:refresh()
    self.currentFrame = 1
    self:refreshTime()
end

return Sprite
