PlayerCinematicState = Class{__includes = BaseState}

function PlayerCinematicState:init(player)
  self.player = player
  self.scene = scene
  PLAYER_STATE = 'CINEMATIC'
end

function PlayerCinematicState:update(dt)

end

function PlayerCinematicState:render()
  local anim = self.player.currentAnimation
  --PLAYER BASE LAYER
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))

  --PLAYER TUNIC
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
