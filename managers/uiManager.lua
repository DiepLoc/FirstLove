---@class UiManager
UiManager = BaseManager:extend()

function UiManager:update(dt)

end

---@param player GameObject
function UiManager:showInventory(player)
    local items = player.inventoryComp.items
    local selectedInd = player.inventoryComp.currentItemIndex
    local anchor = Vector2(350, 720)
    local sourceBorderRect = Rectangle(3 * 16, 2 * 16, 16, 16)
    local displaySize = 48

    -- inventory background
    for i = 1, player.inventoryComp.maxSlots do
        local base0Ind = i - 1
        DrawHelper.drawRect(anchor.x + base0Ind * displaySize, anchor.y, displaySize, displaySize,
            { 0, 0, 0, 0.25 },
            true)
    end

    -- inventory items
    for ind, item in pairs(items) do
        local base0Ind = ind - 1
        local sprite = Constants.ITEM_IMAGE_MAPPING[item.name]
        local col = sprite[1]
        local row = sprite[2]
        local targetRect = Rectangle(anchor.x + base0Ind * displaySize, anchor.y, displaySize, displaySize)
        local sourceRect = Rectangle(col * 16, row * 16, 16, 16)
        DrawHelper.drawImage("general", sourceRect, targetRect, nil, false, false, true)
        if item.isStackable then
            DrawHelper.drawText(item.stack, targetRect.x + 2, targetRect.y + 2)
        end
    end

    -- inventory border
    for i = 1, player.inventoryComp.maxSlots do
        local base0Ind = i - 1
        local color = i ~= selectedInd and { 1, 1, 1, 1 } or { 0, 0, 1, 1 }
        local targetRect = Rectangle(anchor.x + base0Ind * displaySize, anchor.y, displaySize, displaySize)
        DrawHelper.drawImage("general", sourceBorderRect, targetRect, color, false, false, true)
    end
end

function UiManager:showPlayerHealth(player)
    local charInfo = player.infoComp:getInfo(CommonCharInfo)
    local playerHealth = charInfo.health
    local maxHealth = charInfo.maxHealth
    local ceilHealth = math.ceil(playerHealth)
    local anchor = Vector2(350, 690)
    local sourceRect = Rectangle(16, 16 * 2, 16, 16)
    local isHealing = charInfo:isHealing()
    for i = 1, ceilHealth do
        local opacity = i ~= ceilHealth and 1 or (1 - ceilHealth + playerHealth)
        local base0Ind = i - 1
        local targetRect = Rectangle(anchor.x + base0Ind * 24, anchor.y, 24, 24)
        DrawHelper.drawImage("general", sourceRect, targetRect, { 1, 1, 1, math.max(0.2, opacity) }, false, false, true)
    end

    if isHealing and playerHealth < maxHealth then
        local targetRect = Rectangle(anchor.x + (ceilHealth - 1) * 24, anchor.y - 24, 32, 32)
        local healSourceRect = Rectangle(16 * 7, 16 * 2, 16, 16)
        local seconds = love.timer.getTime()
        DrawHelper.drawImage("general", healSourceRect, targetRect,
            { 1, 1, 1, math.abs(seconds - math.floor(seconds) - 0.5) * 2 },
            false,
            false, true)
    end
end

function UiManager:showPlayerHunger(player)
    local playerHunger = player.infoComp:getInfo(CommonCharInfo).hunger
    local ceilHunger = math.ceil(playerHunger)
    local anchor = Vector2(830, 690)
    local soruceRect = Rectangle(16 * 2, 16 * 2, 16, 16)
    for i = 1, ceilHunger do
        local opacity = i ~= ceilHunger and 1 or (1 - ceilHunger + playerHunger)
        local base0Ind = i - 1
        local targetRect = Rectangle(anchor.x - 24 - base0Ind * 24, anchor.y, 24, 24)
        DrawHelper.drawImage("general", soruceRect, targetRect, { 1, 1, 1, math.max(0.2, opacity) }, false, false, true)
    end
end

function UiManager:draw()
    local player = MyLocator.gameObjectManager.player
    if not player then return end

    self:showPlayerHealth(player)
    self:showPlayerHunger(player)
    self:showInventory(player)
end

return UiManager
