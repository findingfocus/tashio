EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, scene)
    self.entity = entity
    self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    self.entity.walkSpeed = 1

    self.scene = scene

    self.moveDuration = 0
    self.movementTimer = 0

    self.collided = false
end

function EntityWalkState:update(dt)
    self.collided = false

    if self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.walkSpeed--ADD WALK SPEED
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - self.entity.walkSpeed--ADD WALK SPEED
    elseif self.entity.direction == 'left' then
        self.entity.x = self.entity.x - self.entity.walkSpeed
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + self.entity.walkSpeed
    end

    --TRIGGER OFFSCREEN
    if self.entity.x + self.entity.width < -TILE_SIZE or self.entity.x > VIRTUAL_WIDTH + TILE_SIZE or self.entity.y + self.entity.height < -TILE_SIZE then
        --ADD IN BOTTOM RULE AS WELL
       self.entity.offscreen = true
    end
    --[[
    if self.entity.y > SCREEN_HEIGHT_LIMIT then
        self.entity.offscreen = true
    end
    --]]

    --ADD COLLISION DETECTION AND RESET POSITIONS

end

function EntityWalkState:processAI(params, dt)
    local scene = params.room
    local directions = {'left', 'right', 'up', 'down'}

    if self.moveDuration == 0 or self.collided then

        self.moveDuration = math.random(5)
        self.entity.direction = directions[math.random(#directions)]
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0

        if math.random(3) == 1 then
            self.entity:changeState('entity-idle')
        else
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
            self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
        end
    end

    self.movementTimer = self.movementTimer + dt
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))
end




















