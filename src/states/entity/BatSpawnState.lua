BatSpawnState = Class{__includes = BaseState}

function BatSpawnState:init(entity, spawnRow, spawnColumn)
    self.entity = entity
    self.stateName = 'spawn'
    self.entity.spawning = true
    self.entity.originalWalkSpeed = entity.walkSpeed
    self.entity.walkSpeed = entity.walkSpeed * 2
    self.scene = scene
    self.spawnRow = spawnRow
    self.spawnColumn = spawnColumn
    self.entity.dx = 0
    self.entity.dy = 0
    self.entity.x = -32
    self.entity.y = -32
    self.entity.locationSet = false
    self.spawnRow = spawnRow
    self.spawnColumn = spawnColumn

    self.moveDuration = 0
    self.movementTimer = 0

    self.collided = false
    self.entity.attackTimer = 0
    --self.entity.dx = -0.8
    self.entity.spawnTimer = math.random(2, 7)
    self.pursueTimer = 0
    self.pursueTrigger = 1.5 + self.entity.spawnTimer
end

function BatSpawnState:setBatLocation()
    if self.spawnRow == 1 then --TOP ENTRANCE
        self.entity.x = self.spawnColumn * TILE_SIZE - TILE_SIZE - 4
        self.entity.y = self.spawnRow * TILE_SIZE - TILE_SIZE - TILE_SIZE
        self.entity.dy = BAT_SPAWN_SPEED
    elseif self.spawnColumn == 10 then --RIGHT SIDE ENTRANCE
        self.entity.x = self.spawnColumn * TILE_SIZE -TILE_SIZE + TILE_SIZE
        self.entity.y = self.spawnRow * TILE_SIZE - TILE_SIZE + 3
        self.entity.dx = -BAT_SPAWN_SPEED
    elseif self.spawnRow == 8 then --BOTTOM ENTRANCE
        self.entity.x = self.spawnColumn * TILE_SIZE - TILE_SIZE - 4
        self.entity.y = self.spawnRow * TILE_SIZE
        self.entity.dy = -BAT_SPAWN_SPEED
    elseif self.spawnColumn == 1 then --LEFT SIDE ENTRANCE
        self.entity.x = self.spawnColumn * TILE_SIZE - TILE_SIZE - 24
        self.entity.y = self.spawnRow * TILE_SIZE - TILE_SIZE
        self.entity.dx = BAT_SPAWN_SPEED
    end
end

function BatSpawnState:processAI(params, dt, player)
    self.entity.spawnTimer = self.entity.spawnTimer - dt
    if self.entity.spawnTimer <= 0 and not self.entity.locationSet then
        self:setBatLocation()
        self.entity.locationSet = true
    end

    self.pursueTimer = self.pursueTimer+ dt
    if self.pursueTimer > self.pursueTrigger then
        self.entity.spawning = false
        self.entity:changeState('bat-walk')
    end
    self.entity.y = self.entity.y + (self.entity.dy * self.entity.walkSpeed * dt)
    self.entity.x = self.entity.x + (self.entity.dx * self.entity.walkSpeed * dt)
end

function BatSpawnState:update(dt)

end

function BatSpawnState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.entity.x, self.entity.y)
        --love.graphics.print(tostring(self.entity.stateMachine.current.stateName), self.entity.x, self.entity.y)
end
