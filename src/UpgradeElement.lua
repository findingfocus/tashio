UpgradeElement = Class{}

function UpgradeElement:init(type)
  self.type = type
  if self.type == 'flamme' then
    --PULL IN FLAMME IMAGE
    self.element = flamme
    self.mineral = ruby
  elseif self.type == 'aquis' then
    self.element = aquis
    self.mineral = ruby
  elseif self.type == 'ekko' then
    self.element = ekko
    self.mineral = ruby
  elseif self.type == 'lox' then
    self.element = lox
    self.mineral = ruby
  end
  self.lineYSpacing = 15
  self.line1Y = SCREEN_HEIGHT_LIMIT - 40 - 50 + 6
  self.line2Y = self.line1Y + self.lineYSpacing
  self.line3Y = self.line2Y + self.lineYSpacing
  self.selection = 1
  self.selectionYTable = {self.line1Y, self.line2Y, self.line3Y}
  self.selectionCostTable = {0, 25, 50}
  self.selectionY = self.selectionYTable[self.selection]
  self.lineTextX = 19
  self.upgradeCursorBlink = false
  self.upgradeCursorBlinkTimer = 0
  self.upgradeCursorBlinkThreshold = .5
  self.activeLevel = 1
  self.resultString = ''
  self.upgradeBoxY = SCREEN_HEIGHT_LIMIT - 40 - 46
  self.upgradeBoxWidth = 80
  self.upgradeBoxHeight = 46
  self.mineralInventoryX = VIRTUAL_WIDTH - 28
  self.mineralInventoryY = SCREEN_HEIGHT_LIMIT - 40 - 12
  self.mineralInventoryWidth = 28
  self.mineralInventoryHeight = 12

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

    --UPGRADE CURSOR
    if self.upgradeCursorBlink then
      love.graphics.setColor(TRANSPARENT)
    else
      love.graphics.setColor(WHITE)
    end


    love.graphics.draw(upgradeCursor, self.lineTextX - 2, self.selectionY)

    --ACTIVE LEVEL
    --local resultColors = {}
    --love.graphics.setColor(resultColor)
    love.graphics.setColor(WHITE)
    love.graphics.draw(rightArrowSelector, 0, self.selectionYTable[self.activeLevel] + 3)


    love.graphics.setColor(BLACK)
    love.graphics.rectangle('fill', self.mineralInventoryX - 1, self.mineralInventoryY - 1, self.mineralInventoryWidth + 1, self.mineralInventoryHeight + 1)
    love.graphics.setColor(INVENTORY_COLOR)
    love.graphics.rectangle('fill', self.mineralInventoryX, self.mineralInventoryY, self.mineralInventoryWidth, self.mineralInventoryHeight)

    love.graphics.setColor(WHITE)
    love.graphics.draw(self.mineral, VIRTUAL_WIDTH -28 + 2, SCREEN_HEIGHT_LIMIT - 40 - 12 + 2)
    love.graphics.setColor(BLACK)
    love.graphics.print(string.format("%02d", gPlayer.rubyCount), VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 40 - 12)
end
