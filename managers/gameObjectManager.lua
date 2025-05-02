require "managers.baseManager"

---@class GameObjectManager
GameObjectManager = BaseManager:extend()

function GameObjectManager:new()
    self.gameObjects = {}

    return self
end

function GameObjectManager:onSetup()
    self.player = Factory.getChar(1, 0)
    table.insert(self.gameObjects, self.player)
    local objs = GameObjectFactory.generateTerrain(100, 40, 0.1, 0, 20)
    for _, v in pairs(objs) do
        table.insert(self.gameObjects, v)
    end
end

function GameObjectManager:getObjByName(objName)
    local objs = {}
    for _, gameObject in pairs(self.gameObjects) do
        if gameObject.name == objName then
            table.insert(objs, gameObject)
        end
    end
    return objs
end

function GameObjectManager:getObjByCondition(func)
    local objs = {}
    for _, gameObject in pairs(self.gameObjects) do
        if func(gameObject) then
            table.insert(objs, gameObject)
        end
    end
    return objs
end

function GameObjectManager:update(dt)
    for i = #self.gameObjects, 1, -1 do
        self.gameObjects[i]:update(dt)
        if self.gameObjects[i].isDestroyed then
            table.remove(self.gameObjects, i)
        end
    end
end

function GameObjectManager:draw()
    for i = #self.gameObjects, 1, -1 do
        self.gameObjects[i]:draw()
    end
end

return GameObjectManager
