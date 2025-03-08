MageIntroTopTrigger = Class{__includes = BaseState}

local mage = MAP[10][19].npc[1]

function MageIntroTopTrigger:init()
  self.stateName = 'mageIntroTopTrigger'

  self.originalPlayerX, self.originalPlayerY = gPlayer.x, gPlayer.y
  self.step = 1
  sceneView.activeDialogueID = nil
  self.showOff = false
end

function MageIntroTopTrigger:update(dt)
  if not PAUSED then
    sceneView:update(dt)
  end
  if gPlayer.y < TILE_SIZE then
    self.step = 1
  end
  if self.step == 1 then
    mage:changeAnimation('walk-down')
    gPlayer:changeState('player-cinematic')
    Timer.tween(1.5, {
      [mage] = {x = TILE_SIZE * 4 + TILE_SIZE / 2, y = TILE_SIZE},
    }):finish()
    gPlayer:changeAnimation('walk-down')
    Timer.tween(1.5, {
      [gPlayer] = {x = TILE_SIZE * 4 + TILE_SIZE / 2, y = TILE_SIZE * 3},
    }):finish()
    if gPlayer.y == TILE_SIZE * 3 then
      Timer.clear()
      self.step = 2
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
      MAP[10][19].dialogueBox[sceneView.activeDialogueID]:update(dt)
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
        self.showOff = true
      end
    if sceneView.activeDialogueID ~= nil then
      MAP[10][19].dialogueBox[sceneView.activeDialogueID]:update(dt)
    end
  elseif self.step == 8 then
    self.treasureX = gPlayer.x + 3
    self.treasureY = gPlayer.y - 10
    gPlayer:changeAnimation('showOff')
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

  love.graphics.setColor(gKeyItemInventory.elementColor)
  love.graphics.circle('fill', VIRTUAL_WIDTH - 86, VIRTUAL_HEIGHT - 8, 6)

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
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1, 150/255)
    love.graphics.draw(brightside, gPlayer.x + 8 - TILE_SIZE, gPlayer.y - 6 - TILE_SIZE)
    gPlayer:render()
    love.graphics.draw(flamme, self.treasureX, self.treasureY)
  end

  --[[
  love.graphics.setColor(YELLOW)
  love.graphics.circle('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 64, 3)
  --]]
end
