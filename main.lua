require 'src/dependencies'
local inspect = require 'lib/inspect'
local buttonTest = false
local buttonTimer = 1
local dpad = {}
local dpadTopLeft = TouchDetection(DPAD_X,DPAD_Y, DPAD_COLOR_TL)
local dpadTop = TouchDetection(DPAD_X + DPAD_DIAGONAL_WIDTH, DPAD_Y, DPAD_COLOR_TC)
local dpadTopRight = TouchDetection(DPAD_X + DPAD_DIAGONAL_WIDTH * 2, DPAD_Y, DPAD_COLOR_TR)
local dpadLeft = TouchDetection(DPAD_X, DPAD_Y + DPAD_DIAGONAL_WIDTH, DPAD_COLOR_LEFT)
local dpadRight = TouchDetection(DPAD_X + DPAD_DIAGONAL_WIDTH * 2, DPAD_Y + DPAD_DIAGONAL_WIDTH, DPAD_COLOR_RIGHT)
local dpadBottomLeft = TouchDetection(DPAD_X, DPAD_Y + DPAD_DIAGONAL_WIDTH * 2, DPAD_COLOR_BL)
local dpadBottom = TouchDetection(DPAD_X + DPAD_DIAGONAL_WIDTH, DPAD_Y + DPAD_DIAGONAL_WIDTH * 2, DPAD_COLOR_BC)
local dpadBottomRight = TouchDetection(DPAD_X + DPAD_DIAGONAL_WIDTH * 2, DPAD_Y + DPAD_DIAGONAL_WIDTH * 2, DPAD_COLOR_BR)
table.insert(dpad, dpadTopLeft)
table.insert(dpad, dpadTop)
table.insert(dpad, dpadTopRight)
table.insert(dpad, dpadLeft)
table.insert(dpad, dpadRight)
table.insert(dpad, dpadBottomLeft)
table.insert(dpad, dpadBottom)
table.insert(dpad, dpadBottomRight)
function love.load()
  love.window.setTitle('Tashio Tempo')

  love.mouse.setVisible(false)

  math.randomseed(os.time())

  love.graphics.setFont(pixelFont)

  io.stdout:setvbuf ('no')
    
  if arg and arg [#arg] == '-debug' then
      MODDEBUG = require ('lib/mobdebug')
      MODDEBUG.start()
      MODDEBUG.off()
  end

  function debug_on (on)
      if MODDEBUG then
          if on then
              MODDEBUG.on()
          else
              MODDEBUG.off()
          end
      end
  end

  function debug(v)
      debug_on(v ~= false)
  end

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT_GB, WINDOW_WIDTH, WINDOW_HEIGHT, {
      vsync = true,
      fullscreen = true,
      resizable = false
  })

  gStateMachine = StateMachine {
      ['titleState'] = function() return TitleScreenState() end,
      ['playState'] = function() return PlayState() end,
  }

  gStateMachine:change('playState')

  love.keyboard.keysPressed = {}
  love.keyboard.keysReleased = {}
  touches = {}

  function love.touchpressed(id, x, y, dx, dy)
      touches[id] = {x = x, y = y, dx = dx, dy = dy}
      touches[id].x, touches[id].y = push:toGame(x, y)
  end

  function love.touchmoved(id, x, y, dx, dy)
      if touches[id] then
          touches[id].x, touches[id].y = push:toGame(x, y)
          touches[id].dx = dx
          touches[id].dy = dy


          --dpad[i].mouseX, dpad[i].mouseY = push:toGame(mouseX, mouseY)
          --dpad[i].mouseX = dpad[i].mouseX * SCALE_FACTOR
          --dpad[i].mouseY = dpad[i].mouseY * SCALE_FACTOR
      end
  end

  function love.touchreleased(id, x, y, dx, dy)
      touches[id] = nil
  end
end

function love.resize(w, h)
	push:resize(w,h)
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

function love.keyboard.wasReleased(key)
    if love.keyboard.keysReleased[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
  mouseX, mouseY = love.mouse.getPosition()
  --touches = love.touch.getTouches()


  --FOR TOUCHES
  --[[
  for i, id in pairs(touches) do
    mouseX, mouseY = love.touch.getPosition(id)
    dpad[i].mouseX = mouseX
    dpad[i].mouseY = mouseY
    dpad[i].mouseX, dpad[i].mouseY = push:toGame(mouseX, mouseY)
    if dpad[i].mouseX == nil then
        dpad[i].mouseX = 0
    end
    if dpad[i].mouseY == nil then
        dpad[i].mouseY = 0
    end
    dpad[i].mouseX = dpad[i].mouseX * SCALE_FACTOR
    dpad[i].mouseY = dpad[i].mouseY * SCALE_FACTOR
  end
  --FOR MOUSE
  mouseX, mouseY = push:toGame(mouseX, mouseY)
  if mouseX == nil then
      mouseX = 0
  end
  if mouseY == nil then
      mouseY = 0
  end
  mouseX = mouseX * SCALE_FACTOR
  mouseY = mouseY * SCALE_FACTOR
  --]]

  if love.mouse.isDown(1) then
      mouseDown = true
  else
      mouseDown = false
  end

  --[[
  for k, v in pairs(dpad) do
      if mouseDown then
          for index, touch in pairs(touches) do
              if v:collides(touch) then
                  v.pressed = true
                  break
              else
                  v.pressed = false
              end
          end
      else
          v.pressed = false
      end
  end
  --]]
  for k, touch in pairs(touches) do
      for index, button in pairs(dpad) do
          if button:collides(touch) then
              button.pressed = true
          end
      end
  end

  buttonTimer = buttonTimer - dt
  if buttonTimer <= 0 then
      buttonTest = buttonTest == false and true or false
      buttonTimer = 1

  end
  Timer.update(dt)
  if love.keyboard.wasPressed('tab') then
    mouseState = not love.mouse.isVisible()
    love.mouse.setVisible(mouseState)
  end

  gStateMachine:update(dt)

  love.keyboard.keysPressed = {}
  love.keyboard.keysReleased = {}
end

function love.draw()
	push:start()

	gStateMachine:render()

	displayFPS()

    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(gameboyOverlay, 0, VIRTUAL_HEIGHT)

    ---[[
    love.graphics.setColor(WHITE)
    love.graphics.print('mouseX: ' .. tostring(mouseX), 0, 0)
    love.graphics.print('mouseY: ' .. tostring(mouseY), 0, 10)
    --]]
    for k, v in pairs(dpad) do
        v:render()
    end

    --love.graphics.print('touches: ' .. inspect(touches), 0, 20)

    love.graphics.setColor(RED)
    --love.graphics.circle('fill', 25, 25, 10)
    for id, touch in pairs(touches) do
        love.graphics.setColor(RED)
        love.graphics.print('x: ' .. tostring(touch.x), 10, 40)
        love.graphics.print('y: ' .. tostring(touch.y), 10, 50)
        love.graphics.circle('fill', touch.x, touch.y, 10)
    end
	push:finish()
end

function displayFPS()
	love.graphics.setFont(classicFont)
	love.graphics.setColor(WHITE)
	love.graphics.print(tostring(love.timer.getFPS()), SCREEN_WIDTH_LIMIT - 17, VIRTUAL_HEIGHT - 12)
end
