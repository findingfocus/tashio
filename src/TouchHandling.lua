TouchHandling = Class{}

function insertTouchDirection(direction)
    local directionCount = 0
    for key, value in ipairs(TOUCH_LIST) do
        if value == direction then
            directionCount = directionCount + 1
        end
    end
    if directionCount == 0 then
        table.insert(TOUCH_LIST, direction)
    end
end

function removeTouchDirection(direction)
    for key, value in ipairs(TOUCH_LIST) do
        if value == direction then
            table.remove(TOUCH_LIST, key)
            break
        end
    end
end

function TouchHandling:init()
    dpad = {
        TouchDetection(DPAD_X,DPAD_Y, DPAD_COLOR_TL, 'up', 'left'), --UPLEFT
        TouchDetection(DPAD_X + DPAD_DIAGONAL_WIDTH, DPAD_Y, DPAD_COLOR_TC, 'up'), --UP
        TouchDetection(DPAD_X + DPAD_DIAGONAL_WIDTH * 2, DPAD_Y, DPAD_COLOR_TR, 'up', 'right'), --UPRIGHT
        TouchDetection(DPAD_X, DPAD_Y + DPAD_DIAGONAL_WIDTH, DPAD_COLOR_LEFT, 'left'), --LEFT
        TouchDetection(DPAD_X + DPAD_DIAGONAL_WIDTH * 2, DPAD_Y + DPAD_DIAGONAL_WIDTH, DPAD_COLOR_RIGHT, 'right'), --RIGHT
        TouchDetection(DPAD_X, DPAD_Y + DPAD_DIAGONAL_WIDTH * 2, DPAD_COLOR_BL, 'down', 'left'), --DOWNLEFT
        TouchDetection(DPAD_X + DPAD_DIAGONAL_WIDTH, DPAD_Y + DPAD_DIAGONAL_WIDTH * 2, DPAD_COLOR_BC, 'down'), --DOWN
        TouchDetection(DPAD_X + DPAD_DIAGONAL_WIDTH * 2, DPAD_Y + DPAD_DIAGONAL_WIDTH * 2, DPAD_COLOR_BR, {'down', 'right'}), --DOWNRIGHT
    }
    buttons = {
        TouchDetection(VIRTUAL_WIDTH - 33, VIRTUAL_HEIGHT_GB / 2 + DPAD_DIAGONAL_WIDTH + 2, DPAD_COLOR_TL), --A
        TouchDetection(VIRTUAL_WIDTH - 64, VIRTUAL_HEIGHT_GB / 2 + DPAD_DIAGONAL_WIDTH * 2 + 3, DPAD_COLOR_TL), --B
        TouchDetection(VIRTUAL_WIDTH / 2 - 56, VIRTUAL_HEIGHT_GB - 30, DPAD_COLOR_TL), --SELECT
        TouchDetection(VIRTUAL_WIDTH / 2 - 14, VIRTUAL_HEIGHT_GB - 30, DPAD_COLOR_TL), --START
    }
    --[2] == UP
    --[4] == LEFT
    --[5] == RIGHT
    --[7] == DOWN
    --
    --[1] == UPLEFT
    --[3] == UPRIGHT
    --[6] == DOWNLEFT
    --[8] == DOWNRIGHT
  touches = {}

  function love.touchpressed(id, x, y, dx, dy)
      touches[id] = {x = x, y = y, dx = dx, dy = dy}
      touches[id].x, touches[id].y = push:toGame(x, y)
      if buttons[3]:collides(touches[id]) then
        toggleHelp = toggleHelp == false and true or false
      end

  end

  function love.touchmoved(id, x, y, dx, dy)
      if touches[id] then
          touches[id].x, touches[id].y = push:toGame(x, y)
          touches[id].dx = dx
          touches[id].dy = dy
      end
  end

  function love.touchreleased(id, x, y, dx, dy)
      touches[id] = nil
  end
end

function TouchHandling:update(dt)
  for k, button in pairs(dpad) do
      button.pressed = false
  end

  for k, button in pairs(dpad) do
      for index, touch in pairs(touches) do
          if button:collides(touch) then
              button.pressed = true
              break
          end
      end
  end

  if buttons[1].pressed then
    sounds['spellcast']:play()
  end

  TOUCH_LIST = {}
  for index, button in ipairs(dpad) do
    if button.pressed then
        if button.secondDirection then
            insertTouchDirection(button.direction)
            insertTouchDirection(button.secondDirection)
        else
            insertTouchDirection(button.direction)
        end
    end
  end
end

function TouchHandling:render()
    for k, v in ipairs(dpad) do
        v:render()
    end

    love.graphics.setColor(RED)
    for id, touch in pairs(touches) do
        love.graphics.setColor(RED)
        --love.graphics.print('x: ' .. tostring(touch.x), 10, 40)
        --love.graphics.print('y: ' .. tostring(touch.y), 10, 50)
        love.graphics.circle('fill', touch.x, touch.y, 10)
    end
end