PlayerMeditateState = Class{__includes = BaseState}

function PlayerMeditateState:init(player)
  self.player = player
  self.image = love.graphics.newImage('graphics/tashioMeditate.png')
  self.greenTunic = love.graphics.newImage('graphics/tashioMeditateGreen.png')
  self.player.meditate = true
end

function PlayerMeditateState:update(dt)
  if INPUT:pressed('up') or INPUT:pressed('left') or INPUT:pressed('down') or INPUT:pressed('right') then
    self.player.stateMachine:change('player-walk')
    self.player.meditate = false
  end
end

function PlayerMeditateState:render()
  love.graphics.draw(self.image, self.player.x, self.player.y)
  if gPlayer.tunicEquipped == 'greenTunic' then
    love.graphics.draw(self.greenTunic, self.player.x, self.player.y)
  end
end
