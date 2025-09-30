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
  self.step = 1
  self.turnTimer = 0.8
  self.turnCount = 0
  self.sleepTimer = 0
  --[[
  self.step = 3
  gPlayer.x = -32
  --]]
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
  --self.fadeToBlack = true
  self.fadeToBlack = false
  self.fadeFromBlack = false
  self.blackOpacity = 0
  self.castleView = false
  self.tutorialTextAlpha = 0
  self.dialogueID = 0
  self.activeDialogueID = 0
end

Event.on('turnOffTutorialText', function()
    sceneView.tutorialText = false
end)

Event.on('fadeInTutorialText', function(dt)
    gStateMachine.current.tutorialTextAlpha = math.min(255, gStateMachine.current.tutorialTextAlpha + dt * 120)
    sceneView.tutorialText = true
    sceneView.tutorialTextAlpha = math.min(gStateMachine.current.tutorialTextAlpha, 255)
end)

function OpeningCinematic:update(dt)
  if not PAUSED and self.castleView then
    sceneView:update(dt)
  end
  self.lavaSystem:update(dt)
  self.testX = self.testX + dt * 2
  self.animatables:update(dt)
  if self.castleView then
    local yStarting = 15
    local yOffset = 10
    love.graphics.print('\'WASD\' to move', 42, yStarting)
    love.graphics.print('Spacebar is A Button', 42, yStarting + yOffset)
    love.graphics.print('Shift is B Button', 42, yStarting + yOffset * 2)
  end

  if self.step == 1 then
    mage.x = mage.x + mage.walkSpeed * dt
    mage:changeAnimation('walk-right')
    if mage.x > TILE_SIZE * 3 then
      self.step = 2
      mage:changeAnimation('idle-right')
    end
  elseif self.step == 2 then
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
      self.step = 3
    end
  elseif self.step == 3 then
    self.zigzagTime = self.zigzagTime + self.zigzagFrequency * dt
    self.offset = math.sin(self.zigzagTime) * self.zigzagAmplitude
    --MAGE PARTICLES
    self.psystem:moveTo(mage.x + 14, mage.y + 4)
    self.psystem:update(dt)

    --TASHIO PARTICLES
    self.psystem2:moveTo(gPlayer.x + 8, gPlayer.y + gPlayer.height)
    self.psystem2:setParticleLifetime(2, 3)
    self.psystem2:setEmissionArea('borderrectangle', 5, 0)
    self.psystem2:setLinearAcceleration(0, -5)
    self.psystem2:setEmissionRate(20)
    self.psystem2:setColors(80/255, 40/255, 255/255, 255/255, 80/255, 180/255, 255/255, 0/255)
    self.psystem2:update(dt)
    gPlayer.x = gPlayer.x - mage.walkSpeed * dt
    gPlayer.y = gPlayer.y + self.offset
    mage.x = mage.x - mage.walkSpeed * dt
    mage:changeAnimation('walk-left')
    if self.blackOpacity >= 255 then
      gPlayer.x = TILE_SIZE * 1
      gPlayer.y = TILE_SIZE * 2 - 6
      --castleMage.x, castleMage.y = TILE_SIZE * 2, -TILE_SIZE
      gPlayer.direction = 'down'
      sceneView.currentMap = Map(10, 18, gPlayer.spellcastCount)
      sceneView.mapRow = 10
      sceneView.mapColumn = 18
      self.animatables = InsertAnimation(sceneView.currentMap.row, sceneView.currentMap.column)
      gPlayer:changeState('player-cinematic')
      gPlayer:changeAnimation('sleep-left')
      gPlayer.direction = 'left'
      --gPlayer:changeAnimation('death')
      --gPlayer.animations['death'].currentFrame = 9
      self.fadeToBlack = false
      self.fadeFromBlack = true
      self.castleView = true
      self.step = 4
      sceneView.tutorialText = true
      --self.castleStep1 = true
    end
  elseif self.step == 4 then
    if self.blackOpacity <= 0 then
        self.step = 5
    end
  elseif self.step == 5 then
    self.turnTimer = self.turnTimer + dt
    if self.turnTimer > 1 then
      if gPlayer.direction == 'left' then
        self.turnCount = self.turnCount + 1
        gPlayer.direction = 'right'
        gPlayer:changeAnimation('sleep-right')
      else
        self.turnCount = self.turnCount + 1
        gPlayer.direction = 'left'
        gPlayer:changeAnimation('sleep-left')
      end
    self.turnTimer = 0
    end
    if self.turnCount >= 4 then
      gPlayer:changeAnimation('sleep-down')
      self.turnTimer = -5
      self.sleepTimer = self.sleepTimer + dt
      if self.sleepTimer > .8 then
        gPlayer:changeAnimation('idle-down')
        gPlayer.direction = 'down'
        --self.step = 6
        Event.dispatch('fadeInTutorialText', dt)
        --gStateMachine:change('playState')
      if self.tutorialTextAlpha == 255 then
        self.step = 7
        gPlayer:changeState('player-idle')
      end
      end
    end
 elseif self.step == 7 then
    if sceneView.cameraX > VIRTUAL_WIDTH - 5 then
      Event.dispatch('turnOffTutorialText', dt)
      --MAP[10][19].collidableMapObjects = {}
      gStateMachine:change('mageIntroTopTrigger')
    end
  end

  if self.step == 2 then
    gPlayer.y = math.max(TILE_SIZE * 3 - 8, gPlayer.y - dt * 2)
    self.psystem2:moveTo(gPlayer.x + 8, gPlayer.y + gPlayer.height)
    self.psystem2:setParticleLifetime(2, 3)
    self.psystem2:setEmissionArea('borderrectangle', 5, 0)
    self.psystem2:setLinearAcceleration(0, -5)
    self.psystem2:setEmissionRate(20)
    self.psystem2:setColors(80/255, 40/255, 255/255, 255/255, 80/255, 180/255, 255/255, 0/255)
    self.psystem2:update(dt)
  end

  --FIRST FADE TO BLACK
  if gPlayer.x < 0 and not self.castleView then
    self.fadeToBlack = true
  end

  if INPUT:pressed('action') then
    --DIALOGUE DETECTION
    --[[
    for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox) do
      if gPlayer:dialogueCollides(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k]) and not MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].activated then
        PAUSED = true
        MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k]:flushText()
        MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].activated = true
        self.dialogueID = k
        sceneView.activeDialogueID = v.dialogueID
      end
    end
    --]]
    for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do
      if v.classType == 'treasureChest' then
        if not v.opened then
          if gPlayer:dialogueCollides(v) then
            if gPlayer.direction ~= 'down' then
              v:openChest()
              treasureChestOption = true
              gItemInventory.grid[1][1] = {}
              table.insert(gItemInventory.grid[1][1], Item('lute'))
            end
          end
        end
      end
    end
  end

  if sceneView.activeDialogueID ~= nil then
      MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[sceneView.activeDialogueID]:update(dt)
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
    for k, v in pairs(MAP[10][18].npc) do
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
  local anim = gPlayer.currentAnimation

  if not self.castleView then
    love.graphics.setColor(WHITE)
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

  --[[
  love.graphics.setColor(gKeyItemInventory.elementColor)
  love.graphics.circle('fill', VIRTUAL_WIDTH - 86, VIRTUAL_HEIGHT - 8, 6)
  --]]

  love.graphics.setColor(WHITE)
  love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
  heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
  love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)

  if sceneView.activeDialogueID ~= nil then
    MAP[10][18].dialogueBox[sceneView.activeDialogueID]:render()
  end

  --KEYLOGGER
  --[[
  if INPUT:down('up') then
    love.graphics.setColor(FADED)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 11 + KEYLOGGER_YOFFSET, 0, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --UP
  else
    love.graphics.setColor(WHITE)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 11 + KEYLOGGER_YOFFSET, 0, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --UP
  end
  if INPUT:down('right') then
    love.graphics.setColor(FADED)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 8, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, ninetyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --RIGHT
  else
    love.graphics.setColor(WHITE)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 8, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, ninetyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --RIGHT
  end
  if INPUT:down('down') then
    love.graphics.setColor(FADED)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, oneEightyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --DOWN
  else
    love.graphics.setColor(WHITE)
    love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, oneEightyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --DOWN
  end
  if INPUT:down('left') then
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


  --love.graphics.print('cameraX: ' .. tostring(sceneView.cameraX), 0, 0)
  --love.graphics.print('walk: ' .. tostring(gPlayer.walkSpeed), 0, 0)
  --PAUSED DEBUG
  --love.graphics.print('alpha: ' .. tostring(gStateMachine.current.tutorialTextAlpha), 0, 0)
  --[[
  love.graphics.print('step1: ' .. tostring(self.castleStep1), 0, 0)
  love.graphics.print('step2: ' .. tostring(self.castleStep2), 0, 10)
  love.graphics.print('step3: ' .. tostring(self.castleStep3), 0, 20)
  love.graphics.print('step4: ' .. tostring(self.castleStep4), 0, 30)
  love.graphics.print('step5: ' .. tostring(self.castleStep5), 0, 40)
  love.graphics.print('step6: ' .. tostring(self.castleStep6), 0, 50)
  love.graphics.print('step7: ' .. tostring(self.castleStep7), 0, 60)
  --]]
  --
end
