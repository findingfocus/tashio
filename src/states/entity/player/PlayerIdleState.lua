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
  if not sceneView.player.falling and not sceneView.player.graveyard then
      if #INPUT_LIST > 0 then
          self.player.currentAnimation:refresh()
      end
      --REHAUL INPUT
      --[[
      if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
          love.keyboard.isDown('up') or love.keyboard.isDown('down') then
          self.player:changeState('player-walk')
      end
      --]]
      if #OUTPUT_LIST > 0 then
        self.player:changeState('player-walk')
      end
      if #TOUCH_OUTPUT_LIST > 0 then
          self.player:changeState('player-walk')
      end
  end

  if sceneView.player.falling then
    sceneView.player.dx = 0
    sceneView.player.dy = 0
    sceneView.player:changeAnimation('falling')
  end

    --self.player.animations['falling'].looping = false
    --DONT CHANGE TO WALK IF CONTRIDICTING INPUTS HELD
end

function PlayerIdleState:render()
    local anim = self.player.currentAnimation

    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.player.x, self.player.y)
    if self.player.blueTunicEquipped then
        love.graphics.draw(gTextures['character-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    elseif self.player.redTunicEquipped then
        love.graphics.draw(gTextures['character-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    elseif self.player.greenTunicEquipped then
        love.graphics.draw(gTextures['character-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    elseif self.player.yellowTunicEquipped then
        love.graphics.draw(gTextures['character-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    end
    if self.player.fireSpellEquipped then
        love.graphics.setColor(gKeyItemInventory.elementColor)
        love.graphics.draw(gTextures['character-element'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    end
    if gItemInventory.itemSlot[1] ~= nil then
        if gItemInventory.itemSlot[1].type == 'lute' and not self.player.falling then
            love.graphics.draw(gTextures['lute-equip'], gFrames['lute-equip'][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        end
    end
end
