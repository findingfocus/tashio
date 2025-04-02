Entity = Class{}

particle = love.graphics.newImage('graphics/particle.png')
local FLASH_FREQUENCY = 0.08
local FLASH_DURATION = 0.85
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
  --self.walkSpeed = math.random
  self.offscreen = false
  self.psystem = love.graphics.newParticleSystem(particle, 400)


  self.offsetX = def.offsetX or 0
  self.offsetY = def.offsetY or 0
  self.type = def.type or nil
  if self.type == 'bat' then
    self.attackSpeed = def.attackSpeed or BAT_ATTACK_SPEED
  end

  --ORIGINAL POSITION RESETS
  self.originalAnimations = self:createAnimations(def.animations)
  self.originalX = def.x
  self.originalY = def.y
  self.originalDirection = def.direction
  self.originalType = def.type
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
  if self.type == 'bat' then
    self:changeAnimation('pursue')
    self:changeState('bat-spawn')
    self.locationSet = false
    self.spawnTimer = self.originalSpawnTimer
    self.pursueTimer = 0
    --self.pursueTrigger = 1.5 + self.spawnTimer
  end
  if self.type == 'gecko' or self.type == 'geckoC' then
    self.direction = self.originalDirection
    self:changeState('entity-idle')
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

function Entity:update(dt)
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
  if self.type == 'gecko' then
    if self.corrupted then
      self.psystem:moveTo(self.x + 8, self.y + 8)
      self.psystem:setParticleLifetime(1, 4)
      self.psystem:setEmissionArea('borderellipse', 2, 2)
      self.psystem:setEmissionRate(40)
      self.psystem:setTangentialAcceleration(0, 4)
      self.psystem:setColors(67/255, 25/255, 36/255, 255/255, 25/255, 0/255, 51/255, 0/255)
      self.psystem:update(dt)
    else
      self.psystem:reset()
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
        sounds['hurt']:play()
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

  if self.type == 'gecko' then --IF TYPE HAS PARTICLE SYSTEM TODO
    love.graphics.draw(self.psystem, math.floor(adjacentOffsetX), math.floor(adjacentOffsetY))
  end

  self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
  self.stateMachine:render()
  self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end
