RefineryState = Class{__includes = BaseState}

local ren = MAP[1][11].npc[1]
local count = 0

function RefineryState:init()
  self.stateName = 'refineryState'
  sceneView.currentMap = Map(1, 11, gPlayer.spellcastCount)
  self.row = 1
  self.column = 11
  self.flammeUI = false
  self.flammeUpgrade = UpgradeElement('flamme')
  --self.flammeUpgrade.activeLevel = 3
  self.aquisUpgrade = UpgradeElement('aquis')
  --self.aquisUpgrade.activeLevel = 3
  self.ekkoUpgrade = UpgradeElement('ekko')
  self.loxUpgrade = UpgradeElement('lox')
  self.activeUpgrade = nil
  self.animatables = {}
  self.animatables = InsertAnimation(sceneView.currentMap.row, sceneView.currentMap.column)
end

function RefineryState:update(dt)
  self.animatables:update(dt)
  if INPUT:pressed('start') then
    if not PAUSED and not gPlayer.dead and not luteState then
      gStateMachine:change('pauseState')
    end
  end

  if not PAUSED then
    sceneView:update(dt)
  end

  --UPDATE ACTIVE UPGRADE
  if self.activeUpgrade ~= nil then
    self.activeUpgrade:update(dt)
  end


  if INPUT:pressed('action') then
    --DIALOGUE DETECTION
    for k, v in pairs(MAP[self.row][self.column].dialogueBox) do
      if gPlayer:dialogueCollides(MAP[self.row][self.column].dialogueBox[k]) and not MAP[self.row][self.column].dialogueBox[k].activated then
        sfx['ui-scroll1']:play()
        PAUSED = true
        MAP[self.row][self.column].dialogueBox[k]:flushText()
        MAP[self.row][self.column].dialogueBox[k].activated = true
        self.dialogueID = k
        sceneView.activeDialogueID = self.dialogueID
        if v.index == 2 then
          self.activeUpgrade = self.flammeUpgrade
          self.activeUpgrade:setSelection()
          self.activeUpgrade:calculate()
          MAP[1][11].dialogueBox[2].aButtonCount = MAP[1][11].dialogueBox[2].aButtonCount + 1
          MAP[1][11].dialogueBox[2]:reinit(self.activeUpgrade.infoTable[self.activeUpgrade.selection])
          MAP[1][11].dialogueBox[2]:flushText()
          MAP[1][11].dialogueBox[2].activated = true
        elseif v.index == 3 then
          self.activeUpgrade = self.aquisUpgrade
          self.activeUpgrade:setSelection()
          self.activeUpgrade:calculate()
          MAP[1][11].dialogueBox[3].aButtonCount = MAP[1][11].dialogueBox[3].aButtonCount + 1
          MAP[1][11].dialogueBox[3]:reinit(self.activeUpgrade.infoTable[self.activeUpgrade.selection])
          MAP[1][11].dialogueBox[3]:flushText()
          MAP[1][11].dialogueBox[3].activated = true
        elseif v.index == 4 then
          self.activeUpgrade = self.ekkoUpgrade
          self.activeUpgrade:setSelection()
          self.activeUpgrade:calculate()
          MAP[1][11].dialogueBox[4].aButtonCount = MAP[1][11].dialogueBox[4].aButtonCount + 1
          MAP[1][11].dialogueBox[4]:reinit(self.activeUpgrade.infoTable[self.activeUpgrade.selection])
          MAP[1][11].dialogueBox[4]:flushText()
          MAP[1][11].dialogueBox[4].activated = true
        elseif v.index == 5 then
          self.activeUpgrade = self.loxUpgrade
          self.activeUpgrade:setSelection()
          self.activeUpgrade:calculate()
          MAP[1][11].dialogueBox[5].aButtonCount = MAP[1][11].dialogueBox[5].aButtonCount + 1
          MAP[1][11].dialogueBox[5]:reinit(self.activeUpgrade.infoTable[self.activeUpgrade.selection])
          MAP[1][11].dialogueBox[5]:flushText()
          MAP[1][11].dialogueBox[5].activated = true
        end
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
    ---[[
    if self.activeUpgrade ~= nil then
      self.activeUpgrade.selection = 1
      self.activeUpgrade.selectionY = self.activeUpgrade.selectionYTable[self.activeUpgrade.selection]
    end
    self.activeUpgrade = nil
    --]]
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


----RENDER ACTIVE UPGRADE
  if self.activeUpgrade ~= nil then
    self.activeUpgrade:render()
  end


  --[[
  love.graphics.setColor(gKeyItemInventory.elementColor)
  love.graphics.circle('fill', VIRTUAL_WIDTH - 86, VIRTUAL_HEIGHT - 8, 6)
  --]]

  love.graphics.setColor(WHITE)
  love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
  heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
  love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)

  if gPlayer.elementEquipped == 'flamme' then
    --VIBRANCY RENDER
    --EMPTY VIBRANCY BAR
    love.graphics.setColor(255/255, 30/255, 30/255, 255/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 2, VIRTUAL_HEIGHT - 13, 2, 10)
    --VIBRANCY BAR
    love.graphics.setColor(30/255, 30/255, 30/255, 255/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 2, VIRTUAL_HEIGHT - 13, 2, gPlayer.flammeVibrancy / 10)
    --love.graphics.print('vibrancy: ' .. tostring(gPlayer.flammeVibrancy), 0, 0)
    --A SLOT SPELL SLOT
    love.graphics.setColor(WHITE)
    love.graphics.draw(flamme2, VIRTUAL_WIDTH / 2 - 11 , VIRTUAL_HEIGHT - 13)
  end


  if sceneView.activeDialogueID ~= nil then
    MAP[self.row][self.column].dialogueBox[self.dialogueID]:render()
  end

  --[[
  love.graphics.setColor(GREEN)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, 2)
  --]]

  --love.graphics.print(Inspect(MAP[self.row][self.column].dialogueBox[4]), 0, 0)
  --love.graphics.print(self.dialogueID, 0, 10)
  --love.graphics.print('5: ' .. tostring(MAP[self.row][self.column].dialogueBox[5].activated), 0, 20)
  --love.graphics.print('player_state: ' .. tostring(PLAYER_STATE), 5, 95)
end
