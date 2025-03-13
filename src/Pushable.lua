Pushable = Class{}

function Pushable:init(x, y, type, keyItem)
  self.tileX = x
  self.tileY = y
  self.originalTileX = x
  self.originalTileY = y
  self.x = (x * TILE_SIZE) - TILE_SIZE
  self.y = (y * TILE_SIZE) - TILE_SIZE
  self.originalX = self.x
  self.originalY = self.y
  self.width = TILE_SIZE
  self.height = TILE_SIZE
  self.keyItem = keyItem or nil
  self.classType = 'pushable'
  self.type = type
  self.originalHealth = 25
  self.health = self.originalHealth
  self.brokenCrate = false
  self.legalPushCheckRow = nil
  self.legalPushCheckColumn = nil
  self.scaleX = 1
  self.scaleY = 1
  self.falling = false
  self.fallen = false
  self.crateCompletelyBroken = false
  self.active = true
  if self.type == 'log' then
    self.image = log
  elseif self.type == 'boulder' then
    self.image = boulder
  elseif self.type == 'crate' then
    self.image = crate
    self.animations = self:createAnimations(ENTITY_DEFS['crate'].animations)
    self:changeAnimation('defaultCrate')
  end
  self.pushUpInitiated = false
  self.timer = 0
end

function Pushable:createAnimations(animations)
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

function Pushable:changeAnimation(name)
  self.currentAnimation = self.animations[name]
end


function Pushable:resetOriginalPosition()
  if self.keyItem ~= true then
    self.x = self.originalX
    self.y = self.originalY
    self.scaleX = 1
    self.scaleY = 1
    self.tileX = self.originalTileX
    self.tileY = self.originalTileY
    self.falling = false
    self.fallen = false
    self.active = true
    self.brokenCrate = false
    self.health = self.originalHealth
  end
  if self.type == 'crate' then
    self.image = crate
    self.animations = self:createAnimations(ENTITY_DEFS['crate'].animations)
    self:changeAnimation('defaultCrate')
  end
end

function Pushable:pushUp()
  for k, v in pairs(OUTPUT_LIST) do
    if v == 'up' then
      self.pushUpInitiated = true
    end
  end
  for k, v in pairs(TOUCH_OUTPUT_LIST) do
    if v == 'up' then
      self.pushUpInitiated = true
    end
  end
end

function Pushable:pushDown()
  for k, v in pairs(OUTPUT_LIST) do
    if v == 'down' then
      self.pushDownInitiated = true
    end
  end
  for k, v in pairs(TOUCH_OUTPUT_LIST) do
    if v == 'down' then
      self.pushDownInitiated = true
    end
  end
end

function Pushable:pushLeft()
  for k, v in pairs(OUTPUT_LIST) do
    if v == 'left' then
      self.pushLeftInitiated = true
    end
  end
  for k, v in pairs(TOUCH_OUTPUT_LIST) do
    if v == 'left' then
      self.pushLeftInitiated = true
    end
  end
end

function Pushable:pushRight()
  for k, v in pairs(OUTPUT_LIST) do
    if v == 'right' then
      self.pushRightInitiated = true
    end
  end
  for k, v in pairs(TOUCH_OUTPUT_LIST) do
    if v == 'right' then
      self.pushRightInitiated = true
    end
  end
end

function Pushable:spellCollides(target)
  return not (self.x + self.width - COLLISION_BUFFER < target.x or self.x + COLLISION_BUFFER > target.x + target.width or
  self.y + self.height - COLLISION_BUFFER < target.y + FLAME_COLLISION_BUFFER or self.y + COLLISION_BUFFER > target.y + target.height)
end

function Pushable:breakCrate()
  self.brokenCrate = true
  --TODO ADD POTENTIAL OTHER ITEMS
  table.insert(MAP[sceneView.currentMap.row][sceneView.currentMap.column].coins, Coin())
  local index = #MAP[sceneView.currentMap.row][sceneView.currentMap.column].coins
  MAP[sceneView.currentMap.row][sceneView.currentMap.column].coins[index].x = self.x + 5
  MAP[sceneView.currentMap.row][sceneView.currentMap.column].coins[index].y = self.y + 7
  self:changeAnimation('breakCrate')
end

function Pushable:collides(x, y, target)
  if x < target.x + target.width and x + TILE_SIZE > target.x then
    if y < target.y + target.height and y + TILE_SIZE > target.y then
      return true
    end
  end
  return false
end

function Pushable:legalPush(row, col)
  self.legalPushCheckRow = row
  self.legalPushCheckColumn = col
  if row < 1 or row > 8 or col < 1 or col > 10 then
    return false
  end

  for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do
    if v.tileX == col and v.tileY == row then
      return false
    end
  end

  for k, npc in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].npc) do
    local pushableX = (col * TILE_SIZE) - TILE_SIZE
    local pushableY = (row * TILE_SIZE) - TILE_SIZE
    if self:collides(pushableX, pushableY, npc) then
      return false
    end
  end

  local tile = sceneView.currentMap.tiles[row][col]
  local aboveGround = sceneView.currentMap.aboveGroundTiles[row][col]
  local topLevel = sceneView.currentMap.topLevelTiles[row][col]

  if tile.id >= 97 and tile.id <= 256 then
    return false
  elseif aboveGround.id >= 97 and aboveGround.id <= 256 then
    return false
  elseif topLevel.id >= 97 and topLevel.id <= 256 then
    return false
  else
    return true
  end
end

function Pushable:update(dt)
  self.timer = self.timer + dt
  --IF ANIMATION
  ---[[
  if self.currentAnimation then
    self.currentAnimation:update(dt)
  end
  --]]



  if self.pushUpInitiated then
    local tileAbove = (self.tileY * TILE_SIZE) - TILE_SIZE * 2
    local tile = sceneView.currentMap.aboveGroundTiles[self.legalPushCheckRow][self.legalPushCheckColumn].id
    if self.y > tileAbove then
      self.y = self.y - PUSH_SPEED * dt
    else
      --CHASM DETECTION
      if tile >= CHASM_DEF_BEGIN + 2 and tile <= CHASM_DEF_END then
          self.falling = true
      end
      self.y = tileAbove
      self.pushUpInitiated = false
      self.tileY = self.tileY - 1
    end
  end

  if self.pushDownInitiated then
    local tileBelow = self.tileY * TILE_SIZE
    local tile = sceneView.currentMap.aboveGroundTiles[self.legalPushCheckRow][self.legalPushCheckColumn].id
    if self.y < tileBelow then
      self.y = self.y + PUSH_SPEED * dt
    else
      --CHASM DETECTION
      if tile >= CHASM_DEF_BEGIN + 2 and tile <= CHASM_DEF_END then
          self.falling = true
      end
      self.y = tileBelow
      self.pushDownInitiated = false
      self.tileY = self.tileY + 1
    end
  end

  if self.pushLeftInitiated then
    local tileLeft = (self.tileX * TILE_SIZE) - TILE_SIZE * 2
    local tile = sceneView.currentMap.aboveGroundTiles[self.legalPushCheckRow][self.legalPushCheckColumn].id
    if self.x > tileLeft then
      self.x = self.x - PUSH_SPEED * dt
    else
      --CHASM DETECTION
      if tile >= CHASM_DEF_BEGIN + 2 and tile <= CHASM_DEF_END then
          self.falling = true
      end
      self.x = tileLeft
      self.pushLeftInitiated = false
      self.tileX = self.tileX - 1
    end
  end

  if self.pushRightInitiated then
    local tileRight = self.tileX * TILE_SIZE
    local tile = sceneView.currentMap.aboveGroundTiles[self.legalPushCheckRow][self.legalPushCheckColumn].id
    if self.x < tileRight then
      self.x = self.x + PUSH_SPEED * dt
    else
      --CHASM DETECTION
      if tile >= CHASM_DEF_BEGIN + 2 and tile <= CHASM_DEF_END then
          self.falling = true
      end
      self.x = tileRight
      self.pushRightInitiated = false
      self.tileX = self.tileX + 1
    end
  end

  if self.falling then
    self.scaleX = math.max(0, self.scaleX - dt)
    self.scaleY = math.max(0, self.scaleY - dt)
    if self.scaleX == 0 then
      self.fallen = true
    end
  end
end

function Pushable:render(adjacentOffsetX, adjacentOffsetY)
  love.graphics.setColor(WHITE)
  self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
  --IF BOULDER OR LOG
  --love.graphics.draw(self.image, self.x, self.y)
  --IF CRATE
  if self.type == 'crate' then
    local anim = self.currentAnimation
    if self.falling then
      love.graphics.draw(self.image, self.x + 8, self.y + 8, 0, self.scaleX, self.scaleY, TILE_SIZE / 2, TILE_SIZE / 2)
      love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], self.x + 8, self.y + 8, 0, self.scaleX, self.scaleY, TILE_SIZE / 2, TILE_SIZE / 2)
    else
      love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], self.x, self.y)
    end
    --love.graphics.print(tostring(self.health), self.x, self.y)
  elseif self.type == 'boulder' then
    if self.falling then
      love.graphics.draw(self.image, self.x + 8, self.y + 8, 0, self.scaleX, self.scaleY, TILE_SIZE / 2, TILE_SIZE / 2)
    else
      love.graphics.draw(self.image, self.x, self.y)
    end
  end
  self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end
