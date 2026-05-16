Entity = Class{}

particle = love.graphics.newImage('graphics/particle.png')
local FLASH_FREQUENCY = 0.12
local FLASH_DURATION = 0.4
local DAMAGE = 1

function Entity:init(def)
  self.x = def.x
  self.y = def.y
  self.dx = 0
  self.dy = 0
  self.dialogueBox = {}
  self.hit = false
  self.enemy = def.enemy or false
  self.width = def.width
  self.height = def.height
  self.darkBat = false or def.darkBat
  self.direction = def.direction or 'down'
  self.animations = self:createAnimations(def.animations)
  self.spawning = def.spawning or nil
  self.blocked = false
  self.flapTimer = 0
  self.flapThreshold = 0.5
  self.flapActive = false
  --self:changeAnimation('idle-down')
  self.spawnRow = def.spawnRow or nil
  self.spawnColumn = def.spawnColumn or nil
  self.originalSpawnRow = def.spawnRow or nil
  self.originalSpawnColumn = def.spawnColumn or nil
  self.health = def.health
  self.originalHealth = def.health
  self.corrupted = def.corrupted
  self.originalCorrupted = def.corrupted
  self.zigzagTime = def.zigzagTime or nil
  self.zigzagFrequency = def.zigzagFrequency or nil
  self.zigzagAmplitude = def.zigzagAmplitude or nil
  self.damageFlash = false
  self.damageFlashDuration = FLASH_DURATION
  self.damageFlashTimer = FLASH_FREQUENCY
  self.distanceToPlayer = 25
  self.displacementMagnitude = def.displacementMagnitude
  self.spawnTimer = def.spawnTimer or 0
  self.pursueTimer = 0
  self.pursueTrigger = def.pursueTrigger or 1.5
  self.originalSpawnTimer = def.spawnTimer or 0
  self.walkSpeed = def.walkSpeed
  self.originalWalkSpeed = def.walkSpeed
  self.aiPath = def.aiPath
  self.geckoCollideCount = 0
  self.splashed = false
  --self.walkSpeed = math.random
  self.offscreen = false
  self.psystem = love.graphics.newParticleSystem(particle, 400)


  self.offsetX = def.offsetX or 0
  self.offsetY = def.offsetY or 0
  self.type = def.type or nil
  if self.type == 'bat' then
    self.attackSpeed = def.attackSpeed or BAT_ATTACK_SPEED
  end
  if self.type == 'gecko' or self.type == 'geckoC' then
    self.psystem:setColors(GECKO_CORRUPTED_PARTICLE)
  end

  self.colorOption = 'corrupted'

  --ORIGINAL POSITION RESETS
  self.originalAnimations = self:createAnimations(def.animations)
  self.originalX = def.x
  self.originalY = def.y
  self.originalDirection = def.direction
  self.originalType = def.type
  self.splashed = false
  self.splashTimer = 0
  self.blueFlashing = false
  self.blueFlashTimer = 0

  self.aquisCollides = false
end

function Entity:resetOriginalPosition()
  self.x = self.originalX
  self.y = self.originalY
  self.health = self.originalHealth
  self.locationSet = false
  self.damageFlash = false
  self.flashing = false
  self.corrupted = true
  self.walkSpeed = self.originalWalkSpeed
  self.dx = 0
  self.dy = 0
  self.splashed = false
  self.splashTimer = 0
  self.blueFlashing = false
  self.blueFlashTimer = 0
  self.colorOption = 'corrupted'
  self.splashed = false

  self.aquisCollides = false
  if self.type == 'bat' then
    self:changeAnimation('pursue')
    self:changeState('bat-spawn')
    self.locationSet = false
    self.spawnTimer = self.originalSpawnTimer
    self.pursueTimer = 0
    self.flapActive = false
    --self.pursueTrigger = 1.5 + self.spawnTimer
  end
  if self.type == 'gecko' or self.type == 'geckoC' then
    self.direction = self.originalDirection
    self:changeState('entity-idle')
    self:changeAnimation('idle-right')
    self.animations = self:createAnimations(ENTITY_DEFS['geckoC'].animations)
    self.psystem:setColors(GECKO_CORRUPTED_PARTICLE)
  end
  self.type = self.originalType
  self.offscreen = false
  self.psystem:reset()
end

function Entity:createAnimations(animations)
  local animationsReturned = {}

  for k, animationsDef in pairs(animations) do
    animationsReturned[k] = Animation {
      texture = animationsDef.texture or 'entities',
      frames = animationsDef.frames,
      interval = animationsDef.interval,
      looping = animationsDef.looping
    }
  end
  return animationsReturned
end

function Entity:collides(target)
  return not (self.x + self.width - COLLISION_BUFFER < target.x or self.x + COLLISION_BUFFER > target.x + target.width or
  self.y + self.height - COLLISION_BUFFER < target.y or self.y + COLLISION_BUFFER > target.y + target.height)
end

function Entity:coinCollides(target)
  return not (self.x + self.width - COLLISION_BUFFER < target.x + 4 or self.x + COLLISION_BUFFER > target.x + target.width - 4 or
  self.y + self.height - COLLISION_BUFFER < target.y or self.y + COLLISION_BUFFER > target.y + target.height - 5)
end

function Entity:dialogueCollides(target)
  return not (self.dialogueBoxX + self.dialogueBoxWidth - COLLISION_BUFFER < target.x or self.dialogueBoxX + COLLISION_BUFFER > target.x + target.width or
  self.dialogueBoxY + self.dialogueBoxHeight - COLLISION_BUFFER < target.y or self.dialogueBoxY + COLLISION_BUFFER > target.y + target.height)
end

function Entity:fireSpellCollides(target)
  return not (self.x + self.width - COLLISION_BUFFER < target.x or self.x + COLLISION_BUFFER > target.x + target.width or
  self.y + self.height - COLLISION_BUFFER < target.y + FLAME_COLLISION_BUFFER or self.y + COLLISION_BUFFER > target.y + target.height)
end

function Entity:leftCollidesMapObject(target)
  return not (self.x + 1 > target.x + target.width or self.x + 3 < target.x or
  self.y + 8 > target.y + target.height or self.y + self.height - 2 < target.y)
end

function Entity:rightCollidesMapObject(target)
  return not (self.x + self.width - 3 > target.x + target.width or self.x + self.width - 1 < target.x or
  self.y + 8 > target.y + target.height or self.y + self.height - 2 < target.y)
end

function Entity:topCollidesMapObject(target)
  return not (self.x + 3 > target.x + target.width or self.x + self.width - 3 < target.x or
  self.y + 6 > target.y + target.height or self.y + 8 < target.y)
end

function Entity:topCollidesWallObject(target)
  return not (self.x + 3 > target.x + target.width or self.x + self.width - 3 < target.x or
  self.y + 1 > target.y + target.height or self.y + 3 < target.y)
end

function Entity:leftCollidesWallObject(target)
  return not (self.x + 1 > target.x + target.width or self.x + 3 < target.x or
  self.y + 3 > target.y + target.height or self.y + self.height - 2 < target.y)
end

function Entity:rightCollidesWallObject(target)
  return not (self.x + self.width - 3 > target.x + target.width or self.x + self.width - 1 < target.x or
  self.y + 3 > target.y + target.height or self.y + self.height - 2 < target.y)
end

function Entity:bottomCollidesMapObject(target)
  return not (self.x + 3 > target.x + target.width or self.x + self.width - 3 < target.x or
  self.y + self.height - 2 > target.y + target.height or self.y + self.height < target.y)
end

function Entity:changeState(name)
  self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
  self.currentAnimation = self.animations[name]
end

function Entity:circleCollides(target)
  local castRadius = gPlayer.aquisProjectile.spellLevel
  local biggerX = math.max(self.x + 8, target.x)
  local smallerX = math.min(self.x + 8, target.x)
  local biggerY = math.max(self.y + 8, target.y)
  local smallerY = math.min(self.y + 8, target.y)
  local sideA = biggerX - smallerX
  local sideB = biggerY - smallerY
  local sideCSquared = (sideA * sideA) + (sideB * sideB)
  local sideC = math.sqrt(sideCSquared)
  if sideC <= castRadius + TILE_SIZE / 2 then
    --COLLIDE
    love.graphics.setColor(1,0,0,1)
    return true
  else
    --NOT COLLIDE
    love.graphics.setColor(0,0,1,1)
    return false
  end
end

function Entity:update(dt)
  if gPlayer.aquisCasting then
    self.aquisCollides = self:circleCollides(gPlayer.aquisProjectile)
  end
  local knockbackSpeed = SPELL_KNOCKBACK / 4
  --AQUIS TO PLAYER COLLISION
  if self.aquisCollides and self.type ~= 'player' then
    self.hit = true
    if gPlayer.aquisProjectile.direction == 'down' then
      self.dy = knockbackSpeed
    elseif gPlayer.aquisProjectile.direction == 'up' then
      self.dy = -knockbackSpeed
    elseif gPlayer.aquisProjectile.direction == 'left' then
      self.dx = -knockbackSpeed
    elseif gPlayer.aquisProjectile.direction == 'right' then
      self.dx = knockbackSpeed
    end
    self.splashed = true
    self.aquisCollides = false
    self.damageFlash = true
    self.splashTimer = 0
    --ADD SPLASH SOUND
  end

  --UNSPLASH
  local splashMax = 10
  if self.splashTimer > splashMax then
    self.splashTimer = 0
    self.splashed = false
    self.blueFlashing = false
    self.psystem:setParticleLifetime(1, 4)
    self.psystem:setColors(GECKO_CORRUPTED_PARTICLE)
    self.walkSpeed = self.originalWalkSpeed
  end

  if self.splashed then
    self.splashTimer = self.splashTimer + dt
    self.blueFlashTimer = self.blueFlashTimer + dt
    self.walkSpeed = 5
  end
  local flashSpeed = .2
  if self.blueFlashTimer > flashSpeed then
    self.blueFlashing = not self.blueFlashing
    self.blueFlashTimer = 0
  end

  --BAT FLAP
  if self.type == 'bat' then
    if self.flapActive then
      self.flapTimer = self.flapTimer + dt
    end
    if self.flapTimer > self.flapThreshold then
      self.flapTimer = 0
      sfx['bat-flap']:play()
    end
  end
  --[[
  if self.flapTimer > self.flapThreshold then
    self.flapTimer = 0
    sfx['bat-flap']:play()
  end
  if self.type == 'bat' then
    if self.stateName == 'spawn' then
      if self.spawning then
        if self.flapTimer > self.flapThreshold then
          self.flapTimer = 0
          sfx['bat-flap']:play()
        end
      end
    elseif self.stateName == 'pursue' or self.stateName == 'flee' then
      if self.flapTimer > self.flapThreshold then
        self.flapTimer = 0
        sfx['bat-flap']:play()
      end
    end
  end
  --]]

  if self.damageFlash then
    self.damageFlashTimer = self.damageFlashTimer - dt
    if self.damageFlashTimer <= 0 then
      self.flashing = not self.flashing
      self.damageFlashTimer = FLASH_FREQUENCY
    end
    self.damageFlashDuration = self.damageFlashDuration - dt
    if self.damageFlashDuration <= 0 then
      self.damageFlashDuration = FLASH_DURATION
      self.damageFlash = false
      self.flashing = false
    end
  end

  self.stateMachine:update(dt)

  if self.currentAnimation then
    self.currentAnimation:update(dt)
  end

  --GECKO PARTICLE SYSTEM
  --GECKO SPLASH
  if self.type == 'gecko' then
    if self.corrupted then
      self.psystem:moveTo(self.x + 8, self.y + 8)
      self.psystem:setParticleLifetime(1, 4)
      self.psystem:setEmissionArea('borderellipse', 2, 2)
      self.psystem:setEmissionRate(40)
      self.psystem:setTangentialAcceleration(0, 4)
      if self.splashed then
        self.psystem:setTangentialAcceleration(0, 3)
        self.psystem:setParticleLifetime(1, 3)
      else
        self.psystem:setColors(GECKO_CORRUPTED_PARTICLE)
        self.psystem:setTangentialAcceleration(2, 6)
      end
      self.psystem:update(dt)
    else
      self.psystem:update(dt)
    end
  end

  --SPELLCAST TO GECKO COLLISION
  if self.type == 'gecko' and successfulCast then
    for i = 1, sceneView.spellcastEntityCount do
      local spellX = sceneView.spellcastEntities[i].x
      local spellY = sceneView.spellcastEntities[i].y
      --ENTITY KNOCKBACK FOR SPELL COLLISIONS
      if self:fireSpellCollides(sceneView.spellcastEntities[i]) and not self.hit and self.corrupted then
        self.damageFlash = true
        self.health = math.max(0, self.health - DAMAGE)
        sounds['hurt']:play()
        sfx['fire-blast2']:play()
        if self.x > spellX then
          self.dx = SPELL_KNOCKBACK
        else
          self.dx = -SPELL_KNOCKBACK
        end
        if self.y > spellY then
          self.dy = SPELL_KNOCKBACK
        else
          self.dy = -SPELL_KNOCKBACK
        end
        self.hit = true
      end
    end
    --SPELLCAST TO BAT COLLISION
  elseif self.type == 'bat' and successfulCast then
    for i = 1, sceneView.spellcastEntityCount do
      local spellX = sceneView.spellcastEntities[i].x
      local spellY = sceneView.spellcastEntities[i].y
      --ENTITY KNOCKBACK FOR SPELL COLLISIONS
      if self:fireSpellCollides(sceneView.spellcastEntities[i]) and not self.hit and self.corrupted and not self.spawning then
        self.damageFlash = true
        self.health = math.max(0, self.health - DAMAGE)
        sfx['bat-damaged']:play()
        sfx['fire-blast2']:play()
        if self.x > spellX then
          self.dx = SPELL_KNOCKBACK
        else
          self.dx = -SPELL_KNOCKBACK
        end
        if self.y > spellY then
          self.dy = SPELL_KNOCKBACK
        else
          self.dy = -SPELL_KNOCKBACK
        end
        self.hit = true
      end
    end


  end

  --SHOULD NEST IN SELF.HIT? WAS CAUSING BUGS
  ---[[
  if self.hit then
    if self.dx > 0 then
      self.dx = math.max(0, self.dx - SLOW_TO_STOP * dt)
    end
    if self.dy > 0 then
      self.dy = math.max(0, self.dy - SLOW_TO_STOP * dt)
    end
    if self.dx < 0 then
      self.dx = math.min(0, self.dx + SLOW_TO_STOP * dt)
    end
    if self.dy < 0 then
      self.dy = math.min(0, self.dy + SLOW_TO_STOP * dt)
    end
    end
  --]]

  --self.x = self.x + self.dx * dt
  --self.y = self.y + self.dy * dt
  --
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if self.dx == 0 and self.dy == 0 then
    self.hit = false
  end

  self.dialogueBox.x = self.x
  self.dialogueBox.y = self.y
  ---[[


  --TODO
  if self.type == 'gecko' and self.corrupted then
    --BOUNDARY LIMIT ENTITY CLAMPING
    --TOP BOUNDARY
    if self.y <= -SIDE_EDGE_BUFFER_PLAYER then
      self.y = -SIDE_EDGE_BUFFER_PLAYER
    end

    --RIGHT BOUNDARY
    if self.x + self.width >= VIRTUAL_WIDTH + SIDE_EDGE_BUFFER_PLAYER then
      self.x = VIRTUAL_WIDTH + SIDE_EDGE_BUFFER_PLAYER - self.width
    end

    --BOTTOM BOUNDARY
    if self.y + self.height >= SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER then
      self.y = SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER - self.height
    end

    --LEFT BOUNDARY
    if self.x <= -SIDE_EDGE_BUFFER_PLAYER then
      self.x = -SIDE_EDGE_BUFFER_PLAYER
    end
  end


  --[[
  -EDGE_BUFFER
  --LEFT BOUNDARY
  -EDGE_BUFFER
  --RIGHT BOUNDARY
  VIRTUAL_WIDTH + EDGE_BUFFER_PLAYER
  --BOTTOM BOUNDARY
  SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER
  --]]
end

function Entity:processAI(params, dt, player)
  self.stateMachine:processAI(params, dt, player)
end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
  if self.type ~= 'spellcast' then
    if self.flashing then
      love.graphics.setColor(RED)
    else
      love.graphics.setColor(WHITE)
    end
  end

  self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
  --BLUE FLASHING
  if self.type ~= 'spellcast' then
    if self.blueFlashing then
      love.graphics.setColor(45/255,45/255,255/255,1)
      if self.type == 'player' then
        love.graphics.setColor(WHITE)
      end
    end
  end
  --love.graphics.setColor(230/255,20/255,20/255,1)
  if self.type == 'gecko' then
    love.graphics.setColor(WHITE)
    if self.stateMachine.current.stateName == 'flee' then
      love.graphics.setColor(1,1,1,self.stateMachine.current.alpha/255)
    end
    self.psystem:setColors(GECKO_CORRUPTED_PARTICLE)
    love.graphics.draw(self.psystem, math.floor(adjacentOffsetX), math.floor(adjacentOffsetY))
  end
  if self.type == 'gecko' then --IF TYPE HAS PARTICLE SYSTEM TODO
    if self.stateMachine.current.stateName == 'flee' then
      love.graphics.setColor(1,1,1,self.stateMachine.current.alpha/255)
    end
  end

  if self.type == 'gecko' then
    --CORRUPT
    if self.colorOption == 'corrupted' then
      local color = CORRUPT_GECKO_COLOR
      table.insert(color, 4, self.stateMachine.current.alpha/255)
      love.graphics.setColor(color)
    end
    if self.colorOption == 'cleansed' then
      --CLEANSED
      local color = CLEANSED_GECKO_COLOR
      table.insert(color, 4, self.stateMachine.current.alpha/255)
      love.graphics.setColor(color)
    end


    if self.splashed then
      local color = SPLASHED_GECKO_COLOR
      table.insert(color, 4, self.stateMachine.current.alpha/255)
      love.graphics.setColor(color)
    elseif not self.damageFlash and not self.colorOption == 'cleansed' then
      local color = CORRUPTED_GECKO_COLOR
      table.insert(color, 4, self.stateMachine.current.alpha/255)
      love.graphics.setColor(color)
    end

    if self.damageFlash then
      if self.flashing then
      local color = DAMAGED_GECKO_COLOR
      table.insert(color, 4, self.stateMachine.current.alpha/255)
      love.graphics.setColor(color)
      else
      local color = SPLASHED_GECKO_COLOR
      table.insert(color, 4, self.stateMachine.current.alpha/255)
      love.graphics.setColor(color)
      end
    end
  end

  self.stateMachine:render()

  --GECKO DEBUG
  --love.graphics.print(tostring(self.hit), self.x + 12, self.y)
  --love.graphics.print(tostring(self.dy), self.x + 12, self.y + 10)
  self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)

  --love.graphics.setColor(0,1,0,1)
  --love.graphics.circle('line', self.x + 8, self.y + 8, TILE_SIZE / 2)

  --love.graphics.circle('line', self.x, self.y, TILE_SIZE / 2)
  --CIRCLE COLLISION
  --
  -- if gPlayer.aquisCasting then
  --   local aquisCollides = self:circleCollides(gPlayer.aquisProjectile)
  --   if aquisCollides then
  --     love.graphics.setColor(1,0,0,1)
  --   else
  --     love.graphics.setColor(0,0,1,1)
  --   end
  -- end
end
