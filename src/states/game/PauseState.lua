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

    for k, v in pairs(touches) do
        --INVENTORY SWAP
        if buttons[2]:collides(touches[k]) and touches[k].wasTouched then
            if self.inventoryType == 'keyItem' then
                self.inventoryType = 'item'
            else
                self.inventoryType = 'keyItem'
            end
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
    --PLAYER
    love.graphics.draw(gTextures['character-walk'], gFrames['character-walk'][1], INVENTORY_PLAYER_X, INVENTORY_PLAYER_Y)
    if gPlayer.blueTunicEquipped then
        love.graphics.draw(gTextures['character-blueTunic'], gFrames['character-blueTunic'][1], math.floor(INVENTORY_PLAYER_X), math.floor(INVENTORY_PLAYER_Y))
    elseif gPlayer.redTunicEquipped then
        love.graphics.draw(gTextures['character-redTunic'], gFrames['character-redTunic'][1], math.floor(INVENTORY_PLAYER_X), math.floor(INVENTORY_PLAYER_Y))
    elseif gPlayer.greenTunicEquipped then
        love.graphics.draw(gTextures['character-greenTunic'], gFrames['character-greenTunic'][1], math.floor(INVENTORY_PLAYER_X), math.floor(INVENTORY_PLAYER_Y))
    elseif gPlayer.yellowTunicEquipped then
        love.graphics.draw(gTextures['character-yellowTunic'], gFrames['character-yellowTunic'][1], math.floor(INVENTORY_PLAYER_X), math.floor(INVENTORY_PLAYER_Y))
    end

    --ELEMENT RENDER
    love.graphics.setColor(gKeyItemInventory.elementColor)
    love.graphics.draw(gTextures['character-element'], gFrames['character-element'][1], math.floor(INVENTORY_PLAYER_X), math.floor(INVENTORY_PLAYER_Y))

    love.graphics.setColor(WHITE)
    love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
    heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
    love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)

    --LUTE
    if gItemInventory.itemSlot[1] ~= nil then
        if gItemInventory.itemSlot[1].type == 'lute' then
            love.graphics.setColor(WHITE)
            love.graphics.draw(gTextures['lute-equip'], gFrames['lute-equip'][1], math.floor(INVENTORY_PLAYER_X), math.floor(INVENTORY_PLAYER_Y))
        end
    end
end
