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
    love.graphics.draw(gTextures['character-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
  elseif self.player.tunicEquipped == 'redTunic' then
    love.graphics.draw(gTextures['character-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
  elseif self.player.tunicEquipped == 'greenTunic' then
    love.graphics.draw(gTextures['character-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
  elseif self.player.tunicEquipped == 'yellowTunic' then
    love.graphics.draw(gTextures['character-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
  end

  if gItemInventory.itemSlot[1] ~= nil then
    if gItemInventory.itemSlot[1].type == 'lute' and not self.player.falling then
      if not gPlayer.pushing then
        love.graphics.setColor(WHITE)
        love.graphics.draw(gTextures['lute-equip'], gFrames['lute-equip'][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
      end
    end
  end

  if self.player.elementEquipped == 'flamme' then
    if not gPlayer.pushing then
      love.graphics.setColor(gKeyItemInventory.elementColor)
      love.graphics.draw(gTextures['character-element'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    end
  end
end
