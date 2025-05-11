---@class BaseInvItem
BaseInvItem = Object:extend()

function BaseInvItem:new(name)
    self.name = name
    self.isStackable = false
    self.stack = 1
    return self
end

function BaseInvItem:setStackable()
    self.isStackable = true
    return self
end

function BaseInvItem:setStack(stack)
    self.stack = stack
    return self
end

function BaseInvItem:onStartAction(subject)

end

function BaseInvItem:onConsume()
    self.stack = self.stack - 1
end

function BaseInvItem:onSetup(image)
    self.image = image
    return self
end

function BaseInvItem:getLeftActionAnim()
    return nil
end

function BaseInvItem:onLeftAction(subject, data)
end

return BaseInvItem
