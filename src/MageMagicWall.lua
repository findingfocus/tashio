MageMagicWall = Class{}

function MageMagicWall:init()
  self.psystem = love.graphics.newParticleSystem(particle, 500)
  self.x = 0
  self.y = 0
end

function MageMagicWall:update(dt)
  self.psystem:moveTo(TILE_SIZE * 5, TILE_SIZE - 1)
  self.psystem:setParticleLifetime(2, 4)
  self.psystem:setEmissionArea('borderrectangle', TILE_SIZE, 0)
  self.psystem:setLinearAcceleration(0, math.random(-6, -12))
  self.psystem:setEmissionRate(500)
  self.psystem:setColors(80/255, 40/255, 255/255, 255/255, 80/255, 120/255, 255/255, 100/255)
  self.psystem:update(dt)
end

function MageMagicWall:render(adjacentOffsetX, adjacentOffsetY)
  love.graphics.setColor(WHITE)
  self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
  love.graphics.draw(self.psystem, self.x, self.y)
  self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end
