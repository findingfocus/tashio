SaveSelect = Class{}

function SaveSelect:init(x, y, option)
  self.x = x
  self.y = y
  self.width = 140
  self.height = 40
  self.selected = false
  self.option = option
  self.saveDataExists = love.filesystem.getInfo("saves/savePlayerData" .. self.option .. ".bin")
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

  love.graphics.setColor(WHITE)
  if self.saveDataExists == nil then
    love.graphics.print("NEW GAME", self.x + 5, self.y + 5)
  else
    love.graphics.print("CONTINUE", self.x + 5, self.y + 5)
  end
end
