PlayState = Class{__includes = BaseState}
successfulCast = false
HEART_CROP = 56
local STRING_WIDTH = 2
totalHealth = 14
--TODO FIX THIS NASTY
healthDifference = totalHealth - 2
HEART_CROP = math.max(56 - (4 * healthDifference), 0)
healthDifference = 0
local creditSequence = false
local creditsY = VIRTUAL_HEIGHT
local creditsYReset = VIRTUAL_HEIGHT
local inspect = require "lib/inspect"
local manisTimer = 0
Lute = Lute()
leftCount = 0
luteState = false
toggleHelp = false
gItemInventory = Inventory('item')
gKeyItemInventory = Inventory('keyItem')
gItems = {}

local vibrancy = 0
local vibrancyGrow = true

local triggerSceneTransition = false
local leftFadeTransitionX = -VIRTUAL_WIDTH / 2
local rightFadeTransitionX = VIRTUAL_WIDTH
local startingSceneTransitionFinished = false
local transitionFadeAlpha = 0

gPlayer = Player {
  animations = ENTITY_DEFS['player'].animations,
  walkSpeed = ENTITY_DEFS['player'].walkSpeed,
  x = TILE_SIZE * 2,
  y = TILE_SIZE * 6,
  --y = 30,
  width = TILE_SIZE,
  height = TILE_SIZE,
}
gPlayer.checkPointPositions.x = TILE_SIZE * 2
gPlayer.checkPointPositions.y = TILE_SIZE * 6
ninetyDegrees = math.rad(90)
oneEightyDegrees = math.rad(180)
twoSeventyDegress = math.rad(270)
rotate = 0
treasureChestOption = false
local columns = 10
local rows = 8
cameraX = 0
--STARTING SCENE gPlayer SPAWN
--sceneView = Scene(gPlayer, 10, 19)
--sceneView = Scene(gPlayer, 7, 4)
--sceneView = Scene(gPlayer, 1, 12)
sceneView = Scene(gPlayer, 4, 11)
--gPlayer.y = TILE_SIZE
--gPlayer.x = TILE_SIZE * 8
tilesheet = love.graphics.newImage('graphics/masterSheet.png')
--textures = love.graphics.newImage('graphics/textures.png')
quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)

function PlayState:init()
  self.stateName = 'PlayState'
  self.snowSystem = SnowSystem()
  self.rainSystem = RainSystem()

  gPlayer.stateMachine = StateMachine {
    ['player-walk'] = function() return PlayerWalkState(gPlayer, self.scene) end,
    ['player-idle'] = function() return PlayerIdleState(gPlayer) end,
    ['player-death'] = function() return PlayerDeathState(gPlayer) end,
    ['player-meditate'] = function() return PlayerMeditateState(gPlayer) end,
    ['player-cinematic'] = function() return PlayerCinematicState(gPlayer, self.scene) end,
  }

  --gPlayer:changeState('player-death')
  gPlayer:changeState('player-idle')
  self.manis = 100
  self.manisMax = 100
  --self.manisDrain = .45
  self.manisDrain = 10
  self.manisRegen = 1.2
  self.focusIndicatorX = 0
  self.focusMax = 4
  self.unFocus = 0
  self.unFocusGrowing = true
  self.stateTimer = 0
  self.saveUtility = SaveData()
  self.loadTest = {}
  self.optionSelector = 1
  self.gameOver = false
  self.activeEvent = false
  self.activeDialogueID = nil
  self.animatables = InsertAnimation(sceneView.currentMap.row, sceneView.currentMap.column)
end

function PlayState:update(dt)
  --[[
  if vibrancyGrow then
    vibrancy = math.min(vibrancy + dt, 10)
    if vibrancy == 10 then
      vibrancyGrow = false
    end
  else
    vibrancy = math.max(0, vibrancy - dt)
    if vibrancy == 0 then
      vibrancyGrow = true
    end
 end
 --]]
  if love.keyboard.wasPressed('y') then
    sceneView.activeDialogueID = nil
    gStateMachine:change('openingCinematic')
  end
  if love.keyboard.wasPressed('t') then
    sceneView.activeDialogueID = nil
    MAP[10][19].collidableMapObjects = {}
    gStateMachine:change('mageIntroTopTrigger')
  end
  self.stateTimer = self.stateTimer + dt
  if self.stateTimer >= 1 then
    --gStateMachine:change('chasmFallingState')
  end
  if love.keyboard.wasPressed('g') then
    if WINDOW_HEIGHT == 144 * SCALE_FACTOR * 2 then
      SCALE_FACTOR = 4
      WINDOW_HEIGHT = 144 * SCALE_FACTOR
      WINDOW_WIDTH = 160 * SCALE_FACTOR
      VIRTUAL_HEIGHT_GB = 144
    else
      SCALE_FACTOR = SCALE_FACTOR_RESET
      WINDOW_HEIGHT = 144 * SCALE_FACTOR * 2
      WINDOW_WIDTH = 160 * SCALE_FACTOR
      VIRTUAL_HEIGHT_GB = 144 * 2
    end

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT_GB, WINDOW_WIDTH, WINDOW_HEIGHT)
  end

  if INPUT:pressed('start') then
    if not PAUSED and not gPlayer.dead then
      gStateMachine:change('pauseState')
    end
  end

  if INPUT:pressed('start') or INPUT:pressed('action') then
    if self.gameOver then
      sceneView.player.deadTimer = 0
      sceneView.player.dead = false
      self.gameOver = false
      MAP[sceneView.currentMap.row][sceneView.currentMap.column].attacks = {}
      if self.optionSelector == 2 then
        gStateMachine:change('titleState')
      elseif self.optionSelector == 1 then
        --CONTINUE GAME
        --LOAD LAST SAVE
        self.saveUtility:loadPlayerData()
        gStateMachine:change('playState')
        gPlayer.stateMachine:change('player-meditate')
      end
    end
  end

  if INPUT:pressed('actionB') and gItemInventory.itemSlot[1] ~= nil then
    if gItemInventory.itemSlot[1].type == 'lute' then
      if not luteState then
        gPlayer.direction = 'down'
        gPlayer:changeAnimation('idle-down')
        luteState = true
      end
    end
  end

  if INPUT:pressed('select') then
    if luteState then
      luteState = false
    else
      --toggleHelp = toggleHelp == false and true or false
    end
  end

  if love.keyboard.wasPressed('c') then
    creditSequence = creditSequence == false and true or false
  end

  --self.rainSystem:update(dt)
  --self.snowSystem:update(dt)
  if creditSequence then
    self.rainSystem:update(dt)
    self.snowSystem:update(dt)
    creditsY = creditsY - CREDITS_SPEED
  end

  for k, v in pairs(touches) do
    if buttons[1]:collides(touches[k]) and touches[k].wasTouched then
      --DIALOGUE DETECTION
      for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox) do
        if gPlayer:dialogueCollides(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k]) then
          MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k]:flushText()
          --[[
          MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].line1Result = ''
          MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].line2Result = ''
          MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].line3Result = ''
          MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].lineCount = 1
          MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].textIndex = 1
          --]]
          --IF COLLIDES WITH SIGNPOST
          --table.insert(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBoxCollided, MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k])
          --PAUSED = true
        end
      end
      for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do
        if v.classType == 'treasureChest' then
          if not v.opened then
            if gPlayer:dialogueCollides(v) then
              v:openChest()
              self.dialogueID = k
              --treasureChestOption = true
              --v.dialogueBox[1]:flushText()
              --[[
              v.dialogueBox[1].line1Result = ''
              v.dialogueBox[1].line2Result = ''
              v.dialogueBox[1].line3Result = ''
              v.dialogueBox[1].lineCount = 1
              v.dialogueBox[1].textIndex = 1
              --]]
              --table.insert(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBoxCollided, MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects[k].dialogueBox[1])
              --PAUSED = true
            end
          end
        end
      end
    end

    if buttons[2]:collides(touches[k]) and gItemInventory.itemSlot[1] ~= nil then
      if gItemInventory.itemSlot[1].type == 'lute' then
        if not luteState then
          gPlayer.direction = 'down'
          gPlayer:changeAnimation('idle-down')
          luteState = true
        end
      end
    end

    if buttons[3]:collides(touches[k]) and touches[k].wasTouched then
      if luteState then
        luteState = false
      else
        toggleHelp = toggleHelp == false and true or false
      end
    end
  end

  if luteState then
    Lute:update(dt)
  end

  if not sceneView.shifting then
    --FOCUS GAIN
    if (INPUT:down('action') and not luteState) or (buttons[1].fireSpellPressed and not luteState) then
      --VIBRANCY DRAIN
      --if gPlayer.flammeVibrancy <a

      gPlayer.flammeVibrancy = math.min(100, gPlayer.flammeVibrancy + dt * 2)

      --UNFOCUS
      if (self.unFocus < self.focusMax) and self.unFocusGrowing then
        if self.manis > 0 then
          self.unFocus = self.unFocus + FOCUS_GROW * dt
        else
          self.unFocus = 0
        end
      end

      --UNFOCUS SHRINK
      if self.unFocus >= self.focusMax then
        self.unFocus = self.focusMax
        self.unFocusGrowing = false
      end

      --UNFOCUS DECREMENT
      if (self.unFocus <= self.focusMax) and not self.unFocusGrowing then
        self.unFocus = self.unFocus - FOCUS_GROW * dt
      end

      --UNFOCUS GROW
      if self.unFocus <= 0 then
        self.unFocus = 0
        self.unFocusGrowing = true
      end


      --APPLY UNFOCUS TO FOCUS INDICATOR
      self.focusIndicatorX = math.max(self.focusIndicatorX - (self.manisDrain + self.unFocus) * dt, 0)

      --CLAMP FOCUS INDICATOR TO 0 IF NO MANIS
      if self.manis <= 0 then
        self.focusIndicatorX = math.max(self.focusIndicatorX - (self.manisDrain - self.unFocus) * dt, 0)
      end

      --MANIS DRAIN
      self.manis = math.max(self.manis - MANIS_DRAIN * dt, 0)
      if self.manis > 0 then
        manisTimer = manisTimer + dt
      end

      if self.manis > 0 then
        --FOCUS INDICATOR RISING
        self.focusIndicatorX = math.min(self.focusIndicatorX + (self.unFocus * UNFOCUS_SCALER) * dt, self.manisMax - 2)
      end
    else
      --MANIS REGEN
      self.manis = math.min(self.manis + MANIS_REGEN * dt, self.manisMax)
      --UNFOCUS DRAIN
      self.unFocus = 0
      self.focusIndicatorX = math.max(self.focusIndicatorX - FOCUS_DRAIN * dt, 0)
    end

    --TODO
    for k, v in ipairs(buttons) do
      if v.direction == 'B' then

      end
    end
  end

  if self.focusIndicatorX >= 65 and self.focusIndicatorX <= 85 then
    successfulCast = true
    --sounds['spellcast']:play()
  else
    successfulCast = false
  end

  cameraX = cameraX + 1

  --ADD TOUCH
  --


  --TODO MOVE FROM PLAYSTATE

  if INPUT:pressed('select') then
    gStateMachine:change('minimap')
    gStateMachine.current.cursorX = sceneView.currentMap.column * 16 - 16
    gStateMachine.current.cursorY = sceneView.currentMap.row * 13 - 13
    gStateMachine.current.row = sceneView.currentMap.row
    gStateMachine.current.column = sceneView.currentMap.column
    gStateMachine.current.tashioRow = sceneView.currentMap.row
    gStateMachine.current.tashioColumn = sceneView.currentMap.column
    gStateMachine.current.tashioX = gPlayer.x / 16
    gStateMachine.current.tashioY = gPlayer.y / 13
    --MINIMAP_ROW = sceneView.currentMap.row
    --MINIMAP_COLUMN = sceneView.currentMap.column
  end


  if INPUT:pressed('action') then
    --DIALOGUE DETECTION
    for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox) do
      if gPlayer:dialogueCollides(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k]) and not MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].activated then
        PAUSED = true
        MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k]:flushText()
        MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].activated = true
        self.dialogueID = k
        self.activeDialogueID = v.dialogueID
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

  if not PAUSED then
    sceneView:update(dt)
    --TODO CAN WE DIG DOWN INTO THE PLAY STATE AND PULL FIELDS
    self.activeDialogueID = sceneView.activeDialogueID
  end

  if gStateMachine.current.stateName == 'PlayState' then
    self.animatables:update(dt)
  end

  --UPDATE DIALOGUE BOXES
  --DIALOGUE UPDATE
  if self.activeDialogueID ~= nil then
    MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[self.activeDialogueID]:update(dt)
  end

  --DIALOGUE BOX UPDATES FOR NPCS
  for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox) do
    if v.option == 'npc' then
      v.x = v.npc.x
      v.y = v.npc.y
    end
  end

  --DIALOGUE UPDATE
  if PAUSED then
      --MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects[self.dialogueID].dialogueBox[1]:update(dt)
    if MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[self.activeDialogueID] ~= nil then
      --MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[self.activeDialogueID]:update(dt)
      --[[
    elseif MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBoxCollided ~= nil then
      MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBoxCollided[1]:update(dt)
      --]]
    end
  end

  rotate = rotate + .05

  --LOCK SCREEN POSITION
  --GAMEBOY TOGGLE
  --love.window.setPosition(400, 40)
  --SCREEN LOCK POSITION
  --DEV POSITION
  love.window.setPosition(400, 60)

  --WARP ZONES
  if #MAP[sceneView.currentMap.row][sceneView.currentMap.column].warpZones > 0 then
    for k, v in pairs(sceneView.currentMap.warpZones) do
      if v:collides() and not gPlayer.warping then
        gPlayer:changeState('player-idle')
        --gPlayer:changeState('player-walk')
        gPlayer.currentAnimation:refresh()
        triggerStartingSceneTransition = true
        gPlayer.warping = true
        --RESET TREASURE CHEST TODO TURN OFF FOR DEMO
        for k, v in pairs(MAP[v.warpRow][v.warpCol].collidableMapObjects) do
          if v.classType == 'treasureChest' then
            --v:reset()
          end
          if v.classType == 'pushable' then
            v:resetOriginalPosition()
          end
        end
        MAP[v.warpRow][v.warpCol].coins = {}
        --DISJOINTED DIALOGUE BOX
        if MAP[v.warpRow][v.warpCol].disjointUp then
          gPlayer.extendDialogueBoxUpwards = true
        else
          gPlayer.extendDialogueBoxUpwards = false
        end
      end
    end
  end

  if triggerStartingSceneTransition then
    leftFadeTransitionX = leftFadeTransitionX + FADE_TRANSITION_SPEED * dt
    rightFadeTransitionX = rightFadeTransitionX - FADE_TRANSITION_SPEED * dt
    if leftFadeTransitionX > 0 then
      leftFadeTransitionX = 0
      triggerStartingSceneTransition = false
      startingSceneTransitionFinished = true
      for k, v in pairs(sceneView.currentMap.warpZones) do
        if gPlayer.warping then
          sceneView = Scene(gPlayer, sceneView.currentMap.warpZones[k].warpRow, sceneView.currentMap.warpZones[k].warpCol)
          gStateMachine.current.animatables = InsertAnimation(sceneView.currentMap.row, sceneView.currentMap.column)
          gPlayer.x = v.playerX
          gPlayer.y = v.playerY
        end
      end
      triggerFinishingSceneTransition = true
    end
    if rightFadeTransitionX < VIRTUAL_WIDTH / 2 then
      rightFadeTransitionX = VIRTUAL_WIDTH / 2
      triggerStartingSceneTransition = false
      startingSceneTransitionFinished = true
      --RESET ENTITIES UPON WARP
      for i = 1, #MAP[sceneView.currentMap.row][sceneView.currentMap.column].entities do
        MAP[sceneView.currentMap.row][sceneView.currentMap.column].entities[i]:resetOriginalPosition()
      end
      sceneView.player.checkPointPositions.x = sceneView.player.x
      sceneView.player.checkPointPositions.y = sceneView.player.y
    end
    transitionFadeAlpha = math.min(transitionFadeAlpha + FADE_TO_BLACK_SPEED * dt, 255)
  end
  if triggerFinishingSceneTransition then
    leftFadeTransitionX = leftFadeTransitionX - FADE_TRANSITION_SPEED * dt
    rightFadeTransitionX = rightFadeTransitionX + FADE_TRANSITION_SPEED * dt
    if leftFadeTransitionX < -VIRTUAL_WIDTH / 2 then
      leftFadeTransitionX = -VIRTUAL_WIDTH / 2
      triggerFinishingSceneTransition = false
      startingSceneTransitionFinished = false
    end
    if rightFadeTransitionX > VIRTUAL_WIDTH then
      rightFadeTransitionX = VIRTUAL_WIDTH
      triggerFinishingSceneTransition = false
      startingSceneTransition = false
      gPlayer.warping = false
    end
    transitionFadeAlpha = math.max(transitionFadeAlpha - FADE_TO_BLACK_SPEED * dt, 0)
  end

  --SAVE
  if love.keyboard.wasPressed('k') then
    self.saveUtility:savePlayerData()
  end

  --LOADING
  if love.keyboard.wasPressed('l') then
    gPlayer.stateMachine:change('player-meditate')
    self.saveUtility:loadPlayerData()
  end

  --GAME OVER OPTION SELECTOR
  if self.gameOver then
    if INPUT:pressed('down') then
      if self.optionSelector ~= 2 then
        sounds['beep']:play()
      end
      self.optionSelector = 2
    elseif INPUT:pressed('up') then
      if self.optionSelector ~= 1 then
        sounds['beep']:play()
      end
      self.optionSelector = 1
    end
  end

  --MINERAL UPDATE
  for k, v in pairs(MAP[4][12].mineralDeposits) do
      if v.harvestTime < MINERAL_HARVEST_RESET then
        v:update(dt)
      end
  end
end

function PlayState:render()
  love.graphics.clear(BLACK)

  love.graphics.push()
  sceneView:render()
  love.graphics.pop()
  ---[[
  love.graphics.setColor(0,0,0,255)
  --love.graphics.print('Tashio Tempo', VIRTUAL_WIDTH - 150, SCREEN_HEIGHT_LIMIT + 4)

  --MANIS BAR RENDER
  ---[[
  love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
  love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT - 4, self.manis, 2)

  --CAST BAR RENDER
  love.graphics.setColor(BLACK)
  love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT + 2 - 4, 100, 2)

  --SUCCESSFUL CAST RANGE
  love.graphics.setColor(GREEN)
  love.graphics.rectangle('fill', 65, SCREEN_HEIGHT_LIMIT + 2 - 4, 20, 2)

  --FOCUS INDICATOR
  love.graphics.setColor(WHITE)
  love.graphics.rectangle('fill', self.focusIndicatorX, SCREEN_HEIGHT_LIMIT + 2 - 4, 2, 2)
  --]]

  --DEBUG MANIS SPELLCASTING
  --[[
  love.graphics.print('unFocus: ' .. tostring(self.unFocus), 5, SCREEN_HEIGHT_LIMIT - 15)
  love.graphics.print('unFocusGrowing: ' .. tostring(self.unFocusGrowing), 5, SCREEN_HEIGHT_LIMIT - 25)
  love.graphics.print('focusIndicatorX: ' .. tostring(self.focusIndicatorX), 5, SCREEN_HEIGHT_LIMIT - 35)
  --]]

  love.graphics.setFont(classicFont)
  love.graphics.setColor(BLACK)
  --love.graphics.printf('Tashio Tempo', 0, VIRTUAL_HEIGHT - 13, VIRTUAL_WIDTH, 'center')
  ---[[KEYLOGGER
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

  --DEBUG PRINT
  if love.keyboard.isDown('5') then
    love.graphics.setColor(DEBUG_BG)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(WHITE)
    love.graphics.setFont(pixelFont)
    love.graphics.print('MAP[' .. tostring(sceneView.currentMap.row) .. '][' .. tostring(sceneView.currentMap.column) .. ']', 5, 15)
    love.graphics.print('player.x: ' .. string.format("%.1f", gPlayer.x), 5, 25)
    love.graphics.print('player.y: ' .. string.format("%.1f", gPlayer.y), 5, 35)
    love.graphics.print('direction: ' .. tostring(gPlayer.direction), 5, 45)
    love.graphics.print('playerLastInput: ' .. tostring(gPlayer.lastInput), 5, 55)
    love.graphics.print('Cast: ' .. tostring(successfulCast), 5, 65)
    love.graphics.print('animatables: ' .. tostring(sceneView.currentMap.tiles[4][1].id), 5, 75)
    love.graphics.print('INPUT_LIST: ' .. inspect(INPUT_LIST), 5, 85)
    love.graphics.print('player_state: ' .. tostring(PLAYER_STATE), 5, 95)
    love.graphics.print('collideCount: ' .. tostring(topCollidesCount), 5, 105)
    --love.graphics.print('fallTimer: ' .. tostring(sceneView.player.fallTimer), 5, 105)
    --love.graphics.print('falling: ' .. tostring(sceneView.player.falling), 5, 115)
    love.graphics.print('attacks: ' .. tostring(MAP[sceneView.currentMap.row][sceneView.currentMap.column].attacks[1]), 5, 115)
    --love.graphics.print('pushTimer: ' .. tostring(sceneView.player.pushTimer), 85, 115)
    --love.graphics.print('rightCollide: ' .. tostring(gPlayer:rightCollidesMapObject(MAP[sceneView.currentMap.row][sceneView.currentMap.column].pushables[1]), 85, 115))
  elseif love.keyboard.isDown('6') then
    love.graphics.setColor(DEBUG_BG)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(WHITE)
    --love.graphics.print('graveyard: ' .. inspect(sceneView.player.graveyard), 5, 25)
    love.graphics.print('checkpoint: ' .. inspect(gPlayer.checkPointPositions), 5, 35)
    --love.graphics.print('testNumber' .. inspect(testNumber), 5, 35)
    --print('leftCount: ' .. inspect(leftCount), 5, 15)
    --print(inspect(sceneView.player.animations['falling']))

  end

  --love.graphics.print('luteState' .. tostring(luteState), 0, VIRTUAL_HEIGHT - 50)
  love.graphics.setFont(pixelFont)

  --LUTE RENDER
  if luteState then
    Lute:render()
  end

  if toggleHelp then
    love.graphics.setColor(180/255, 20/255, 30/255, 190/255)
    love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

    love.graphics.setFont(classicFont)

    love.graphics.setColor(0/255, 0/255, 100/255, 255/255)
    love.graphics.printf('CONTROLS:', 10, 20, 150, 'left')
    love.graphics.printf('WASD = MOVE', 10, 40, 150, 'left')
    love.graphics.printf('P KEY = A BUTTON', 10, 60, 150, 'left')
    love.graphics.printf('O KEY = B BUTTON', 10, 80, 150, 'left')
    love.graphics.printf('ENTER = INVENTORY', 10, 100, 150, 'left')
    love.graphics.setColor(WHITE)
    love.graphics.printf('CONTROLS:', 9, 19, 150, 'left')
    love.graphics.printf('WASD = MOVE', 9, 39, 150, 'left')
    love.graphics.printf('P KEY = A BUTTON', 9, 59, 150, 'left')
    love.graphics.printf('O KEY = B BUTTON', 9, 79, 150, 'left')
    love.graphics.printf('ENTER = INVENTORY', 9, 99, 150, 'left')
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

  --VIBRANCY RENDER
  love.graphics.draw(flamme, VIRTUAL_WIDTH / 2 - 11, VIRTUAL_HEIGHT - 13)
  --EMPTY VIBRANCY BAR
  love.graphics.setColor(255/255, 30/255, 30/255, 255/255)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 2, VIRTUAL_HEIGHT - 13, 2, 10)
  --VIBRANCY BAR
  love.graphics.setColor(30/255, 30/255, 30/255, 255/255)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 2, VIRTUAL_HEIGHT - 13, 2, gPlayer.flammeVibrancy / 10)
  --love.graphics.print('vibrancy: ' .. tostring(gPlayer.flammeVibrancy), 0, 0)
  love.graphics.setColor(WHITE)
  love.graphics.draw(flamme, VIRTUAL_WIDTH / 2 - 11, VIRTUAL_HEIGHT - 13)

  --TRANSITION START
  love.graphics.setColor(BLACK)
  love.graphics.rectangle('fill', leftFadeTransitionX, 0, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT)
  love.graphics.rectangle('fill', rightFadeTransitionX, 0, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT)

  --TRANSITION BLACK FADE
  love.graphics.setColor(0/255, 0/255, 0/255, transitionFadeAlpha/255)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  --[[
  love.graphics.setColor(WHITE)
  --love.graphics.print('player_wt: ' .. tostring(gPlayer.walkTimer), 5, 10)
  -- love.graphics.print('frame: ' .. tostring(gPlayer.currentAnimation:getCurrentFrame()), 5, 20)
  --]]
  --
  --print(MAP[sceneView.currentMap.row][sceneView.currentMap.column].npc[1].dialogueBox[1].text)
  love.graphics.setColor(WHITE)
  --love.graphics.print('value: ' .. MAP[7][2].pushables[1].classType, 10, 10)
  displayFPS()

  --CREDITED SUPPORTERS
  if creditSequence then
    love.graphics.setColor(0, 0, 0, 190/255)
    love.graphics.rectangle('fill',0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(WHITE)
    --self.snowSystem:render()
    self.rainSystem:render()
    love.graphics.printf('SUPPORTERS:\nsoup_or_king\nakabob56\njeanniegrey\nsaltomanga\nmeesegamez\nk_tronix\nhimeh3\nflatulenceknocker\nofficial_wutnot\nroughcookie\ntheshakycoder\ntjtheprogrammer\npunymagus\nprostokotylo\ntheveryrealrev\nsqwinge\nbrettdoestwitch\nbrightsidemovement\nlokitrixter', 0, creditsY, VIRTUAL_WIDTH, 'center')
  end

  --self.snowSystem:render()
  --self.rainSystem:render()
  if sceneView.player.deadTimer > 2 then
    gPlayer.dx = 0
    gPlayer.dy = 0
    gPlayer:changeAnimation('death')
    self.gameOver = true
  end
  if self.gameOver then
    love.graphics.setColor(1,0,0,100/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setFont(classicFont)
    love.graphics.setColor(WHITE)
    love.graphics.printf('GAME OVER', 0, 24, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(pixelFont)

    if self.optionSelector == 1 then
      love.graphics.setColor(DARK_CYAN)
      love.graphics.printf('CONTINUE', 0, VIRTUAL_HEIGHT - 56, VIRTUAL_WIDTH, 'center')
      love.graphics.setColor(DARK_RED)
      love.graphics.printf('QUIT', 0, VIRTUAL_HEIGHT - 36, VIRTUAL_WIDTH, 'center')
    elseif self.optionSelector == 2 then
      love.graphics.setColor(DARK_RED)
      love.graphics.printf('CONTINUE', 0, VIRTUAL_HEIGHT - 56, VIRTUAL_WIDTH, 'center')
      love.graphics.setColor(DARK_CYAN)
      love.graphics.printf('QUIT', 0, VIRTUAL_HEIGHT - 36, VIRTUAL_WIDTH, 'center')
    end
  end



  --TOUCH DEBUG
    for id, state in pairs(INPUT._touches) do
      --love.graphics.print(id, "pressed:", state.pressed, "down:", state.down, "released:", state.released)
      --love.graphics.print(tostring(INPUT:getActiveDevice()), 0,0)
    end
    --DEBUG
    local bat = MAP[4][11].entities[1]
    --[[
    love.graphics.print('sTimer: ' .. tostring(bat.spawnTimer), 0,10)
    love.graphics.print('pTimer: ' .. tostring(bat.pursueTimer), 0,20)
    love.graphics.print('pTrigger: ' .. tostring(bat.pursueTrigger), 0,30)
    --]]
    --DEBUGG
    --love.graphics.print('state: ' .. tostring(bat.stateMachine.current.stateName), 0,40)
    --love.graphics.print('blocked: ' .. tostring(bat.blocked), 0,0)
end

function displayFPS()
  love.graphics.setFont(classicFont)
  love.graphics.setColor(WHITE)
  love.graphics.print(tostring(love.timer.getFPS()), SCREEN_WIDTH_LIMIT - 27, VIRTUAL_HEIGHT - 12)
end

