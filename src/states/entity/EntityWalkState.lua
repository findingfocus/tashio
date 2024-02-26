EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, scene)
    self.entity = entity
    self.entity:changeAnimation('walk-down')

    self.scene = scene

    self.moveDuration = 0
    self.movementTimer = 0

    self.collided = false
end

function EntityWalkState:update(dt)
    self.collided = false

    if self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt
    end
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
            self.entity:changeState('idle')
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
        self.entity.x, self.entity.y)
end




















