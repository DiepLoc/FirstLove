FaceToFaceTeleportState = BaseState:extend()

function FaceToFaceTeleportState:new(parentState, targetPosition)
    self.parentState = parentState or NullState()
    self.targetPos = targetPosition
    self.remainingTeleportWaitTime = 0
end

function FaceToFaceTeleportState:update(subject, dt)
    local player = MyLocator.gameObjectManager.player

    if not player then return self.parentState end

    local playerCenter = player.positionComp.displayRect:getCenter()
    local subjectCenter = subject.positionComp.displayRect:getCenter()
    local distance, dxVal, dyVal = CommonHelper.getDistance(playerCenter.x, playerCenter.y, subjectCenter.x,
        subjectCenter.y)
    local vector = playerCenter - subjectCenter

    if self.remainingTeleportWaitTime <= 0 and dyVal < Constants.ENDERMAN_TELEPORT_MAX_Y and dxVal > Constants.ENDERMAN_TELEPORT_MIN_X
        and (player.positionComp.lastDirection == "right" and vector.x < 0 or player.positionComp.lastDirection == "left" and vector.x > 0) then
        self:softTeleport(subject, playerCenter)
        self.remainingTeleportWaitTime = 3
    else
        self:simpleTracking(subject, vector, dxVal, dyVal)
    end

    self.remainingTeleportWaitTime = self.remainingTeleportWaitTime - dt

    return nil
end

function FaceToFaceTeleportState:softTeleport(subject, targetPosition)
    local targetTile = CommonHelper.getTilePos(targetPosition)
    for x = -4, 4 do
        if math.abs(x) >= 2 then
            for y = -3, 3 do
                local success = subject:onTeleport(targetTile.x + x, targetTile.y + y)
                if success then
                    break
                end
            end
        end
    end
end

return FaceToFaceTeleportState
