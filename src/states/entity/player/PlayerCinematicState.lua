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
  if self.player.blueTunicEquipped then
    love.graphics.draw(gTextures['character-fall-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
  elseif self.player.redTunicEquipped then
    love.graphics.draw(gTextures['character-fall-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
  elseif self.player.greenTunicEquipped then
    love.graphics.draw(gTextures['character-fall-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
  elseif self.player.yellowTunicEquipped then
    love.graphics.draw(gTextures['character-fall-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
  end
end
