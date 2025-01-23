BatSpawnState = Class{__includes = BaseState}

function BatSpawnState:init(entity, scene)
    self.entity = entity
    self.stateName = 'spawn'
    self.entity.originalWalkSpeed = entity.walkSpeed
    self.scene = scene

    self.moveDuration = 0
    self.movementTimer = 0

    self.collided = false
    self.entity.attackTimer = 0
    self.entity.dx = -0.8
    self.pursueTimer = 0
    self.pursueTrigger = 4
end

function BatSpawnState:processAI(params, dt, player)
    self.pursueTimer = self.pursueTimer+ dt
    if self.pursueTimer > self.pursueTrigger then
        self.entity:changeState('bat-walk')
    end
    self.entity.x = self.entity.x + (self.entity.dx * self.entity.walkSpeed * dt)
end

function BatSpawnState:update(dt)

end

function BatSpawnState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.entity.x, self.entity.y)
        love.graphics.print(tostring(self.entity.stateMachine.current.stateName), self.entity.x, self.entity.y)
end
