PauseState = Class{__includes = BaseState}

function PauseState:init()

end

function PauseState:update(dt)
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gStateMachine:change('playState')
    end
    gInventory:update(dt)
end

function PauseState:render()
    love.graphics.draw(pauseMockup, 0, 0)
    gInventory:render()
    love.graphics.setColor(WHITE)
    --]]

    love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
    heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
    love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
end
