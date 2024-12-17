TreasureChest = Class{}

function TreasureChest:init(tileX, tileY, contents, dialogueBox)
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
    self.contents = contents
end

function TreasureChest:openChest()
    self.showOffItem = true
    self.opened = true
    self.image = treasureChestOpen
    gPlayer:changeAnimation('showOff')
end

function TreasureChest:reset()
    self.opened = false
    self.image = treasureChestClosed
end

function TreasureChest:update(dt)

end

function TreasureChest:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.setColor(WHITE)
    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    love.graphics.draw(self.image, self.x, self.y)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
    if self.showOffItem then
        if self.contents == 'coin' then
            love.graphics.draw(coin, gPlayer.x + 4, gPlayer.y - 10)
        end
    end
end
