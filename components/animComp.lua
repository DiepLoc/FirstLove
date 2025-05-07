---@class AnimComp
AnimComp = Object:extend()

function AnimComp:new(currentAnimName, anim)
    self.anims = {}
    self:addAnim(currentAnimName, anim)
    self.currentAnimName = currentAnimName
    self.isInsideScreen = true
    self.color = { 1, 1, 1, 1 }
    self.baseColor = { 1, 1, 1, 1 }
    return self
end

function AnimComp:addAnim(name, anim)
    self.anims[name] = anim
    return self
end

function AnimComp:getCurrentAnim()
    return self.anims[self.currentAnimName]
end

function AnimComp:setCurrentAnim(name)
    if self.anims[name] then
        if (self.currentAnimName ~= name) then
            self.currentAnimName = name
            self:getCurrentAnim():refresh()
        end
    else
        error("Animation " .. name .. " does not exist.")
    end
end

function AnimComp:update(subject, dt)
    local currentAnim = self:getCurrentAnim()
    currentAnim:update(dt)

    local lerpR = CommonHelper.lerpValue(self.color[1], self.baseColor[1], 0.05)
    local lerpG = CommonHelper.lerpValue(self.color[2], self.baseColor[2], 0.05)
    local lerpB = CommonHelper.lerpValue(self.color[3], self.baseColor[3], 0.05)
    local lerpA = CommonHelper.lerpValue(self.color[4], self.baseColor[4], 0.05)
    self.color = { lerpR, lerpG, lerpB, lerpA }
    -- self.isInsideScreen = MyLocator.camera:worldToScreenOrNull(subject.positionComp.displayRect) ~= nil
end

function AnimComp:draw(positionComp)
    if not positionComp.isVisible then return end

    local currentAnim = self:getCurrentAnim()
    local displayRect = positionComp.displayRect
    -- local collisionRect = positionComp:getWorldCollisionRect()
    -- DrawHelper.drawRect(collisionRect.x, collisionRect.y, collisionRect.width, collisionRect.height)
    currentAnim:draw(displayRect.x, displayRect.y, displayRect.width, displayRect.height, self.color)
end

return AnimComp
