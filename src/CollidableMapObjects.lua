CollidableMapObjects = Class{}

function CollidableMapObjects:init(row, column, x, y, width, height)
  self.x = x or TILE_SIZE * column - TILE_SIZE
  self.y = y or TILE_SIZE * row - TILE_SIZE
  self.width = width or TILE_SIZE
  self.height = height or TILE_SIZE
end

function CollidableMapObjects:update(dt)

end

function CollidableMapObjects:render()
  --[[
  love.graphics.setColor(RED)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  --]]
end
