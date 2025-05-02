AnimComp = Object:extend()

function AnimComp:new(currentAnimName, anim)
    self.anims = {}
    self:addAnim(currentAnimName, anim)
    self.currentAnimName = currentAnimName
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

function AnimComp:update(dt)
    local currentAnim = self:getCurrentAnim()
    currentAnim:update(dt)
end

function AnimComp:draw(positionComp)
    if not positionComp.isVisible then return end

    local currentAnim = self:getCurrentAnim()
    local displayRect = positionComp.displayRect
    currentAnim:draw(displayRect.x, displayRect.y, displayRect.width, displayRect.height)
end

return AnimComp
