GameObject = Object:extend()

function GameObject:new(animComp, positionComp, stateComp, name)
  self.animComp = animComp
  self.positionComp = positionComp
  self.stateComp = StateComp(stateComp or NullState())
  self.isDestroyed = false
  self.name = name or "GameObject"
  return self
end

function GameObject:update(dt)
  self.stateComp:update(self, dt)
  self.animComp:update(dt)
  self.positionComp:update(dt)
end

function GameObject:draw()
  self.animComp:draw(self.positionComp)
  self.positionComp:draw()
  self.stateComp:draw()
end

return GameObject
