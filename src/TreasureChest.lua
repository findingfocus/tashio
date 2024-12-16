TreasureChest = Class{}

function TreasureChest:init(tileX, tileY, dialogueBox)
    self.tileX = tileX
    self.tileY = tileY
    self.classType = 'treasureChest'
    self.x = (tileX * TILE_SIZE) - TILE_SIZE
    self.y = (tileY * TILE_SIZE) - TILE_SIZE
    self.width = TILE_SIZE
    self.height = TILE_SIZE
    self.opened = false
    self.image = treasureChestClosed
    self.dialogueBox = dialogueBox
end

function TreasureChest:openChest()
    self.opened = true
    self.image = treasureChestOpen
end

function TreasureChest:update(dt)

end

function TreasureChest:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.setColor(WHITE)
    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    love.graphics.draw(self.image, self.x, self.y)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end
