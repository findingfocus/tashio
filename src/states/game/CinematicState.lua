CinematicState = Class{__includes = BaseState}

--CINEMATIC STATE
--GENERIC SCRIPT RUNNER FOR CUTSCENES AND FLASHBACKS
--USAGE: gStateMachine:change('cinematic', {script = {...}, onComplete = function() ... end})
--SCRIPT IS ARRAY OF STEPS: {type='move', actor='mage', toX=..., duration=..., onComplete=fn}
--SUPPORTED TYPES: 'move', 'wait', 'fadeToBlack', 'fadeFromBlack', 'warp', 'dialogue', 'custom'

function CinematicState:init()
  self.stateName = 'cinematic'
  self.script = {}
  self.currentStep = 1
  self.stepTimer = 0
  self.activeTween = nil
  self.onComplete = nil
  self.blackOpacity = 0
  self.fadeToBlack = false
  self.fadeFromBlack = false
  self.locked = true
  self.animatables = nil
end

function CinematicState:enter(params)
  params = params or {}
  if params.script then
    self.script = params.script
    self.onComplete = params.onComplete
  end
  self.locked = true
  self.currentStep = 1
  self.stepTimer = 0
  self.blackOpacity = 0
  self.fadeToBlack = false
  self.fadeFromBlack = false
  gPlayer:changeState('player-cinematic')
  self.animatables = InsertAnimation(sceneView.mapRow, sceneView.mapColumn)
  if #self.script > 0 and self.script[1].onEnter then
    self.script[1].onEnter()
  end
end

function CinematicState:exit()
  if self.activeTween then
    Timer.clear()
  end
  if PLAYER_STATE == 'CINEMATIC' then
    gPlayer:changeState('player-idle')
  end
end

function CinematicState:update(dt)
  if #self.script == 0 then
    if self.onComplete then self.onComplete() end
    return
  end

  local step = self.script[self.currentStep]
  if step == nil then
    if self.onComplete then self.onComplete() end
    return
  end

  --FADE HANDLING
  if self.fadeToBlack then
    self.blackOpacity = math.min(255, self.blackOpacity + 5)
  elseif self.fadeFromBlack then
    self.blackOpacity = math.max(0, self.blackOpacity - 5)
    if self.blackOpacity <= 0 then
      self.blackOpacity = 0
      self.fadeFromBlack = false
    end
  end

  --STEP TYPES
  if step.type == 'wait' then
    self.stepTimer = self.stepTimer + dt
    if step.onUpdate then step.onUpdate(dt) end
    if self.stepTimer >= (step.duration or 0) then
      if step.onComplete then step.onComplete() end
      self:nextStep()
    end
  elseif step.type == 'move' then
    if step.onUpdate then
      local done = step.onUpdate(dt)
      if done then
        if step.onComplete then step.onComplete() end
        self:nextStep()
      end
    else
      self:nextStep()
    end
  elseif step.type == 'fadeToBlack' then
    self.fadeToBlack = true
    if self.blackOpacity >= 255 then
      self.fadeToBlack = false
      if step.onComplete then step.onComplete() end
      self:nextStep()
    end
  elseif step.type == 'fadeFromBlack' then
    self.fadeFromBlack = true
    if self.blackOpacity <= 0 then
      if step.onComplete then step.onComplete() end
      self:nextStep()
    end
  elseif step.type == 'warp' then
    if step.onEnter then step.onEnter() end
    if step.onComplete then step.onComplete() end
    self:nextStep()
  elseif step.type == 'dialogue' then
    if not step.cinematicEntered then
      step.cinematicEntered = true
      local box = MAP[sceneView.mapRow][sceneView.mapColumn].dialogueBox[step.dialogueID]
      if box then sceneView.activeDialogueID = step.dialogueID; box.activated = true; box:flushText(); box.aButtonCount = 1; PAUSED = true end
    end
    if sceneView.activeDialogueID == nil and not PAUSED then
      if step.onComplete then step.onComplete() end
      self:nextStep()
    end
  elseif step.type == 'custom' then
    if step.onUpdate then
      local done = step.onUpdate(dt)
      if done then
        if step.onComplete then step.onComplete() end
        self:nextStep()
      end
    else
      self:nextStep()
    end
  end

  --GLOBAL FADE TICK
  if step.type ~= 'fadeToBlack' and step.type ~= 'fadeFromBlack' then
    if self.fadeToBlack then
      self.blackOpacity = math.min(255, self.blackOpacity + 5)
    elseif self.fadeFromBlack then
      self.blackOpacity = math.max(0, self.blackOpacity - 5)
    end
  end

  if sceneView.activeDialogueID ~= nil then
    local box = MAP[sceneView.mapRow][sceneView.mapColumn].dialogueBox[sceneView.activeDialogueID]
    if box then box:update(dt) end
  end

  if self.animatables then
    if self.animatables.mapRow ~= sceneView.mapRow or self.animatables.mapColumn ~= sceneView.mapColumn then
      self.animatables = InsertAnimation(sceneView.mapRow, sceneView.mapColumn)
    end
    self.animatables:update(dt)
  end
  for k, v in pairs(MAP[sceneView.mapRow][sceneView.mapColumn].psystems) do v:update(dt) end
end

function CinematicState:nextStep()
  self.stepTimer = 0
  self.currentStep = self.currentStep + 1
  if self.currentStep > #self.script then
    if self.onComplete then self.onComplete() end
    return
  end
  local next = self.script[self.currentStep]
  if next and next.onEnter then
    next.onEnter()
  end
end

function CinematicState:render()
  love.graphics.push()
  sceneView:render()
  love.graphics.pop()

  -- HUD
  love.graphics.setColor(WHITE)
  love.graphics.draw(hudOverlay, 0, VIRTUAL_HEIGHT - 16)
  if gItemInventory.itemSlot[1] ~= nil then gItemInventory.itemSlot[1]:render() end
  love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
  heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
  love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
  if gPlayer.elementEquipped == 'flamme' then
    love.graphics.setColor(255/255, 30/255, 30/255, 255/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 2, VIRTUAL_HEIGHT - 13, 2, 10)
    love.graphics.setColor(30/255, 30/255, 30/255, 255/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 2, VIRTUAL_HEIGHT - 13, 2, gPlayer.flammeVibrancy / 10)
    love.graphics.setColor(WHITE)
    love.graphics.draw(flamme2, VIRTUAL_WIDTH / 2 - 11 , VIRTUAL_HEIGHT - 13)
  elseif gPlayer.elementEquipped == 'aquis' then
    love.graphics.setColor(100/255, 140/255, 255/255, 255/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 2, VIRTUAL_HEIGHT - 13, 2, 10)
    love.graphics.setColor(30/255, 30/255, 30/255, 255/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 2, VIRTUAL_HEIGHT - 13, 2, gPlayer.aquisVibrancy / 10)
    love.graphics.setColor(WHITE)
    love.graphics.draw(aquis2, VIRTUAL_WIDTH / 2 - 11 , VIRTUAL_HEIGHT - 13)
  end
  if sceneView.activeDialogueID == nil then
    love.graphics.setColor(255/255, 0/255, 0/255, gPlayer.magicHudOpacity/255)
    love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT - 4, gPlayer.manis, 2)
    love.graphics.setColor(0,0,0, gPlayer.magicHudOpacity/255)
    love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT + 2 - 4, 100, 2)
    love.graphics.setColor(0,1,0, gPlayer.magicHudOpacity/255)
    love.graphics.rectangle('fill', 65, SCREEN_HEIGHT_LIMIT + 2 - 4, 20, 2)
    love.graphics.setColor(1,1,1, gPlayer.magicHudOpacity/255)
    love.graphics.rectangle('fill', gPlayer.focusIndicatorX, SCREEN_HEIGHT_LIMIT + 2 - 4, 2, 2)
    love.graphics.setColor(WHITE)
  end

  if self.blackOpacity > 0 then
    love.graphics.setColor(0, 0, 0, self.blackOpacity/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(WHITE)
  end
end
