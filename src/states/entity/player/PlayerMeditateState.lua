PlayerMeditateState = Class{__includes = BaseState}

function PlayerMeditateState:init(player)
  self.player = player
  self.image = love.graphics.newImage('graphics/tashioMeditate.png')
end

function PlayerMeditateState:update(dt)
  if INPUT:pressed('up') or INPUT:pressed('left') or INPUT:pressed('down') or INPUT:pressed('right') then
    self.player.stateMachine:change('player-walk')
  end
end

function PlayerMeditateState:render()
  love.graphics.draw(self.image, self.player.x, self.player.y)
end
