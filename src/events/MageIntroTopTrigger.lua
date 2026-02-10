MageIntroTopTrigger = Class{__includes = BaseState}

local mage = MAP[10][19].npc[1]
luteState = false

function MageIntroTopTrigger:init()
  self.stateName = 'mageIntroTopTrigger'

  self.originalPlayerX, self.originalPlayerY = gPlayer.x, gPlayer.y
  self.step = 0
  sceneView.activeDialogueID = nil
  self.showOff = false
  self.treasureX = -TILE_SIZE
  self.treasureY = -TILE_SIZE
  self.psystem = love.graphics.newParticleSystem(particle, 400)
  self.option = nil
  self.saveDataUtility = SaveData()
  gKeyItemInventory.elementColor = TRANSPARENT
end

function MageIntroTopTrigger:update(dt)
  if not PAUSED then
    sceneView:update(dt)
  end

  if INPUT:pressed('start') then
    if not luteState and self.step == 0 then
      sfx['pause1']:play()
      gStateMachine:change('pauseState')
    end
  end

  ---[[
  --TRIGGER LUTE STATE
  if INPUT:pressed('actionB') and gItemInventory.itemSlot[1] ~= nil and not gPlayer.warping then
    if gItemInventory.itemSlot[1].type == 'lute' then
      if not luteState and not sceneView.dialogueBoxActive then
        if self.step == 0 then
          gPlayer.direction = 'down'
          gPlayer:changeAnimation('idle-down')
          luteState = true
          stopOST()
          Lute:reset()
          bassNotes1:reset()
        end
      end
    end
  end
  --]]

  if INPUT:pressed('select') then
    if not luteState then
      if self.step == 0 or self.step == 9 then
        sfx['pause2']:play()
        gStateMachine:change('minimap')
        gStateMachine.current.cursorX = sceneView.currentMap.column * 16 - 16
        gStateMachine.current.cursorY = sceneView.currentMap.row * 13 - 13
        gStateMachine.current.row = sceneView.currentMap.row
        gStateMachine.current.column = sceneView.currentMap.column
        gStateMachine.current.tashioRow = sceneView.currentMap.row
        gStateMachine.current.tashioColumn = sceneView.currentMap.column
        gStateMachine.current.tashioX = gPlayer.x / 16
        gStateMachine.current.tashioY = gPlayer.y / 13
        minimapCooldown = MINIMAP_COOLDOWN
        --MINIMAP_ROW = sceneView.currentMap.row
        --MINIMAP_COLUMN = sceneView.currentMap.column
      end
    end
  end

  if luteState then
    Lute:update(dt)
  end

  --TOGGLE LUTE OFF
  if INPUT:pressed('start') then
    if luteState then
      luteState = false
      SOUNDTRACK = MAP[sceneView.currentMap.row][sceneView.currentMap.column].ost
      Lute:reset()
      bassNotes1:reset()
    end
  end

  if gPlayer.y < TILE_SIZE - 8 and (gPlayer.x > TILE_SIZE * 4 and gPlayer.x < TILE_SIZE * 6) then
    self.option = 1
    gPlayer:changeAnimation('walk-down')
    table.insert(MAP[10][19].collidableMapObjects, CollidableMapObjects(1, 5, TILE_SIZE, TILE_SIZE))
    table.insert(MAP[10][19].collidableMapObjects, CollidableMapObjects(1, 6, TILE_SIZE, TILE_SIZE))
    self.step = 1
  elseif gPlayer.y > TILE_SIZE * 6 + 8 then
    self.option = 2
    table.insert(MAP[10][19].collidableMapObjects, CollidableMapObjects(1, 5, TILE_SIZE, TILE_SIZE))
    table.insert(MAP[10][19].collidableMapObjects, CollidableMapObjects(1, 6, TILE_SIZE, TILE_SIZE))
    gPlayer:changeAnimation('walk-up')
    self.step = 1
  end

  if sceneView.cameraX > VIRTUAL_WIDTH - 5 then
    Event.dispatch('turnOffTutorialText', dt)
  end

  if INPUT:pressed('action') then
    --DIALOGUE DETECTION
    for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox) do
      if gPlayer:dialogueCollides(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k]) and not MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].activated then
        PAUSED = true
        MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k]:flushText()
        MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].activated = true
        self.dialogueID = k
        sceneView.activeDialogueID = v.dialogueID
      end
    end
    for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do
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

  --DIALOGUE UPDATE
  if sceneView.activeDialogueID ~= nil then
    MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[sceneView.activeDialogueID]:update(dt)
  end

  if self.step == 1 then
    mage:changeAnimation('walk-down')
    gPlayer:changeState('player-cinematic')
    if self.option == 1 then
      Timer.tween(2, {
        [mage] = {x = TILE_SIZE * 4 + TILE_SIZE / 2, y = TILE_SIZE},
      }):finish()
      Timer.tween(1.5, {
        [gPlayer] = {x = TILE_SIZE * 4 + TILE_SIZE / 2, y = TILE_SIZE * 3},
      }):finish()
      if gPlayer.y == TILE_SIZE * 3 then
        Timer.clear()
        self.step = 2
      end
    elseif self.option == 2 then
      if gPlayer.y < TILE_SIZE * 6 then
        Timer.tween(2, {
          [mage] = {x = TILE_SIZE * 4 + TILE_SIZE / 2, y = TILE_SIZE},
        }):finish()
        Timer.tween(1.5, {
          [gPlayer] = {x = TILE_SIZE * 4 + TILE_SIZE / 2, y = TILE_SIZE * 4},
        }):finish()
        if gPlayer.y == TILE_SIZE * 4 then
          Timer.clear()
          self.step = 2
        end
      else
        gPlayer.y = gPlayer.y - (PLAYER_WALK_SPEED / 2) * dt
      end
    end
  elseif self.step == 2 then
    gPlayer:changeAnimation('idle-up')
    self.step = 3
  elseif self.step == 3 then
    sceneView.activeDialogueID = 13
    MAP[10][19].dialogueBox[sceneView.activeDialogueID]:flushText()
    MAP[10][19].dialogueBox[sceneView.activeDialogueID].aButtonCount = 1
    self.step = 4
  elseif self.step == 4 then
    if MAP[10][19].dialogueBox[13].finishedPrinting then
      self.step = 5
    end
    if sceneView.activeDialogueID ~= nil then
      --MAP[10][19].dialogueBox[sceneView.activeDialogueID]:update(dt)
    end
  elseif self.step == 5 then
    Timer.tween(1, {
      [mage] = {y = TILE_SIZE * 2},
    }):finish()
    if mage.y == TILE_SIZE * 2 then
      Timer.clear()
      self.step = 6
    end
  elseif self.step == 6 then
    sceneView.activeDialogueID = 14
    MAP[10][19].dialogueBox[sceneView.activeDialogueID]:flushText()
    MAP[10][19].dialogueBox[sceneView.activeDialogueID].aButtonCount = 1
    self.step = 7
  elseif self.step == 7 then
    if MAP[10][19].dialogueBox[14].finishedPrinting then
      self.step = 8
      mage:changeAnimation('walk-up')
    end
    if MAP[10][19].dialogueBox[14].currentPage == 3 then
      self.treasureX = gPlayer.x + 3
      self.treasureY = gPlayer.y - 10
      self.showOff = true
      gPlayer:changeAnimation('showOff')
      gPlayer.flammeUnlocked = true
      gPlayer.showOff = true
      mage:changeAnimation('idle-down')
      if not TUTORIAL_COMPLETED then
        --self.saveDataUtility:savePlayerData()
        sfx['open-chest']:play()
      end
      TUTORIAL_COMPLETED = true
    end
    if MAP[10][19].dialogueBox[14].currentPage == 4 then
      self.showOff = false
      gPlayer.showOff = false
      gPlayer:changeAnimation('idle-up')
      mage:changeAnimation('walk-down')
    end
    if sceneView.activeDialogueID ~= nil then
      --MAP[10][19].dialogueBox[sceneView.activeDialogueID]:update(dt)
    end
  elseif self.step == 8 then
    Timer.tween(2, {
      [mage] = {y = -TILE_SIZE},
    }):finish()
    if mage.y == -TILE_SIZE then
      --TRIGGER MAGE WALL
      Timer.clear()
      --MAGE WALL BARRIER
      --TOGGLE FOR DEPLOYMENT
      ---[[
      table.insert(MAP[10][19].collidableMapObjects, CollidableMapObjects(1, 5, TILE_SIZE, TILE_SIZE))
      table.insert(MAP[10][19].collidableMapObjects, CollidableMapObjects(1, 6, TILE_SIZE, TILE_SIZE))
      table.insert(MAP[10][19].psystems, MageMagicWall())
      MAP[10][19].psystems[1]:activate()
      MAP[10][19].psystems[1].active = true
      --]]
      self.step = 9
      gPlayer:changeAnimation('idle-up')
      gPlayer.direction = 'up'
    end
  elseif self.step == 9 then
    --CHANGE TO PLAY STATE
    gPlayer:changeState('player-walk')
    gStateMachine:change('playState')
  end

  if sceneView.dialogueBoxActive then
    sceneView.dialogueBoxActive = false
  end
end

function MageIntroTopTrigger:render()
  love.graphics.push()
  sceneView:render()
  love.graphics.pop()
  love.graphics.setFont(classicFont)

  local anim = gPlayer.currentAnimation
  --HUD RENDER
  ---[[
  love.graphics.setColor(WHITE)
  love.graphics.draw(hudOverlay, 0, VIRTUAL_HEIGHT - 16)
  --]]
  if gItemInventory.itemSlot[1] ~= nil then
    love.graphics.setFont(pixelFont)
    gItemInventory.itemSlot[1]:render()
  end

  --love.graphics.setColor(gKeyItemInventory.elementColor)
  --love.graphics.circle('fill', VIRTUAL_WIDTH - 86, VIRTUAL_HEIGHT - 8, 6)

  love.graphics.setColor(WHITE)
  love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
  heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
  love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
  if MAP[10][19].dialogueBox[sceneView.activeDialogueID] ~= nil then
    MAP[10][19].dialogueBox[sceneView.activeDialogueID]:render()
  end
  --love.graphics.print("step: " .. tostring(self.step), 0, 0)

  if self.showOff then
    love.graphics.setColor(COOKIE_VIGNETTE_COLOR)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, SCREEN_HEIGHT_LIMIT - 40)
    love.graphics.setColor(1, 1, 1, 120/255)
    love.graphics.draw(brightside, gPlayer.x + 8 - TILE_SIZE, gPlayer.y - 6 - TILE_SIZE)
    gPlayer:render()
    love.graphics.draw(flamme, self.treasureX, self.treasureY)
  end

  if sceneView.activeDialogueID ~= nil then
    MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[sceneView.activeDialogueID]:render()
  end

  --LUTE RENDER
  if luteState then
    Lute:render()
  end

  --[[
  love.graphics.setColor(BLACK)
  love.graphics.print('luteState: ' .. tostring(luteState), 0, 14)
  love.graphics.print('boxActive: ' .. tostring(sceneView.dialogueBoxActive), 0, 24)
  love.graphics.print('boxActive: ' .. tostring(sceneView.activeDialogueID), 0, 34)
  --]]
end
