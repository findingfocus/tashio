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
  self.colorResultTable = {BLACK, BLACK, BLACK}
  self.selectionCostTable = {10, 25, 50}
  self.selectionY = self.selectionYTable[self.selection]
  self.lineTextX = 19
  self.upgradeCursorBlink = false
  self.upgradeCursorBlinkTimer = 0
  self.upgradeCursorBlinkThreshold = .5
  self.activeLevel = 1
  if self.type ~= 'flamme' then
    self.activeLevel = 0
  end
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

function UpgradeElement:calculate()
  if self.activeLevel == 0 then
    self.resultTable[1] = 'unavailable'
    self.resultTable[2] = 'unavailable'
    self.resultTable[3] = 'unavailable'
  elseif self.activeLevel == 1 then
    self.resultTable[1] = 'unlocked'
    self.resultTable[3] = 'unavailable'
    --CAN WE AFFORD LEVEL 2
    if self.type == 'flamme' then
      if gPlayer.rubyCount >= self.selectionCostTable[2] then
        self.resultTable[2] = 'purchasable'
      else
        self.resultTable[2] = 'unavailable'
      end
    elseif self.type == 'aquis' then
      if gPlayer.sapphireCount >= self.selectionCostTable[2] then
        self.resultTable[2] = 'purchasable'
      else
        self.resultTable[2] = 'unavailable'
      end
    elseif self.type == 'ekko' then
      if gPlayer.emeraldCount >= self.selectionCostTable[2] then
        self.resultTable[2] = 'purchasable'
      else
        self.resultTable[2] = 'unavailable'
      end
    elseif self.type == 'lox' then
      if gPlayer.topazCount >= self.selectionCostTable[2] then
        self.resultTable[2] = 'purchasable'
      else
        self.resultTable[2] = 'unavailable'
      end
    end
  elseif self.activeLevel == 2 then
    self.resultTable[1] = 'unlocked'
    self.resultTable[2] = 'unlocked'
    self.resultTable[3] = 'unavailable'
    if self.type == 'flamme' then
      if gPlayer.rubyCount >= self.selectionCostTable[3] then
        self.resultTable[3] = 'purchasable'
      else
        self.resultTable[3] = 'unavailable'
      end
    elseif self.type == 'aquis' then
      if gPlayer.sapphireCount >= self.selectionCostTable[3] then
        self.resultTable[3] = 'purchasable'
      else
        self.resultTable[3] = 'unavailable'
      end
    elseif self.type == 'ekko' then
      if gPlayer.emeraldCount >= self.selectionCostTable[3] then
        self.resultTable[3] = 'purchasable'
      else
        self.resultTable[3] = 'unavailable'
      end
    elseif self.type == 'lox' then
      if gPlayer.topazCount >= self.selectionCostTable[3] then
        self.resultTable[3] = 'purchasable'
      else
        self.resultTable[3] = 'unavailable'
      end
    end
  elseif self.activeLevel == 3 then
    self.resultTable[1] = 'unlocked'
    self.resultTable[2] = 'unlocked'
    self.resultTable[3] = 'unlocked'
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
      self.selectionY = self.selectionYTable[self.selection]
      self.upgradeCursorBlinkTimer = 0
      self.upgradeCursorBlink = false
    end

    if INPUT:pressed('up') then
      if self.selection > 1 then
        self.selection = self.selection - 1
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

    love.graphics.setColor(WHITE)
    love.graphics.print('Cost: ' .. tostring(self.selectionCostTable[self.selection]), 0, 0)
    love.graphics.print('Selection: ' .. Inspect(self.resultTable[self.selection]), 0, 10)

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
