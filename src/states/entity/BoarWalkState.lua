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
  if self.entity.type == 'boar' then
    if self.entity.direction == 'down' then
      self.entity.y = self.entity.y + self.entity.walkSpeed * dt
      --self.entity.dx = 0
      self.entity:changeAnimation('walk-down')
    elseif self.entity.direction == 'up' then
      self.entity.y = self.entity.y - self.entity.walkSpeed * dt
      --self.entity.dx = 0
      self.entity:changeAnimation('walk-up')
    elseif self.entity.direction == 'left' then
      self.entity.x = self.entity.x - self.entity.walkSpeed * dt
      --self.entity.dy = 0
      self.entity:changeAnimation('walk-left')
    elseif self.entity.direction == 'right' then
      self.entity.x = self.entity.x + self.entity.walkSpeed * dt
      --self.entity.dy = 0
      self.entity:changeAnimation('walk-right')
    end
  end

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
 
  if self.entity.direction == 'up' then
    if self.entity.y <= destinationNodeY then
      self.entity.x, self.entity.y = destinationNodeX, destinationNodeY
      self.entity:updatePath()
      self.entity:calculateDirection()
    end
  elseif self.entity.direction == 'down' then
    if self.entity.y >= destinationNodeY then
      self.entity.x, self.entity.y = destinationNodeX, destinationNodeY
      self.entity:updatePath()
      self.entity:calculateDirection()
    end
  elseif self.entity.direction == 'left' then
    if self.entity.x <= destinationNodeX then
      self.entity.x, self.entity.y = destinationNodeX, destinationNodeY
      self.entity:updatePath()
      self.entity:calculateDirection()
    end
  elseif self.entity.direction == 'right' then
    if self.entity.x >= destinationNodeX then
      self.entity.x, self.entity.y = destinationNodeX, destinationNodeY
      self.entity:updatePath()
      self.entity:calculateDirection()
    end
  end

  -- if destinationNodeX == self.entity.nearestTileColumn + 1 then
  --   self.entity.direction = 'right'
  -- end
  -- if destinationNode:getX() == self.entity.nearestTileColumn - 1 then
  --   self.entity.direction = 'left'
  -- end
  -- if destinationNode:getY() == self.entity.nearestTileRow - 1 then
  --   self.entity.direction = 'up'
  -- end
  -- if destinationNode:getY() == self.entity.nearestTileRow + 1 then
  --   self.entity.direction = 'down'
  -- end

  -- local tashio = player
  -- local velocity = .5
  -- if self.entity.corrupted then
  --   --TRACK PLAYERS X POSITION
  --   if self.entity.aiPath == 1 then
  --     if self.entity.x > tashio.x + 2 then
  --       self.entity.direction = 'left'
  --     elseif self.entity.x + 2 < tashio.x then
  --       self.entity.direction = 'right'
  --     elseif self.entity.y > tashio.y then
  --       self.entity.direction = 'up'
  --     elseif self.entity.y < tashio.y then
  --       self.entity.direction = 'down'
  --     end
  --
  --   --TRACK PLAYERS Y POSITION
  --   elseif self.entity.aiPath == 2 then
  --     if self.entity.y > tashio.y + 2 then
  --       self.entity.direction = 'up'
  --     elseif self.entity.y + 2 < tashio.y then
  --       self.entity.direction = 'down'
  --     elseif self.entity.x > tashio.x then
  --       self.entity.direction = 'left'
  --     elseif self.entity.x < tashio.x then
  --       self.entity.direction = 'right'
  --     end
  --   end
  -- end

  -- if self.entity.x > tashio.x - 2 and self.entity.x + self.entity.width < tashio.x + tashio.width + 2 then
  --   self.entity.axisAligned = true
  -- elseif self.entity.y > tashio.y - 2 and self.entity.y + self.entity.height < tashio.y + tashio.height + 2 then
  --   self.entity.axisAligned = true
  -- else
  --   self.entity.axisAligned = false
  -- end
  --
  -- if self.entity.axisAligned then
  --   self.entity.walkSpeed = 50
  -- else
  --   self.entity.walkSpeed = self.entity.originalWalkSpeed
  -- end
end

function BoarWalkState:render()
  local anim = self.entity.currentAnimation
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
  self.entity.x, self.entity.y)
  love.graphics.print(tostring(self.entity.destinationNodeIndex), self.entity.x, self.entity.y)
end
