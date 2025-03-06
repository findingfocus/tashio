TouchDetection = Class{}

function TouchDetection:init(placementX, placementY, colorOption, direction, secondDirection)
  self.mouseX = 0
  self.mouseY = 0
  self.width = DPAD_DIAGONAL_WIDTH
  self.height = DPAD_DIAGONAL_WIDTH
  self.color = colorOption
  self.pressed = false
  self.x = placementX
  self.y = placementY
  self.touched = false
  self.direction = direction or nil
  self.secondDirection = secondDirection or nil
end

function TouchDetection:collides(touch)
  if touch.x == nil or touch.y == nil then
    touch.x = -10
    touch.y = -10
    return false
  end

  if self.x < touch.x and (self.x + self.width) > touch.x and
    self.y < touch.y and (self.y + self.height) > touch.y then
    return true
  else
    return false
  end
end

function TouchDetection:render()
  --love.graphics.setColor(0/255, 255/255, 0/255, 100/255)
  --love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  --if self.pressed then
    --love.graphics.setColor(DPAD_COLOR_TL)
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(WHITE)
    love.graphics.print(self.direction, self.x, self.y)
  --end
end
