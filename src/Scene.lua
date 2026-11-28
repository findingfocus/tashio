Scene = Class{}

local TIME = 0
local SPEED = 3
local PLAYER_OFFSET = TILE_SIZE / 2
local AMP = 20
local TRANSITION_SPEED = 0.65
--SPELLCAST COUNT
local x, y = love.mouse.getPosition()

local triggerSceneTransition = false
local leftFadeTransitionX = -VIRTUAL_WIDTH / 2
local rightFadeTransitionX = VIRTUAL_WIDTH
local startingSceneTransitionFinished = false
local transitionFadeAlpha = 0
local leftPingbackHandle = nil
local rightPingbackHandle = nil
local topPingbackHandle = nil
local bottomPingbackHandle = nil

--INPUT GUARDS
function isSceneBusy()
  return sceneView.shifting or PAUSED or CREDITS_ROLLING or sceneView.activeDialogueID ~= nil or sceneView.dialogueBoxActive
end

function canPlayerAct()
  return not isSceneBusy() and not gPlayer.dead and not gPlayer.falling and not gPlayer.warping
end

function canPlayerUseItem()
  return canPlayerAct() and gItemInventory.itemSlot[1] ~= nil
end

function canStrumLute(timeSinceLastStrum)
  if not canPlayerUseItem() then return false end
  if gItemInventory.itemSlot[1].type ~= 'lute' then return false end
  if timeSinceLastStrum ~= nil and timeSinceLastStrum <= 1 then return false end
  if #gPlayer.rings ~= 0 and gPlayer.rings[1].ringActive then return false end
  return true
end

function canCastElement()
  return not isSceneBusy() and not dialogueBoxJustClosed and not luteState and gPlayer.elementEquipped ~= '' and not gPlayer.gameJustStarted and not gPlayer.dead
end

--PINGBACK HELPER
local function registerPingback(self, eventName, stackKey, activeKey, indexKey, timerKey, timerHandleKey, thresholdKey, currentHandle)
  if currentHandle ~= nil then
    currentHandle:remove()
  end
  return Event.on(eventName, function()
    if self[activeKey] then
      return
    end
    self[activeKey] = true
    self[indexKey] = #self.pingbackStack[stackKey]
    self[timerKey] = 0
    local pingback = self.pingbackStack[stackKey][self[indexKey]]
    if pingback ~= nil then
      table.insert(self.resonanceRings, Resonance('enemy', nil, pingback.status, pingback.entityX, pingback.entityY))
    end
    self[indexKey] = self[indexKey] - 1
    if self[indexKey] <= 0 then
      self[activeKey] = false
      return
    end
    self[timerHandleKey] = Timer.every(self[thresholdKey], function()
      local nextPingback = self.pingbackStack[stackKey][self[indexKey]]
      if nextPingback ~= nil then
        table.insert(self.resonanceRings, Resonance('enemy', nil, nextPingback.status, nextPingback.entityX, nextPingback.entityY))
      end
      self[indexKey] = self[indexKey] - 1
      if self[indexKey] <= 0 then
        self[activeKey] = false
        self[timerHandleKey] = nil
        return false
      end
    end)
  end)
end

function Scene:init(player, mapRow, mapColumn)
  self.player = player
  self.mapRow = mapRow
  self.mapColumn = mapColumn
  self.currentMap = Map(mapRow, mapColumn, self.player.spellcastCount)
  self.snowSystem = SnowSystem()
  self.rainSystem = RainSystem()
  self.lavaSystem = LavaSystem()
  self.sandSystem = SandSystem()
  self.dialogueBoxActive = false
  self.particleSystem = {}

  self.cameraX = 0
  self.cameraY = 0
  self.shifting = false
  self.entities = {}

  self.spellcastEntityCount = self.player.spellcastCount
  self.count = self.spellcastEntityCount
  self.step = math.pi * 2 / self.count

  self.spellcastEntities = {}
  self.possibleDirections = {'left', 'right', 'up', 'down'}
  self.activeDialogueID = nil
  self.tutorialText = false
  self.tutorialTextAlpha = 0

  self.resonanceRings = {}

  local resonanceColor = 'corrupt'
  --table.insert(self.resonanceRings, Resonance('enemy', nil, resonanceColor))
  -- self.resonanceRings[1].entityX = 10
  -- self.resonanceRings[1].entityY = 10

  self.pingbackStack = {
    -- ['top'] = {Resonance('enemy', nil, 'corrupt', 30, -20)},
    ----table.insert(self.resonanceRings, Resonance('enemy', nil, resonanceColor, 12,0))
    --['right'] = {Resonance('enemy', nil, 'corrupt', VIRTUAL_WIDTH + 4, 50), Resonance('enemy', nil, 'cleansed', VIRTUAL_WIDTH + 4, 85)},
    --['bottom'] = {Resonance('enemy', nil, 'corrupt', 45, SCREEN_HEIGHT_LIMIT + 4), Resonance('enemy', nil, 'reintegrated', 70, SCREEN_HEIGHT_LIMIT + 4)},
    ---- ['left'] = {Resonance('enemy', nil, resonanceColor, -20, 50), Resonance('enemy', nil, resonanceColor, -20, 10), Resonance('enemy', nil, resonanceColor, -20, 80)},
    --['left'] = {Resonance('enemy', nil, resonanceColor, -20, 50), Resonance('enemy', nil, 'reintegrated', -20, 69)},
    ['top'] = {},
    ['right'] = {},
    ['bottom'] = {},
    ['left'] = {},
  }

  self.leftPingbackIndex = 0
  self.leftPingbackTimer = 0
  self.leftPingbackTimerThreshold = 0.5
  self.leftPingbackActive = false
  self.leftPingbackTimerHandle = nil

  self.rightPingbackIndex = 0
  self.rightPingbackTimer = 0
  self.rightPingbackTimerThreshold = 0.5
  self.rightPingbackActive = false
  self.rightPingbackTimerHandle = nil

  self.topPingbackIndex = 0
  self.topPingbackTimer = 0
  self.topPingbackTimerThreshold = 0.5
  self.topPingbackActive = false
  self.topPingbackTimerHandle = nil

  self.bottomPingbackIndex = 0
  self.bottomPingbackTimer = 0
  self.bottomPingbackTimerThreshold = 0.5
  self.bottomPingbackActive = false
  self.bottomPingbackTimerHandle = nil

  self.timeSinceLastPingBack = 0

  --SPELLCAST ENTITY
  for i = 1, 3 do
    table.insert(self.spellcastEntities, Entity {
      animations = ENTITY_DEFS['spellcast'].animations,
      x = 25,
      y = 25,
      width = TILE_SIZE,
      height = TILE_SIZE,
      type = 'spellcast',
    })
    self.spellcastEntities[i].stateMachine = StateMachine {
      ['flame-idle'] = function() return FlameIdle(self.spellcastEntities[i], self, self.spellcastEntityCount) end,
    }
    self.spellcastEntities[i]:changeState('flame-idle')
  end

  Event.on('left-transition', function()
    if self.currentMap.column ~= 1 and self.currentMap.column ~= 11 and not gPlayer.warping then
      self.nextMap = Map(self.currentMap.row, self.currentMap.column - 1, self.player.spellcastCount)
      self.mapColumn = self.mapColumn - 1
      self:beginShifting(-VIRTUAL_WIDTH, 0)
    end
  end)
  Event.on('right-transition', function()
    if self.currentMap.column ~= OVERWORLD_MAP_WIDTH / 2 and self.currentMap.column ~= OVERWORLD_MAP_WIDTH and not gPlayer.warping then
      self.nextMap = Map(self.currentMap.row, self.currentMap.column + 1, self.player.spellcastCount)
      self.mapColumn = self.mapColumn + 1
      self:beginShifting(VIRTUAL_WIDTH, 0)
    end
  end)
  Event.on('up-transition', function()
    if self.currentMap.row ~= 1 and not gPlayer.warping then
      self.nextMap = Map(self.currentMap.row - 1, self.currentMap.column, self.player.spellcastCount)
      self.mapRow = self.mapRow - 1
      self:beginShifting(0, -VIRTUAL_HEIGHT)
    end
  end)
  Event.on('down-transition', function()
    if self.currentMap.row ~= OVERWORLD_MAP_HEIGHT and not gPlayer.warping then
      self.nextMap = Map(self.currentMap.row + 1, self.currentMap.column, self.player.spellcastCount)
      self.mapRow = self.mapRow + 1
      self:beginShifting(0, VIRTUAL_HEIGHT)
    end
  end)

  self.leftCollisionTriggered = false
  self.rightCollisionTriggered = false
  self.topCollisionTriggered = false
  self.bottomCollisionTriggered = false

  --LEFT PINGBACKS
  leftPingbackHandle = registerPingback(self, 'triggerLeftPingBacks', 'left', 'leftPingbackActive', 'leftPingbackIndex', 'leftPingbackTimer', 'leftPingbackTimerHandle', 'leftPingbackTimerThreshold', leftPingbackHandle)
  --RIGHT PINGBACKS
  rightPingbackHandle = registerPingback(self, 'triggerRightPingBacks', 'right', 'rightPingbackActive', 'rightPingbackIndex', 'rightPingbackTimer', 'rightPingbackTimerHandle', 'rightPingbackTimerThreshold', rightPingbackHandle)
  --TOP PINGBACKS
  topPingbackHandle = registerPingback(self, 'triggerTopPingBacks', 'top', 'topPingbackActive', 'topPingbackIndex', 'topPingbackTimer', 'topPingbackTimerHandle', 'topPingbackTimerThreshold', topPingbackHandle)
  --BOTTOM PINGBACKS
  bottomPingbackHandle = registerPingback(self, 'triggerBottomPingBacks', 'bottom', 'bottomPingbackActive', 'bottomPingbackIndex', 'bottomPingbackTimer', 'bottomPingbackTimerHandle', 'bottomPingbackTimerThreshold', bottomPingbackHandle)
end

function Scene:beginShifting(shiftX, shiftY)
  self.currentMap.collidableMapObjects = {}
  self.currentMap.collidableWallObjects = {}
  self.shifting = true
  self.nextMap.adjacentOffsetY = shiftY
  self.nextMap.adjacentOffsetX = shiftX

  --FADE OUT ALL RESONANCE RINGS ON SCENE TRANSITION
  for k, v in pairs(self.resonanceRings) do
    v:fade(0.15)
  end
  for k, v in pairs(self.player.rings) do
    v:fade()
  end
  --STOP PINGBACKS DURING SCENE TRANSITION
  if self.leftPingbackTimerHandle ~= nil then
    self.leftPingbackTimerHandle:remove()
    self.leftPingbackTimerHandle = nil
  end
  self.leftPingbackActive = false
  self.leftPingbackIndex = 0

  if shiftX < 0 then --SHIFT LEFT
    --self.nextMap.adjacentOffsetX = self.nextMap.adjacentOffsetX + 16
    playerX = VIRTUAL_WIDTH - self.player.width
    playerY = self.player.y
  elseif shiftX > 0 then --SHIFT RIGHT
    --self.nextMap.adjacentOffsetX = self.nextMap.adjacentOffsetX - 16
    playerX = 0
    playerY = self.player.y
  elseif shiftY < 0 then -- SHIFT UP
    self.nextMap.adjacentOffsetY = self.nextMap.adjacentOffsetY + 16
    shiftY = shiftY + 16
    playerY = SCREEN_HEIGHT_LIMIT - self.player.height
    playerX = self.player.x
  elseif shiftY > 0 then -- SHIFT DOWN
    self.nextMap.adjacentOffsetY = self.nextMap.adjacentOffsetY - 16
    shiftY = shiftY - 16
    playerY = 0
    playerX = self.player.x
  end

  --SPELLCAST TWEEN
  for k, v in pairs(self.spellcastEntities) do
    Timer.tween(TRANSITION_SPEED, {
      [self.spellcastEntities[k]] = {x = playerX + math.cos(k * self.step + TIME * SPEED) * AMP, y = playerY + math.sin(k * self.step + TIME * SPEED) * AMP - 5},
    }):finish()
  end

  --PLAYER AND CAMERA TWEEN
  Timer.tween(TRANSITION_SPEED, {
    [self] = {cameraX = shiftX, cameraY = shiftY},
    [self.player] = {x = math.floor(playerX), y = math.floor(playerY)},
  }):finish(function()
    self:finishShifting()
  end)

  --RESET TREASURE CHEST TODO TURN OFF FOR DEMO
  for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do
    if v.classType == 'treasureChest' then
      --v:reset()
    end
  end

  self:reinitWeather()
end

function Scene:reinitWeather()
  --WEATHER IN SCENE TRANSITION
  if MAP[self.mapRow][self.mapColumn].weather[1] ~= nil then
    if MAP[self.mapRow][self.mapColumn].weather[1] == 'BLIZZARD' then
      self.particleSystem = {}
      table.insert(self.particleSystem, self.snowSystem)
      self.particleSystem[1].psystems:setEmissionRate(self.particleSystem[1].initialEmissionRate)
    end
    if MAP[self.mapRow][self.mapColumn].weather[1] == 'LIGHT_SAND' then
      self.particleSystem = {}
      table.insert(self.particleSystem, self.sandSystem)
      self.particleSystem[1].psystems:setEmissionRate(self.particleSystem[1].initialLightEmissionRate)
    end
    if MAP[self.mapRow][self.mapColumn].weather[1] == 'HEAVY_SAND' then
      self.particleSystem = {}
      table.insert(self.particleSystem, self.sandSystem)
      self.particleSystem[1].psystems:setEmissionRate(self.particleSystem[1].initialHeavyEmissionRate)
    end
    if MAP[self.mapRow][self.mapColumn].weather[1] == 'LIGHT_RAIN' then
      self.particleSystem = {}
      table.insert(self.particleSystem, self.rainSystem)
      self.particleSystem[1].psystems:setEmissionRate(self.particleSystem[1].initialHeavyEmissionRate)
    end
  else --IF NO WEATHER IN CURRENT SCENE
    if self.particleSystem[1] ~= nil then
      self.particleSystem[1].psystems:setEmissionRate(0)
      self.particleSystem[1].psystems:reset()
    end
  end
end

function Scene:generatePingBackStack()
  --LEFT PINGBACKS
  self.pingbackStack['left'] = {}
  local colCheck = sceneView.currentMap.column - 1
  local xPositionLock = -20

  for k, v in pairs(MAP[sceneView.currentMap.row][colCheck].entities) do
    if v.enemy then
      if v.status == 'corrupt' then
        local resonanceColor = 'corrupt'
        self.pingbackStack['left'][#self.pingbackStack['left'] + 1] = Resonance('enemy', nil, resonanceColor, xPositionLock, v.y)
      end
    end
  end

  --RIGHT PINGBACKS
  self.pingbackStack['right'] = {}
  local colCheck = sceneView.currentMap.column + 1
  local xPositionLock = VIRTUAL_WIDTH + 4

  for k, v in pairs(MAP[sceneView.currentMap.row][colCheck].entities) do
    if v.enemy then
      if v.status == 'corrupt' then
        local resonanceColor = 'corrupt'
        self.pingbackStack['right'][#self.pingbackStack['right'] + 1] = Resonance('enemy', nil, resonanceColor, xPositionLock, v.y)
      end
    end
  end

  --TOP PINGBACKS
  self.pingbackStack['top'] = {}
  local rowCheck = sceneView.currentMap.row - 1
  local yPositionLock = -20

  for k, v in pairs(MAP[rowCheck][sceneView.currentMap.column].entities) do
    if v.enemy then
      if v.status == 'corrupt' then
        local resonanceColor = 'corrupt'
        self.pingbackStack['top'][#self.pingbackStack['top'] + 1] = Resonance('enemy', nil, resonanceColor, v.x, yPositionLock)
      end
    end
  end

  --BOTTOM PINGBACKS
  self.pingbackStack['bottom'] = {}
  local rowCheck = sceneView.currentMap.row + 1
  local yPositionLock = SCREEN_HEIGHT_LIMIT + 4

  for k, v in pairs(MAP[rowCheck][sceneView.currentMap.column].entities) do
    if v.enemy then
      if v.status == 'corrupt' then
        local resonanceColor = 'corrupt'
        self.pingbackStack['bottom'][#self.pingbackStack['bottom'] + 1] = Resonance('enemy', nil, resonanceColor, v.x, yPositionLock)
      end
    end
  end
end

function Scene:finishShifting()
  --WEATHER
  --[[
  if MAP[self.mapRow][self.mapColumn].weather[1] == nil then
    --self.particleSystem[1].psystems:setEmissionRate(0)
  end
  --]]

  self.shifting = false
  self.cameraX = 0
  self.cameraY = 0
  self.nextMap.adjacentOffsetX = 0
  self.nextMap.adjacentOffsetY = 0
  sceneView.player.checkPointPositions.x = sceneView.player.x
  sceneView.player.checkPointPositions.y = sceneView.player.y
  for i = 1, 3 do
    self.currentMap.psystems[i]:release()
  end
  --TODO CHECK CURRENT MAP ROW AND COL UPON WARP ZONE
  for k, v in pairs(MAP[self.currentMap.row][self.currentMap.column].entities) do
    if v.type ~= 'bat' then
      v:changeState('entity-idle')
    else
      v:changeState('bat-spawn')
    end
    v:resetOriginalPosition()
  end
  --RESET PUSHABLES
  for k, v in pairs(MAP[self.currentMap.row][self.currentMap.column].collidableMapObjects) do
    if v.classType == 'pushable' then
      v:resetOriginalPosition()
    end
  end
  MAP[self.currentMap.row][self.currentMap.column].coins = {}
  --self.currentMap.row = sceneView.currentMap.row
  --self.currentMap.column = sceneView.currentMap.column

  if DESERT_SHORTCUT_UNLOCKED then
    Event.dispatch('solveDesertShortcutBoulders')
  end

  self.currentMap = self.nextMap
  gStateMachine.current.animatables = InsertAnimation(self.currentMap.row, self.currentMap.column)

  SOUNDTRACK = MAP[sceneView.currentMap.row][sceneView.currentMap.column].ost

  if MAP[self.currentMap.row][self.currentMap.column].disjointUp then
    gPlayer.extendDialogueBoxUpwards = true
  else
    gPlayer.extendDialogueBoxUpwards = false
  end
  self.nextMap = nil
  --AQUIS SCENE TRANSITION RESET
  gPlayer.aquisProjectile = AquisProjectile()
  gPlayer.aquisCasting = false
  gPlayer.aquisCastLanded = false
  gPlayer.aquisCastingTimer = 0
  gPlayer.aquisCastLandedTimer = 0
  gPlayer.aquisSuccessTimer = 0
  self:generatePingBackStack()
end

function Scene:defineLeftPingBackStack()
  --SEARCH LEFT ADJACENT SCENE FOR PING BACKS
  --FINISH SHIFTING WILL PROBABLY HOLD PING BACK STACK DECLATIONS FOR ADJECENT SCENES
  --TABLE.INSERT Resonance() into .pingbackStack[direction]
end

function Scene:update(dt)
  --RESONANCE RING SPAWN TEST PLS REMOVE

  -- if love.keyboard.wasPressed('l') then
  --
  --   -- sceneView.pingbackStack =
  --   -- ['top'] = {Resonance('enemy', nil, 'corrupt', -0, 15)},
  --
  --   self.resonanceRings = {}
  --
  --   local resonanceColor = 'corrupt'
  --   table.insert(self.resonanceRings, Resonance('enemy', nil, resonanceColor, 12,0))
  --   self.resonanceRings[1].entityX = -20
  --   self.resonanceRings[1].entityY = 50
  -- end

  -- if love.keyboard.wasPressed('l') then
  --   self:generatePingBackStack()
  -- end

  --SCENE RESONANCE RINGS UPDATE
  for k, v in pairs(self.resonanceRings) do
    v:update(dt)
  end

  --REMOVE RINGS
  for i = #self.resonanceRings, 1, -1 do
    if self.resonanceRings[i].luteResonanceAlpha <= 0 then
      table.remove(self.resonanceRings, i)
    end
  end

  self.demoFinished = false
  x, y = love.mouse.getPosition()
  --self.snowSystem:update(dt)
  --self.rainSystem:update(dt)
  --self.sandSystem:update(dt)
  if self.particleSystem[1] ~= nil then
    self.particleSystem[1]:update(dt)
  end
  --self.lavaSystem:update(dt)
  self.currentMap:update(dt)
  if not self.shifting then
    self.player:update(dt)
  else
    --RESONANCE TRACKS PLAYER WHILE IN SCENE SHIFT
    for k, v in pairs(self.player.rings) do
      v:update(dt)
    end
  end
  --RESONANCE PINGBACK COLLISION
  if #self.player.rings ~= 0 then
    --LEFT PINGBACK COLLISION
    local ring = self.player.rings[1]
    if ring.luteResonanceX - ring.luteResonanceRadius < 0 then
      if not ring.leftCollisionTriggered then
        ring.leftCollisionTriggered = true
        Event.dispatch('triggerLeftPingBacks')
      end
    end
    --RIGHT PINGBACK COLLISION
    if ring.luteResonanceX + ring.luteResonanceRadius > VIRTUAL_WIDTH then
      if not ring.rightCollisionTriggered then
        ring.rightCollisionTriggered = true
        Event.dispatch('triggerRightPingBacks')
      end
    end

    --TOP PINGBACK COLLISION
    if ring.luteResonanceY - ring.luteResonanceRadius < 0 then
      if not ring.topCollisionTriggered then
        ring.topCollisionTriggered = true
        Event.dispatch('triggerTopPingBacks')
      end
    end

    --TOP PINGBACK COLLISION
    if ring.luteResonanceY + ring.luteResonanceRadius > VIRTUAL_HEIGHT - 16 then
      if not ring.bottomCollisionTriggered then
        ring.bottomCollisionTriggered = true
        Event.dispatch('triggerBottomPingBacks')
      end
    end
  end


  if not self.shifting then
    TIME = TIME + dt

    local newX = self.player.x
    local newY = self.player.y

    local velX = newX - self.player.prevX
    local velY = newY - self.player.prevY

    --STEP TO CALCULATE COLLISION IN SMALLER INCREMENTS
    local stepSize = 1
    local stepsX = math.ceil(math.abs(velX) / stepSize)
    local stepsY = math.ceil(math.abs(velY) / stepSize)
    local stepVelX = velX ~= 0 and (velX / stepsX) or 0
    local stepVelY = velY ~= 0 and (velY / stepsY) or 0

    --RESET PLAYER POSITION TO PREVENT DOUBLE UPDATING
    self.player.x = self.player.prevX
    self.player.y = self.player.prevY

    local function checkCollisions()
      local horizontalCollision = false
      local verticalCollision = false

      --COLLIDABLE MAP OBJECT COLLISION
      for k, v in pairs(sceneView.currentMap.collidableMapObjects) do
        local object = v

        if not v.falling then
          if self.player:leftCollidesMapObject(object) then
            self.player.x = object.x + object.width - AABB_SIDE_COLLISION_BUFFER
            horizontalCollision = true
          elseif self.player:rightCollidesMapObject(object) then
            self.player.x = object.x - self.player.width + AABB_SIDE_COLLISION_BUFFER
            horizontalCollision = true
          end
          if self.player:topCollidesMapObject(object) then
            self.player.y = object.y + object.height - AABB_TOP_COLLISION_BUFFER
            verticalCollision = true
          elseif self.player:bottomCollidesMapObject(object) then
            self.player.y = object.y - self.player.height
            verticalCollision = true
          end
        end
      end

      for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do

        local object = v
        if not v.falling and v.active then
          if self.player:leftCollidesMapObject(object) then
            self.player.x = object.x + object.width - AABB_SIDE_COLLISION_BUFFER
            horizontalCollision = true
          elseif self.player:rightCollidesMapObject(object) then
            self.player.x = object.x - self.player.width + AABB_SIDE_COLLISION_BUFFER
            horizontalCollision = true
          end
          if self.player:topCollidesMapObject(object) then
            self.player.y = object.y + object.height - AABB_TOP_COLLISION_BUFFER
            verticalCollision = true
          elseif self.player:bottomCollidesMapObject(object) then
            self.player.y = object.y - self.player.height
            verticalCollision = true
          end
        end
      end

      --[[
      for i = 1, #self.currentMap.collidableWallObjects do
        local wall = self.currentMap.collidableWallObjects[i]
        if self.player:leftCollidesMapObject(wall) then
          self.player.x = wall.x + wall.width - AABB_SIDE_COLLISION_BUFFER
          horizontalCollision = true
        elseif self.player:rightCollidesMapObject(wall) then
          self.player.x = wall.x - self.player.width + AABB_SIDE_COLLISION_BUFFER
          horizontalCollision = true
        end
        if self.player:topCollidesMapObject(wall) then
          self.player.y = wall.y + wall.height - AABB_TOP_COLLISION_BUFFER
          verticalCollision = true
        elseif self.player:bottomCollidesMapObject(wall) then
          self.player.y = wall.y - self.player.height
          verticalCollision = true
        end
      end
      --]]

      --TODO
      --COLLISIONS DEFERRED TO WALK STATE MAYBE MOVE INTO PLAYER CLASS?
      --[[
      for i = 1, #MAP[self.mapRow][self.mapColumn].npc do
        local npc = MAP[self.mapRow][self.mapColumn].npc[i]
        if self.player:leftCollidesMapObject(npc) then
          self.player.x = npc.x + npc.width - AABB_SIDE_COLLISION_BUFFER
          horizontalCollision = true
        elseif self.player:rightCollidesMapObject(npc) then
          self.player.x = npc.x - self.player.width + AABB_SIDE_COLLISION_BUFFER
          horizontalCollision = true
        end
        if self.player:topCollidesMapObject(npc) then
          self.player.y = npc.y + npc.height - AABB_TOP_COLLISION_BUFFER
          verticalCollision = true
        elseif self.player:bottomCollidesMapObject(npc) then
          self.player.y = npc.y - self.player.height
          verticalCollision = true
        end
      end
      --]]

      return horizontalCollision, verticalCollision
    end

    for i = 1, stepsX do
      self.player.x = self.player.x + stepVelX
      local horizontalCollision = checkCollisions()
      if horizontalCollision then
        stepVelX = 0
        break
      end
    end

    for i = 1, stepsY do
      self.player.y = self.player.y + stepVelY
      local _, verticalCollision = checkCollisions()
      if verticalCollision then
        stepVelY = 0
        break
      end
    end

    self.player.prevX = self.player.x
    self.player.prevY = self.player.y
  end

  --PLAYER TO MINERAL COLLISION
  for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].mineralDeposits) do
    if not v.mined then
      local object = v
      if self.player:leftCollidesMapObject(object) then
        self.player.x = object.x + object.width - AABB_SIDE_COLLISION_BUFFER
      elseif self.player:rightCollidesMapObject(object) then
        self.player.x = object.x - self.player.width + AABB_SIDE_COLLISION_BUFFER
      end
      if self.player:topCollidesMapObject(object) then
        self.player.y = object.y + object.height - AABB_TOP_COLLISION_BUFFER
      elseif self.player:bottomCollidesMapObject(object) then
        self.player.y = object.y - self.player.height
      end
    end
  end

  for i = 1, #self.spellcastEntities do
    if not self.shifting then
      self.spellcastEntities[i].x = self.player.x + math.cos(i * self.step + TIME * SPEED) * AMP
      self.spellcastEntities[i].y = self.player.y + math.sin(i * self.step + TIME * SPEED) * AMP - 5
      self.spellcastEntities[i]:update(dt)
    end
  end

  --PLAYER TO WALL OBJECT COLLISION DETECTION
  for i = 1, #self.currentMap.collidableWallObjects do
    local wall = self.currentMap.collidableWallObjects[i]
    if self.player:topCollidesWallObject(self.currentMap.collidableWallObjects[i]) then
      self.player.y = wall.y + wall.height - 1
    elseif self.player:leftCollidesWallObject(self.currentMap.collidableWallObjects[i]) then
      self.player.x = wall.x + wall.width - AABB_SIDE_COLLISION_BUFFER
    elseif self.player:rightCollidesWallObject(self.currentMap.collidableWallObjects[i]) then
      self.player.x = wall.x - self.player.width + AABB_SIDE_COLLISION_BUFFER
    elseif self.player:bottomCollidesMapObject(self.currentMap.collidableWallObjects[i]) then
      self.player.y = wall.y - self.player.height
    end
  end

  --ENTITY TO COLLIDABLE OBJECT COLLISION
  for k, object in pairs(sceneView.currentMap.collidableMapObjects) do
    if not gPlayer.dead then
      for index, entity in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].entities) do
        if entity.enemy and entity.pathEnabled then
          if entity:leftCollidesMapObject(object) then
            entity.x = object.x + entity.width - AABB_SIDE_COLLISION_BUFFER
            entity.geckoCollideCount = entity.geckoCollideCount + 1
          elseif entity:rightCollidesMapObject(object) then
            entity.x = object.x - entity.width + AABB_SIDE_COLLISION_BUFFER
            entity.geckoCollideCount = entity.geckoCollideCount + 1
          end
          if entity:topCollidesMapObject(object) then
            entity.y = object.y + entity.height - AABB_TOP_COLLISION_BUFFER
            entity.geckoCollideCount = entity.geckoCollideCount + 1
          elseif entity:bottomCollidesMapObject(object) then
            entity.y = object.y - entity.height
            entity.geckoCollideCount = entity.geckoCollideCount + 1
          end
        end
      end
    end
  end

  for k, gecko in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].entities) do
    if gecko.type == 'gecko' or gecko.type == 'boar' then
      if gecko.geckoCollideCount > 60 then
        gecko.geckoCollideCount = 0
        if gecko.aiPath == 1 then
          gecko.aiPath = 2
        else
          gecko.aiPath = 1
        end
      end
    end
  end
  --OLD PLAYER TO MAP OBJECT COLLISION DETECTION
  --[[
  for k, v in pairs(sceneView.currentMap.collidableMapObjects) do
    local object = v

    if self.player:leftCollidesMapObject(object) then
      self.player.x = object.x + object.width - AABB_SIDE_COLLISION_BUFFER
    end
    if self.player:rightCollidesMapObject(object) then
      self.player.x = object.x - self.player.width + AABB_SIDE_COLLISION_BUFFER
    end
    if self.player:topCollidesMapObject(object) then
      self.player.y = object.y + object.height - AABB_TOP_COLLISION_BUFFER
    end
    if self.player:bottomCollidesMapObject(object) then
      self.player.y = object.y - self.player.height
    end
  end
  --]]

  ---[[
  --NPC COLLISION
  if not self.shifting then
    for i = 1, #MAP[self.mapRow][self.mapColumn].npc do
      local npc = MAP[self.mapRow][self.mapColumn].npc[i]
      if self.player:leftCollidesMapObject(MAP[self.mapRow][self.mapColumn].npc[i]) then
        self.player.x = npc.x + npc.width - 1
      end
      if self.player:rightCollidesMapObject(MAP[self.mapRow][self.mapColumn].npc[i]) then
        self.player.x = npc.x - self.player.width + 1
      end
      if self.player:topCollidesMapObject(MAP[self.mapRow][self.mapColumn].npc[i]) then
        self.player.y = npc.y + npc.height - 6
      end
      if self.player:bottomCollidesMapObject(MAP[self.mapRow][self.mapColumn].npc[i]) then
        self.player.y = npc.y - self.player.height
      end
    end
  end
  --]]

  --PARTICLE SYSTEM UPDATE
  for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].psystems) do
    v:update(dt)
  end

  --WARP ZONES
  for k, v in ipairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].warpZones) do
    if v:collides() and not gPlayer.warping and not gPlayer.dead then
      gPlayer:changeState('player-idle')
      --gPlayer:changeState('player-walk')
      stopOST()
      SOUNDTRACK = MAP[v.warpRow][v.warpCol].ost
      gPlayer.currentAnimation:refresh()
      triggerStartingSceneTransition = true
      sfx['warp-zone']:play()
      gPlayer.warping = true
      gPlayer.warpObject = v
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

  if triggerStartingSceneTransition then
    leftFadeTransitionX = leftFadeTransitionX + FADE_TRANSITION_SPEED * dt
    rightFadeTransitionX = rightFadeTransitionX - FADE_TRANSITION_SPEED * dt
    if leftFadeTransitionX > 0 then
      leftFadeTransitionX = 0
      triggerStartingSceneTransition = false
      startingSceneTransitionFinished = true
      --TODO ALLOW SPECIFIC WARPZONE TO TRIGGER
      
      --WARPZONE TELEPORT
      for k, v in ipairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].warpZones) do
        if v:collides() and gPlayer.warping then
          sceneView = Scene(gPlayer, sceneView.currentMap.warpZones[k].warpRow, sceneView.currentMap.warpZones[k].warpCol)
          --WEATHER WARPZONE TRIGGER
          if MAP[sceneView.mapRow][sceneView.mapColumn].weather[1] ~= nil then
            if MAP[sceneView.mapRow][sceneView.mapColumn].weather[1] == 'BLIZZARD' then
              table.insert(sceneView.particleSystem, sceneView.snowSystem)
              sceneView.particleSystem[1].psystems:setEmissionRate(sceneView.particleSystem[1].initialEmissionRate)
            end
            if MAP[sceneView.mapRow][sceneView.mapColumn].weather[1] == 'LIGHT_SAND' then
              table.insert(sceneView.particleSystem, sceneView.sandSystem)
              sceneView.particleSystem[1].psystems:setEmissionRate(sceneView.particleSystem[1].initialLightEmissionRate)
            end
            if MAP[sceneView.mapRow][sceneView.mapColumn].weather[1] == 'HEAVY_SAND' then
              table.insert(sceneView.particleSystem, sceneView.sandSystem)
              sceneView.particleSystem[1].psystems:setEmissionRate(sceneView.particleSystem[1].initialHeavyEmissionRate)
            end
            if MAP[sceneView.mapRow][sceneView.mapColumn].weather[1] == 'LIGHT_RAIN' then
              table.insert(sceneView.particleSystem, sceneView.rainSystem)
              sceneView.particleSystem[1].psystems:setEmissionRate(sceneView.particleSystem[1].initialHeavyEmissionRate)
            end
          else
            if sceneView.particleSystem[1] ~= nil then
              sceneView.particleSystem[1].psystems:setEmissionRate(0)
            end
          end

          WATER:update(dt)
          gStateMachine.current.animatables = InsertAnimation(sceneView.currentMap.row, sceneView.currentMap.column)
          --WARP ZONE PLAYER PLACEMENT
          gPlayer.x = v.playerX
          gPlayer.y = v.playerY
          sceneView:generatePingBackStack()
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
      if gPlayer.warpObject.warpToStateChange == 'refineryState' then
        sceneView.mapRow = 1
        sceneView.mapColumn = 11
        gPlayer.extendDialogueBoxUpwards = true
        gStateMachine:change('refineryState')
      elseif gPlayer.warpObject.warpToStateChange == 'playState' then
        gStateMachine:change('playState')
      end
      gPlayer.warping = false
      gPlayer.warpObject = nil
    end
    transitionFadeAlpha = math.max(transitionFadeAlpha - FADE_TO_BLACK_SPEED * dt, 0)
  end

  if self.nextMap then
    if MAP[self.nextMap.row][self.nextMap.column].psystems[1] ~= nil then
      for k, v in pairs(MAP[self.nextMap.row][self.nextMap.column].psystems) do
        v:update(dt)
      end
    end
  end

  --MINERAL RESET
  if not (self.currentMap.row == 4 and self.currentMap.column == 12) then
    for k, v in pairs(MAP[4][12].mineralDeposits) do
      if v.harvestTime > MINERAL_HARVEST_RESET then
        v:resetMineral()
      end
    end
  end
  if not (self.currentMap.row == 2 and self.currentMap.column == 13) then
    for k, v in pairs(MAP[2][13].mineralDeposits) do
      if v.harvestTime > MINERAL_HARVEST_RESET then
        v:resetMineral()
      end
    end
  end
end

function Scene:render()
  love.graphics.setColor(WHITE)
  love.graphics.push()
  if self.shifting then
    love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
  end

  self.currentMap:render()
  love.graphics.setColor(WHITE)

  if self.nextMap then
    self.nextMap:render()
  end

  if self.tutorialText then
    local yStarting = 15
    local yOffset = 10
    local xPosition = 40
    love.graphics.setColor(1,1,1, self.tutorialTextAlpha/255)
    love.graphics.setFont(classicFont)
    love.graphics.print('\'WASD\' to move', xPosition, yStarting)
    love.graphics.print('Spacebar is \'A\'', xPosition, yStarting + yOffset * 2)
    love.graphics.print('Shift is \'B\'', xPosition, yStarting + yOffset * 4)
    love.graphics.print('Tab is \'START\'', xPosition, yStarting + yOffset * 6)
    love.graphics.print('Ctrl is \'SELECT\'', xPosition, yStarting + yOffset * 8)
    --RENDER COLLIDABLE MAP OBJECTS
    if MAP[self.currentMap.row][self.currentMap.column].collidableMapObjects[1] ~= nil then
      for k, v in pairs(MAP[self.currentMap.row][self.currentMap.column].collidableMapObjects) do
        v:render(self.adjacentOffsetX, self.adjacentOffsetY)
      end
    end
    love.graphics.setColor(WHITE)
  end
  love.graphics.pop()

  --CHASM FALL TODO MOVE INTO OWN STATE
  --[[
  gameOver = true
  if gameOver then
    sceneView.player.dead = true
    love.graphics.setColor(0/255, 0/255, 20/255, 255/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    --sceneView.rainSystem:render()
    --love.graphics.setColor(WHITE)
    --love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
  end
  --]]


  if self.player then
    self.player:render()
  end
  love.graphics.push()
  if self.shifting then
    love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
  end

  --RENDER ATTACKS
  if #MAP[self.currentMap.row][self.currentMap.column].attacks > 0 then
    for i = 1, #MAP[self.currentMap.row][self.currentMap.column].attacks do
      MAP[self.currentMap.row][self.currentMap.column].attacks[i]:render()
    end
  end

  love.graphics.setColor(WHITE)
  --RENDER TOP LEVEL TILES
  for y = 1, MAP_HEIGHT do
    for x = 1, MAP_WIDTH do
      local tile = self.currentMap.topLevelTiles[y][x]
      if quads[tile.id] ~= 75 then
        love.graphics.draw(tileSheet, quads[tile.id], (x - 1) * TILE_SIZE + self.currentMap.adjacentOffsetX, (y - 1) * TILE_SIZE + self.currentMap.adjacentOffsetY)
      end
      if self.nextMap then
        local tile = self.nextMap.topLevelTiles[y][x]
        love.graphics.draw(tileSheet, quads[tile.id], (x - 1) * TILE_SIZE + self.nextMap.adjacentOffsetX, (y - 1) * TILE_SIZE + self.nextMap.adjacentOffsetY)
      end
    end
  end

  --SCENE RESONANCE RINGS RENDER
  for k, v in pairs(self.resonanceRings) do
    v:render(dt)
  end

  --ENTITY RENDERS
  --TURNED THIS OFF FOR AQUIS ORDER
  for k, entity in pairs(MAP[self.currentMap.row][self.currentMap.column].entities) do
    if not entity.offscreen and not entity.spawning then
      --entity:render(self.currentMap.adjacentOffsetX, self.currentMap.adjacentOffsetY)
    end
    --love.graphics.print(entity.stateMachine.current.stateName, 0, 0)
  end
  love.graphics.pop()

  -- LUTE RESONANCE RENDER
  for k, v in pairs(self.player.rings) do
    v:render()
  end

  --WEATHER PARTICLE SYSTEM
  --self.snowSystem:render()
  --self.rainSystem:render()
  --self.lavaSystem:render()
  --self.sandSystem:render()
  if self.particleSystem[1] ~= nil then
    self.particleSystem[1]:render()
  end

  --SET FADE FOR SPELLCAST
  --RENDER SPELLCAST
  love.graphics.setColor(255/255, 255/255, 255/255, SPELLCAST_FADE/225)
  for i = 1, gPlayer.spellcastCount do
    if not gPlayer.graveyard then
      self.spellcastEntities[i]:render()
    end
  end

  love.graphics.setColor(WHITE)

  --ONLY RENDER COLLIDED SIGNPOST
  --[[
  for k, v in pairs(MAP[self.mapRow][self.mapColumn].dialogueBoxCollided) do
    MAP[self.mapRow][self.mapColumn].dialogueBoxCollided[k]:render()
  end
  --]]
  --DIALOGUE RENDER
  if self.activeDialogueID ~= nil then
    --DIALOGUE JUST CLOSED
    self.dialogueBoxActive = true
    --MAP[10][19].dialogueBox[1]:render()
    MAP[self.mapRow][self.mapColumn].dialogueBox[self.activeDialogueID]:render()
  end
  --if
  --MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[self.activeDialogueID]:render(dt)
  love.graphics.setColor(WHITE)
  --DEBUG PINGBACK
  --love.graphics.print(self.pingbackStack['top'], 0, 0)
  --love.graphics.print(Inspect(sceneView.currentMap.collidableWallObjects[1]), 0, 0)

  --TRANSITION START
  love.graphics.setColor(BLACK)
  love.graphics.rectangle('fill', leftFadeTransitionX, 0, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT)
  love.graphics.rectangle('fill', rightFadeTransitionX, 0, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT)

  --TRANSITION BLACK FADE
  love.graphics.setColor(0/255, 0/255, 0/255, transitionFadeAlpha/255)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

   love.graphics.setColor(WHITE)
  -- love.graphics.print('rRings#: ' .. tostring(#self.resonanceRings), 0, 10)
  -- love.graphics.print('pRings#: ' .. tostring(#gPlayer.rings), 0, 20)
  --love.graphics.pring('self.resonanceRings[1].ringActive = true
  --love.graphics.print('bottomStack: ' .. tostring(Inspect(self.pingbackStack['bottom'])), 0, 10)
end
