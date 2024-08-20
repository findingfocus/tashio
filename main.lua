require 'src/dependencies'

local buttonTest = false
local buttonTimer = 1
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
    
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT * 2, WINDOW_WIDTH, WINDOW_HEIGHT, {
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
    if love.keyboard.wasPressed('return') or love.keyboard.isDown('return') then
        love.graphics.draw(aPress, 0, VIRTUAL_HEIGHT)
    end
    if love.keyboard.wasPressed('space') or love.keyboard.isDown('space') then
        love.graphics.draw(bPress, 0, VIRTUAL_HEIGHT)
    end
    if love.keyboard.wasPressed('up') or love.keyboard.isDown('up') then
        love.graphics.draw(upPress, 0, VIRTUAL_HEIGHT)
    end
    if love.keyboard.wasPressed('left') or love.keyboard.isDown('left') then
        love.graphics.draw(leftPress, 0, VIRTUAL_HEIGHT)
    end
    if love.keyboard.wasPressed('down') or love.keyboard.isDown('down') then
        love.graphics.draw(downPress, 0, VIRTUAL_HEIGHT)
    end
    if love.keyboard.wasPressed('right') or love.keyboard.isDown('right') then
        love.graphics.draw(rightPress, 0, VIRTUAL_HEIGHT)
    end

    ---[[
    if buttonTest then
        love.graphics.draw(aPress, 0, VIRTUAL_HEIGHT)
        love.graphics.draw(bPress, 0, VIRTUAL_HEIGHT)
        love.graphics.draw(upPress, 0, VIRTUAL_HEIGHT)
        love.graphics.draw(leftPress, 0, VIRTUAL_HEIGHT)
        love.graphics.draw(downPress, 0, VIRTUAL_HEIGHT)
        love.graphics.draw(rightPress, 0, VIRTUAL_HEIGHT)
    end
    --]]
	push:finish()
end

function displayFPS()
	love.graphics.setFont(classicFont)
	love.graphics.setColor(WHITE)
	--print(tostring(accumulator), 0, VIRTUAL_HEIGHT - 62)
	love.graphics.print(tostring(love.timer.getFPS()), SCREEN_WIDTH_LIMIT - 17, VIRTUAL_HEIGHT - 12)
end
