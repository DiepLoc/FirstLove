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
    dmgBlock = "dmgBlock",
    bowAttack = "bowAttack",
    swordAttack = "swordAttack",
    eyeAtEnd = "eyeAtEnd",
    eyeBreak = "eyeBreak",
    shootFireball = "shootFireball",
    pickup = "pickup",
    dragonSong = "dragonSong"
}

local DmgSoundMapping = {
    [Constants.OBJ_NAME_PLAYER] = Sounds.dmgPlayer,
    [Constants.OBJ_NAME_ZOMBIE] = Sounds.dmgZombie,
    [Constants.OBJ_NAME_SKELETON] = Sounds.dmgSkeleton,
    [Constants.OBJ_NAME_CREEPER] = Sounds.dmgCreeper,
    [Constants.OBJ_NAME_ENDERMAN] = Sounds.dmgEnderman,
    [Constants.OBJ_NAME_ENDER_DRAGON] = Sounds.dmgEnderDragon,
    [Constants.OBJ_NAME_END_CRYSTAL] = Sounds.explosion,
}

function SoundManager:new()
    self.sounds = {
        [Sounds.eating] = self:getSourceByFile("McEatingSound"),
        -- [Sounds.dmgPlayer] = self:getSourceByFile("McTakeDmgSound"),
        [Sounds.dmgPlayer] = self:getSourceByFile("McDamagedPlayerSound"),
        [Sounds.dmgZombie] = self:getSourceByFile("McDamagedZombieSound"),
        [Sounds.dmgCreeper] = self:getSourceByFile("McDamagedCreeperSound"),
        [Sounds.dmgSkeleton] = self:getSourceByFile("McDamagedSkeletonSound"),
        [Sounds.dmgEnderman] = self:getSourceByFile("McDamagedEndermanSound", 0.3),
        [Sounds.dmgEnderDragon] = self:getSourceByFile("McDamagedEnderDragonSound"),
        [Sounds.enderDragonDie] = self:getSourceByFile("McEnderDragonDeathSound"),
        [Sounds.explosion] = self:getSourceByFile("McExplosionSound"),
        [Sounds.teleport] = self:getSourceByFile("McTeleportSound"),
        [Sounds.dmgBlock] = self:getSourceByFile("McDamagedBlockSound"),
        [Sounds.bowAttack] = self:getSourceByFile("McBowSound"),
        [Sounds.swordAttack] = self:getSourceByFile("McSwordSound"),
        [Sounds.eyeAtEnd] = self:getSourceByFile("McEyeAtEndSound"),
        [Sounds.eyeBreak] = self:getSourceByFile("McEyeBreakSound"),
        [Sounds.shootFireball] = self:getSourceByFile("McEnderDragonShootFireballSound"),
        [Sounds.pickup] = self:getSourceByFile("McPickupSound"),
        [Sounds.dragonSong] = self:getSongByFile("Battle Of The Beast - The Soundings", 0.2),
    }

    return self
end

function SoundManager:getSourceByFile(name, volume)
    local source = love.audio.newSource("assets/sounds/" .. name .. ".wav", "static")
    source:setVolume(volume or 1)
    return source
end

function SoundManager:getSongByFile(name, volume)
    local source = love.audio.newSource("assets/sounds/" .. name .. ".mp3", "stream")
    source:setVolume(volume or 1)
    source:setLooping(true)
    return source
end

function SoundManager:playSound(name)
    love.audio.stop(self.sounds[name])
    love.audio.play(self.sounds[name])
end

function SoundManager:stop(name)
    love.audio.stop(self.sounds[name])
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

    if event == Constants.EVENT_GAMEOBJ_DESTROYED and data.name == Constants.OBJ_NAME_END_CRYSTAL and not Constants.TURN_OFF_BOSS_MUSIC then
        self:playSound(Sounds.dragonSong)
    end

    if event == Constants.EVENT_GAMEOBJ_DESTROYED and data.name == Constants.OBJ_NAME_ENDER_DRAGON then
        self:playSound(Sounds.enderDragonDie)
        self:stop(Sounds.dragonSong)
    end

    if event == Constants.EVENT_PlAYER_SPAWN then
        self:playSound(Sounds.teleport)
    end

    if event == Constants.EVENT_EXPLODE then
        self:playSound(Sounds.explosion)
    end

    if event == Constants.EVENT_TELEPORT then
        self:playSound(Sounds.teleport)
    end

    if event == Constants.EVENT_DAMAGED_BLOCK or event == Constants.EVENT_PLACE_BLOCK then
        self:playSound(Sounds.dmgBlock)
    end

    if event == Constants.EVENT_PICKUP_ITEM then
        self:playSound(Sounds.pickup)
    end

    if event == Constants.EVENT_ATTACK_ACTION then
        local weapon = data
        if weapon.weaponType == Constants.WEAPON_TYPE_MELEE_2D then
            self:playSound(Sounds.swordAttack)
        end
        if weapon.weaponType == Constants.WEAPON_TYPE_RANGE then
            self:playSound(Sounds.bowAttack)
        end
    end

    if event == Constants.EVENT_EYE_OF_ENDER_USE then
        self:playSound(Sounds.bowAttack)
    end

    if event == Constants.EVENT_EYE_REACHED then
        self:playSound(Sounds.eyeAtEnd)
    end

    if event == Constants.EVENT_EYE_BREAK then
        self:playSound(Sounds.eyeBreak)
    end

    if event == Constants.EVENT_SHOOT_FIREBALL then
        self:playSound(Sounds.shootFireball)
    end
end

return SoundManager
