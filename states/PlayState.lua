PlayState = Class{__includes = BaseState}


function PlayState:init()
    kvothe = Player()
end

function PlayState:update(dt)
    kvothe:update(dt)
end

function PlayState:render()
	love.graphics.clear(GRAY)

    kvothe:render()

    --HUD RENDER
    love.graphics.setColor(YELLOW)
    love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 16, VIRTUAL_WIDTH, 16)
    love.graphics.setColor(BLACK)
    love.graphics.printf('KvotheDX', 0, VIRTUAL_HEIGHT - 15, VIRTUAL_WIDTH, 'center')
end

