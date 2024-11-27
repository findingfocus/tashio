TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()

end

local highlighted = 1

function TitleScreenState:update(dt)

--[[
	sounds['titleMusic']:setLooping(true)
	sounds['titleMusic']:play()
--]]

	if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('right') then
		highlighted = highlighted == 1 and 2 or 1
		sounds['beep']:play()
	end

	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		if highlighted == 1 then
			--sounds['titleMusic']:stop()
			sounds['select']:play()
			gStateMachine:change('playState')
		else
			--sounds['titleMusic']:stop()
			sounds['select']:play()
		end
	end
end

function TitleScreenState:render()
	love.graphics.clear(150/255, 150/255, 255/255, 255/255)
end
