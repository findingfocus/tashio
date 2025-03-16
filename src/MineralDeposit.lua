MineralDeposit = Class{}

function MineralDeposit:init(column, row, type)
  self.renderX = column * TILE_SIZE - TILE_SIZE
  self.renderY = row * TILE_SIZE - TILE_SIZE
  self.x = self.renderX + 7
  self.y = self.renderY + 3
  self.width = TILE_SIZE - 10
  self.height = TILE_SIZE - 10
  self.type = type
  if self.type == 'ruby' then
    self.image = unminedRuby
  end
  self.mined = false
end

function MineralDeposit:spellCollides(target)
  return not (self.x + self.width - COLLISION_BUFFER < target.x or self.x + COLLISION_BUFFER > target.x + target.width or
  self.y + self.height - COLLISION_BUFFER < target.y + FLAME_COLLISION_BUFFER or self.y + COLLISION_BUFFER > target.y + target.height)
end

function MineralDeposit:update(dt)

end

function MineralDeposit:render(adjacentOffsetX, adjacentOffsetY)
  love.graphics.setColor(WHITE)
   self.renderX, self.renderY = self.renderX + (adjacentOffsetX or 0), self.renderY + (adjacentOffsetY or 0)
   love.graphics.draw(self.image, self.renderX, self.renderY)
   self.renderX, self.renderY = self.renderX - (adjacentOffsetX or 0), self.renderY - (adjacentOffsetY or 0)
end
