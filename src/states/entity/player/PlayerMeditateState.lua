PlayerMeditateState = Class{__includes = BaseState}

function PlayerMeditateState:init(player)
  self.player = player
  self.image = love.graphics.newImage('graphics/tashioMeditate.png')
end

function PlayerMeditateState:update(dt)
  if love.keyboard.wasPressed('w') or love.keyboard.wasPressed('a') or love.keyboard.wasPressed('s') or love.keyboard.wasPressed('d') then
    self.player.stateMachine:change('player-walk')
  end
end

function PlayerMeditateState:render()
  love.graphics.draw(self.image, self.player.x, self.player.y)
end
