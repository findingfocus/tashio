Mineral = Class{}

function Mineral:init(x, y, type)
  self.x = x
  self.y = y
  self.width = 9
  self.height = 9
  self.type = type
  if self.type == 'ruby' then
    self.image = ruby
  end
  self.wave = 0
  self.waverX = 0
  self.waverY = 0
end

function Mineral:update(dt)
  ---[[
  self.wave = self.wave + dt
  self.waverX = math.cos(self.wave) * .04
  self.waverY = math.sin(self.wave) * .04
  self.x = self.x + self.waverX
  self.y = self.y + self.waverY
  --self.y = self.y + 10 * dt
  --]]
end

function Mineral:render(adjacentOffsetX, adjacentOffsetY)
  self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0) - 5
  love.graphics.draw(ruby, self.x, self.y)
  self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0) + 5
end
