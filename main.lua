push = require '/dependencies/push'

Class = require 'dependencies/class'

require '/dependencies/StateMachine'
require '/dependencies/BaseState'

require '/states/TitleScreenState'
require '/states/PlayState'
require '/classes/Player'
require '/src/constants'

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Kvothe DX')

    love.mouse.setVisible(false)

	pixelFont = love.graphics.newFont('fonts/Pixel.ttf', 16)
	tinyFont = love.graphics.newFont('fonts/Pixel.ttf', 8)
	love.graphics.setFont(pixelFont)

    kvothe = love.graphics.newImage('/src/pics/kvotheAtlas.png')
    arrowKeyLogger = love.graphics.newImage('/src/pics/arrowKey.png')
    dirt = love.graphics.newImage('/src/pics/dirt.png')

	sounds = {
		['beep'] = love.audio.newSource('music/beep.wav', 'static'),
		['select'] = love.audio.newSource('music/select.wav', 'static')
	}
--]]
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = false
	})

	gStateMachine = StateMachine {
		['titleState'] = function() return TitleScreenState() end,
		['playState'] = function() return PlayState() end,
	}

	gStateMachine:change('playState')

	love.keyboard.keysPressed = {}

end

function love.resize(w, h)
	push:resize(w,h)
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

function love.update(dt)
    if love.keyboard.wasPressed('tab') then
        mouseState = not love.mouse.isVisible()
        love.mouse.setVisible(mouseState)
    end

	gStateMachine:update(dt)

	love.keyboard.keysPressed = {}
end

function love.draw()
	push:start()

	gStateMachine:render()

	displayFPS()

	push:finish()
end

function displayFPS()
	love.graphics.setFont(tinyFont)
	love.graphics.setColor(BLACK)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 1, VIRTUAL_HEIGHT - 7)
end
