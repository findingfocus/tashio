PauseState = Class{__includes = BaseState}

function PauseState:init()
  self.inventoryType = 'item'
  self.stateName = 'PauseState'
end

function PauseState:update(dt)
  if INPUT:pressed('left') then
    sfx['ui-select1']:play()
  end
  if INPUT:pressed('right') then
    sfx['ui-scroll1']:play()
  end
  if INPUT:pressed('up') then
    sfx['ui-select2']:play()
  end
  if INPUT:pressed('down') then
    sfx['ui-scroll2']:play()
  end
  if INPUT:pressed('actionB') then
    sfx['pause3']:play()
  end
  if INPUT:pressed('action') then
    sfx['pause3']:play()
  end

  if INPUT:pressed('start') then
    sfx['pause3']:play()
    gItemInventory.itemCursor:blinkReset()
    luteState = false
    gPlayer.focusIndicatorX = 0

    if TUTORIAL_COMPLETED then
      if sceneView.currentMap.row == 1 and sceneView.currentMap.column == 11 then
        gStateMachine:change('refineryState')
      else
        gStateMachine:change('playState')
      end
    else
      if sceneView.currentMap.row == 10 and sceneView.currentMap.column == 18 then
        gStateMachine:change('openingCinematic')
        gStateMachine.current.step = 5
      else
        gStateMachine:change('mageIntroTopTrigger')
      end
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
      if #gItemInventory.grid[gItemInventory.selectedRow][gItemInventory.selectedCol] == 0 then
        table.insert(gItemInventory.grid[gItemInventory.selectedRow][gItemInventory.selectedCol], gItemInventory.itemSlot[1])
        sfx['item-equip1']:play()
        gItemInventory.itemSlot[1] = nil
      end
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
