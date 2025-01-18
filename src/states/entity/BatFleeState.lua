BatFleeState = Class{__includes = BaseState}

function BatFleeState:init(entity)
    self.entity = entity
    self.fleeTable = {20, -20}
    self.dx = 0
    self.dy = 0
    self.walkSpeed = 0
    self.randomIndex1 = math.random(1, 2)
    self.randomIndex2 = math.random(1, 2)
    self.stateName = 'flee'
    self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['bat'])
    sounds['cleanse']:play()
    self.entity.damageFlash = true
    self.corrupted = false
end

function BatFleeState:processAI(params, dt, player)

end

function BatFleeState:update(dt)
    self.dx = 0
    self.dy = 0
end

function BatFleeState:render()
    love.graphics.setColor(WHITE)
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.entity.x, self.entity.y)
    self.entity.y = self.entity.y - self.entity.displacementY
    self.entity.x = self.entity.x - self.entity.displacementX

    love.graphics.print('dx: ' .. tostring(self.entity.dx), 0, 0)
    love.graphics.print('dy: ' .. tostring(self.entity.dy), 0, 10)
end
