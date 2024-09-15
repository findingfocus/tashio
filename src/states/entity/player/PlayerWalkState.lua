PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player, scene)
    self.player = player
    self.scene = scene
    PLAYER_STATE = 'WALK'
end

function PlayerWalkState:update(dt)
    if not self.player.falling then
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
        --]]

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
    --[[INPUT REHAUL
    if not sceneView.player.falling then
        if #INPUT_LIST == 4 then
            self.player.direction = INPUT_LIST[#INPUT_LIST]
            self.player:changeAnimation('idle-' .. tostring(INPUT_LIST[#INPUT_LIST]))
        end

        if #INPUT_LIST == 2 then
            self.player.walkSpeed = (math.sqrt(2) / 2) * PLAYER_WALK_SPEED
        else
            self.player.walkSpeed = PLAYER_WALK_SPEED
        end

        if love.keyboard.isDown('left') then
            if love.keyboard.isDown('right') then
                self.player:changeAnimation('idle-' .. tostring(self.player.direction))
            else
                if #INPUT_LIST == 3 then
                    self.player.direction = INPUT_LIST[#INPUT_LIST]
                    self.player:changeAnimation('idle-' .. tostring(INPUT_LIST[#INPUT_LIST]))
                    --self.player:changeAnimation('walk-left')
                else
                    self.player.x = math.max(self.player.x - self.player.walkSpeed * dt, -SIDE_EDGE_BUFFER_PLAYER)
                    self.player.direction = 'left'
                end
            end
        end
        if love.keyboard.isDown('right') then
            if love.keyboard.isDown('left') then
                self.player:changeAnimation('idle-' .. tostring(self.player.direction))
            else
                if #INPUT_LIST == 3 then
                    self.player.direction = INPUT_LIST[#INPUT_LIST]
                    self.player:changeAnimation('idle-' .. tostring(INPUT_LIST[#INPUT_LIST]))
                    --self.player:changeAnimation('walk-right')
                else
                    self.player.x = math.min(self.player.x + self.player.walkSpeed * dt, VIRTUAL_WIDTH -self.player.width + SIDE_EDGE_BUFFER_PLAYER)
                    self.player.direction = 'right'
                end
            end
        end
        if love.keyboard.isDown('up') then
            if love.keyboard.isDown('down') then
                self.player:changeAnimation('idle-' .. tostring(self.player.direction))
            else
                if #INPUT_LIST == 3 then
                    self.player.direction = INPUT_LIST[#INPUT_LIST]
                    self.player:changeAnimation('idle-' .. tostring(INPUT_LIST[#INPUT_LIST]))
                    --self.player:changeAnimation('walk-up')
                else
                    self.player.y = math.max(self.player.y - self.player.walkSpeed * dt, -SIDE_EDGE_BUFFER_PLAYER)
                    self.player.direction = 'up'
                end
            end
        end
        if love.keyboard.isDown('down') then
            if love.keyboard.isDown('up') then
                self.player:changeAnimation('idle-' .. tostring(self.player.direction))
            else
                if #INPUT_LIST == 3 then
                    self.player.direction = INPUT_LIST[#INPUT_LIST]
                    self.player:changeAnimation('idle-' .. tostring(INPUT_LIST[#INPUT_LIST]))
                else
                    self.player.direction = 'down'
                    self.player.y = math.min(self.player.y + self.player.walkSpeed * dt, SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER - self.player.height)
                end
            end
        end

        if #INPUT_LIST == 0 then
            self.player.animations['walk-down']:refresh()
            self.player.animations['walk-up']:refresh()
            self.player.animations['walk-left']:refresh()
            self.player.animations['walk-right']:refresh()
            self.player:changeState('player-idle')
            self.player.x = math.floor(self.player.x)
            self.player.y = math.floor(self.player.y)
        end
    end

    --]]

  if sceneView.player.falling then
    sceneView.player:changeAnimation('falling')
  end

end

function PlayerWalkState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    --love.graphics.print('timer: ' .. tostring(self.player.animations['walk-down'].timer), 5, 55)
    if self.player.fireSpellEquipped then
        love.graphics.draw(gTextures['character-fireElement'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    end
end
