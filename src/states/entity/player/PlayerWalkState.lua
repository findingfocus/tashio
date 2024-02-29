PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player, room)
    self.player = player
    self.room = room
    needsRefresh = false
end

function PlayerWalkState:update(dt)
    ---[[
    if #INPUT_LIST == 2 then
        self.player.walkSpeed = math.sqrt(2) / 2
    else
        self.player.walkSpeed = PLAYER_WALK_SPEED
    end

    if love.keyboard.isDown('left') then
        if love.keyboard.isDown('right') then
            self.player:changeAnimation('idle-' .. tostring(self.player.direction))
        else
            self.player.x = math.max(self.player.x - self.player.walkSpeed, -EDGE_BUFFER_KVOTHE)
            self.player.direction = 'left'
            if #INPUT_LIST == 3 then
                self.player:changeAnimation('walk-left')
            end
        end
    end
    if love.keyboard.isDown('right') then
        if love.keyboard.isDown('left') then
            self.player:changeAnimation('idle-' .. tostring(self.player.direction))
        else
            self.player.x = math.min(self.player.x + self.player.walkSpeed, VIRTUAL_WIDTH -self.player.width + EDGE_BUFFER_KVOTHE)
            self.player.direction = 'right'
            if #INPUT_LIST == 3 then
                self.player:changeAnimation('walk-right')
            end
        end
    end
    if love.keyboard.isDown('up') then
        if love.keyboard.isDown('down') then
            self.player:changeAnimation('idle-' .. tostring(self.player.direction))
        else
            self.player.y = math.max(self.player.y - self.player.walkSpeed, -EDGE_BUFFER_KVOTHE)
            self.player.direction = 'up'
            if #INPUT_LIST == 3 then
                self.player:changeAnimation('walk-up')
            end
        end
    end
    if love.keyboard.isDown('down') then
        if love.keyboard.isDown('up') then
            self.player:changeAnimation('idle-' .. tostring(self.player.direction))
        else
            self.player.direction = 'down'
            self.player.y = math.min(self.player.y + self.player.walkSpeed, SCREEN_HEIGHT_LIMIT - self.player.height)
            if #INPUT_LIST == 3 then
                self.player:changeAnimation('walk-down')
            end
        end
    end
    --[[
    self.player.direction = INPUT_LIST[#INPUT_LIST]
    --]]

    --[[
    --MULTIPLE INPUT HANDLING
    if love.graphics.isDown('left') and love.graphics.isDown('right') then

    end
    --]]

    ---[[

    if #INPUT_LIST == 0 then
            self.player.animations['walk-down']:refresh()
            self.player.animations['walk-up']:refresh()
            self.player.animations['walk-left']:refresh()
            self.player.animations['walk-right']:refresh()
            self.player:changeState('idle')
            self.player.x = math.floor(self.player.x)
            self.player.y = math.floor(self.player.y)
    end
    --]]


    --[[
    if love.keyboard.isDown('left') then
        self.player.direction = 'left'
    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
    elseif love.keyboard.isDown('up') then
        self.player.direction = 'up'
    elseif love.keyboard.isDown('down') then
        self.player.direction = 'down'
    else
        self.player:changeState('idle')
    end

    --WORK ON THIS NEXT
    if self.player.direction == 'down' then
        self.player.y = self.player.y + self.player.walkSpeed--ADD WALK SPEED
    elseif self.player.direction == 'up' then
        self.player.y = self.player.y - self.player.walkSpeed--ADD WALK SPEED
    elseif self.player.direction == 'left' then
        self.player.x = self.player.x - self.player.walkSpeed
    elseif self.player.direction == 'right' then
        self.player.x = self.player.x + self.player.walkSpeed
    end
    --]]

    --EntityWalkState.update(self, dt)

    --ADD COLLISION DETECTION
    --ADD EVENT DISPATCH FOR SHIFTING SCREENS
end

function PlayerWalkState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x), math.floor(self.player.y))
    --love.graphics.print('timer: ' .. tostring(self.player.animations['walk-down'].timer), 5, 55)
end
