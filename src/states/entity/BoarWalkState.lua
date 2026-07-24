BoarWalkState = Class{__includes = BaseState}

function BoarWalkState:init(entity, scene)
  self.entity = entity
  if self.entity.corrupted and self.entity.type == 'boar' then
    self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['boar'].animations)
  end
  self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
  --self.entity.walkSpeed = .5
  self.scene = scene

  self.moveDuration = 0
  self.movementTimer = 0

  self.collided = false
  self.stateName = 'walk'
  self.alpha = 255
  self.entity:updatePath()
  self.entity:calculateDirection()
end

function BoarWalkState:update(dt)
  --TRIGGER OFFSCREEN
  if self.entity.x + self.entity.width < -TILE_SIZE or self.entity.x > VIRTUAL_WIDTH + TILE_SIZE or self.entity.y + self.entity.height < -TILE_SIZE then
    --ADD IN BOTTOM RULE AS WELL
    self.entity.offscreen = true
  end
  if self.entity.y > SCREEN_HEIGHT_LIMIT then
    self.entity.offscreen = true
  end
end

function BoarWalkState:processAI(params, dt, player)
  local destinationNode = self.entity.pathNodes[self.entity.destinationNodeIndex]
  if destinationNode == nil then return end

  local destinationNodeX = destinationNode:getX() * TILE_SIZE - TILE_SIZE
  local destinationNodeY = destinationNode:getY() * TILE_SIZE - TILE_SIZE

  local node1X = self.entity.pathNodes[self.entity.destinationNodeIndex]:getX() * TILE_SIZE - TILE_SIZE
  local node1Y = self.entity.pathNodes[self.entity.destinationNodeIndex]:getY() * TILE_SIZE - TILE_SIZE

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

  local distance = math.sqrt(xDifference * xDifference + yDifference * yDifference)
  local step = self.entity.originalWalkSpeed * dt

  if distance > step then
    self.entity.x = self.entity.x + (xDifference / distance) * step
    self.entity.y = self.entity.y + (yDifference / distance) * step
  else
    self.entity.x = node1X
    self.entity.y = node1Y
    self.entity.offAxis = false
    self.entity.walkSpeed = self.entity.originalWalkSpeed
    self.entity:updatePath()
  end
end

function BoarWalkState:render()
  local anim = self.entity.currentAnimation
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
  self.entity.x, self.entity.y)
  love.graphics.print('nodeIndex: ' .. tostring(self.entity.destinationNodeIndex), self.x, self.y)
end
