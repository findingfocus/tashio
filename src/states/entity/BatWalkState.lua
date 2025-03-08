BatWalkState = Class{__includes = BaseState}

function BatWalkState:init(entity, scene)
  self.entity = entity
  self.stateName = 'pursue'
  --self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
  self.walkSpeed = entity.originalWalkSpeed
  self.scene = scene

  self.moveDuration = 0
  self.movementTimer = 0

  self.collided = false
  self.entity.attackTimer = 0
end

function getDistanceToPlayer(player, entity)
  local aLength, bLength, cLength, aSquared, bSquared, cSquared = 0, 0, 0, 0, 0, 0
  entity.distanceToPlayer = 0
  if math.abs(entity.x - player.x) <= 10 then
    if entity.y < player.y then
      --BOTTOM OF BAT to TOP OF PLAYER
      entity.distanceToPlayer = player.y - (entity.y + entity.height - 3)
    else
      --TOP OF BAT TO BOTTOM PLAYER
      entity.distanceToPlayer = entity.y - (player.y + player.height)
    end
  end
  if math.abs(entity.y - player.y) <= 10 then
    if entity.x < player.x then
      --RIGHT OF BAT TO LEFT OF PLAYER
      entity.distanceToPlayer = player.x - (entity.x + entity.width)
    else
      --LEFT OF BAT TO RIGHT OF PLAYER
      entity.distanceToPlayer = entity.x - (player.x + player.width)
    end
  end
  if entity.x < player.x then --BAT IS ON THE LEFT
    if entity.y < player.y then --BAT IS IN TOPLEFT
      --BR OF BAT to TL of PLAYER
      aLength = math.abs((entity.x + entity.width) - player.x - BAT_DISTANCE)
      bLength = math.abs((entity.y + entity.height) - player.y - BAT_DISTANCE)
    else --BAT IS IN BOTTOM LEFT
      --TR OF BAT to BL of PLAYER
      aLength = math.abs((entity.x + entity.width - BAT_DISTANCE) - player.x)
      bLength = math.abs(entity.y - (player.y + player.height - BAT_DISTANCE))
    end
  else --BAT IS ON THE RIGHT
    if entity.y < player.y then --BAT IS IN TOPRIGHT
      --BL OF BAT TO TR of PLAYER
      aLength = math.abs(entity.x - (player.x + player.width - BAT_DISTANCE))
      bLength = math.abs((entity.y + entity.height - BAT_DISTANCE) - player.y)
    else --BAT IS IN BOTTOM RIGHT
      --TL OF BAT TO BR of PLAYER
      aLength = math.abs(entity.x - (player.x + player.width - BAT_DISTANCE))
      bLength = math.abs(entity.y - (player.y + player.height - BAT_DISTANCE))
    end
  end

  aSquared = aLength * aLength
  bSquared = bLength * bLength
  cSquared = aSquared + bSquared
  cLength = math.sqrt(cSquared)
  if entity.distanceToPlayer == 0 then
    entity.distanceToPlayer = cLength
  end
end

function BatWalkState:update(dt)
  if self.entity.corrupted then
    if self.entity.health <= 0 then
      sounds['cleanse']:play()
      self.entity.damageFlash = false
      self.entity.flashing = false
      self.entity.corrupted = false
      self.entity:changeState('bat-flee')
    end
  end

  self.collided = false

  --TRIGGER OFFSCREEN
  if self.entity.x + self.entity.width < -TILE_SIZE or self.entity.x > VIRTUAL_WIDTH + TILE_SIZE or self.entity.y + self.entity.height < -TILE_SIZE then
    --ADD IN BOTTOM RULE AS WELL
    self.entity.offscreen = true
  end
  if self.entity.y > SCREEN_HEIGHT_LIMIT then
    self.entity.offscreen = true
  end
end


function BatWalkState:processAI(params, dt, player)
  getDistanceToPlayer(player, self.entity)
  if self.entity.distanceToPlayer < 13 then
    self.entity.walkSpeed = 0
    self.entity.attackTimer = self.entity.attackTimer + dt
    if self.entity.attackTimer > 2 then
      self.entity.attackTimer = 0
      table.insert(MAP[sceneView.currentMap.row][sceneView.currentMap.column].attacks, Spitball(self.entity))
    end
  else
    self.entity.walkSpeed = self.entity.originalWalkSpeed
  end
  self.entity.zigzagTime = self.entity.zigzagTime + self.entity.zigzagFrequency * dt

  if self.entity.health <= 0 then
    self.entity.hit = false
    self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['bat'])
    self.entity:changeState('bat-flee')
  end

  local dx = player.x - self.entity.x
  local dy = player.y - self.entity.y
  local distance =  math.sqrt(dx^2 + dy^2)

  if distance > 0 then
    dx = dx / distance
    dy = dy / distance
    if gPlayer.falling then
      self.entity.attackTimer = 0
      dy = -BAT_FLYBACK_SPEED * dt
      dx =  BAT_FLYBACK_SPEED * dt
    end
  end

  local offset = math.sin(self.entity.zigzagTime) * self.entity.zigzagAmplitude
  local offsetX = -dy * offset
  local offsetY = dx * offset


  self.entity.x = self.entity.x + (dx * self.entity.walkSpeed * dt) + offsetX
  self.entity.y = self.entity.y + (dy * self.entity.walkSpeed * dt) + offsetY

  getDistanceToPlayer(player, self.entity)
end

function BatWalkState:render()
  local anim = self.entity.currentAnimation
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
  self.entity.x, self.entity.y)
  --love.graphics.print(tostring(self.entity.stateMachine.current.stateName), self.entity.x, self.entity.y)
  --[[
  love.graphics.setColor(WHITE)
  love.graphics.print(tostring(self.entity.x), self.entity.x, self.entity.y - 5)
  --]]
end
