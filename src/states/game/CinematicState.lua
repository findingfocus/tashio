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
end

function CinematicState:enter(params)
  params = params or {}
  if params.script then
    self.script = params.script
    self.onComplete = params.onComplete
  end
  self.currentStep = 1
  self.stepTimer = 0
  self.blackOpacity = 0
  self.fadeToBlack = false
  self.fadeFromBlack = false
  if #self.script > 0 and self.script[1].onEnter then
    self.script[1].onEnter()
  end
end

function CinematicState:exit()
  if self.activeTween then
    Timer.clear()
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
  --RENDER CURRENT MAP
  love.graphics.push()
  sceneView:render()
  love.graphics.pop()

  --FADE OVERLAY
  if self.blackOpacity > 0 then
    love.graphics.setColor(0, 0, 0, self.blackOpacity/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(WHITE)
  end
end
