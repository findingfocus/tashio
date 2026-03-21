AquisProjectile = Class{}

function AquisProjectile:init()
  self.xOffset = 0
  self.yOffset = 0
end

function AquisProjectile:update(dt)
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
  love.graphics.setColor(GREEN)
  --love.graphics.rectangle('fill', gPlayer.x + self.xOffset, gPlayer.y + self.yOffset, TILE_SIZE, TILE_SIZE)
  love.graphics.circle('fill', gPlayer.x + (TILE_SIZE / 2) + self.xOffset, gPlayer.y + (TILE_SIZE / 2) + self.yOffset, TILE_SIZE / 2)
end
