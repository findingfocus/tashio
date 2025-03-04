Minimap = Class{__includes = BaseState}

function Minimap:init()
  love.window.setPosition(400, 60)
  self.cursorX = 0
  self.cursorY = 0
  self.blink = false
  self.blinkTimer = .5
  self.row = 0
  self.column = 0
  self.names = {}
  for i = 1, 10 do
    table.insert(self.names, {})
    for j = 1, 10 do
      table.insert(self.names[i], {})
      self.names[i][j].locationName = 'Forgotten Forest'
    end
  end

  for i = 1, 4 do
    for j = 3, 6 do
      self.names[i][j].locationName = 'Ice Mountain'
    end
    for j = 7, 10 do
      self.names[i][j].locationName = 'Mount Kazan'
    end
  end

  for i = 7, 10 do
    for j = 7, 10 do
      self.names[i][j].locationName = 'Dusty Desert'
    end
  end

  self.names[7][1].locationName = 'Dark Temple'
  self.names[7][2].locationName = 'Village'
  self.names[7][3].locationName = 'Gecko Road'
  self.names[7][4].locationName = 'Dungeon'
  self.names[8][3].locationName = 'Inn'
  self.names[9][3].locationName = 'Test of Strength'
  self.names[10][3].locationName = 'Test of Strength'
  self.names[10][2].locationName = 'Test of Strength'
  self.names[10][1].locationName = 'Test of Strength'
  self.names[9][1].locationName = 'Test of Strength'
  self.names[8][1].locationName = 'Test of Strength'
  self.names[8][2].locationName = 'Rickety Bridge'
  self.names[9][2].locationName = 'Mage\'s Castle'
end

function Minimap:update(dt)
  self.blinkTimer = self.blinkTimer - dt
  if self.blinkTimer <= 0 then
    self.blink = not self.blink
    self.blinkTimer = .5
  end
  if INPUT:pressed('select') then
    gStateMachine:change('playState')
  end
  if INPUT:pressed('left') then
    self.cursorX = math.max(self.cursorX - 16, 0)
    self.blink = false
    self.blinkTimer = .5
  end
  if INPUT:pressed('right') then
    self.cursorX = math.min(self.cursorX + 16, 144)
    self.blink = false
    self.blinkTimer = .5
  end
  if INPUT:pressed('up') then
    self.cursorY = math.max(self.cursorY - 13, 0)
    self.blink = false
    self.blinkTimer = .5
  end
  if INPUT:pressed('down') then
    self.cursorY = math.min(self.cursorY + 13, 117)
    self.blink = false
    self.blinkTimer = .5
  end

  self.column = self.cursorX / 16 + 1
  self.row = self.cursorY / 13 + 1
end

function Minimap:render()
  love.graphics.clear(181/255, 172/255, 138/255, 255/255)
  love.graphics.draw(minimap, 0, 0)
  if self.blink then
    love.graphics.setColor(TRANSPARENT)
  else
    love.graphics.setColor(WHITE)
  end
  love.graphics.draw(minimapCursor, self.cursorX, self.cursorY)

  love.graphics.setColor(BLACK)
  --love.graphics.print('Valley of death', 5, VIRTUAL_HEIGHT - 15)
  --love.graphics.print('row: ' .. tostring(self.row) .. 'col: ' .. tostring(self.column), 5, VIRTUAL_HEIGHT - 15)

  love.graphics.print(self.names[self.row][self.column].locationName, 5, VIRTUAL_HEIGHT - 15)
end
