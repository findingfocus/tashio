PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
  self.direction = 'down'
  self.player = player
  self.player:changeAnimation('idle-' .. self.player.direction)
  self.waitDuration = 0
  self.waitTimer = 0
  PLAYER_STATE = 'IDLE'
end

local fallTimer = 0

function PlayerIdleState:update(dt)
  self.player.pushing = false
  if not sceneView.player.falling and not sceneView.player.graveyard then
    if #INPUT_LIST > 0 then
      self.player.currentAnimation:refresh()
    end
    if #OUTPUT_LIST > 0 then
      self.player:changeState('player-walk')
    end
    if #TOUCH_OUTPUT_LIST > 0 then
      self.player:changeState('player-walk')
    end

    --IDLE
    if #OUTPUT_LIST == 0 and #TOUCH_OUTPUT_LIST == 0 then
      self.player.animations['push-' .. tostring(self.player.direction)]:refresh()
      self.player:changeAnimation('idle-' .. tostring(self.player.direction))
    end
  end

  if sceneView.player.falling or sceneView.player.chasmFalling then
    sceneView.player.dx = 0
    sceneView.player.dy = 0
    --IS THIS OK TO KEEP REMOVED? CHECK
    --sceneView.player:changeAnimation('falling')
  end
end

function PlayerIdleState:render()
  local anim = self.player.currentAnimation

  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
  math.floor(self.player.x), math.floor(self.player.y))

  if not self.player.falling then
    if not self.player.showOff then
      if self.player.tunicEquipped == 'blueTunic' then
        love.graphics.draw(gTextures['character-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
      elseif self.player.tunicEquipped == 'redTunic' then
        love.graphics.draw(gTextures['character-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
      elseif self.player.tunicEquipped == 'greenTunic' then
        love.graphics.draw(gTextures['character-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
      elseif self.player.tunicEquipped == 'yellowTunic' then
        love.graphics.draw(gTextures['character-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
      end
    end
  else --IF FALLING
    if self.player.tunicEquipped == 'blueTunic' then
      love.graphics.draw(gTextures['character-fall-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    elseif self.player.tunicEquipped == 'redTunic' then
      love.graphics.draw(gTextures['character-fall-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    elseif self.player.tunicEquipped == 'greenTunic' then
      love.graphics.draw(gTextures['character-fall-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    elseif self.player.tunicEquipped == 'yellowTunic' then
      love.graphics.draw(gTextures['character-fall-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    end
  end

  if self.player.elementEquipped == 'flamme' and not self.player.showOff then
    love.graphics.setColor(gKeyItemInventory.elementColor)
    love.graphics.draw(gTextures['character-element'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
  end
  --LUTE RENDER EQUIPPED
  if gItemInventory.itemSlot[1] ~= nil then
    if gItemInventory.itemSlot[1].type == 'lute' and not self.player.falling then
      if not gPlayer.pushing and not gPlayer.showOff then
        love.graphics.setColor(WHITE)
        love.graphics.draw(gTextures['lute-equip'], gFrames['lute-equip'][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
      end
    end
  end

  if self.player.showOff then
    if self.player.tunicEquipped == 'greenTunic' then
      love.graphics.setColor(WHITE)
      love.graphics.draw(showOffGreenTunic, math.floor(self.player.x), math.floor(self.player.y))
    end
  end
end
