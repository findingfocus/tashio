AquisProjectile = Class{}

function AquisProjectile:init()
  self.xOffset = 0
  self.yOffset = 0
  self.nearestTileRow = 0
  self.nearestTileColumn = 0
  self.landingSpotX = 0
  self.landingSpotY = 0
  self.x = TILE_SIZE
  self.y = TILE_SIZE
end

function AquisProjectile:update(dt)
  self.nearestTileColumn = math.floor((gPlayer.x + 8) / TILE_SIZE)
  self.nearestTileRow = math.floor((gPlayer.y + 8) / TILE_SIZE)
  self.nearestTileRow = self.nearestTileRow * TILE_SIZE
  self.nearestTileColumn = self.nearestTileColumn * TILE_SIZE

  if gPlayer.direction == 'down' then
    self.yOffset = TILE_SIZE * 2
    self.xOffset = 0
  elseif gPlayer.direction == 'up' then
    self.yOffset = -TILE_SIZE * 2
    self.xOffset = 0
  elseif gPlayer.direction == 'left' then
    self.xOffset = -TILE_SIZE * 2
    self.yOffset = 0
  elseif gPlayer.direction == 'right' then
    self.xOffset = TILE_SIZE * 2
    self.yOffset = 0
  end

  for k, v in pairs(sceneView.currentMap.collidableMapObjects) do
    --LAND SPOT DEFAULTS TO TWO TILES AWAY
    if v.x == self.nearestTileColumn + self.xOffset and v.y == self.nearestTileRow + self.yOffset then
      if gPlayer.direction == 'right' then
        self.xOffset = TILE_SIZE
        for k, v in pairs(sceneView.currentMap.collidableMapObjects) do
          if v.x == self.nearestTileColumn + self.xOffset and v.y == self.nearestTileRow + self.yOffset then
            self.xOffset = 0
          end
        end
      elseif gPlayer.direction == 'left' then
        self.xOffset = -TILE_SIZE
        for k, v in pairs(sceneView.currentMap.collidableMapObjects) do
          if v.x == self.nearestTileColumn + self.xOffset and v.y == self.nearestTileRow + self.yOffset then
            self.xOffset = 0
          end
        end
      elseif gPlayer.direction == 'up' then
        self.yOffset = -TILE_SIZE
        for k, v in pairs(sceneView.currentMap.collidableMapObjects) do
          if v.x == self.nearestTileColumn + self.xOffset and v.y == self.nearestTileRow + self.yOffset then
            self.yOffset = 0
          end
        end
      elseif gPlayer.direction == 'down' then
        self.yOffset = TILE_SIZE
        for k, v in pairs(sceneView.currentMap.collidableMapObjects) do
          if v.x == self.nearestTileColumn + self.xOffset and v.y == self.nearestTileRow + self.yOffset then
            self.yOffset = 0
          end
        end
      end
    end
  end

  if gPlayer.aquisSuccessTimer == 0.5 then
    if not gPlayer.aquisCasting then
      gPlayer.aquisCasting = true
      self.x = gPlayer.x + TILE_SIZE / 2
      self.y = gPlayer.y + TILE_SIZE / 2
      self.landingSpotX = self.nearestTileColumn + self.xOffset + 8
      self.landingSpotY = self.nearestTileRow + self.yOffset + 8
    end
  end

  if gPlayer.aquisCasting and not gPlayer.aquisCastLanded then
    Timer.tween(0.25, {
      [self] = {x = self.landingSpotX, y = self.landingSpotY}
    })

    gPlayer.aquisCastingTimer = gPlayer.aquisCastingTimer + dt

    if gPlayer.aquisCastingTimer >= 0.25 then
      gPlayer.aquisCastLanded = true
      gPlayer.aquisCastingTimer = 0
      gPlayer.aquisCastLandedTimer = 0
    end
  end

  if gPlayer.aquisCastLanded then
    gPlayer.aquisCastLandedTimer = gPlayer.aquisCastLandedTimer + dt
    if gPlayer.aquisCastLandedTimer > 1 then
      gPlayer.aquisCasting = false
      gPlayer.aquisCastLanded = false
      gPlayer.aquisCastLandedTimer = 0
    end
  end
end

function AquisProjectile:render()
  --[[
  love.graphics.setColor(WHITE)
  love.graphics.print('nearestRow: ' .. self.nearestTileRow, 0, 0)
  love.graphics.print('nearestCol: ' .. self.nearestTileColumn, 0, 10)
  love.graphics.print(Inspect(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects), 0, 20)
  --]]

  for k, v in pairs(sceneView.currentMap.collidableMapObjects) do
    --love.graphics.setColor(RED)
    --love.graphics.rectangle('fill', v.x, v.y, TILE_SIZE, TILE_SIZE)
  end
  --NEAREST TILE TO PLAYER
  love.graphics.setColor(100,100,200,1)
  --love.graphics.rectangle('fill', self.nearestTileColumn, self.nearestTileRow, TILE_SIZE, TILE_SIZE)
  --BLUE SQUARE MAGIC LAND
  love.graphics.setColor(0,1,0,1)
  love.graphics.rectangle('fill', self.nearestTileColumn + self.xOffset, self.nearestTileRow + self.yOffset, TILE_SIZE, TILE_SIZE)

  --SPELL PROJECTILE
  if gPlayer.aquisCasting or gPlayer.aquisCastLanded then
    love.graphics.setColor(0,0,1,1)
    love.graphics.circle('fill', self.x, self.y, TILE_SIZE / 2)
    --love.graphics.circle('fill', gPlayer.x + (TILE_SIZE / 2) + self.xOffset, gPlayer.y + (TILE_SIZE / 2) + self.yOffset, TILE_SIZE / 2)
  end
end
