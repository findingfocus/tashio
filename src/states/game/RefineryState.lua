RefineryState = Class{__includes = BaseState}

local ren = MAP[1][11].npc[1]
  local count = 0

function RefineryState:init()
  self.stateName = 'refineryState'
  sceneView.currentMap = Map(1, 11, gPlayer.spellcastCount)
  self.row = 1
  self.column = 11
end

function RefineryState:update(dt)
  if not PAUSED then
    sceneView:update(dt)
  end

  if INPUT:pressed('action') then
    --DIALOGUE DETECTION
    for k, v in pairs(MAP[1][11].dialogueBox) do
      if gPlayer:dialogueCollides(MAP[1][11].dialogueBox[k]) and not MAP[1][11].dialogueBox[k].activated then
        PAUSED = true
        MAP[1][11].dialogueBox[k]:flushText()
        MAP[1][11].dialogueBox[k].activated = true
        self.dialogueID = k
        sceneView.activeDialogueID = self.dialogueID
      end
    end
    for k, v in pairs(MAP[1][11].collidableMapObjects) do
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
      MAP[1][11].dialogueBox[self.dialogueID]:update(dt)
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

  love.graphics.setColor(WHITE)
  love.graphics.draw(hudOverlay, 0, VIRTUAL_HEIGHT - 16)
  --]]
  if gItemInventory.itemSlot[1] ~= nil then
    love.graphics.setFont(pixelFont)
    gItemInventory.itemSlot[1]:render()
  end

  love.graphics.setColor(gKeyItemInventory.elementColor)
  love.graphics.circle('fill', VIRTUAL_WIDTH - 86, VIRTUAL_HEIGHT - 8, 6)

  love.graphics.setColor(WHITE)
  love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
  heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
  love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)

  if sceneView.activeDialogueID ~= nil then
    MAP[1][11].dialogueBox[self.dialogueID]:render()
  end

  love.graphics.setColor(GREEN)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, 20)

  --love.graphics.print(Inspect(MAP[1][11].dialogueBox[4]), 0, 0)
  --love.graphics.print(self.dialogueID, 0, 10)
  --love.graphics.print('5: ' .. tostring(MAP[1][11].dialogueBox[5].activated), 0, 20)
  love.graphics.print('player_state: ' .. tostring(PLAYER_STATE), 5, 95)
end
