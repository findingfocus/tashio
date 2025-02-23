InputHandling = Class{}

local inspect = require 'lib/inspect'

function InputHandling:init()

end

function insertDirection(direction)
  local directionCount = 0
  for key, value in ipairs(INPUT_LIST) do
    if value == direction then
      directionCount = directionCount + 1
    end
  end
  if directionCount == 0 then
    table.insert(INPUT_LIST, direction)
  end
end

function removeDirection(direction)
  for key, value in ipairs(INPUT_LIST) do
    if value == direction then
      table.remove(INPUT_LIST, key)
      break
    end
  end
end

function InputHandling:update(dt)
  if love.keyboard.wasPressed('a') then
    insertDirection('left')
  end
  if love.keyboard.wasPressed('w') then
    insertDirection('up')
  end
  if love.keyboard.wasPressed('d') then
    insertDirection('right')
  end
  if love.keyboard.wasPressed('s') then
    insertDirection('down')
  end

  if love.keyboard.wasReleased('a') then
    removeDirection('left')
  end
  if love.keyboard.wasReleased('w') then
    removeDirection('up')
  end
  if love.keyboard.wasReleased('d') then
    removeDirection('right')
  end
  if love.keyboard.wasReleased('s') then
    removeDirection('down')
  end

  --INPUT LIST SANITATION
  OUTPUT_LIST = {}
  for key, value in ipairs(INPUT_LIST) do
    table.insert(OUTPUT_LIST, value)
  end
  if #INPUT_LIST > 2 then
    OUTPUT_LIST = {}
  end
  local horizontalInput = 0
  local verticalInput = 0
  for key, value in ipairs(OUTPUT_LIST) do
    if value == 'left' or value == 'right' then
      horizontalInput = horizontalInput + 1
    elseif value == 'up' or value == 'down' then
      verticalInput = verticalInput + 1
    end
    if horizontalInput == 2 or verticalInput == 2 then
      OUTPUT_LIST = {}
    end
  end
end

function InputHandling:render()
  --[[
  love.graphics.setColor(DEBUG_BG2)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, 70)
  love.graphics.setFont(pixelFont)
  love.graphics.setColor(WHITE)
  love.graphics.print("INPUT: " .. inspect(INPUT_LIST), 0, 0)
  love.graphics.print("INPUT#: " .. tostring(#INPUT_LIST), 0, 10)
  love.graphics.print("TOUCH: " .. inspect(TOUCH_LIST), 0, 20)
  love.graphics.print("TOUCH#: " .. tostring(#TOUCH_LIST), 0, 30)
  love.graphics.print("OUTPUT: " .. inspect(OUTPUT_LIST), 0, 40)
  love.graphics.print("TOUCH: " .. inspect(TOUCH_OUTPUT_LIST), 0, 50)
  love.graphics.print("WALK: " .. tostring(sceneView.player.walkSpeed), 0, 60)
  --]]
end
