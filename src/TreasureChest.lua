TreasureChest = Class{}

function TreasureChest:init(tileX, tileY, contents, dialogueBoxID)
  self.tileX = tileX
  self.tileY = tileY
  self.classType = 'treasureChest'
  self.x = (tileX * TILE_SIZE) - TILE_SIZE
  self.y = (tileY * TILE_SIZE) - TILE_SIZE
  self.width = TILE_SIZE
  self.height = TILE_SIZE
  self.opened = false
  self.image = treasureChestClosed
  self.active = true
  --self.dialogueBox = dialogueBox or nil
  self.dialogueBoxID = dialogueBoxID
  self.contents = contents
  if self.contents == 'coin' then
    self.treasureImage = love.graphics.newImage('graphics/coin.png')
  elseif self.contents == 'lute' then
    self.treasureImage = love.graphics.newImage('graphics/lute.png')
  elseif self.contents == 'tome1' then
    self.treasureImage = love.graphics.newImage('graphics/tome1.png')
  elseif self.contents == 'greenTunic' then
    self.treasureImage = love.graphics.newImage('graphics/greenTunicSolo.png')
  end
  self.treasureX = 0
  self.treasureY = 0
end

function TreasureChest:openChest()
  self.showOffItem = true
  self.opened = true
  self.image = treasureChestOpen
  if self.contents == 'tome1' then
    gPlayer.tome1Unlocked = true
  end

  self.treasureX = gPlayer.x + 4
  if self.contents == 'coin' then
    self.treasureY = gPlayer.y - 10
  elseif self.contents == 'lute' then
    self.treasureY = gPlayer.y - 14
  elseif self.contents == 'tome1' then
    self.treasureX = gPlayer.x + 3
    self.treasureY = gPlayer.y - 14
  elseif self.contents == 'greenTunic' then
    self.treasureX = gPlayer.x + 1
    self.treasureY = gPlayer.y - 12
  end

  sceneView.activeDialogueID = self.dialogueBoxID
  gStateMachine.current.activeDialogueID = self.dialogueBoxID

  MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[self.dialogueBoxID]:flushText()
  MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[self.dialogueBoxID].activated = true
  --sceneView.activeDialogueID = MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[self.dialogueID]
  PAUSED = true

  gPlayer:changeAnimation('showOff')
  gPlayer.showOff = true
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
    love.graphics.draw(self.treasureImage, self.treasureX, self.treasureY)
  end
end
