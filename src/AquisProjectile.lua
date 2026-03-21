AquisProjectile = Class{}

function AquisProjectile:init()
  self.xOffset = 0
  self.yOffset = 0
  self.nearestTileRow = 0
  self.nearestTileColumn = 0
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
end

function AquisProjectile:render()
  love.graphics.setColor(WHITE)
  love.graphics.print('nearestRow: ' .. self.nearestTileRow, 0, 0)
  love.graphics.print('nearestCol: ' .. self.nearestTileColumn, 0, 10)
  love.graphics.print(Inspect(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects), 0, 20)

  for k, v in pairs(sceneView.currentMap.collidableMapObjects) do
    love.graphics.setColor(RED)
    love.graphics.rectangle('fill', v.x, v.y, TILE_SIZE, TILE_SIZE)
  end
  --NEAREST TILE
  love.graphics.setColor(0,0,255/255,1)
  love.graphics.rectangle('fill', self.nearestTileColumn + self.xOffset, self.nearestTileRow + self.yOffset, TILE_SIZE, TILE_SIZE)

  --SPELL PROJECTILE
  love.graphics.setColor(GREEN)
  --love.graphics.rectangle('fill', gPlayer.x + self.xOffset, gPlayer.y + self.yOffset, TILE_SIZE, TILE_SIZE)
  love.graphics.circle('fill', gPlayer.x + (TILE_SIZE / 2) + self.xOffset, gPlayer.y + (TILE_SIZE / 2) + self.yOffset, TILE_SIZE / 2)
end
