NPCWalkState = Class{__includes = BaseState}

function NPCWalkState:init(entity)
    self.entity = entity
    self.entity.direction = entity.direction
end

function NPCWalkState:update(dt)
    if self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt
        self.entity:changeAnimation('walk-down')
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - self.entity.walkSpeed * dt
        self.entity:changeAnimation('walk-up')
    elseif self.entity.direction == 'left' then
        self.entity.x = self.entity.x - self.entity.walkSpeed * dt
        self.entity:changeAnimation('walk-left')
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + self.entity.walkSpeed * dt
        self.entity:changeAnimation('walk-right')
    end
end

function NPCWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))
end
