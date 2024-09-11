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
end
