PlayerDeathState = Class{__includes = BaseState}

function PlayerDeathState:init(player, scene)
  self.player = player
  self.scene = scene
  PLAYER_STATE = 'DEATH'
  self.timer = 0
  self.player:changeAnimation('death')
end

function PlayerDeathState:update(dt)
end

function PlayerDeathState:render()
  local anim = self.player.currentAnimation

  --PLAYER BASE LAYER
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))

  --GREEN TUNIC
  if gPlayer.tunicEquipped  == 'greenTunic' then
    if gPlayer.falling then
      love.graphics.draw(gTextures['character-fall-greenTunic'], gFrames['character-death-greenTunic'][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    else
      love.graphics.draw(gTextures['character-death-greenTunic'], gFrames['character-death-greenTunic'][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    end
  end
end
