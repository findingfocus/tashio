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
Lute = Lute()
leftCount = 0
luteState = false
toggleHelp = false
gItemInventory = Inventory('item')
gKeyItemInventory = Inventory('keyItem')
gItems = {}

--LUTE EQUIP OBTAIN
--table.insert(gItemInventory.grid[1][1], Item('lute'))
--table.insert(gItemInventory.grid[1][2], Item('healthPotion', 10))

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
--sceneView = Scene(gPlayer, 4, 13)
--sceneView = Scene(gPlayer, 10, 18)
--sceneView = Scene(gPlayer, 2, 11)
--ICE MOUNTAIN SHORTCUT
--sceneView = Scene(gPlayer, 3, 5)
--DARK FOREST
--sceneView = Scene(gPlayer, 3, 5)
sceneView = Scene(gPlayer, 7, 5)
--sceneView = Scene(gPlayer, 1, 13)
--sceneView = Scene(gPlayer, 9, 3)
--sceneView = Scene(gPlayer, 9, 2)
--sceneView = Scene(gPlayer, 4, 11)

--GREEN TUNIC EQUIP
--PLAYER EQUIPS
--gPlayer.tunicEquipped = 'greenTunic'
--gPlayer.elementEquipped = 'flamme'

--sceneView = Scene(gPlayer, 1, 12)
--sceneView = Scene(gPlayer, 1, 11)
--[[
gPlayer.y = TILE_SIZE * 3
gPlayer.x = TILE_SIZE * 4
--]]
gPlayer.y = TILE_SIZE * 4
gPlayer.x = TILE_SIZE * 4
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
  self.stateTimer = 0
  self.saveUtility = SaveData()
  self.loadTest = {}
  self.optionSelector = 1
  self.gameOver = false
  self.activeEvent = false
  self.activeDialogueID = nil
  self.animatables = InsertAnimation(sceneView.currentMap.row, sceneView.currentMap.column)

  if SAVE_DATA_NEEDS_LOADING then
    self.saveUtility:loadPlayerData()
    SAVE_DATA_NEEDS_LOADING = false
  end
end


local sfx_index = 1
function PlayState:update(dt)
  if love.keyboard.wasPressed('b') then
    playThis[sfx_index]:play()
    sfx_index = sfx_index + 1
  end

  if love.keyboard.wasPressed('f') then
    ---[[
    gPlayer.flammeUnlocked = true
    gPlayer.elementEquipped = 'flamme'
    gPlayer.greenTunicUnlocked = true
    gPlayer.tunicEquipped = 'greenTunic'
    --]]
    --[[
    gPlayer.greenTunicUnlocked = false
    gPlayer.tunicEquipped = ''
    sceneView = Scene(gPlayer, 7, 5)
    gKeyItemInventory.tomeEquipped = 'tome1'
    gKeyItemInventory.tome1Equipped = true
    gPlayer.tome1Unlocked = true
    --]]
  end

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
    if not PAUSED and not gPlayer.dead and not luteState then
      sfx['pause2']:play()
      gStateMachine:change('pauseState')
    end
  end

  --NON CHASM GAME OVER
  if INPUT:pressed('start') or INPUT:pressed('action') then
    if self.gameOver then
      sceneView.player.deadTimer = 0
      sceneView.player.dead = false
      self.gameOver = false
      MAP[sceneView.currentMap.row][sceneView.currentMap.column].attacks = {}
      if self.optionSelector == 2 then
        gStateMachine:change('titleState')
        gStateMachine.current.step = 3
        gPlayer.health = 6
      elseif self.optionSelector == 1 then
        --CONTINUE GAME
        --LOAD LAST SAVE
        SOUNDTRACK = MAP[sceneView.currentMap.row][sceneView.currentMap.column].ost
        SAVE_DATA_NEEDS_LOADING = true
        gStateMachine:change('playState')
        --self.saveUtility:loadPlayerData()
        gPlayer.stateMachine:change('player-meditate')
      end
    end
  end

  --TRIGGER LUTE STATE
  if INPUT:pressed('actionB') and gItemInventory.itemSlot[1] ~= nil then
    if gItemInventory.itemSlot[1].type == 'lute' then
      if not luteState then
        if not sceneView.dialogueBoxActive then
          if not gPlayer.dead then
            gPlayer.direction = 'down'
            gPlayer:changeAnimation('idle-down')
            luteState = true
            Lute:reset()
            bassNotes1:reset()
          end
        end
      end
    elseif gItemInventory.itemSlot[1].type == 'healthPotion' and gPlayer.health < 14 and gItemInventory.itemSlot[1].quantity > 0 then
      --HEALTH POTION HEAL
      love.graphics.setColor(WHITE)
      love.graphics.print('POTION', 0,0)
      gItemInventory.itemSlot[1].quantity = math.max(0, gItemInventory.itemSlot[1].quantity - 1)
      gPlayer.health = 14
      sfx['use-potion']:play()
    end
  end

  if luteState then
    if INPUT:pressed('select') then
      Lute:reset()
      bassNotes1:reset()
    end
  end

  if love.keyboard.wasPressed('e') then
    gItemInventory.grid[1][1] = {}
  end

  if INPUT:pressed('start') then
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

  if luteState then
    Lute:update(dt)
  end

  cameraX = cameraX + 1

  --ADD TOUCH
  --


  --TODO MOVE FROM PLAYSTATE

  --TOGGLE MINIMAP
  if INPUT:pressed('select') and not luteState then
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
    --MINIMAP_ROW = sceneView.currentMap.row
    --MINIMAP_COLUMN = sceneView.currentMap.column
  end


  if INPUT:pressed('action') and not gPlayer.meditate then
    --DIALOGUE DETECTION DIALOGUE COLLIDE
    for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox) do
      if gPlayer:dialogueCollides(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k]) and not MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].activated then
          --if gPlayer.direction ~= 'up' then
          sfx['ui-scroll1']:play()
          PAUSED = true
          MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k]:flushText()
          MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[k].activated = true
          self.activeDialogueID = k
          sceneView.activeDialogueID = self.activeDialogueID
          --end
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

  --TODO DOES THIS WORK OUTSIDE OF CONDITIONAL
  if gStateMachine.current.stateName == 'PlayState' then
    --self.animatables:update(dt)
  end
  self.animatables:update(dt)

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


  --SAVE
  if love.keyboard.wasPressed('k') then
    self.saveUtility:savePlayerData()
  end

  --LOADING
  if love.keyboard.wasPressed('l') then
    gPlayer.stateMachine:change('player-meditate')
    --self.saveUtility:loadPlayerData()
    local animatables = InsertAnimation(sceneView.mapRow, sceneView.mapColumn)
    gStateMachine.current.animatables = animatables
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
  for k, v in pairs(MAP[2][13].mineralDeposits) do
    if v.harvestTime < MINERAL_HARVEST_RESET then
      v:update(dt)
    end
  end

  --TOME 1 SUCCESS
  ---[[
  if love.keyboard.wasPressed('n') then
    gPlayer:changeState('player-cinematic')
    gStateMachine:change('Tome1SuccessState')
    gStateMachine.current.animatables:update(dt)
  end
  --]]

  if sceneView.dialogueBoxActive then
    sceneView.dialogueBoxActive = false
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

  --HERE
  ---[[
  if gItemInventory.itemSlot[1] ~= nil then
    love.graphics.setFont(pixelFont)
    gItemInventory.itemSlot[1]:render()
  end
  --]]
  

  --[[
  love.graphics.setColor(gKeyItemInventory.elementColor)
  love.graphics.circle('fill', VIRTUAL_WIDTH - 86, VIRTUAL_HEIGHT - 8, 6)
  --]]

  love.graphics.setColor(WHITE)
  love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
  heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
  love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)

  if gPlayer.elementEquipped == 'flamme' then
    --VIBRANCY RENDER
    --love.graphics.draw(flamme, VIRTUAL_WIDTH / 2 - 11, VIRTUAL_HEIGHT - 13)
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

  --MAGIC RENDER
  --MANIS BAR RENDER
  ---[[
  if self.activeDialogueID == nil then
    love.graphics.setColor(255/255, 0/255, 0/255, gPlayer.magicHudOpacity/255)
    love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT - 4, gPlayer.manis, 2)

    --CAST BAR RENDER
    love.graphics.setColor(0,0,0, gPlayer.magicHudOpacity/255)
    love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT + 2 - 4, 100, 2)

    --SUCCESSFUL CAST RANGE
    love.graphics.setColor(0,1,0, gPlayer.magicHudOpacity/255)
    love.graphics.rectangle('fill', 65, SCREEN_HEIGHT_LIMIT + 2 - 4, 20, 2)

    --FOCUS INDICATOR
    love.graphics.setColor(1,1,1, gPlayer.magicHudOpacity/255)
    love.graphics.rectangle('fill', gPlayer.focusIndicatorX, SCREEN_HEIGHT_LIMIT + 2 - 4, 2, 2)
    --]]

    --TRANSITION START
    love.graphics.setColor(BLACK)
    love.graphics.rectangle('fill', leftFadeTransitionX, 0, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT)
    love.graphics.rectangle('fill', rightFadeTransitionX, 0, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT)

    --TRANSITION BLACK FADE
    love.graphics.setColor(0/255, 0/255, 0/255, transitionFadeAlpha/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  end

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
    love.graphics.printf('SUPPORTERS:\nsoup_or_king\nakabob56\njeanniegrey\nsaltomanga\nmeesegamez\nk_tronix\nhimeh3\nflatulenceknocker\nofficial_wutnot\nroughcookie\ntheshakycoder\ntjtheprogrammer\npunymagus\nprostokotylo\ntheveryrealrev\nsqwinge\nbrettdoestwitch\nbrightsidemovement\nlokitrixter\nkviktus', 0, creditsY, VIRTUAL_WIDTH, 'center')
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
    --love.graphics.print('dID: ' .. tostring(sceneView.activeDialogueID), 0,0)
    --STATE DEBUG
    --[[
    print(Inspect(gStateMachine.states.playState.animatables[1]))
    --]]
    --DEBUG
    --[[
    love.graphics.print(tostring(MAP[1][12].entities[1].x), 0, 10)
    love.graphics.print(tostring(MAP[1][12].entities[1].darkBat), 0, 30)
    love.graphics.print(tostring(MAP[1][12].entities[1].blocked), 0, 40)
    love.graphics.print(tostring(MAP[1][12].entities[1].stateName), 0, 50)
    --]]
    --REST DEBUG
    --[[
    love.graphics.print('abutton: ' .. tostring(MAP[10][18].dialogueBox[2].aButtonCount), 0, 20)
    love.graphics.print('pageLength: ' .. tostring(MAP[10][18].dialogueBox[2].pageLength), 0, 30)
    love.graphics.print('restButton: ' .. tostring(MAP[10][18].dialogueBox[2].restButtonCount), 0, 40)
    love.graphics.print('test: ' .. tostring(MAP[10][18].dialogueBox[2].test), 0, 50)
    love.graphics.print('cPage: ' .. tostring(MAP[10][18].dialogueBox[2].currentPage), 0, 60)
    --print(Inspect(MAP[10][18].dialogueBox[2]))
    --]]
    --
    --DEBUG RENDER
    for k, v in pairs(MAP[2][11].dialogueBox) do
      --v:render()
    end

    --[[
    love.graphics.print('#: ' .. tostring(#sceneView.particleSystem), 0, 10)
    love.graphics.print('mRow: ' .. tostring(sceneView.mapRow), 0, 20)
    love.graphics.print('mCol: ' .. tostring(sceneView.mapColumn), 0, 30)
    --]]
    --love.graphics.print(sceneView.currentMap.column, 0, 0)
    --

    --TODO
    --KEY ITEM PUZZLE STATE FOR SCENE 7, 5
    --SHORTCUT 1
    if sceneView.currentMap.row == 7 and sceneView.currentMap.column == 5 then
      for k, v in pairs(MAP[7][5].collidableMapObjects) do
        if v.type == 'boulder' then
          if v.identifier == 'keyItem1' then
            --COL 2, ROW 4 OR 6
            if (v.x / TILE_SIZE) + 1 == 2 then
              v.keyItem = true
              if (v.y / TILE_SIZE) + 1 ~= 5 then
                v.keyItem = true
              else
                v.keyItem = false
              end
            end
          elseif v.identifier == 'keyItem2' then
            --COL 1, ROW 3 or 4
            if (v.x / TILE_SIZE) + 1 == 1 then
              if (v.y / TILE_SIZE) + 1 == 4 or (v.y / TILE_SIZE) + 1 == 3 then
                v.keyItem = true
              else
                v.keyItem = false
              end
            end
          elseif v.identifier == 'keyItem3' then
            --COL 3, ROW 4 OR 6
            if (v.x / TILE_SIZE) + 1 == 3 then
              v.keyItem = true
              if (v.y / TILE_SIZE) + 1 == 4 or (v.y / TILE_SIZE) + 1 == 6 then
                v.keyItem = true
              else
                v.keyItem = false
              end
            end

          end
        end
      end
    end

    love.graphics.setColor(WHITE)

    --DEBUG
    --[[
    love.graphics.print('tome: ' .. gKeyItemInventory.tomeEquipped, 0, 0)
    love.graphics.print('justClosed: ' .. tostring(sceneView.dialogueBoxJustClosed), 0, 10)
    --]]
    --love.graphics.print('falling: ' .. tostring(gPlayer.falling), 0, 10)
    --love.graphics.print('g1-2: ' .. Inspect(gItemInventory.grid[1][2]), 0, 10)
    if #gItemInventory.grid[1][2] == 0 then
      love.graphics.print('1 2 is empty!', 0, 20)
    else
    --love.graphics.print('1 2 is: ' .. tostring(gItemInventory.grid[1][2][1].type), 0, 20)
    end
end

function displayFPS()
  love.graphics.setFont(classicFont)
  love.graphics.setColor(WHITE)
  love.graphics.print(tostring(love.timer.getFPS()), SCREEN_WIDTH_LIMIT - 27, VIRTUAL_HEIGHT - 12)
end

