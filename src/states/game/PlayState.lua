PlayState = Class{__includes = BaseState}
successfulCast = false
HEART_CROP = 56
totalHealth = 14
healthDifference = 0

function PlayState:init()
    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        walkSpeed = ENTITY_DEFS['player'].walkSpeed,
        x = 30,
        y = 30,
        width = TILE_SIZE,
        height = TILE_SIZE,
    }
    --self.player.damageFlash = true
    self.player.stateMachine = StateMachine {
        ['player-walk'] = function() return PlayerWalkState(self.player, self.scene) end,
        ['player-idle'] = function() return PlayerIdleState(self.player) end,
    }
    self.player:changeState('player-idle')
    self.manis = 100
    self.manisMax = 100
    self.manisDrain = 0.45
    self.manisRegen = 1.2
    self.focusIndicatorX = 0
    self.focusMax = 1.5
    self.unFocus = 0
    self.unFocusGrowing = true
    ninetyDegrees = math.rad(90)
    oneEightyDegrees = math.rad(180)
    twoSeventyDegress = math.rad(270)
    rotate = 0
    local columns = 10
    local rows = 8
    cameraX = 0
    --STARTING SCENE
    sceneView = Scene(self.player, 1, 2)
    tilesheet = love.graphics.newImage('graphics/masterSheet.png')
    --textures = love.graphics.newImage('graphics/textures.png')
    quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)
end

function PlayState:update(dt)
    if not sceneView.shifting then
        --UNFOCUS
        if (self.unFocus < self.focusMax) and self.unFocusGrowing then
            self.unFocus = self.unFocus + 0.15
        end

        if self.unFocus >= self.focusMax then
            self.unFocus = self.focusMax
            self.unFocusGrowing = false
        end

        if (self.unFocus <= self.focusMax) and not self.unFocusGrowing then
            self.unFocus = self.unFocus - 0.15
        end

        if self.unFocus <= 0 then
            self.unFocus = 0
            self.unFocusGrowing = true
        end
        --FOCUS GAIN
        if love.keyboard.isDown('space') then
            self.focusIndicatorX = math.max(self.focusIndicatorX - self.manisDrain + self.unFocus, 0)
            if self.manis == 0 then
                self.focusIndicatorX = math.max(self.focusIndicatorX - self.manisDrain - self.unFocus, 0)
            end
        else
            self.focusIndicatorX = math.max(self.focusIndicatorX - self.manisDrain - self.unFocus, 0)
        end

        if love.keyboard.isDown('space') then
            --MANIS DRAIN
            self.manis = math.max(self.manis - 0.5, 0)

            if self.manis > 0 then
                --FOCUS INDICATOR RISING
                self.focusIndicatorX = math.min(self.focusIndicatorX + self.unFocus, self.manisMax - 2)
                self.focusIndicatorX = math.min(self.focusIndicatorX + 1.2, self.manisMax - 2)
            elseif self.manis == 0 then
                --DRAINING FOCUS WHEN NO MANIS
                self.focusIndicatorX = math.max(self.focusIndicatorX - self.manisDrain, 0)
            end
        elseif self.manis < self.manisMax then --IF SPACE ISNT HELD
            --MANIS REGEN
            self.manis = math.min(self.manis + 0.3, self.manisMax)
            --UNFOCUS DRAIN
            --self.unFocus = math.max(self.unFocus - 0.15, 0)
        end
    end

    if self.focusIndicatorX > 65 and self.focusIndicatorX < 85 then
        successfulCast = true
    else
        successfulCast = false
    end


    cameraX = cameraX + 1
    sceneView:update(dt)

    rotate = rotate + .05
    love.window.setPosition(390, 80)
end

function PlayState:render()
	love.graphics.clear(GRAY)

    love.graphics.push()
    sceneView:render()
    love.graphics.pop()

    --HUD RENDER
    love.graphics.setColor(142/255, 146/255, 171/255, 255/255)
    love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 16, VIRTUAL_WIDTH, 16)
    love.graphics.setColor(WHITE)

    love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
    heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
    love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
    love.graphics.print('health: ' .. tostring(sceneView.player.health), VIRTUAL_WIDTH - 130, SCREEN_HEIGHT_LIMIT + 4)

    --MANIS BAR RENDER
    love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
    love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT, self.manis, 2)

    --CAST BAR RENDER
    love.graphics.setColor(BLACK)
    love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT + 2, 100, 2)

    --SUCCESSFUL CAST RANGE
    love.graphics.setColor(GREEN)
    love.graphics.rectangle('fill', 65, SCREEN_HEIGHT_LIMIT + 2, 20, 2)

    --FOCUS INDICATOR
    love.graphics.setColor(WHITE)
    love.graphics.rectangle('fill', self.focusIndicatorX, SCREEN_HEIGHT_LIMIT + 2, 2, 2)

    --DEBUG MANIS SPELLCASTING
    --[[
    love.graphics.print('unFocus: ' .. tostring(self.unFocus), 5, SCREEN_HEIGHT_LIMIT - 15)
    love.graphics.print('unFocusGrowing: ' .. tostring(self.unFocusGrowing), 5, SCREEN_HEIGHT_LIMIT - 25)
    love.graphics.print('focusIndicatorX: ' .. tostring(self.focusIndicatorX), 5, SCREEN_HEIGHT_LIMIT - 35)
    --]]



	love.graphics.setFont(classicFont)
    love.graphics.setColor(BLACK)
    --love.graphics.printf('Tashio Tempo', 0, VIRTUAL_HEIGHT - 13, VIRTUAL_WIDTH, 'center')
    if love.keyboard.isDown('up') then
        love.graphics.setColor(FADED)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 11 + KEYLOGGER_YOFFSET, 0, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --UP
    else
        love.graphics.setColor(WHITE)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 11 + KEYLOGGER_YOFFSET, 0, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --UP
    end
    if love.keyboard.isDown('right') then
        love.graphics.setColor(FADED)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 8, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, ninetyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --RIGHT
    else
        love.graphics.setColor(WHITE)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 8, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, ninetyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --RIGHT
    end
    if love.keyboard.isDown('down') then
        love.graphics.setColor(FADED)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, oneEightyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --DOWN
    else
        love.graphics.setColor(WHITE)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, oneEightyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --DOWN
    end
    if love.keyboard.isDown('left') then
        love.graphics.setColor(FADED)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 24, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, twoSeventyDegress, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --LEFT
    else
        love.graphics.setColor(WHITE)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 24, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, twoSeventyDegress, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --LEFT
    end

    --DEBUG PRINT
    if love.keyboard.isDown('1') then
        love.graphics.setColor(DEBUG_BG)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(WHITE)
        love.graphics.setFont(pixelFont)
        love.graphics.print('MAP[' .. tostring(sceneView.currentMap.row) .. '][' .. tostring(sceneView.currentMap.column) .. ']', 5, 15)
        love.graphics.print('player.x: ' .. string.format("%.1f", self.player.x), 5, 25)
        love.graphics.print('player.y: ' .. string.format("%.1f", self.player.y), 5, 35)
        love.graphics.print('direction: ' .. tostring(self.player.direction), 5, 45)
        love.graphics.print('LASTINPUT: ' .. tostring(self.player.lastInput), 5, 55)
        love.graphics.print('Cast: ' .. tostring(successfulCast), 5, 65)
    end
    if love.keyboard.isDown('2') then
        --]]
    end
end
