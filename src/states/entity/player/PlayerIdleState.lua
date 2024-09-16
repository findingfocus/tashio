PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(entity)
    self.direction = 'down'
    self.entity = entity
    self.entity:changeAnimation('idle-' .. self.entity.direction)
    self.waitDuration = 0
    self.waitTimer = 0
    PLAYER_STATE = 'IDLE'
end

local fallTimer = 0

function PlayerIdleState:update(dt)
    --[[
  fallTimer = fallTimer + dt 
  if fallTimer > 3 then
    self.entity:changeAnimation('falling')

    if self.entity.animations['falling'].timesPlayed >= 1 then
      self.entity:changeState('player-idle')
      self.entity.animations['falling'].timesPlayed = 0
      fallTimer = 0
    end
  end
  --]]
  --print('fallTimer: ' .. fallTimer)

  if not sceneView.player.falling and not sceneView.player.graveyard then
      if #INPUT_LIST > 0 then
          self.entity.currentAnimation:refresh()
      end
      --REHAUL INPUT
      --[[
      if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
          love.keyboard.isDown('up') or love.keyboard.isDown('down') then
          self.entity:changeState('player-walk')
      end
      --]]
      if #OUTPUT_LIST > 0 then
        self.entity:changeState('player-walk')
      end
      if #TOUCH_OUTPUT_LIST > 0 then
          self.entity:changeState('player-walk')
      end
  end

  if sceneView.player.falling then
    sceneView.player.dx = 0
    sceneView.player.dy = 0
    sceneView.player:changeAnimation('falling')
  end

    --self.entity.animations['falling'].looping = false 
    --DONT CHANGE TO WALK IF CONTRIDICTING INPUTS HELD
end

function PlayerIdleState:render()
    local anim = self.entity.currentAnimation

    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.entity.x, self.entity.y)
    if self.entity.blueTunicEquipped then
        love.graphics.draw(gTextures['character-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.entity.x), math.floor(self.entity.y))
    elseif self.entity.redTunicEquipped then
        love.graphics.draw(gTextures['character-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.entity.x), math.floor(self.entity.y))
    elseif self.entity.greenTunicEquipped then
        love.graphics.draw(gTextures['character-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.entity.x), math.floor(self.entity.y))
    elseif self.entity.yellowTunicEquipped then
        love.graphics.draw(gTextures['character-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.entity.x), math.floor(self.entity.y))
    end
    if self.entity.fireSpellEquipped then
        love.graphics.draw(gTextures['character-fireElement'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.entity.x), math.floor(self.entity.y))
    end
end
