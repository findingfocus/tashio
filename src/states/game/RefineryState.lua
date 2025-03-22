RefineryState = Class{__includes = BaseState}

local ren = MAP[1][11].npc[1]
local count = 0
local lineYSpacing = 15
local line1Y = SCREEN_HEIGHT_LIMIT - 40 - 50 + 6
local line2Y = line1Y + lineYSpacing
local line3Y = line2Y + lineYSpacing
local selection = 1
local selectionYTable = {line1Y, line2Y, line3Y}
local selectionCostTable = {0, 25, 50}
local selectionY = selectionYTable[selection]
local lineTextX = 19
local upgradeCursor = love.graphics.newImage('graphics/upgradeCursor.png')
local upgradeCursorBlink = false
local upgradeCursorBlinkTimer = 0
local upgradeCursorBlinkThreshold = .5
local activeLevel = 1
local resultString = ''
--[[

  resultString = nonSelectable
  'Already have upgrade'

  resultString = tooExpensive
  'X minerals are Needed'

  resultString = outOfRange
  'Level X is Needed'

  resultString = availableUpgrade
  'Can afford'

--]]

function RefineryState:init()
  self.stateName = 'refineryState'
  sceneView.currentMap = Map(1, 11, gPlayer.spellcastCount)
  self.row = 1
  self.column = 11
  self.flammeUI = false
end

function RefineryState:update(dt)
  if not PAUSED then
    sceneView:update(dt)
  end

  if self.flammeUI then

    if INPUT:pressed('down') then
      if selection < 3 then
        selection = selection + 1
      end
      selectionY = selectionYTable[selection]
      upgradeCursorBlinkTimer = 0
      upgradeCursorBlink = false
    end

    if INPUT:pressed('up') then
      if selection > 1 then
        selection = selection - 1
      end
      selectionY = selectionYTable[selection]
      upgradeCursorBlinkTimer = 0
      upgradeCursorBlink = false
      upgradeCursorBlink = false
    end

    upgradeCursorBlinkTimer = upgradeCursorBlinkTimer + dt
    if upgradeCursorBlinkTimer > upgradeCursorBlinkThreshold then
      upgradeCursorBlink = not upgradeCursorBlink
      upgradeCursorBlinkTimer = 0
    end
  end

  if INPUT:pressed('action') then
    --DIALOGUE DETECTION
    for k, v in pairs(MAP[self.row][self.column].dialogueBox) do
      if gPlayer:dialogueCollides(MAP[self.row][self.column].dialogueBox[k]) and not MAP[self.row][self.column].dialogueBox[k].activated then
        PAUSED = true
        MAP[self.row][self.column].dialogueBox[k]:flushText()
        MAP[self.row][self.column].dialogueBox[k].activated = true
        self.dialogueID = k
        sceneView.activeDialogueID = self.dialogueID
        self.flammeUI = true
      end
    end
    for k, v in pairs(MAP[self.row][self.column].collidableMapObjects) do
      if v.classType == 'treasureChest' then
        if not v.opened then
          if gPlayer:dialogueCollides(v) then
            v:openChest()
            treasureChestOption = true
          end
        end
      end
    end
  end

  if sceneView.activeDialogueID ~= nil then
      MAP[self.row][self.column].dialogueBox[self.dialogueID]:update(dt)
  else
    self.flammeUI = false
    selection = 1
    selectionY = selectionYTable[selection]
  end

  --DIALOGUE BOX UPDATES FOR NPCS
  for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox) do
    if v.option == 'npc' then
      v.x = v.npc.x
      v.y = v.npc.y
    end
  end
end

function RefineryState:render()
  love.graphics.push()
  sceneView:render()
  love.graphics.pop()
  love.graphics.setFont(pixelFont2)

  love.graphics.setColor(WHITE)
  love.graphics.draw(hudOverlay, 0, VIRTUAL_HEIGHT - 16)
  --]]
  if gItemInventory.itemSlot[1] ~= nil then
    love.graphics.setFont(pixelFont)
    gItemInventory.itemSlot[1]:render()
  end

  --UPGRADE UI
  if self.flammeUI then

    local upgradeBoxY = SCREEN_HEIGHT_LIMIT - 40 - 46
    local upgradeBoxWidth = 80
    local upgradeBoxHeight = 46
    --TAN BOX
    love.graphics.setColor(BLACK)
    love.graphics.rectangle('fill', 0, upgradeBoxY - 1, upgradeBoxWidth + 1, upgradeBoxHeight + 1)
    love.graphics.setColor(INVENTORY_COLOR)
    love.graphics.rectangle('fill', 0, upgradeBoxY, upgradeBoxWidth, upgradeBoxHeight)

    love.graphics.setColor(WHITE)
    love.graphics.draw(flamme, 5, line1Y + 1)
    love.graphics.draw(flamme, 5, line2Y + 1)
    love.graphics.draw(flamme, 5, line3Y + 1)
    love.graphics.setColor(BLACK)
    love.graphics.print('Level 1', lineTextX, line1Y)
    love.graphics.print('Level 2', lineTextX, line2Y)
    love.graphics.print('Level 3', lineTextX, line3Y)

    love.graphics.setColor(WHITE)
    love.graphics.print('Cost: ' .. tostring(selectionCostTable[selection]), 0, 0)

    --UPGRADE CURSOR
    if upgradeCursorBlink then
      love.graphics.setColor(TRANSPARENT)
    else
      love.graphics.setColor(WHITE)
    end


    love.graphics.draw(upgradeCursor, lineTextX - 2, selectionY)

    --ACTIVE LEVEL
    --local resultColors = {}
    love.graphics.setColor(resultColor)
    love.graphics.draw(rightArrowSelector, 0, selectionYTable[activeLevel] + 3)

    --MINERAL INVENTORY BOX
    local mineralInventoryX = VIRTUAL_WIDTH - 28
    local mineralInventoryY = SCREEN_HEIGHT_LIMIT - 40 - 12
    local mineralInventoryWidth = 28
    local mineralInventoryHeight = 12

    love.graphics.setColor(BLACK)
    love.graphics.rectangle('fill', mineralInventoryX - 1, mineralInventoryY - 1, mineralInventoryWidth + 1, mineralInventoryHeight + 1)
    love.graphics.setColor(INVENTORY_COLOR)
    love.graphics.rectangle('fill', mineralInventoryX, mineralInventoryY, mineralInventoryWidth, mineralInventoryHeight)

    love.graphics.setColor(WHITE)
    love.graphics.draw(ruby, VIRTUAL_WIDTH -28 + 2, SCREEN_HEIGHT_LIMIT - 40 - 12 + 2)
    love.graphics.setColor(BLACK)
    love.graphics.print(string.format("%02d", gPlayer.rubyCount), VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 40 - 12)

  end

  love.graphics.setColor(gKeyItemInventory.elementColor)
  love.graphics.circle('fill', VIRTUAL_WIDTH - 86, VIRTUAL_HEIGHT - 8, 6)

  love.graphics.setColor(WHITE)
  love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
  heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
  love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)

  --VIBRANCY RENDER
  love.graphics.draw(flamme, VIRTUAL_WIDTH / 2 - 11, VIRTUAL_HEIGHT - 13)
  --EMPTY VIBRANCY BAR
  love.graphics.setColor(255/255, 30/255, 30/255, 255/255)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 2, VIRTUAL_HEIGHT - 13, 2, 10)
  --VIBRANCY BAR
  love.graphics.setColor(30/255, 30/255, 30/255, 255/255)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 2, VIRTUAL_HEIGHT - 13, 2, gPlayer.flammeVibrancy / 10)
  --love.graphics.print('vibrancy: ' .. tostring(gPlayer.flammeVibrancy), 0, 0)
  love.graphics.setColor(WHITE)
  love.graphics.draw(flamme, VIRTUAL_WIDTH / 2 - 11, VIRTUAL_HEIGHT - 13)

  if sceneView.activeDialogueID ~= nil then
    MAP[self.row][self.column].dialogueBox[self.dialogueID]:render()
  end

  love.graphics.setColor(GREEN)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, 2)

  --love.graphics.print(Inspect(MAP[self.row][self.column].dialogueBox[4]), 0, 0)
  --love.graphics.print(self.dialogueID, 0, 10)
  --love.graphics.print('5: ' .. tostring(MAP[self.row][self.column].dialogueBox[5].activated), 0, 20)
  --love.graphics.print('player_state: ' .. tostring(PLAYER_STATE), 5, 95)
end
