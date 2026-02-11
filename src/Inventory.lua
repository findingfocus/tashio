Inventory = Class{}
renderCircle = false

function Inventory:init(option)
  self.option = option
  self.elementSlot = {}
  --DEMO SET DEFAULT FLAMME
  self.elementColor = FLAMME_COLOR
  --self.elementColor = TRANSPARENT

  if self.option == 'item' then
    self.x = 5
    self.y = 5
    self.rowAmount= 4
    self.columnAmount = 3
    self.itemWidth = 30
    self.itemHeight = 25
    self.width = self.columnAmount * self.itemWidth
    self.height = self.rowAmount * self.itemHeight
    self.row = {}
    self.column = {}
    self.grid = {}
    self.itemSlot = {}
    self.selectedRow = 1
    self.selectedCol = 1
    self.itemCursor = Cursor(GRID_XOFFSET, GRID_YOFFSET, 'item')

    for i = 1, self.rowAmount do
      self.grid[i] =  {}
      for k = 1, self.columnAmount do
        self.grid[i][k] = {}
      end
    end
    --table.insert(self.grid[1][2], Item('healthPotion', 10))
  end
--[[
    self.grid[1][2][1].image = healthPotion
    self.grid[1][2][1].quantity = 10
    self.grid[1][2][1].type = 'healthPotion'
    --]]
    --
    --[[
    self.grid[1][2][1].image = berry
    self.grid[1][2][1].quantity = 10
    --]]
    --[[
    self.grid[3][2][1].type = 'lute'
    self.grid[3][2][1].image = lute
    self.grid[3][2][1].quantity = nil
    --]]
  if self.option == 'keyItem' then
    self.x = VIRTUAL_WIDTH - 40
    self.y = 40
    self.rowAmount= 3
    self.columnAmount = 4
    self.itemWidth = 30
    self.itemHeight = 25
    self.width = self.columnAmount * self.itemWidth
    self.height = self.rowAmount * self.itemHeight
    self.row = {}
    self.column = {}
    self.grid = {}
    self.itemSlot = {}
    self.selectedRow = 2
    self.selectedCol = 1
    self.keyItemCursor = Cursor(self.selectedRow, self.selectedCol, 'keyItem')
    ---[[
    self.tome1Equipped = false
    self.tomeEquipped = ''
    --]]
    --[[
    self.tome1Equipped = true
    self.tomeEquipped = 'tome1'
    --]]

    for i = 1, self.rowAmount do
      self.grid[i] =  {}
      for k = 1, self.columnAmount do
        self.grid[i][k] = {}
      end
    end
  end
end

function handleDownInput(self)
  if self.selectedRow ~= self.rowAmount then
    self.selectedRow = self.selectedRow + 1
    if self.option == 'item' then
      self.itemCursor:blinkReset()
    elseif self.option == 'keyItem' then
      self.keyItemCursor:blinkReset()
    end
  end
end

function handleUpInput(self)
  if self.selectedRow ~= 1 then
    self.selectedRow = self.selectedRow - 1
    if self.option == 'item' then
      self.itemCursor:blinkReset()
    elseif self.option == 'keyItem' then
      self.keyItemCursor:blinkReset()
    end
  end
end

function handleLeftInput(self)
  if self.selectedCol ~= 1 then
    self.selectedCol = self.selectedCol -1
    if self.option == 'item' then
      self.itemCursor:blinkReset()
    elseif self.option == 'keyItem' then
      self.keyItemCursor:blinkReset()
    end
  end
end

function handleRightInput(self)
  if self.selectedCol ~= self.columnAmount then
    self.selectedCol = self.selectedCol + 1
    if self.option == 'item' then
      self.itemCursor:blinkReset()
    elseif self.option == 'keyItem' then
      self.keyItemCursor:blinkReset()
    end
  end
end

function handleAInput(self)
  if self.grid[self.selectedRow][self.selectedCol][1] ~= nil then
    self.grid[self.selectedRow][self.selectedCol][1]:equip() --MOVES SELECTED ITEM TO PROPER LOCATION
    local itemCopy = nil   --COPY ITEM THAT IS EQUIPPED
    if self.itemSlot[1] ~= nil then
      itemCopy = self.itemSlot[1]
    end
    self.itemSlot = {}
    table.insert(self.itemSlot, self.grid[self.selectedRow][self.selectedCol][1])
    table.remove(self.grid[self.selectedRow][self.selectedCol], 1)
    if itemCopy ~= nil then
      table.insert(self.grid[self.selectedRow][self.selectedCol], itemCopy)
    end
  end
end


function Inventory:update(dt)
  if self.option == 'item' then
    if INPUT:pressed('up') then
      handleUpInput(self)
    end

    if INPUT:pressed('left') then
      handleLeftInput(self)
    end
    if INPUT:pressed('down') then
      handleDownInput(self)
    end
    if INPUT:pressed('right') then
      handleRightInput(self)
    end

    if INPUT:pressed('action') then
      handleAInput(self)
    end

    --UPDATE CURSOR
    self.itemCursor:update(dt, self.selectedRow, self.selectedCol)

    for row = 1, self.rowAmount do
      for col = 1, self.columnAmount do
        if self.grid[row][col][1] ~= nil then
          self.grid[row][col][1]:update(row, col)
        end
      end
    end

  elseif self.option == 'keyItem' then
    if INPUT:pressed('up') then
      handleUpInput(self)
    end
    if INPUT:pressed('left') then
      handleLeftInput(self)
    end
    if INPUT:pressed('down') then
      handleDownInput(self)
    end
    if INPUT:pressed('right') then
      handleRightInput(self)
    end

    if INPUT:pressed('action') then
      if self.selectedRow == 1 then --ELEMENT ROW
        if self.selectedCol == 1 then
          --TODO FIX SPELL NAMES
          if gPlayer.flammeUnlocked then
            --EQUIP SOUND
            --sfx['item-equip3']:play()
            --self.elementSlot = 'flammeSpell'
            if gPlayer.elementEquipped == 'flamme' then
              gPlayer.elementEquipped = ''
            else
              gPlayer.elementEquipped = 'flamme'
            end
            self.elementColor = FLAMME_COLOR
          end
        elseif self.selectedCol == 2 then
          if gPlayer.aquisUnlocked then
            self.elementSlot = 'aquisSpell'
            gPlayer.elementEquipped = 'aquis'
            self.elementColor = AQUIS_COLOR
          end
        elseif self.selectedCol == 3 then
          if gPlayer.ekkoUnlocked then
            self.elementSlot = 'ekkoSpell'
            gPlayer.elementEquipped = 'ekko'
            self.elementColor = EKKO_COLOR
          end
        elseif self.selectedCol == 4 then
          if gPlayer.loxUnlocked then
            self.elementSlot = 'loxSpell'
            gPlayer.elementEquipped = 'lox'
            self.elementColor = LOX_COLOR
          end
        end
      end
      if self.selectedRow == 2 then --TUNIC ROW
        if self.selectedCol == 1 then
          if gPlayer.tunicEquipped == 'greenTunic' then
            gPlayer.tunicEquipped = ''
          else
            if gPlayer.greenTunicUnlocked then
              gPlayer.tunicEquipped = 'greenTunic'
            end
          end
        end
        if self.selectedCol == 2 then
          if gPlayer.tunicEquipped == 'blueTunic' then
            gPlayer.tunicEquipped = ''
          else
            if gPlayer.blueTunicUnlocked then
              gPlayer.tunicEquipped = 'blueTunic'
            end
          end
        end
        if self.selectedCol == 3 then
          if gPlayer.tunicEquipped == 'redTunic' then
            gPlayer.tunicEquipped = ''
          else
            if gPlayer.redTunicUnlocked then
              gPlayer.tunicEquipped = 'redTunic'
            end
          end
        end
        if self.selectedCol == 4 then
          if gPlayer.tunicEquipped == 'yellowTunic' then
            gPlayer.tunicEquipped = ''
          else
            if gPlayer.yellowTunicUnlocked then
              gPlayer.tunicEquipped = 'yellowTunic'
            end
          end
        end
      elseif self.selectedRow == 3 then --TOME ROW
        if self.selectedCol == 1 then
          if gPlayer.tome1Unlocked then
            self.tome1Equipped = not self.tome1Equipped
            if self.tome1Equipped then
              self.tomeEquipped = 'tome1'
            else
              self.tomeEquipped = ''
            end
          end
        end
      end
    end

    self.keyItemCursor:update(dt, self.selectedRow, self.selectedCol)
  end
end

function Inventory:render(cursorRender)
  love.graphics.setColor(WHITE)
  for i = 1, self.rowAmount do
    for k = 1, self.columnAmount do
      if self.grid[i][k][1] ~= nil then
        self.grid[i][k][1]:render()
      end
    end
  end
  --REMOVED itemSlot[1]
  if self.itemSlot[1] ~= nil then
    self.itemSlot[1]:render()
  end

  --TOME
  if gPlayer.tome1Unlocked then
    love.graphics.draw(tome1, KEYITEM_XOFFSET + 1, KEYITEM_YOFFSET + 32)
  end


  if cursorRender == 'keyItem' then
    if self.option == 'keyItem' then
      self.keyItemCursor:render()
    end
  elseif cursorRender == 'item' then
    if self.option == 'item' then
      self.itemCursor:render()
    end
  end

  if gPlayer.flammeUnlocked then
    love.graphics.setColor(WHITE)
    love.graphics.draw(flamme, KEYITEM_XOFFSET + 1, KEYITEM_YOFFSET + 1)
  end

  if gPlayer.greenTunicUnlocked then
    love.graphics.setColor(WHITE)
    love.graphics.draw(greenTunicSolo, KEYITEM_XOFFSET, KEYITEM_YOFFSET + 17)
  end

  if self.tome1Equipped then
    love.graphics.setColor(WHITE)
    love.graphics.draw(tome1, VIRTUAL_WIDTH - 12 - TILE_SIZE * 3 + 5, 5)
  end

  if gPlayer.elementEquipped == 'flamme' then
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
end
