EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.direction = 'right'
    self.entity = entity
    self.waitDuration = 0
    self.waitTimer = 0
    if self.entity.corrupted and self.entity.type == 'gecko' then
        self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['geckoC'].animations)
    elseif not self.entity.corrupted and self.entity.type == 'gecko' then
        self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['gecko'].animations)
    end
    self.entity:changeAnimation('idle-' .. self.entity.direction)
end

function EntityIdleState:processAI(params, dt, player)
    if self.waitDuration == 0 then
        self.waitDuration = math.random(5)
    else
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration then
            self.entity:changeState('entity-walk')
        end
    end
end

function EntityIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))
end
