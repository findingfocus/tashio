require 'src/dependencies'

function love.load()
  love.window.setTitle('Tashio Tempo')

  love.mouse.setVisible(false)

  math.randomseed(os.time())
  
  love.graphics.setFont(pixelFont)

  keyboardInput = InputHandling()
  touchInput = TouchHandling()

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
    fullscreen = false,
    resizable = false
  })

  gStateMachine = StateMachine {
    ['titleState'] = function() return TitleScreenState() end,
    ['playState'] = function() return PlayState() end,
    ['pauseState'] = function() return PauseState() end,
    ['chasmFallingState'] = function() return FallingChasmState() end,
    ['openingCinematic'] = function() return OpeningCinematic() end,
    ['minimap'] = function() return Minimap() end,
  }

  --gStateMachine:change('titleState')
  gStateMachine:change('playState')
  --gStateMachine:change('minimap')
  --gStateMachine:change('chasmFallingState')
  for _, button in ipairs(dpad) do
    button:render()
    --button.pressed = INPUT:down(button.direction) or (button.secondDirection and INPUT:down(button.secondDirection))
  end
  for _, button in ipairs(buttons) do
    button:render()
    --button.pressed = INPUT:down(button.direction)
  end

  love.keyboard.keysPressed = {}
  love.keyboard.keysReleased = {}
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
  keyboardInput:update(dt)
  touchInput:update(dt)
  ---[[
  function love.touchpressed(id, x, y, dx, dy, pressure)
    local gameX, gameY = push:toGame(x, y)
    INPUT:touchpressed(id, x, y, dx, dy, pressure)
  end

  function love.touchmoved(id, x, y, dx, dy, pressure)
    local gameX, gameY = push:toGame(x, y)
    INPUT:touchmoved(id, x, y, dx, dy, pressure)
  end

  function love.touchreleased(id, x, y, dx, dy, pressure)
    INPUT:touchreleased(id, x, y, dx, dy, pressure)
  end
  --]]

  Timer.update(dt)
  if love.keyboard.wasPressed('`') then
    mouseState = not love.mouse.isVisible()
    love.mouse.setVisible(mouseState)
  end

  gStateMachine:update(dt)

  love.keyboard.keysPressed = {}
  love.keyboard.keysReleased = {}
  for k, v in pairs(touches) do
    touches[k].wasTouched = false
  end
end

function love.draw()
  push:start()

  gStateMachine:render()

  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(gameboyOverlay, 0, VIRTUAL_HEIGHT)
  keyboardInput:render()
  touchInput:render()
  push:finish()
end

