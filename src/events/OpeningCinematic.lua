OpeningCinematic = Class{__includes = BaseState}

local mage = MAP[10][20].npc[1]
local castleMage = MAP[10][19].npc[1]

function OpeningCinematic:init()
  self.stateName = 'openingCinematic'
  self.testX = 0
  self.originalPlayerX, self.originalPlayerY = gPlayer.x, gPlayer.y
  self.animatables = {}
  --self.originalSceneRow, self.originalSceneColumn = sceneView.currentMap.row, sceneView.currentMap.column
  gPlayer.x = TILE_SIZE * 8
  gPlayer.y = TILE_SIZE * 3
  sceneView.currentMap = Map(10,20, gPlayer.spellcastCount)
  sceneView.mapRow = 10
  sceneView.mapColumn = 20
  sceneView.activeDialogueID = nil
  --gStateMachine.current.animatables = {}
  self.animatables = InsertAnimation(sceneView.currentMap.row, sceneView.currentMap.column)
  gPlayer:changeState('player-death')
  gPlayer:changeAnimation('death')
  gPlayer.animations['death'].currentFrame = 9
  --table.insert(MAP[10][19].dialogueBoxCollided, MAP[10][19].dialogueBox[1])
  self.lavaSystem = LavaSystem()
  --self.mageStep1 = false
  self.mageStep1 = true
  self.mageStep2 = false
  self.mageStep3 = false
  self.mageStep4 = false
  self.tashioStep1 = false
  self.tashioStep2 = false
  self.castleStep1 = false
  self.castleStep2 = false
  self.castleStep3 = false
  self.castleStep4 = false
  self.castleStep5 = false
  self.castleStep6 = false
  self.castleStep7 = false
  self.castleStep8 = false
  self.tashioWaitTimer = 0
  self.mageWaitTimer = 0
  self.mageWalkTimer = 0
  self.psystem = love.graphics.newParticleSystem(particle, 400)
  self.psystem2 = love.graphics.newParticleSystem(particle, 100)
  self.zigzagFrequency = 3
  self.zigzagAmplitude = 0.15
  self.zigzagTime = 0
  self.offset = 0
 -- self.fadeToBlack = true
 self.fadeToBlack = false
  self.fadeFromBlack = false
  self.blackOpacity = 0
  self.castleView = false
end

function OpeningCinematic:update(dt)
  self.lavaSystem:update(dt)
  self.testX = self.testX + dt * 2
  self.animatables:update(dt)
  --sceneView.currentMap.insertAnimations:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    sceneView.currentMap = Map(7, 4, gPlayer.spellcastCount)
    sceneView.mapRow = 7
    sceneView.mapColumn = 4
    gPlayer.x = self.originalPlayerX
    gPlayer.y = self.originalPlayerY
    gStateMachine:change('playState')
  end

  if self.castleStep1 then
    castleMage.y = math.min(castleMage.y + castleMage.walkSpeed / 2 * dt, TILE_SIZE * 2 - 6)
    castleMage:changeAnimation('walk-down')
    if castleMage.y == TILE_SIZE * 2 - 6 then
      self.castleStep1 = false
      self.castleStep2 = true
    end
  elseif self.castleStep2 then
    castleMage.x = math.min(castleMage.x + castleMage.walkSpeed / 2 * dt, TILE_SIZE * 5)
    castleMage:changeAnimation('walk-right')
    if castleMage.x == TILE_SIZE * 5 then
      castleMage:changeAnimation('idle-right')
      gPlayer:changeAnimation('idle-left')
      self.castleStep2 = false
      self.castleStep3 = true
      --[[
      MAP[10][19].dialogueBox[1].line1Result = ''
      MAP[10][19].dialogueBox[1].line2Result = ''
      MAP[10][19].dialogueBox[1].line3Result = ''
      MAP[10][19].dialogueBox[1].lineCount = 1
      MAP[10][19].dialogueBox[1].textIndex = 1
      --]]
    end

    --DIALOGUE UPDATE
  elseif self.castleStep3 then
    sceneView.activeDialogueID = 1
    MAP[10][19].dialogueBox[sceneView.activeDialogueID]:flushText()
    MAP[10][19].dialogueBox[sceneView.activeDialogueID].aButtonCount = 1
    --PAUSED = true
    self.castleStep2 = false
    self.castleStep3 = false
    self.castleStep4 = true
  elseif self.castleStep4 then
    if MAP[10][19].dialogueBox[1].finishedPrinting then
      self.castleStep4 = false
      self.castleStep5 = true
    end
    if sceneView.activeDialogueID ~= nil then
      MAP[10][19].dialogueBox[sceneView.activeDialogueID]:update(dt)
    end
  elseif self.castleStep5 then
    castleMage:changeAnimation('walk-left')
    castleMage.x = castleMage.x - castleMage.walkSpeed * dt
    if castleMage.x < TILE_SIZE * 3 then
      castleMage.x = TILE_SIZE * 3
      self.castleStep5 = false
      self.castleStep6 = true
      castleMage:changeAnimation('walk-up')
    end
  elseif self.castleStep6 then
    castleMage.y = castleMage.y - castleMage.walkSpeed * dt
    if castleMage.y + castleMage.height < 0 then
      self.castleStep6 = false
      self.castleStep7 = true
      gPlayer:changeAnimation('walk-left')
    end
  elseif self.castleStep7 then
      gPlayer.x = gPlayer.x - gPlayer.walkSpeed / 1.5 * dt
      if gPlayer.x < TILE_SIZE * 6 then
        gPlayer.x = TILE_SIZE * 6
        self.castleStep7 = false
        self.castleStep8 = true
        gPlayer.direction = 'down'
        gPlayer:changeAnimation('walk-down')
      end
  elseif self.castleStep8 then
    gPlayer.y = gPlayer.y + gPlayer.walkSpeed / 1.5 * dt
  end

  if self.castleView then
    gPlayer:update(dt)
    gPlayer:changeState('player-cinematic')
  end

  if self.mageStep1 then
    mage.x = mage.x + mage.walkSpeed * dt
    mage:changeAnimation('walk-right')
    if mage.x > TILE_SIZE * 3 then
      self.mageStep1 = false
      self.mageStep2 = true
      mage:changeAnimation('idle-right')
    end
  elseif self.mageStep2 then
    self.tashioWaitTimer = self.tashioWaitTimer + dt
    if self.tashioWaitTimer > 0.5 then
      self.tashioStep1 = true
    end
    self.psystem:moveTo(mage.x + 14, mage.y + 4)
    self.psystem:setParticleLifetime(1, 4)
    self.psystem:setEmissionArea('borderellipse', 1, 1)
    self.psystem:setEmissionRate(40)
    self.psystem:setTangentialAcceleration(0, 8)
    self.psystem:setColors(200/255, 20/255, 220/255, 255/255, 130/255, 0/255, 200/255, 0/255)
    self.psystem:update(dt)
    self.mageWaitTimer = self.mageWaitTimer + dt
    if self.mageWaitTimer > 4 then
      self.mageStep2 = false
      self.mageStep3 = true
    end
  elseif self.mageStep3 then
    self.zigzagTime = self.zigzagTime + self.zigzagFrequency * dt
    self.offset = math.sin(self.zigzagTime) * self.zigzagAmplitude
    self.psystem:moveTo(mage.x + 14, mage.y + 4)
    self.psystem:update(dt)
    gPlayer.x = gPlayer.x - mage.walkSpeed * dt
    gPlayer.y = gPlayer.y + self.offset
    mage.x = mage.x - mage.walkSpeed * dt
    mage:changeAnimation('walk-left')
    if self.blackOpacity >= 255 then
      self.mageStep3 = false
      self.tashioStep1 = false
      gPlayer.x = TILE_SIZE * 7
      gPlayer.y = TILE_SIZE * 2 - 6
      --castleMage.x, castleMage.y = TILE_SIZE * 2, -TILE_SIZE
      gPlayer.direction = 'down'
      sceneView.currentMap = Map(10,19, gPlayer.spellcastCount)
      sceneView.mapRow = 10
      sceneView.mapColumn = 19
      self.animatables = InsertAnimation(sceneView.currentMap.row, sceneView.currentMap.column)
      gPlayer:changeState('player-idle')
      --gPlayer:changeAnimation('death')
      --gPlayer.animations['death'].currentFrame = 9
      self.fadeToBlack = false
      self.fadeFromBlack = true
      self.castleView = true
      self.castleStep1 = true
    end
  end

  if self.tashioStep1 then
    gPlayer.y = math.max(TILE_SIZE * 3 - 8, gPlayer.y - dt * 2)
    self.psystem2:moveTo(gPlayer.x + 8, gPlayer.y + gPlayer.height)
    self.psystem2:setParticleLifetime(2, 3)
    self.psystem2:setEmissionArea('borderrectangle', 5, 0)
    self.psystem2:setLinearAcceleration(0, -5)
    self.psystem2:setEmissionRate(20)
    self.psystem2:setColors(80/255, 40/255, 255/255, 255/255, 80/255, 180/255, 255/255, 0/255)
    self.psystem2:update(dt)
  end

  if gPlayer.x < 0 then
    self.fadeToBlack = true
  end

  if gPlayer.y > VIRTUAL_HEIGHT - 8 then
    self.fadeToBlack = true
  end

  if self.fadeToBlack then
    self.blackOpacity = self.blackOpacity + 5
  elseif self.fadeFromBlack then
    self.blackOpacity = self.blackOpacity - 5
    if self.blackOpacity <= 0 then
      self.blackOpacity = 0
      self.fadeFromBlack = false
    end
  end


  for k, v in pairs(MAP[10][20].npc) do
    v:update(dt)
  end
  if self.castleView then
    for k, v in pairs(MAP[10][19].npc) do
      v:update(dt)
    end
  end
end

function OpeningCinematic:render()
  --love.graphics.clear(BLACK)
  love.graphics.push()
  sceneView:render()
  love.graphics.pop()
  love.graphics.setFont(classicFont)

  love.graphics.setColor(WHITE)
  if not self.castleView then
    love.graphics.draw(self.psystem, 0, 0)
    love.graphics.draw(self.psystem2, 0, 0)
    self.lavaSystem:render()
  end
  --HUD RENDER
  ---[[
  love.graphics.setColor(WHITE)
  love.graphics.draw(hudOverlay, 0, VIRTUAL_HEIGHT - 16)
  --]]
  if gItemInventory.itemSlot[1] ~= nil then
    love.graphics.setFont(pixelFont)
    gItemInventory.itemSlot[1]:render()
  end

  love.graphics.setColor(gKeyItemInventory.elementColor)
  love.graphics.circle('fill', VIRTUAL_WIDTH - 86, VIRTUAL_HEIGHT - 8, 6)

  love.graphics.setColor(WHITE)
  love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
  heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
  love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)

  --love.graphics.print('state: ' .. tostring(PLAYER_STATE), 5, 0)
  if self.castleStep4 then
    --[[
    if MAP[10][19].dialogueBoxCollided[1] ~= nil then
      MAP[10][19].dialogueBoxCollided[1]:render()
    end
    --]]

    if MAP[10][19].dialogueBox[sceneView.activeDialogueID] ~= nil then
      MAP[10][19].dialogueBox[sceneView.activeDialogueID]:render()
    end
  end


  --KEYLOGGER
  --[[
  if love.keyboard.isDown('w') then
    love.graphics.setColor(FADED)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 11 + KEYLOGGER_YOFFSET, 0, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --UP
  else
    love.graphics.setColor(WHITE)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 11 + KEYLOGGER_YOFFSET, 0, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --UP
  end
  if love.keyboard.isDown('d') then
    love.graphics.setColor(FADED)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 8, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, ninetyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --RIGHT
  else
    love.graphics.setColor(WHITE)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 8, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, ninetyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --RIGHT
  end
  if love.keyboard.isDown('s') then
    love.graphics.setColor(FADED)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, oneEightyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --DOWN
  else
    love.graphics.setColor(WHITE)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, oneEightyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --DOWN
  end
  if love.keyboard.isDown('a') then
    love.graphics.setColor(FADED)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 24, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, twoSeventyDegress, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --LEFT
  else
    love.graphics.setColor(WHITE)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 24, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, twoSeventyDegress, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --LEFT
  end
  --]]

  if self.fadeToBlack or self.fadeFromBlack then
    love.graphics.setColor(0/255, 0/255, 0/255, self.blackOpacity/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  end


  --PAUSED DEBUG
  --love.graphics.print('PlayerState: ' .. tostring(PLAYER_STATE), 0, 0)
  --[[
  love.graphics.print('step1: ' .. tostring(self.castleStep1), 0, 0)
  love.graphics.print('step2: ' .. tostring(self.castleStep2), 0, 10)
  love.graphics.print('step3: ' .. tostring(self.castleStep3), 0, 20)
  love.graphics.print('step4: ' .. tostring(self.castleStep4), 0, 30)
  love.graphics.print('step5: ' .. tostring(self.castleStep5), 0, 40)
  love.graphics.print('step6: ' .. tostring(self.castleStep6), 0, 50)
  love.graphics.print('step7: ' .. tostring(self.castleStep7), 0, 60)
  --]]
  --love.graphics.print('column: ' .. tostring(sceneView.mapColumn), 0, 88)
end
