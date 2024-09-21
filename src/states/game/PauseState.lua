PauseState = Class{__includes = BaseState}

function PauseState:init()
    self.inventoryType = 'item'
    self.stateName = 'PauseState'
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        luteState = false
        gStateMachine:change('playState')
    end
    if love.keyboard.wasPressed('o') then
        if self.inventoryType == 'keyItem' then
            self.inventoryType = 'item'
        else
            self.inventoryType = 'keyItem'
        end
    end
    if self.inventoryType == 'item' then
        gItemInventory:update(dt)
    end
    if self.inventoryType == 'keyItem' then
        gKeyItemInventory:update(dt)
    end
end

function PauseState:render()
    love.graphics.draw(pauseMockup, 0, 0)
    gItemInventory:render(self.inventoryType)
    gKeyItemInventory:render(self.inventoryType)
    love.graphics.setColor(WHITE)
    --]]

    love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
    heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
    love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
end
