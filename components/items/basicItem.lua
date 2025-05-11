BasicItem = BaseInvItem:extend()

function BasicItem:new(name)
    BasicItem.super.new(self, name)
    return self
end

function BasicItem:onLeftAction(subject, data)
end

return BasicItem
