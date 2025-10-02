TouchDetection = Class{}

function TouchDetection:init(placementX, placementY, width, height, colorOption, direction, secondDirection)
  self.mouseX = 0
  self.mouseY = 0
  self.width = width
  self.height = height
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
  --[[
  --RENDER BUTTON PRESS
  for _, input in pairs(OUTPUT_LIST) do
    if self.direction == input then
      love.graphics.setColor(1,0,0, 100/255)
      if input == 'up' then
        love.graphics.rectangle('fill', self.x + DPAD_BUTTON_WIDTH, self.y, self.width - DPAD_BUTTON_WIDTH * 2, self.height)
      elseif input == 'left' then
        love.graphics.rectangle('fill', self.x, self.y + DPAD_BUTTON_WIDTH, self.width, self.height - DPAD_BUTTON_WIDTH * 2)
      elseif input == 'right' then
        love.graphics.rectangle('fill', self.x, self.y + DPAD_BUTTON_WIDTH, self.width, self.height - DPAD_BUTTON_WIDTH * 2)
      elseif input == 'down' then
        love.graphics.rectangle('fill', self.x + DPAD_BUTTON_WIDTH, self.y, self.width - DPAD_BUTTON_WIDTH * 2, self.height)
      else
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
      end
    end
  end

  for _, input in pairs(BUTTON_LIST) do
    if self.direction == input then
      love.graphics.setColor(1,0,0, 100/255)
      if input == 'A' then
        love.graphics.circle('fill', self.x + DPAD_BUTTON_WIDTH / 2, self.y + DPAD_BUTTON_WIDTH / 2, DPAD_BUTTON_WIDTH / 2 + 0.5)
      end
      if input == 'B' then
        love.graphics.circle('fill', self.x + DPAD_BUTTON_WIDTH / 2, self.y + DPAD_BUTTON_WIDTH / 2, DPAD_BUTTON_WIDTH / 2 + 0.5)
      end
      if input == 'START' then
        love.graphics.setColor(WHITE)
        love.graphics.draw(optionsButtonPressed, self.x, self.y)
      end
      if input == 'SELECT' then
        love.graphics.setColor(WHITE)
        love.graphics.draw(optionsButtonPressed, self.x, self.y)
      end
    end
  end
  --]]
end
