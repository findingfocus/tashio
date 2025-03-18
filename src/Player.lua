Player = Class{__includes = Entity}

local heartSpeed = 0.5
local counter = 0
local safeCounter = 0
local pitCount = 0

function Player:init(def)
  Entity.init(self, def)
  self.lastInput = nil
  self.inputsHeld = 0
  self.health = 14
  self.heartTimer = heartSpeed
  self.decrement = true
  self.dead = false
  self.checkPointPositions = {x = 0, y = 0}
  self.falling = false
  self.fallTimer = 0
  self.graveyard = false
  self.tweenAllowed = true
  self.prevX = 0
  self.prevY = 0
  self.dialogueBoxX = self.x
  self.dialogueBoxY = self.y - TILE_SIZE
  self.dialogueBoxWidth = TILE_SIZE
  self.dialogueBoxHeight = TILE_SIZE
  self.fireSpellEquipped = true
  self.luteEquipped = false
  self.warping = false
  self.extendDialogueBoxUpwards = false
  self.pushTimer = 0
  self.pushing = false
  self.coinCount = 0
  self.rubyCount = 0
  self.flammeVibrancy = 0
  self.type = 'player'
  self.TLCollide = 0
  self.TRCollide = 0
  self.BLCollide = 0
  self.BRCollide = 0
  self.DownLeftFall = false
  self.LeftFall = false
  self.UpLeftFall = false
  self.UpFall = false
  self.UpRightFall = false
  self.RightFall = false
  self.DownRightFall = false
  self.DownFall = false
  self.chasmCollided = {}
  self.chasmFalling = false
  self.chasmFallTimer = 0
  self.checkPointTick = 0
  self.deadTimer = 0
  self.chasmDeath = false
  self.spellcastCount = 1
  self.manis = 100
  self.manisMax = 100
  --self.manisDrain = .45
  self.manisDrain = 10
  self.manisRegen = 1.2
  self.focusIndicatorX = 0
  self.focusMax = 4
  self.unFocus = 0
  self.unFocusGrowing = true
  self.manisTimer = 0
  self.magicHudOpacity = 0
end

function Player:saveDataTable()
  local saveData = {}
  saveData['health'] = self.health
  return saveData
end

function updateHearts(player)
  healthDifference = totalHealth - player.health
  HEART_CROP = 56 - (4 * healthDifference)
end

function Player:chasmTopLeftCollide(chasm)
  local chasmTopLeftX = self.x + 6
  local chasmTopLeftY = self.y + 14
  local chasmTLWidth = 2
  local chasmTopLeftHeight = 2

  if chasmTopLeftX - 1 > chasm.x and chasmTopLeftX + 1 < chasm.x + chasm.width - 3 then
    if chasmTopLeftY + chasmTopLeftHeight - 1 > chasm.y + 2 and chasmTopLeftY < chasm.y + chasm.height then
      self.TLCollide = self.TLCollide + 1
      self.chasmFalling = true
      return true
    end
  end
  return false
end

function Player:chasmTopRightCollide(chasm)
  local chasmTopRightX = self.x + self.width - 8
  local chasmTopRightY = self.y + 14
  local chasmTopRightWidth = 2
  local chasmTopRightHeight = 2

  if chasmTopRightX + 1 > chasm.x + 2 and chasmTopRightX < chasm.x + chasm.width then
    if chasmTopRightY + chasmTopRightHeight - 1 > chasm.y + 2 and chasmTopRightY < chasm.y + chasm.height then
      self.TRCollide = self.TRCollide + 1
      self.chasmFalling = true
      return true
    end
  end
  return false
end

function Player:chasmBottomLeftCollide(chasm)
  local chasmBottomLeftX = self.x + 6
  local chasmBottomLeftY = self.y + self.height - 2
  local chasmBottomLeftWidth = 2
  local chasmBottomLeftHeight = 2

  if chasmBottomLeftX - 1 > chasm.x and chasmBottomLeftX + 1 < chasm.x + chasm.width - 3 then
    if chasmBottomLeftY + chasmBottomLeftHeight - 1 > chasm.y + 4 and chasmBottomLeftY < chasm.y + chasm.height then
      self.BLCollide = self.BLCollide + 1
      self.chasmFalling = true
      return true
    end
  end
  return false
end

function Player:chasmBottomRightCollide(chasm)
  local chasmBottomRightX = self.x + self.width - 8
  local chasmBottomRightY = self.y + self.height - 2
  local chasmBottomRightWidth = 2
  local chasmBottomRightHeight = 2

  if chasmBottomRightX + 1 > chasm.x + 2 and chasmBottomRightX < chasm.x + chasm.width then
    if chasmBottomRightY + chasmBottomRightHeight - 1 > chasm.y + 4 and chasmBottomRightY < chasm.y + chasm.height then
      self.BRCollide = self.BRCollide + 1
      self.chasmFalling = true
      return true
    end
  end
  return false
end

function Player:resetFallingDirection()
  self.DownLeftFall = false
  self.LeftFall = false
  self.UpLeftFall = false
  self.UpFall = false
  self.UpRightFall = false
  self.RightFall = false
  self.DownRightFall = false
  self.DownFall = false
end

function Player:update(dt)
  self.prevX = self.x
  self.prevY = self.y
  CHASM_TL_COLLIDE_X = self.x + 6
  CHASM_TL_COLLIDE_Y = self.y + 10
  CHASM_TL_COLLIDE_WIDTH = 2
  CHASM_TL_COLLIDE_HEIGHT = 2

  CHASM_TR_COLLIDE_X = self.x + self.width - 8
  CHASM_TR_COLLIDE_Y = self.y + 10
  CHASM_TR_COLLIDE_WIDTH = 2
  CHASM_TR_COLLIDE_HEIGHT = 2

  CHASM_BL_COLLIDE_X = self.x + 6
  CHASM_BL_COLLIDE_Y = self.y + self.height - 2
  CHASM_BL_COLLIDE_WIDTH = 2
  CHASM_BL_COLLIDE_HEIGHT = 2

  CHASM_BR_COLLIDE_X = self.x + self.width - 8
  CHASM_BR_COLLIDE_Y = self.y + self.height - 2
  CHASM_BR_COLLIDE_WIDTH = 2
  CHASM_BR_COLLIDE_HEIGHT = 2

  if not self.graveyard and not self.falling and not self.chasmFalling then
    self.checkPointTick = self.checkPointTick + dt
    if self.checkPointTick > 1 then
      self.checkPointPositions.x = self.x
      self.checkPointPositions.y = self.y
      self.checkPointTick = 0
    end
  end

  --PLAYER DEATH
  if self.health <= 0 and not self.dead then
    self.dead = true
    self:changeState('player-death')
    if self.health == 0 then
      sounds['death']:play()
    end

    --[[
    if self.chasmDeath then
      self.deadTimer = 0
      self.dead = false
      self.damageFlash = false
      self.graveyard = false
      self.dx = 0
      self.dy = 0
      self.hit = false
      self.dead = false
      self.deadTimer = 0
      --gStateMachine:change('chasmFallingState')
    end
    --]]
  end

  if self.dead then
    self.deadTimer = self.deadTimer + dt
  end

  healthDifference = totalHealth - self.health
  HEART_CROP = math.max(56 - (4 * healthDifference), 0)

  --TRANSITION EVENT TRIGGERS
  if not sceneView.shifting and not sceneView.player.falling and not sceneView.player.graveyard then
    --if #OUTPUT_LIST > 0 then
    for k, v in ipairs(OUTPUT_LIST) do
      if v == 'right' then
        if self.x + self.width >= VIRTUAL_WIDTH + SIDE_EDGE_BUFFER_PLAYER then
          Event.dispatch('right-transition')
        end
      elseif v == 'left' then
        if self.x <= -SIDE_EDGE_BUFFER_PLAYER then
          Event.dispatch('left-transition')
        end
      elseif v == 'up' then
        if self.y <= -SIDE_EDGE_BUFFER_PLAYER then
          Event.dispatch('up-transition')
        end
      elseif v == 'down' then
        if self.y + self.height >= SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER then
          Event.dispatch('down-transition')
        end
      end
    end
  end

  if not self.warping then
    Entity.update(self, dt)
  end


  --DISJOINT DIRECTIONS, ONLY HAVE UP RIGHT NOW
  if self.direction == 'up' then
    self.dialogueBoxX = self.x + DIALOGUE_TRIGGER_SHRINK / 2
    if self.extendDialogueBoxUpwards then
      self.dialogueBoxY = self.y - TILE_SIZE / 2 - 7
    else
      self.dialogueBoxY = self.y - TILE_SIZE / 2
    end
    self.dialogueBoxWidth = TILE_SIZE - DIALOGUE_TRIGGER_SHRINK
    self.dialogueBoxHeight = TILE_SIZE / 2
  elseif self.direction == 'down' then
    self.dialogueBoxX = self.x + DIALOGUE_TRIGGER_SHRINK / 2
    self.dialogueBoxY = self.y + TILE_SIZE
    self.dialogueBoxWidth = TILE_SIZE - DIALOGUE_TRIGGER_SHRINK
    self.dialogueBoxHeight = TILE_SIZE / 2
  elseif self.direction == 'left' then
    self.dialogueBoxX = self.x - TILE_SIZE / 2 + 1
    self.dialogueBoxY = self.y + DIALOGUE_TRIGGER_SHRINK / 2
    self.dialogueBoxWidth = TILE_SIZE / 2
    self.dialogueBoxHeight = TILE_SIZE - DIALOGUE_TRIGGER_SHRINK
  elseif self.direction == 'right' then
    self.dialogueBoxX = self.x + TILE_SIZE - 1
    self.dialogueBoxY = self.y + DIALOGUE_TRIGGER_SHRINK / 2
    self.dialogueBoxWidth = TILE_SIZE / 2
    self.dialogueBoxHeight = TILE_SIZE - DIALOGUE_TRIGGER_SHRINK
  end

  --SPELLCASTING
  if not sceneView.shifting then
    --FOCUS GAIN
    if (INPUT:down('action') and not luteState) or (buttons[1].fireSpellPressed and not luteState) then
      --VIBRANCY DRAIN
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
        self.manisTimer = self.manisTimer + dt
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
  end

  if self.focusIndicatorX >= 65 and self.focusIndicatorX <= 85 then
    successfulCast = true
    --sounds['spellcast']:play()
  else
    successfulCast = false
  end

  if self.focusIndicatorX > 0 then
    self.magicHudOpacity = math.min(255, self.magicHudOpacity + dt * 900)
  elseif self.focusIndicatorX <= 0 then
    self.magicHudOpacity = math.max(0, self.magicHudOpacity - dt * 400)
  end
end

function Player:render()
  if not self.graveyard then
    --DIALOGUE BOX DETECTION
    --[[
    love.graphics.setColor(1,0,0,0.7)
    love.graphics.rectangle('fill', self.dialogueBoxX + 1, self.dialogueBoxY + 1, self.dialogueBoxWidth - COLLISION_BUFFER, self.dialogueBoxHeight - COLLISION_BUFFER)
    --]]
    Entity.render(self)
    --[[
    love.graphics.setColor(RED)
    love.graphics.rectangle('fill', CHASM_TOP_COLLIDE_X, CHASM_TOP_COLLIDE_Y, CHASM_TOP_COLLIDE_WIDTH, CHASM_TOP_COLLIDE_HEIGHT)
    love.graphics.rectangle('fill', CHASM_BOTTOM_COLLIDE_X, CHASM_BOTTOM_COLLIDE_Y, CHASM_BOTTOM_COLLIDE_WIDTH, CHASM_BOTTOM_COLLIDE_HEIGHT)
    love.graphics.rectangle('fill', CHASM_LEFT_COLLIDE_X, CHASM_LEFT_COLLIDE_Y, CHASM_LEFT_COLLIDE_WIDTH, CHASM_LEFT_COLLIDE_HEIGHT)
    love.graphics.rectangle('fill', CHASM_RIGHT_COLLIDE_X, CHASM_RIGHT_COLLIDE_Y, CHASM_RIGHT_COLLIDE_WIDTH, CHASM_RIGHT_COLLIDE_HEIGHT)
    --]]
    --[[
    love.graphics.setColor(GREEN)
    love.graphics.rectangle('fill', CHASM_TL_COLLIDE_X, CHASM_TL_COLLIDE_Y, CHASM_TL_COLLIDE_WIDTH, CHASM_TL_COLLIDE_HEIGHT)
    love.graphics.rectangle('fill', CHASM_BL_COLLIDE_X, CHASM_BL_COLLIDE_Y, CHASM_BL_COLLIDE_WIDTH, CHASM_BL_COLLIDE_HEIGHT)
    love.graphics.setColor(BLUE)
    love.graphics.rectangle('fill', CHASM_TR_COLLIDE_X, CHASM_TR_COLLIDE_Y, CHASM_TR_COLLIDE_WIDTH, CHASM_TR_COLLIDE_HEIGHT)
    love.graphics.rectangle('fill', CHASM_BR_COLLIDE_X, CHASM_BR_COLLIDE_Y, CHASM_BR_COLLIDE_WIDTH, CHASM_BR_COLLIDE_HEIGHT)
    --]]
  end
end
