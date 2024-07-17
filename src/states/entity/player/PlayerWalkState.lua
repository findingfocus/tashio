PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player, scene)
    self.player = player
    self.scene = scene
    PLAYER_STATE = 'WALK'
end

function PlayerWalkState:update(dt)
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

function PlayerWalkState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x), math.floor(self.player.y))
    --love.graphics.print('timer: ' .. tostring(self.player.animations['walk-down'].timer), 5, 55)
end
