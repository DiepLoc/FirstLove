-- Load the Object system
Object = require "classic"

-- Load utils
Vector2 = require "utils.vector2"
Rectangle = require "utils.rectangle"

-- Load components
--- states
BaseState = require "components.states.baseState"
MoveState = require "components.states.moveState"
FlyState = require "components.states.flyState"
NullState = require "components.states.nullState"

--- info
BaseInfo = require "components.infoItems.baseInfo"
WaterInfo = require "components.infoItems.waterInfo"
CommonCharInfo = require "components.infoItems.commonCharInfo"

--- components
Sprite = require "components.sprite"
AnimComp = require "components.animComp"
PositionComp = require "components.positionComp"
StateComp = require "components.stateComp"
InfoComp = require "components.infoComp"

-- common
GameObject = require "gameObject"
DrawHelper = require "drawHelper"
Constants = require "constants"
Factory = require "gameObjectFactory"
CommonHelper = require "commonHelper"


-- (add more classes here when you have new ones)

-- Optionally print to confirm loading
print("All classes loaded!")
