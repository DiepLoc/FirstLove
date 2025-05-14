-- Load the Object system
Object                  = require "classic"

-- Load utils
Vector2                 = require "utils.vector2"
Rectangle               = require "utils.rectangle"

-- common
GameObject              = require "gameObject"
DrawHelper              = require "drawHelper"
Constants               = require "constants"
Factory                 = require "gameObjectFactory"
ItemFactory             = require "inventoryItemFactory"
CommonHelper            = require "commonHelper"

-- Load components
--- states
BaseState               = require "components.states.baseState"
PlayerState             = require "components.states.playerState"
FlyState                = require "components.states.flyState"
NullState               = require "components.states.nullState"
ShortLifeState          = require "components.states.shortLifeState"
ActionState             = require "components.states.actionState"
SimpleAiState           = require "components.states.simpleAiState"
FaceToFaceTeleportState = require "components.states.faceToFaceTeleportState"
EnderEyeState           = require "components.states.enderEyeState"
DyingState              = require "components.states.dyingState"
CreeperState            = require "components.states.creeperState"
EnderDragonState        = require "components.states.enderDragonState"

--- info
BaseInfo                = require "components.infoItems.baseInfo"
CommonBlockInfo         = require "components.infoItems.commonBlockInfo"
CommonCharInfo          = require "components.infoItems.commonCharInfo"
DmgInfo                 = require "components.infoItems.dmgInfo"
LootInfo                = require "components.infoItems.lootInfo"
FireballInfo            = require "components.infoItems.fireballInfo"

--- items
BaseInvItem             = require "components.items.baseInvItem"
WeaponItem              = require "components.items.weaponItem"
BlockItem               = require "components.items.blockItem"
ConsumableItem          = require "components.items.consumableItem"
BasicItem               = require "components.items.basicItem"

--- components
Sprite                  = require "components.sprite"
AnimComp                = require "components.animComp"
PositionComp            = require "components.positionComp"
StateComp               = require "components.stateComp"
InfoComp                = require "components.infoComp"
InventoryComp           = require "components.inventoryComp"


-- (add more classes here when you have new ones)

-- Optionally print to confirm loading
print("All classes loaded!")
