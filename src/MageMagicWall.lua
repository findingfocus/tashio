MageMagicWall = Class{}

function MageMagicWall:init()
  self.psystem = love.graphics.newParticleSystem(particle, 800)
  self.x = 0
  self.y = 0
  self.active = false
  self.opacity = 0
end

function MageMagicWall:activate()
  self.active = true
end

function MageMagicWall:update(dt)
  self.psystem:moveTo(TILE_SIZE * 5, TILE_SIZE - 1)
  self.psystem:setParticleLifetime(2, 4)
  self.psystem:setEmissionArea('borderrectangle', TILE_SIZE, 0)
  self.psystem:setLinearAcceleration(0, math.random(-2, -20))
  --MOBILE
  self.psystem:setEmissionRate(180)
  self.psystem:setColors(80/255, 40/255, 255/255, 255/255, 80/255, 120/255, 255/255, 150/255)
  self.psystem:update(dt)

  if self.active then
    self.opacity = math.min(255, self.opacity + (255 * dt))
  end
end

function MageMagicWall:render(adjacentOffsetX, adjacentOffsetY)
  if self.active then
    love.graphics.setColor(255/255, 255/255, 255/255, self.opacity/255)
    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    love.graphics.draw(self.psystem, self.x, self.y)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
  end
end
