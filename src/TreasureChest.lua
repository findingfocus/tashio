TreasureChest = Class{}

function TreasureChest:init(tileX, tileY)
    self.tileX = tileX
    self.tileY = tileY
    self.x = (tileX * TILE_SIZE) - TILE_SIZE
    self.y = (tileY * TILE_SIZE) - TILE_SIZE
    self.width = TILE_SIZE
    self.height = TILE_SIZE
    self.opened = false
    self.image = treasureChestClosed
    --self.contents
end

function TreasureChest:update(dt)

end

function TreasureChest:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.setColor(WHITE)
    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    love.graphics.draw(self.image, self.x, self.y)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end
