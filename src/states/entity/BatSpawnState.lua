BatSpawnState = Class{__includes = BaseState}

function BatSpawnState:init(entity, spawnRow, spawnColumn)
  self.entity = entity
  self.stateName = 'spawn'
  self.entity.spawning = false
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
  self.blocked = false

  self.moveDuration = 0
  self.movementTimer = 0

  self.collided = false
  self.entity.attackTimer = 0
  --self.entity.dx = -0.8
  --self.entity.pursueTrigger = 1.5 + self.entity.spawnTimer
end

function BatSpawnState:setBatLocation()
  if self.spawnRow == 1 then --TOP ENTRANCE
    self.entity.x = self.spawnColumn * TILE_SIZE - TILE_SIZE - 4
    self.entity.y = self.spawnRow * TILE_SIZE - TILE_SIZE - self.entity.height
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
    self.entity.x = self.spawnColumn * TILE_SIZE - TILE_SIZE - self.entity.width
    self.entity.y = self.spawnRow * TILE_SIZE - TILE_SIZE
    self.entity.dx = BAT_SPAWN_SPEED
  end
  self.entity.locationSet = true
  self.entity.pursueTimer = 0
end

function BatSpawnState:processAI(params, dt, player)
  if self.entity.spawnTimer <= 0 and not self.entity.locationSet then
    self:setBatLocation()
  end

  for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do
    if v.classType == 'pushable' then
      if self.entity.spawnRow == 1 then
        if v.y == TILE_SIZE and v.x == self.entity.spawnColumn * TILE_SIZE - TILE_SIZE then
          if v.active then
            self.entity.blocked = true
            break
          end
        else
          self.entity.blocked = false
        end
      elseif self.spawnRow == 8 then --BOTTOM ENTRANCE
        if v.y == TILE_SIZE * 6 and v.x == self.entity.spawnColumn * TILE_SIZE - TILE_SIZE then
          if v.active then
            self.entity.blocked = true
            break
          end
        else
          self.entity.blocked = false
        end
      elseif self.spawnColumn == 10 then --RIGHT SIDE ENTRANCE
        if v.y == self.entity.spawnRow * TILE_SIZE - TILE_SIZE and v.x == TILE_SIZE * 8 then
          if v.active then
            self.entity.blocked = true
            break
          end
        else
          self.entity.blocked = false
        end
      elseif self.spawnColumn == 1 then --LEFT SIDE ENTRANCE
        if v.y == self.entity.spawnRow * TILE_SIZE - TILE_SIZE and v.x == TILE_SIZE then
          if v.active then
            self.entity.blocked = true
            break
          end
        else
          self.entity.blocked = false
        end
      end
    end
  end

  if not self.entity.blocked then
    self.entity.spawnTimer = self.entity.spawnTimer - dt
  end

  if self.entity.spawnTimer <= 0 and not self.entity.blocked then
    self.entity.spawning = true
    self.entity.flapActive = true
    self.entity.pursueTimer = self.entity.pursueTimer + dt
  end

  if self.entity.spawning then
    if not self.entity.blocked then
      self.entity.y = self.entity.y + (self.entity.dy * self.entity.walkSpeed * dt)
      self.entity.x = self.entity.x + (self.entity.dx * self.entity.walkSpeed * dt)
    else
      self.entity.y = self.entity.y - (self.entity.dy * self.entity.walkSpeed * dt)
      self.entity.x = self.entity.x - (self.entity.dx * self.entity.walkSpeed * dt)
    end

    if self.entity.x > VIRTUAL_WIDTH or self.entity.x + self.entity.width < 0 or self.entity.y > VIRTUAL_HEIGHT or self.entity.y + self.entity.height < 0 then
      self:setBatLocation()
    end
  end

  if self.entity.pursueTimer > self.entity.pursueTrigger then
    self.entity.spawning = false
    self.entity:changeState('bat-walk')
  end

end

function BatSpawnState:update(dt)

end

function BatSpawnState:render()
  local anim = self.entity.currentAnimation
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
  self.entity.x, self.entity.y)
  --love.graphics.print(tostring(self.entity.stateMachine.current.stateName), self.entity.x, self.entity.y)
  --love.graphics.print(tostring(self.entity.spawnTimer), 0,0)
end
