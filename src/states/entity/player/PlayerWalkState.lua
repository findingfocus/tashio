PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player, room)
    self.player = player
    self.room = room
end

function PlayerWalkState:update(dt)
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

    --EntityWalkState.update(self, dt)

    --ADD COLLISION DETECTION
    --ADD EVENT DISPATCH FOR SHIFTING SCREENS
end

function PlayerWalkState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x), math.floor(self.player.y))
end
