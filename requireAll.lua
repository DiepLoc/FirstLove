-- Load the Object system
Object          = require "classic"

-- Load utils
Vector2         = require "utils.vector2"
Rectangle       = require "utils.rectangle"

-- Load components
--- states
BaseState       = require "components.states.baseState"
PlayerState     = require "components.states.playerState"
FlyState        = require "components.states.flyState"
NullState       = require "components.states.nullState"
ShortLifeState  = require "components.states.shortLifeState"
ActionState     = require "components.states.actionState"
SimpleAiState   = require "components.states.simpleAiState"

--- info
BaseInfo        = require "components.infoItems.baseInfo"
CommonBlockInfo = require "components.infoItems.commonBlockInfo"
CommonCharInfo  = require "components.infoItems.commonCharInfo"
DmgInfo         = require "components.infoItems.dmgInfo"

--- items
BaseInvItem     = require "components.items.baseInvItem"
WeaponItem      = require "components.items.weaponItem"

--- components
Sprite          = require "components.sprite"
AnimComp        = require "components.animComp"
PositionComp    = require "components.positionComp"
StateComp       = require "components.stateComp"
InfoComp        = require "components.infoComp"
InventoryComp   = require "components.inventoryComp"

-- common
GameObject      = require "gameObject"
DrawHelper      = require "drawHelper"
Constants       = require "constants"
Factory         = require "gameObjectFactory"
ItemFactory     = require "inventoryItemFactory"
CommonHelper    = require "commonHelper"


-- (add more classes here when you have new ones)

-- Optionally print to confirm loading
print("All classes loaded!")
