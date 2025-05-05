DmgInfo = BaseInfo:extend()

function DmgInfo:new(damage, exploitDmg)
    self.damage = damage or 0
    self.exploitDmg = exploitDmg or 0
end

return DmgInfo
