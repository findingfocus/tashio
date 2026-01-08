SaveSelect = Class{}

function SaveSelect:init(x, y)
  self.x = x
  self.y = y
  self.width = 140
  self.height = 40
  self.selected = false
end

function SaveSelect:update(dt)

end

function SaveSelect:render()
  love.graphics.setColor(GRAY)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  if self.selected then
    love.graphics.setColor(RED)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
  end
end
