PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player, scene)
    self.player = player
    self.scene = scene
    PLAYER_STATE = 'WALK'
end

function PlayerWalkState:update(dt)
    if not self.player.falling and not luteState then
        if #OUTPUT_LIST > 0 then
            self.player.direction = OUTPUT_LIST[#OUTPUT_LIST]
            self.player:changeAnimation('walk-' .. tostring(OUTPUT_LIST[#OUTPUT_LIST]))
        end
        if #TOUCH_OUTPUT_LIST > 0 then
            self.player.direction = TOUCH_OUTPUT_LIST[#TOUCH_OUTPUT_LIST]
            self.player:changeAnimation('walk-' .. tostring(TOUCH_OUTPUT_LIST[#TOUCH_OUTPUT_LIST]))
        end

        self.player.walkSpeed = PLAYER_WALK_SPEED

        if #OUTPUT_LIST == 2 then
            self.player.walkSpeed = (math.sqrt(2) / 2) * PLAYER_WALK_SPEED
        end
        if #TOUCH_OUTPUT_LIST == 2 then
            self.player.walkSpeed = (math.sqrt(2) / 2) * PLAYER_WALK_SPEED
        end

        for key, value in ipairs(OUTPUT_LIST) do
            if value == 'left' then
                self.player.x = math.max(self.player.x - self.player.walkSpeed * dt, -SIDE_EDGE_BUFFER_PLAYER)
            elseif value == 'right' then
                self.player.x = math.min(self.player.x + self.player.walkSpeed * dt, VIRTUAL_WIDTH - self.player.width + SIDE_EDGE_BUFFER_PLAYER)
            elseif value == 'down' then
                self.player.y = math.min(self.player.y + self.player.walkSpeed * dt, SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER - self.player.height)
            elseif value == 'up' then
                self.player.y = math.max(self.player.y - self.player.walkSpeed * dt, -SIDE_EDGE_BUFFER_PLAYER)
            end
        end
        for key, value in ipairs(TOUCH_OUTPUT_LIST) do
            if value == 'left' then
                self.player.x = math.max(self.player.x - self.player.walkSpeed * dt, -SIDE_EDGE_BUFFER_PLAYER)
            elseif value == 'right' then
                self.player.x = math.min(self.player.x + self.player.walkSpeed * dt, VIRTUAL_WIDTH - self.player.width + SIDE_EDGE_BUFFER_PLAYER)
            elseif value == 'down' then
                self.player.y = math.min(self.player.y + self.player.walkSpeed * dt, SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER - self.player.height)
            elseif value == 'up' then
                self.player.y = math.max(self.player.y - self.player.walkSpeed * dt, -SIDE_EDGE_BUFFER_PLAYER)
            end
        end

        --TRIGGER IDLE
        if #OUTPUT_LIST == 0 and #TOUCH_OUTPUT_LIST == 0 then
            self.player.animations['walk-' .. tostring(self.player.direction)]:refresh()
            self.player:changeAnimation('idle-' .. tostring(self.player.direction))
        end
        if #TOUCH_OUTPUT_LIST == 0 and #OUTPUT_LIST == 0 then
            self.player.animations['walk-' .. tostring(self.player.direction)]:refresh()
            self.player:changeAnimation('idle-' .. tostring(self.player.direction))
        end
    end

  if sceneView.player.falling then
    sceneView.player:changeAnimation('falling')
  end

end

function PlayerWalkState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    --love.graphics.print('timer: ' .. tostring(self.player.animations['walk-down'].timer), 5, 55)
    if not self.player.falling then
        if self.player.blueTunicEquipped then
            love.graphics.draw(gTextures['character-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        elseif self.player.redTunicEquipped then
            love.graphics.draw(gTextures['character-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        elseif self.player.greenTunicEquipped then
            love.graphics.draw(gTextures['character-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        elseif self.player.yellowTunicEquipped then
            love.graphics.draw(gTextures['character-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        end
    else
        if self.player.blueTunicEquipped then
            love.graphics.draw(gTextures['character-fall-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        elseif self.player.redTunicEquipped then
            love.graphics.draw(gTextures['character-fall-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        elseif self.player.greenTunicEquipped then
            love.graphics.draw(gTextures['character-fall-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        elseif self.player.yellowTunicEquipped then
            love.graphics.draw(gTextures['character-fall-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        end
    end

    if self.player.fireSpellEquipped then
        love.graphics.setColor(gKeyItemInventory.elementColor)
        love.graphics.draw(gTextures['character-element'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    end

    love.graphics.setColor(WHITE)
    if gItemInventory.itemSlot[1] ~= nil then
        if gItemInventory.itemSlot[1].type == 'lute' and not self.player.falling then
            love.graphics.draw(gTextures['lute-equip'], gFrames['lute-equip'][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        end
    end
end
