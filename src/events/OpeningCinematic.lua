OpeningCinematic = Class{__includes = BaseState}

function OpeningCinematic:init()
    self.testX = 0
end

function OpeningCinematic:update(dt)
    self.testX = self.testX + dt
end

function OpeningCinematic:render()
    love.graphics.clear(BLACK)
    love.graphics.push()
    sceneView:render()
    love.graphics.pop()
    love.graphics.setFont(classicFont)
    love.graphics.setColor(BLACK)
    --HUD RENDER
    ---[[
    love.graphics.setColor(WHITE)
    love.graphics.draw(hudOverlay, 0, VIRTUAL_HEIGHT - 16)
    --]]
    if gItemInventory.itemSlot[1] ~= nil then
        love.graphics.setFont(pixelFont)
        gItemInventory.itemSlot[1]:render()
    end

    love.graphics.setColor(gKeyItemInventory.elementColor)
    love.graphics.circle('fill', VIRTUAL_WIDTH - 86, VIRTUAL_HEIGHT - 8, 6)

    love.graphics.setColor(WHITE)
    love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
    heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
    love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
    love.graphics.print('HELLO', self.testX, 10)
end
