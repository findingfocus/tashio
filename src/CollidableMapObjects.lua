CollidableMapObjects = Class{}

function CollidableMapObjects:init(row, column, width, height, xOffset, yOffset)
  self.x = TILE_SIZE * column - TILE_SIZE
  self.y = TILE_SIZE * row - TILE_SIZE
  self.width = width or TILE_SIZE
  self.height = height or TILE_SIZE
  self.xOffset = xOffset or nil
  self.yOffset = yOffset or nil
  if self.xOffset then
    self.x = self.x + self.xOffset
  end
  if self.yOffset then
    self.y = self.y + self.yOffset
  end
end

function CollidableMapObjects:update(dt)

end

function CollidableMapObjects:render()
  ---[[
  love.graphics.setColor(RED)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  --]]
end
