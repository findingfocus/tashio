GeckoWalkState = Class{__includes = BaseState}

function GeckoWalkState:init(entity, scene)
  self.entity = entity
  if self.entity.corrupted and self.entity.type == 'gecko' then
    self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['geckoC'].animations)
  end
  self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
  --self.entity.walkSpeed = .5
  self.scene = scene

  self.moveDuration = 0
  self.movementTimer = 0

  self.collided = false
  self.stateName = 'walk'
  self.alpha = 255
  --self.entity.psystem:setColors(GECKO_CORRUPTED_PARTICLE)
end

function GeckoWalkState:update(dt)
  if self.entity.corrupted then
    if self.entity.health <= 0 then
      sfx['cleanse']:play()
      self.entity.damageFlash = false
      self.entity.flashing = false
      self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['gecko'].animations)
      local random = math.random(4)
      self.entity.direction = sceneView.possibleDirections[random]
      self.entity.corrupted = false
      self.entity:changeState('gecko-flee')
      self.entity.colorOption = 'cleansed'
      self.entity.splashed = false
      self.entity.walkSpeed = self.entity.originalWalkSpeed
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

function GeckoWalkState:processAI(params, dt, player)
  --START HERE, ENSURE WHEN DESTINATION NODE INDEX 1  WE CAN STILL TRACK DESTINATION NODE AS STARTING LOCATION
  local destinationNode = self.entity.pathNodes[self.entity.destinationNodeIndex]

  if destinationNode == nil then return end

  local destinationNodeX = destinationNode:getX() * TILE_SIZE - TILE_SIZE
  local destinationNodeY = destinationNode:getY() * TILE_SIZE - TILE_SIZE
 
  local node1X = self.entity.pathNodes[self.entity.destinationNodeIndex]:getX() * TILE_SIZE - TILE_SIZE
  local node1Y = self.entity.pathNodes[self.entity.destinationNodeIndex]:getY() * TILE_SIZE - TILE_SIZE

  -- local node1X
  -- local node1Y
  --
  -- if self.entity.destinationNodeIndex == 1 and self.entity.goingHome then
  --    node1X = self.entity.startingTileX * TILE_SIZE - TILE_SIZE
  --    node1Y = self.entity.startingTileY * TILE_SIZE - TILE_SIZE
  -- else
  --    node1X = self.entity.pathNodes[self.entity.destinationNodeIndex]:getX() * TILE_SIZE - TILE_SIZE
  --    node1Y = self.entity.pathNodes[self.entity.destinationNodeIndex]:getY() * TILE_SIZE - TILE_SIZE
  -- end

  local xDifference = node1X - self.entity.x
  local yDifference = node1Y - self.entity.y

  local axisPriority = ''

  if math.abs(xDifference) > math.abs(yDifference) then
    axisPriority = 'horizontal'
  else
    axisPriority = 'vertical'
  end

  if axisPriority == 'horizontal' then
    if xDifference >= 0 then
      self.entity:changeAnimation('walk-right')
    else
      self.entity:changeAnimation('walk-left')
    end
  elseif axisPriority == 'vertical' then
    if yDifference <= 0 then
      self.entity:changeAnimation('walk-up')
    else
      self.entity:changeAnimation('walk-down')
    end
  end

  --16 makes 20 walkSpeed fastish, and 3 walkspeed slow
  local distance = math.sqrt((xDifference * xDifference + yDifference * yDifference) / ((self.entity.walkSpeed / 16)))
  local step = self.entity.originalWalkSpeed * dt

  if distance > step then
    self.entity.x = self.entity.x + (xDifference / distance) * step
    self.entity.y = self.entity.y + (yDifference / distance) * step
  else
    --INCREMENT DESTINATION NODE INDEX
    self.entity.destinationNodeIndex =  self.entity.destinationNodeIndex + 1
  end


end

function GeckoWalkState:render()
  local anim = self.entity.currentAnimation
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
  self.entity.x, self.entity.y)
  --DIALOGUE HITBOX RENDERS
  --[[
  love.graphics.setColor(RED)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 8, 32, 16, 16)
  love.graphics.setColor(WHITE)
  --]]

  --HEALTH BARS
  ---[[
  if self.entity.type == 'gecko' then
    ---[[
    --love.graphics.setColor(1,0,0,1)
    --love.graphics.rectangle('fill', self.entity.x, self.entity.y - 1, self.entity.health * 5.3, 1)
    -- love.graphics.setColor(WHITE)
    -- love.graphics.print(self.entity.geckoCollideCount, self.entity.x, self.entity.y - 5)
    -- love.graphics.print(self.entity.aiPath, self.entity.x, self.entity.y + 5)
    --]]

    --[[
    love.graphics.setColor(WHITE)
    love.graphics.print('dx: ' .. self.entity.dx, self.entity.x, self.entity.y - 5)
    love.graphics.print('dy: ' .. self.entity.dy, self.entity.x, self.entity.y - 10)
    --]]
  end
  --]]
end
