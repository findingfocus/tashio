Coin = Class{}

function Coin:init()
  self.x = 0
  self.y = 0
  self.width = 10
  self.height = 10
  self.image = love.graphics.newImage('graphics/coin.png')
  self.type = 'coin'
end

function Coin:update(dt)

end

function Coin:render()
  love.graphics.setColor(WHITE)
  love.graphics.draw(self.image, self.x, self.y)
end
