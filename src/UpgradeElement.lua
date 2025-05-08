UpgradeElement = Class{}

function UpgradeElement:init(type)
  self.type = type
  if self.type == 'flamme' then
    --PULL IN FLAMME IMAGE
    self.element = flamme
    self.mineral = ruby
  elseif self.type == 'aquis' then
    self.element = aquis
    self.mineral = sapphire
  elseif self.type == 'ekko' then
    self.element = ekko
    self.mineral = emerald
  elseif self.type == 'lox' then
    self.element = lox
    self.mineral = topaz
  end
  self.lineYSpacing = 15
  self.line1Y = SCREEN_HEIGHT_LIMIT - 40 - 50 + 6
  self.line2Y = self.line1Y + self.lineYSpacing
  self.line3Y = self.line2Y + self.lineYSpacing
  self.selection = 1
  self.selectionYTable = {self.line1Y, self.line2Y, self.line3Y}
  --[[
  self.resultTable = {'unlocked', 'unavailable', 'purchasable'}
  self.colorResultTable = {GRAY, RED, GREEN}
  --]]
  self.resultTable = {'', '', ''}
  self.infoTable = {'infoTable line 1', 'infoTable line 2', 'infoTable line 3'}
  self.colorResultTable = {BLACK, BLACK, BLACK}
  self.selectionCostTable = {10, 25, 50}
  self.selectionY = self.selectionYTable[self.selection]
  self.lineTextX = 19
  self.upgradeCursorBlink = false
  self.upgradeCursorBlinkTimer = 0
  self.upgradeCursorBlinkThreshold = .5
  if self.type ~= 'flamme' then
    --self.activeLevel = 0
  end
  self.activeLevel = gPlayer.flammeUpgradeLevel
  self.resultString = ''
  self.upgradeBoxY = SCREEN_HEIGHT_LIMIT - 40 - 46
  self.upgradeBoxWidth = 80
  self.upgradeBoxHeight = 46
  self.mineralInventoryX = VIRTUAL_WIDTH - 28
  self.mineralInventoryY = SCREEN_HEIGHT_LIMIT - 40 - 12
  self.mineralInventoryWidth = 28
  self.mineralInventoryHeight = 12
  self.calculatedResult = ''

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
end

function UpgradeElement:setSelection()
  if self.activeLevel == 0 then
    self.selection = 1
  else
    self.selection = self.activeLevel
  end
  self.selectionY = self.selectionYTable[self.selection]
end

function UpgradeElement:handleUpgrade(type)
  sounds['coinPickup']:play()
  if type == 'flamme' then
    gPlayer.rubyCount = gPlayer.rubyCount - self.selectionCostTable[self.selection]
    MAP[1][11].dialogueBox[2]:reinit(self.infoTable[self.selection])
    gPlayer.spellcastCount = gPlayer.spellcastCount + 1
    sceneView.count = gPlayer.spellcastCount
    sceneView.step = math.pi * 2 / sceneView.count
  elseif type == 'aquis' then
    gPlayer.sapphireCount = gPlayer.sapphireCount - self.selectionCostTable[self.selection]
    MAP[1][11].dialogueBox[3]:reinit(self.infoTable[self.selection])
  elseif type == 'ekko' then
    gPlayer.emeraldCount = gPlayer.emeraldCount - self.selectionCostTable[self.selection]
    MAP[1][11].dialogueBox[4]:reinit(self.infoTable[self.selection])
  elseif type == 'lox' then
    gPlayer.topazCount = gPlayer.topazCount - self.selectionCostTable[self.selection]
    MAP[1][11].dialogueBox[5]:reinit(self.infoTable[self.selection])
  end
  self.activeLevel = math.min(3, self.activeLevel + 1)
  gPlayer.flammeUpgradeLevel = self.activeLevel
  self:calculate()
end

function UpgradeElement:calculate()
  if self.activeLevel == 0 then
    self.resultTable[1] = 'unavailable'
    self.resultTable[2] = 'unavailable'
    self.resultTable[3] = 'unavailable'
    if self.type == 'flamme' then
      self.infoTable[1] = 'Creating Flamme costs ' .. tostring(self.selectionCostTable[1]) .. ' rubys. '
      self.infoTable[2] = 'Level 2 Flamme requires Level 1 Flamme first. '
      self.infoTable[3] = 'Level 3 Flamme requires Level 2 Flamme first. '
      if gPlayer.rubyCount >= self.selectionCostTable[1] then
        self.resultTable[1] = 'purchasable'
      end
    elseif self.type == 'aquis' then
      self.infoTable[1] = 'Creating Aquis costs ' .. tostring(self.selectionCostTable[1]) .. ' sapphires. '
      self.infoTable[2] = 'Level 2 Aquis requires Level 1 Aquis first. '
      self.infoTable[3] = 'Level 3 Aquis requires Level 2 Aquis first. '
    elseif self.type == 'ekko' then
      self.infoTable[1] = 'Creating Ekko costs ' .. tostring(self.selectionCostTable[1]) .. ' emeralds. '
      self.infoTable[2] = 'Level 2 Ekko requires Level 1 Ekko first. '
      self.infoTable[3] = 'Level 3 Ekko requires Level 2 Ekko first. '
    elseif self.type == 'lox' then
      self.infoTable[1] = 'Creating Lox costs ' .. tostring(self.selectionCostTable[1]) .. ' topaz. '
      self.infoTable[2] = 'Level 2 Lox requires Level 1 Lox first. '
      self.infoTable[3] = 'Level 3 Lox requires Level 2 Lox first. '
      if gPlayer.topazCount >= self.selectionCostTable[1] then
        self.resultTable[1] = 'purchasable'
      end
    end
  elseif self.activeLevel == 1 then
    self.resultTable[1] = 'unlocked'
    self.resultTable[3] = 'unavailable'
    --CAN WE AFFORD LEVEL 2
    if self.type == 'flamme' then
      self.infoTable[1] = 'You have already unlocked Level 1 Flamme. '
      self.infoTable[3] = 'Level 3 Flamme requires Level 2 Flamme first. '
      if gPlayer.rubyCount >= self.selectionCostTable[2] then
        self.resultTable[2] = 'purchasable'
        self.infoTable[2] = 'Refine Flamme to Level 2 for ' .. tostring(self.selectionCostTable[2]) .. ' rubys? '
      else
        self.resultTable[2] = 'unavailable'
        self.infoTable[2] = 'Refining Flamme to Level 2 costs ' .. tostring(self.selectionCostTable[2]) .. ' rubys. '
      end
    elseif self.type == 'aquis' then
      self.infoTable[1] = 'You have already unlocked Level 1 Aquis. '
      self.infoTable[3] = 'Level 3 Aquis requires Level 2 Aquis first. '
      if gPlayer.sapphireCount >= self.selectionCostTable[2] then
        self.resultTable[2] = 'purchasable'
        self.infoTable[2] = 'Refine Aquis to Level 2 for ' .. tostring(self.selectionCostTable[2]) .. ' sapphires? '
      else
        self.resultTable[2] = 'unavailable'
        self.infoTable[2] = 'Refining Aquis to Level 2 costs ' .. tostring(self.selectionCostTable[2]) .. ' sapphires. '
      end
    elseif self.type == 'ekko' then
      self.infoTable[1] = 'You have already unlocked Level 1 Ekko. '
      self.infoTable[3] = 'Level 3 Ekko requires Level 2 Ekko first. '
      if gPlayer.emeraldCount >= self.selectionCostTable[2] then
        self.resultTable[2] = 'purchasable'
        self.infoTable[2] = 'Refine Ekko to Level 2 for ' .. tostring(self.selectionCostTable[2]) .. ' emeralds? '
      else
        self.resultTable[2] = 'unavailable'
        self.infoTable[2] = 'Refining Ekko to Level 2 costs ' .. tostring(self.selectionCostTable[2]) .. ' emeralds. '
      end
    elseif self.type == 'lox' then
      self.infoTable[1] = 'You have already unlocked Level 1 Lox. '
      self.infoTable[3] = 'Level 3 Lox requires Level 2 Lox first. '
      if gPlayer.topazCount >= self.selectionCostTable[2] then
        self.resultTable[2] = 'purchasable'
        self.infoTable[2] = 'Refine Lox to Level 2 for ' .. tostring(self.selectionCostTable[2]) .. ' topaz? '
      else
        self.resultTable[2] = 'unavailable'
        self.infoTable[2] = 'Refining Lox to Level 2 costs ' .. tostring(self.selectionCostTable[2]) .. ' topaz. '
      end
    end
  elseif self.activeLevel == 2 then
    self.resultTable[1] = 'unlocked'
    self.resultTable[2] = 'unlocked'
    self.resultTable[3] = 'unavailable'
    --CAN AFFORD LEVEL 3 UPGRADE
    if self.type == 'flamme' then
      self.infoTable[1] = 'You have already unlocked Level 1 Flamme. '
      self.infoTable[2] = 'You have already unlocked Level 2 Flamme. '
      if gPlayer.rubyCount >= self.selectionCostTable[3] then
        self.resultTable[3] = 'purchasable'
        self.infoTable[3] = 'Refine Flamme to Level 3 for ' .. tostring(self.selectionCostTable[3]) .. ' rubys? '
        --[[
        gPlayer.spellcastCount = gPlayer.spellcastCount - 1
        sceneView.count = gPlayer.spellcastCount
        sceneView.step = math.pi * 2 / sceneView.count
        --]]
      else
        self.resultTable[3] = 'unavailable'
        self.infoTable[3] = 'Refining Flamme to Level 3 costs ' .. tostring(self.selectionCostTable[3]) .. ' rubys. '
      end
    elseif self.type == 'aquis' then
      self.infoTable[1] = 'You have already unlocked Level 1 Aquis. '
      self.infoTable[2] = 'You have already unlocked Level 2 Aquis. '
      if gPlayer.sapphireCount >= self.selectionCostTable[3] then
        self.resultTable[3] = 'purchasable'
        self.infoTable[3] = 'Refine Aquis to Level 3 for ' .. tostring(self.selectionCostTable[3]) .. ' sapphires? '
      else
        self.resultTable[3] = 'unavailable'
        self.infoTable[3] = 'Refining Aquis to Level 3 costs ' .. tostring(self.selectionCostTable[3]) .. ' sapphires . '
      end
    elseif self.type == 'ekko' then
      self.infoTable[1] = 'You have already unlocked Level 1 Ekko. '
      self.infoTable[2] = 'You have already unlocked Level 2 Ekko. '
      if gPlayer.emeraldCount >= self.selectionCostTable[3] then
        self.resultTable[3] = 'purchasable'
        self.infoTable[3] = 'Refine Ekko to Level 3 for ' .. tostring(self.selectionCostTable[3]) .. ' emeralds? '
      else
        self.resultTable[3] = 'unavailable'
        self.infoTable[3] = 'Refining Ekko to Level 3 costs ' .. tostring(self.selectionCostTable[3]) .. ' emeralds . '
      end
    elseif self.type == 'lox' then
      self.infoTable[1] = 'You have already unlocked Level 1 Lox. '
      self.infoTable[2] = 'You have already unlocked Level 2 Lox. '
      if gPlayer.topazCount >= self.selectionCostTable[3] then
        self.resultTable[3] = 'purchasable'
        self.infoTable[3] = 'Refine Lox to Level 3 for ' .. tostring(self.selectionCostTable[3]) .. ' topaz? '
      else
        self.resultTable[3] = 'unavailable'
        self.infoTable[3] = 'Refining Lox to Level 3 costs ' .. tostring(self.selectionCostTable[3]) .. ' topaz . '
      end
    end
  elseif self.activeLevel == 3 then
    self.resultTable[1] = 'unlocked'
    self.resultTable[2] = 'unlocked'
    self.resultTable[3] = 'unlocked'
    if self.type == 'flamme' then
      self.infoTable[1] = 'You have already unlocked Level 1 Flamme. '
      self.infoTable[2] = 'You have already unlocked Level 2 Flamme. '
      self.infoTable[3] = 'You have already unlocked Level 3 Flamme. '
    elseif self.type == 'aquis' then
      self.infoTable[1] = 'You have already unlocked Level 1 Aquis. '
      self.infoTable[2] = 'You have already unlocked Level 2 Aquis. '
      self.infoTable[3] = 'You have already unlocked Level 3 Aquis. '
    elseif self.type == 'ekko' then
      self.infoTable[1] = 'You have already unlocked Level 1 Ekko. '
      self.infoTable[2] = 'You have already unlocked Level 2 Ekko. '
      self.infoTable[3] = 'You have already unlocked Level 3 Ekko. '
    elseif self.type == 'lox' then
      self.infoTable[1] = 'You have already unlocked Level 1 Lox. '
      self.infoTable[2] = 'You have already unlocked Level 2 Lox. '
      self.infoTable[3] = 'You have already unlocked Level 3 Lox. '
    end
  end

  for k, v in pairs(self.resultTable) do
    if v == 'unlocked' then
      self.colorResultTable[k] = BLACK
    elseif v == 'unavailable' then
      self.colorResultTable[k] = RED
    elseif v == 'purchasable' then
      self.colorResultTable[k] = GREEN
    else
        self.colorResultTable[k] = BLACK
    end
  end

  --UNLOCKING ELEMENTS IN THE FIRST PLACE
  --[[
  if self.activeLevel == 0 then
    if self.type == 'aquis' then
      if gPlayer.sapphireCount < self.selectionCostTable[1] then
        self.resultTable[1] = 'unavailable'
      else
        self.resultTable[1] = 'purchasable'
      end
    elseif self.type == 'aquis' then
      if gPlayer.sapphireCount < self.selectionCostTable[1] then
        self.resultTable[1] = 'unavailable'
      else
        self.resultTable[1] = 'purchasable'
      end
    elseif self.type == 'ekko' then
      if gPlayer.emeraldCount < self.selectionCostTable[1] then
        self.resultTable[1] = 'unavailable'
      else
        self.resultTable[1] = 'purchasable'
      end
    elseif self.type == 'lox' then
      if gPlayer.topazCount < self.selectionCostTable[1] then
        self.resultTable[1] = 'unavailable'
      else
        self.resultTable[1] = 'purchasable'
      end
    end
  end
  --]]
end

function UpgradeElement:update(dt)
    if INPUT:pressed('down') then
      if self.selection < 3 then
        self.selection = self.selection + 1
      end
      if self.type == 'flamme' then
        MAP[1][11].dialogueBox[2].aButtonCount = MAP[1][11].dialogueBox[2].aButtonCount + 1
        MAP[1][11].dialogueBox[2]:reinit(self.infoTable[self.selection])
        MAP[1][11].dialogueBox[2]:flushText()
        MAP[1][11].dialogueBox[2].activated = true
        --RESET TO 0 TO ALLOW PLAYER TO SEE UPGRADE HAPPEN
        if self.resultTable[self.selection] == 'purchasable' then
          MAP[1][11].dialogueBox[2].aButtonCount = 0
        end
      elseif self.type == 'aquis' then
        MAP[1][11].dialogueBox[3].aButtonCount = MAP[1][11].dialogueBox[3].aButtonCount + 1
        MAP[1][11].dialogueBox[3]:reinit(self.infoTable[self.selection])
        MAP[1][11].dialogueBox[3]:flushText()
        MAP[1][11].dialogueBox[3].activated = true
        if self.resultTable[self.selection] == 'purchasable' then
          MAP[1][11].dialogueBox[3].aButtonCount = 0
        end
      elseif self.type == 'ekko' then
        MAP[1][11].dialogueBox[4].aButtonCount = MAP[1][11].dialogueBox[4].aButtonCount + 1
        MAP[1][11].dialogueBox[4]:reinit(self.infoTable[self.selection])
        MAP[1][11].dialogueBox[4]:flushText()
        MAP[1][11].dialogueBox[4].activated = true
        if self.resultTable[self.selection] == 'purchasable' then
          MAP[1][11].dialogueBox[4].aButtonCount = 0
        end
      elseif self.type == 'lox' then
        MAP[1][11].dialogueBox[5].aButtonCount = MAP[1][11].dialogueBox[5].aButtonCount + 1
        MAP[1][11].dialogueBox[5]:reinit(self.infoTable[self.selection])
        MAP[1][11].dialogueBox[5]:flushText()
        MAP[1][11].dialogueBox[5].activated = true
        if self.resultTable[self.selection] == 'purchasable' then
          MAP[1][11].dialogueBox[5].aButtonCount = 0
        end
      end
      self.selectionY = self.selectionYTable[self.selection]
      self.upgradeCursorBlinkTimer = 0
      self.upgradeCursorBlink = false
    end

    if INPUT:pressed('up') then
      if self.selection > 1 then
        self.selection = self.selection - 1
      end
      if self.type == 'flamme' then
        MAP[1][11].dialogueBox[2].aButtonCount = MAP[1][11].dialogueBox[2].aButtonCount + 1
        MAP[1][11].dialogueBox[2]:reinit(self.infoTable[self.selection])
        MAP[1][11].dialogueBox[2]:flushText()
        MAP[1][11].dialogueBox[2].activated = true
        if self.resultTable[self.selection] == 'purchasable' then
          MAP[1][11].dialogueBox[2].aButtonCount = 0
        end
      elseif self.type == 'aquis' then
        MAP[1][11].dialogueBox[3].aButtonCount = MAP[1][11].dialogueBox[3].aButtonCount + 1
        MAP[1][11].dialogueBox[3]:reinit(self.infoTable[self.selection])
        MAP[1][11].dialogueBox[3]:flushText()
        MAP[1][11].dialogueBox[3].activated = true
        if self.resultTable[self.selection] == 'purchasable' then
          MAP[1][11].dialogueBox[3].aButtonCount = 0
        end
      elseif self.type == 'ekko' then
        MAP[1][11].dialogueBox[4].aButtonCount = MAP[1][11].dialogueBox[4].aButtonCount + 1
        MAP[1][11].dialogueBox[4]:reinit(self.infoTable[self.selection])
        MAP[1][11].dialogueBox[4]:flushText()
        MAP[1][11].dialogueBox[4].activated = true
        if self.resultTable[self.selection] == 'purchasable' then
          MAP[1][11].dialogueBox[4].aButtonCount = 0
        end
      elseif self.type == 'lox' then
        MAP[1][11].dialogueBox[5].aButtonCount = MAP[1][11].dialogueBox[5].aButtonCount + 1
        MAP[1][11].dialogueBox[5]:reinit(self.infoTable[self.selection])
        MAP[1][11].dialogueBox[5]:flushText()
        MAP[1][11].dialogueBox[5].activated = true
        if self.resultTable[self.selection] == 'purchasable' then
          MAP[1][11].dialogueBox[5].aButtonCount = 0
        end
      end
      self.selectionY = self.selectionYTable[self.selection]
      self.upgradeCursorBlinkTimer = 0
      self.upgradeCursorBlink = false
      self.upgradeCursorBlink = false
    end

    self.upgradeCursorBlinkTimer = self.upgradeCursorBlinkTimer + dt
    if self.upgradeCursorBlinkTimer > self.upgradeCursorBlinkThreshold then
      self.upgradeCursorBlink = not self.upgradeCursorBlink
      self.upgradeCursorBlinkTimer = 0
    end

    if INPUT:pressed('action') then
      if self.resultTable[self.selection] == 'purchasable' then
          self:handleUpgrade(self.type)
      end
    end
end

function UpgradeElement:render()
    --TAN BOX
    love.graphics.setColor(BLACK)
    love.graphics.rectangle('fill', 0, self.upgradeBoxY - 1, self.upgradeBoxWidth + 1, self.upgradeBoxHeight + 1)
    love.graphics.setColor(INVENTORY_COLOR)
    love.graphics.rectangle('fill', 0, self.upgradeBoxY, self.upgradeBoxWidth, self.upgradeBoxHeight)

    love.graphics.setColor(WHITE)
    love.graphics.draw(self.element, 5, self.line1Y + 1)
    love.graphics.draw(self.element, 5, self.line2Y + 1)
    love.graphics.draw(self.element, 5, self.line3Y + 1)
    love.graphics.setColor(BLACK)
    love.graphics.print('Level 1', self.lineTextX, self.line1Y)
    love.graphics.print('Level 2', self.lineTextX, self.line2Y)
    love.graphics.print('Level 3', self.lineTextX, self.line3Y)

    --UPGRADE DEBUG COST
    --[[
    love.graphics.setColor(WHITE)
    love.graphics.print('Cost: ' .. tostring(self.selectionCostTable[self.selection]), 0, 0)
    love.graphics.print('Selection: ' .. Inspect(self.resultTable[self.selection]), 0, 10)
    --]]

    --UPGRADE CURSOR
    if self.upgradeCursorBlink then
      love.graphics.setColor(TRANSPARENT)
    else
      --love.graphics.setColor(WHITE)
      love.graphics.setColor(self.colorResultTable[self.selection])
    end


    love.graphics.draw(upgradeCursor, self.lineTextX - 2, self.selectionY)

    --ACTIVE LEVEL
    --local resultColors = {}
    --love.graphics.setColor(resultColor)
    love.graphics.setColor(WHITE)
    if self.activeLevel ~= 0 then
      love.graphics.draw(rightArrowSelector, 0, self.selectionYTable[self.activeLevel] + 3)
    end

    love.graphics.setColor(BLACK)
    love.graphics.rectangle('fill', self.mineralInventoryX - 1, self.mineralInventoryY - 1, self.mineralInventoryWidth + 1, self.mineralInventoryHeight + 1)
    love.graphics.setColor(INVENTORY_COLOR)
    love.graphics.rectangle('fill', self.mineralInventoryX, self.mineralInventoryY, self.mineralInventoryWidth, self.mineralInventoryHeight)

    love.graphics.setColor(WHITE)
    love.graphics.draw(self.mineral, VIRTUAL_WIDTH -28 + 2, SCREEN_HEIGHT_LIMIT - 40 - 12 + 2)
    love.graphics.setColor(BLACK)
    if self.type == 'flamme' then
      love.graphics.print(string.format("%02d", gPlayer.rubyCount), VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 40 - 12)
    elseif self.type == 'aquis' then
      love.graphics.print(string.format("%02d", gPlayer.sapphireCount), VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 40 - 12)
    elseif self.type == 'ekko' then
      love.graphics.print(string.format("%02d", gPlayer.emeraldCount), VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 40 - 12)
    elseif self.type == 'lox' then
      love.graphics.print(string.format("%02d", gPlayer.topazCount), VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 40 - 12)
    end
end
