PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(entity)
    self.direction = 'down'
    self.entity = entity
    self.entity:changeAnimation('idle-' .. self.entity.direction)
    self.waitDuration = 0
    self.waitTimer = 0
    PLAYER_STATE = 'IDLE'
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
        love.keyboard.isDown('up') or love.keyboard.isDown('down') then
            self.entity:changeState('player-walk')
    end

    --DONT CHANGE TO WALK IF CONTRIDICTING INPUTS HELD
end

function PlayerIdleState:render()
    local anim = self.entity.currentAnimation

    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.entity.x, self.entity.y)
end
