---@class GameObject
GameObject = Object:extend()

function GameObject:new(animComp, positionComp, stateComp, name)
  ---@type AnimComp
  self.animComp = animComp
  ---@type PositionComp
  self.positionComp = positionComp
  ---@type StateComp
  self.stateComp = stateComp or nil
  ---@type InfoComp
  self.infoComp = InfoComp()
  self.collisionObjs = {}

  self.isDestroyed = false
  self.name = name or Constants.OBJ_NAME_OBJECT
  return self
end

function GameObject:update(dt)
  self.animComp:update(self, dt)
  if not self.animComp.isInsideScreen then return end
  if self.stateComp then
    self.stateComp:update(self, dt)
  end
  if self.infoComp then
    self.infoComp:update(self, dt)
  end

  self.positionComp:update(self, dt)
end

function GameObject:handleCollision(otherObj, dt)
  self.infoComp:handleCollision(self, otherObj, dt)
end

function GameObject:draw()
  if not self.animComp.isInsideScreen then return end

  self.animComp:draw(self.positionComp)
  if self.infoComp then
    self.infoComp:draw()
  end
  -- self.positionComp:draw()
  -- self.stateComp:draw()
end

return GameObject
