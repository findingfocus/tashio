Minimap = Class{__includes = BaseState}

function Minimap:init()
  love.window.setPosition(400, 60)
  self.cursorX = 0
  self.cursorY = 0
  self.blink = false
  self.blinkTimer = .5
  self.row = 0
  self.column = 0
  self.tashioRow = 0
  self.tashioColumn = 0
  self.tashioX = 0
  self.tashioY = 0
  self.names = {}
  for i = 1, 20 do
    table.insert(self.names, {})
    for j = 1, 20 do
      table.insert(self.names[i], {})
      self.names[i][j].locationName = 'Forgotten Forest'
    end
  end

  for i = 1, 4 do
    for j = 3, 6 do
      self.names[i][j].locationName = 'Mount Wutai'
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
  self.names[7][3].locationName = 'Campgrounds'
  self.names[8][3].locationName = 'Gecko Road'
  self.names[7][4].locationName = 'Dungeon Entrance'
  self.names[9][3].locationName = 'Fisherman\'s Hut'
  self.names[9][4].locationName = 'River Jai'
  self.names[10][3].locationName = 'Fisher Port'
  self.names[10][2].locationName = 'Test of Strength'
  self.names[10][1].locationName = 'Test of Strength'
  self.names[9][1].locationName = 'Test of Strength'
  self.names[8][1].locationName = 'Test of Strength'
  self.names[8][2].locationName = 'Rickety Bridge'
  self.names[9][2].locationName = 'Mage\'s Castle'
  self.fastSelectTimer = .25
  self.names[6][1].locationName = 'Emishi Village'
  self.names[6][2].locationName = 'Emishi Village'
  self.names[5][2].locationName = 'Emishi Village'
  self.names[5][1].locationName = 'Emishi Village'
  self.names[5][2].locationName = 'Ren\'s Refinery'
  self.names[4][2].locationName = 'Lake Raju'
  self.names[7][2].locationName = 'Torii'
end

function Minimap:playSound(direction)
  if direction == 'right' then
    sfx['ui-scroll1']:play()
  elseif direction == 'down' then
    sfx['ui-scroll2']:play()
  elseif direction == 'left' then
    sfx['ui-select1']:play()
  elseif direction == 'up' then
    sfx['ui-select2']:play()
  end
end

function Minimap:update(dt)
  self.blinkTimer = self.blinkTimer - dt
  if self.blinkTimer <= 0 then
    self.blink = not self.blink
    self.blinkTimer = .5
  end
  if INPUT:pressed('select') then
    sfx['pause3']:play()
    gStateMachine:change('playState')
  end

  if #INPUT_LIST < 3 then
    --DIAGONAL MOVEMENT
    if INPUT:down('up') and INPUT:down('left') then
      self.fastSelectTimer = self.fastSelectTimer - dt
      if self.fastSelectTimer <= 0 then
        self.fastSelectTimer = FAST_SELECT_TIMER + .15
        self.cursorX = math.max(self.cursorX - 16, 0)
        self.cursorY = math.max(self.cursorY - 13, 0)
        self.blink = false
        self.blinkTimer = .5
      end
    end
    if INPUT:down('up') and INPUT:down('right') then
      self.fastSelectTimer = self.fastSelectTimer - dt
      if self.fastSelectTimer <= 0 then
        self.fastSelectTimer = FAST_SELECT_TIMER + .15
        self.cursorX = math.min(self.cursorX + 16, 144)
        self.cursorY = math.max(self.cursorY - 13, 0)
        self.blink = false
        self.blinkTimer = .5
      end
    end
    if INPUT:down('right') and INPUT:down('down') then
      self.fastSelectTimer = self.fastSelectTimer - dt
      if self.fastSelectTimer <= 0 then
        self.fastSelectTimer = FAST_SELECT_TIMER + .15
        self.cursorX = math.min(self.cursorX + 16, 144)
        self.cursorY = math.min(self.cursorY + 13, 117)
        self.blink = false
        self.blinkTimer = .5
      end
    end
    if INPUT:down('down') and INPUT:down('left') then
      self.fastSelectTimer = self.fastSelectTimer - dt
      if self.fastSelectTimer <= 0 then
        self.fastSelectTimer = FAST_SELECT_TIMER + .15
        self.cursorX = math.max(self.cursorX - 16, 0)
        self.cursorY = math.min(self.cursorY + 13, 117)
        self.blink = false
        self.blinkTimer = .5
      end
    end


    --JUST LEFT
    if INPUT:pressed('left') then
      self:playSound('left')
      self.cursorX = math.max(self.cursorX - 16, 0)
      self.blink = false
      self.blinkTimer = .5
    end
    if INPUT:down('left') and not INPUT:down('right') and not INPUT:down('up') and not INPUT:down('down') then
      self.fastSelectTimer = self.fastSelectTimer - dt
      if self.fastSelectTimer <= 0 then
        self.fastSelectTimer = FAST_SELECT_TIMER
        self.cursorX = math.max(self.cursorX - 16, 0)
        self.blink = false
        self.blinkTimer = .5
      end
    end
    if INPUT:released('left') then
      self.fastSelectTimer = FAST_SELECT_TIMER
    end


    --JUST RIGHT
    if INPUT:pressed('right') then
      self:playSound('right')
      self.cursorX = math.min(self.cursorX + 16, 144)
      self.blink = false
      self.blinkTimer = .5
    end
    if INPUT:down('right') and not INPUT:down('left') and not INPUT:down('up') and not INPUT:down('down') then
      self.fastSelectTimer = self.fastSelectTimer - dt
      if self.fastSelectTimer <= 0 then
        self.fastSelectTimer = FAST_SELECT_TIMER
        self.cursorX = math.min(self.cursorX + 16, 144)
        self.blink = false
        self.blinkTimer = .5
      end
    end
    if INPUT:released('right') then
      self.fastSelectTimer = FAST_SELECT_TIMER
    end


    --JUST UP
    if INPUT:pressed('up') then
      self:playSound('up')
      self.cursorY = math.max(self.cursorY - 13, 0)
      self.blink = false
      self.blinkTimer = .5
    end
    if INPUT:down('up') and not INPUT:down('left') and not INPUT:down('right') and not INPUT:down('down') then
      self.fastSelectTimer = self.fastSelectTimer - dt
      if self.fastSelectTimer <= 0 then
        self.fastSelectTimer = FAST_SELECT_TIMER
        self.cursorY = math.max(self.cursorY - 13, 0)
        self.blink = false
        self.blinkTimer = .5
      end
    end
    if INPUT:released('up') then
      self.fastSelectTimer = FAST_SELECT_TIMER
    end


    --JUST DOWN
    if INPUT:pressed('down') then
      self:playSound('down')
      self.cursorY = math.min(self.cursorY + 13, 117)
      self.blink = false
      self.blinkTimer = .5
    end

    if INPUT:down('down') and not INPUT:down('left') and not INPUT:down('right') and not INPUT:down('up') then
      self.fastSelectTimer = self.fastSelectTimer - dt
      if self.fastSelectTimer <= 0 then
        self.fastSelectTimer = FAST_SELECT_TIMER
        self.cursorY = math.min(self.cursorY + 13, 117)
        self.blink = false
        self.blinkTimer = .5
      end
    end
    if INPUT:released('down') then
      self.fastSelectTimer = FAST_SELECT_TIMER
    end


    self.column = self.cursorX / 16 + 1
    self.row = self.cursorY / 13 + 1
  end
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

  love.graphics.setColor(WHITE)
  love.graphics.draw(tashioMini, self.tashioColumn * 16 - 16 + self.tashioX, self.tashioRow * 13 - 13 + self.tashioY)

  love.graphics.setColor(BLACK)
  --love.graphics.print('Valley of death', 5, VIRTUAL_HEIGHT - 15)
  --love.graphics.print('row: ' .. tostring(self.row) .. 'col: ' .. tostring(self.column), 5, VIRTUAL_HEIGHT - 15)

  love.graphics.print(self.names[self.row][self.column].locationName, 5, VIRTUAL_HEIGHT - 15)
  love.graphics.print('[' .. tostring(self.row) .. '][' .. tostring(self.column) .. ']', 0, 0)
end
