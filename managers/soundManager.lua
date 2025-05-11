---@class SoundManager
SoundManager = BaseManager:extend()

local Sounds = {
    eating = "eating",
    dmgPlayer = "dmgPlayer",
    dmgZombie = "dmgZombie",
    dmgCreeper = "dmgCreeper",
    dmgSkeleton = "dmgSkeleton",
    dmgEnderman = "dmgEnderman",
    dmgEnderDragon = "dmgEnderDragon",
    enderDragonDie = "enderDragonDie",
    explosion = "explosion",
    teleport = "teleport",
}

local DmgSoundMapping = {
    [Constants.OBJ_NAME_PLAYER] = Sounds.dmgPlayer,
    [Constants.OBJ_NAME_ZOMBIE] = Sounds.dmgZombie,
    [Constants.OBJ_NAME_SKELETON] = Sounds.dmgSkeleton,
    [Constants.OBJ_NAME_CREEPER] = Sounds.dmgCreeper,
    [Constants.OBJ_NAME_ENDERMAN] = Sounds.dmgEnderman,
    [Constants.OBJ_NAME_ENDER_DRAGON] = Sounds.dmgEnderDragon,
}

function SoundManager:new()
    self.sounds = {
        [Sounds.eating] = self:getSourceByFile("McEatingSound"),
        -- [Sounds.dmgPlayer] = self:getSourceByFile("McTakeDmgSound"),
        [Sounds.dmgPlayer] = self:getSourceByFile("McDamagedSkeletonSound"),
        [Sounds.dmgZombie] = self:getSourceByFile("McDamagedZombieSound"),
        [Sounds.dmgCreeper] = self:getSourceByFile("McDamagedCreeperSound"),
        [Sounds.dmgSkeleton] = self:getSourceByFile("McDamagedSkeletonSound"),
        [Sounds.dmgEnderman] = self:getSourceByFile("McDamagedEndermanSound"),
        [Sounds.dmgEnderDragon] = self:getSourceByFile("McDamagedEnderDragonSound"),
        [Sounds.enderDragonDie] = self:getSourceByFile("McEnderDragonDieSound"),
        [Sounds.explosion] = self:getSourceByFile("McExplosionSound"),
        [Sounds.teleport] = self:getSourceByFile("McTeleportSound"),
    }

    return self
end

function SoundManager:getSourceByFile(name)
    return love.audio.newSource("assets/sounds/" .. name .. ".wav", "static")
end

function SoundManager:playSound(name)
    love.audio.stop(self.sounds[name])
    love.audio.play(self.sounds[name])
end

function SoundManager:onNotify(event, data)
    if event == Constants.EVENT_EATING then
        self:playSound(Sounds.eating)
    end

    if event == Constants.EVENT_DAMAGED_OBJECT then
        local obj = data

        local sound = DmgSoundMapping[obj.name]
        self:playSound(sound)
    end

    if event == Constants.EVENT_PlAYER_SPAWN then
        self:playSound(Sounds.teleport)
    end
end

return SoundManager
