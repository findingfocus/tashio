PauseState = Class{__includes = BaseState}

function PauseState:init()
  self.inventoryType = 'item'
  self.stateName = 'PauseState'
end

function PauseState:update(dt)
  if INPUT:pressed('start') then
    luteState = false
    gPlayer.focusIndicatorX = 0

    if sceneView.currentMap.row == 1 and sceneView.currentMap.column == 11 then
      gStateMachine:change('refineryState')
    else
      gStateMachine:change('playState')
    end
  end
  if INPUT:pressed('actionB') then
    if self.inventoryType == 'keyItem' then
      self.inventoryType = 'item'
    else
      self.inventoryType = 'keyItem'
    end
  end

  --UNEQUIP ITEM
  if INPUT:pressed('select') then
    if gItemInventory.itemSlot[1] ~= nil then
      sfx['item-equip1']:play()
      if gItemInventory.grid[1][1][1] == nil then
        table.insert(gItemInventory.grid[1][1], gItemInventory.itemSlot[1])
      elseif gItemInventory.grid[1][2][1] == nil then
        table.insert(gItemInventory.grid[1][2], gItemInventory.itemSlot[1])
      end
      gItemInventory.itemSlot[1] = nil
    end
  end

  for k, v in pairs(touches) do
    --INVENTORY SWAP
    if buttons[2]:collides(touches[k]) and touches[k].wasTouched then
      if self.inventoryType == 'keyItem' then
        self.inventoryType = 'item'
      else
        self.inventoryType = 'keyItem'
      end
    end
  end

  if self.inventoryType == 'item' then
    gItemInventory:update(dt)
  end
  if self.inventoryType == 'keyItem' then
    gKeyItemInventory:update(dt)
  end
end

function PauseState:render()
  love.graphics.draw(pauseMockup, 0, 0)
  gItemInventory:render(self.inventoryType)
  gKeyItemInventory:render(self.inventoryType)
  love.graphics.setColor(WHITE)
  --PLAYER
  love.graphics.draw(gTextures['character-walk'], gFrames['character-walk'][1], INVENTORY_PLAYER_X, INVENTORY_PLAYER_Y)
  if gPlayer.tunicEquipped == 'blueTunic' then
    love.graphics.draw(gTextures['character-blueTunic'], gFrames['character-blueTunic'][1], math.floor(INVENTORY_PLAYER_X), math.floor(INVENTORY_PLAYER_Y))
  elseif gPlayer.tunicEquipped == 'redTunic' then
    love.graphics.draw(gTextures['character-redTunic'], gFrames['character-redTunic'][1], math.floor(INVENTORY_PLAYER_X), math.floor(INVENTORY_PLAYER_Y))
  elseif gPlayer.tunicEquipped  == 'greenTunic' then
    love.graphics.draw(gTextures['character-greenTunic'], gFrames['character-greenTunic'][1], math.floor(INVENTORY_PLAYER_X), math.floor(INVENTORY_PLAYER_Y))
  elseif gPlayer.tunicEquipped == 'yellowTunic' then
    love.graphics.draw(gTextures['character-yellowTunic'], gFrames['character-yellowTunic'][1], math.floor(INVENTORY_PLAYER_X), math.floor(INVENTORY_PLAYER_Y))
  end

  --ELEMENT RENDER
  if gPlayer.elementEquipped == 'flamme' then
    love.graphics.setColor(gKeyItemInventory.elementColor)
    love.graphics.draw(gTextures['character-element'], gFrames['character-element'][1], math.floor(INVENTORY_PLAYER_X), math.floor(INVENTORY_PLAYER_Y))
  end

  love.graphics.setColor(WHITE)
  love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
  heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
  love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)

  --LUTE
  if gItemInventory.itemSlot[1] ~= nil then
    if gItemInventory.itemSlot[1].type == 'lute' then
      love.graphics.draw(gTextures['lute-equip'], gFrames['lute-equip'][1], math.floor(INVENTORY_PLAYER_X), math.floor(INVENTORY_PLAYER_Y))
      love.graphics.setColor(WHITE)
    end
  end

  love.graphics.setFont(pixelFont2)
  love.graphics.setColor(BLACK)
  --print(string.format("%03d", number))
  love.graphics.print(string.format("%03d", gPlayer.coinCount), VIRTUAL_WIDTH - 48, VIRTUAL_HEIGHT - 29)
  --RUBY
  love.graphics.setColor(WHITE)
  love.graphics.draw(ruby, VIRTUAL_WIDTH - 59, VIRTUAL_HEIGHT - 49)
  love.graphics.setColor(BLACK)
  love.graphics.print(string.format("%02d", gPlayer.rubyCount), VIRTUAL_WIDTH - 48, VIRTUAL_HEIGHT - 51)
end
