MoveState = BaseState:extend()

function MoveState:new()
    return self
end

function MoveState:update(subject, dt)
    local positionComp = subject.positionComp
    local newVelo = Vector2(0, 0)
    -- if love.keyboard.isDown("s") then
    --     newVelo.y = newVelo.y + 1
    -- end
    -- if love.keyboard.isDown("w") then
    --     newVelo.y = newVelo.y - 1
    -- end
    if love.keyboard.isDown("a") then
        newVelo.x = newVelo.x - 1
    end
    if love.keyboard.isDown("d") then
        newVelo.x = newVelo.x + 1
    end

    if positionComp.isGrounded and MyLocator:checkKeyPress("space", false) then
        positionComp:onJump(dt)
    end
    positionComp.velocity = newVelo


    --  anim
    if positionComp.velocity.x > 0 then
        subject.animComp:setCurrentAnim("run-right")
    elseif positionComp.velocity.x < 0 then
        subject.animComp:setCurrentAnim("run-left")
    elseif subject.positionComp.lastDirection == "right" then
        subject.animComp:setCurrentAnim("idle-right")
    else
        subject.animComp:setCurrentAnim("idle-left")
    end

    return nil
end

function MoveState:onStop()
    -- Handle any cleanup or state transition logic here
end

return MoveState
