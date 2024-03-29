require 'src/dependencies'

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Tashio Tempo')

    love.mouse.setVisible(false)

    math.randomseed(os.time())

	love.graphics.setFont(pixelFont)

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
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

	push:finish()
end

function displayFPS()
	love.graphics.setFont(classicFont)
	love.graphics.setColor(BLACK)
	love.graphics.print(tostring(love.timer.getFPS()), 0, VIRTUAL_HEIGHT - 12)
end
