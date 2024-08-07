PlayState = Class{__includes = BaseState}
successfulCast = false
HEART_CROP = 56
local STRING_WIDTH = 2
totalHealth = 14
healthDifference = 0
local inspect = require "lib/inspect"
leftCount = 0
local validTiming = false
local luteState = false
local F1Pressed = false
local D1Pressed = false
local A1Pressed = false
local F2Pressed = false
local luteStringF2 = LuteString(1)
local luteStringD1 = LuteString(2)
local luteStringA1 = LuteString(3)
local luteStringF1 = LuteString(4)
local fretsHeld = {}
local song1 = {}
song1 = {{Note(4,3,2), Note(2,3,1), Note(3,3,1)}, {Note(3,4,1)}, {Note(2,2,1)}, {Note(3,4,1), Note(4,4,1)}, {Note(2,2,1)}}
bassNotes1 = BassNotes({'Bb1', 'A1', 'G1', 'F1'})
local activeNotes = {}
local songTimer = 1

function PlayState:init()
    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        walkSpeed = ENTITY_DEFS['player'].walkSpeed,
        x = 30,
        y = 0,
        --y = 30,
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
    self.manisDrain = .45
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
    --STARTING SCENE PLAYER SPAWN
    sceneView = Scene(self.player, 7, 3)
    tilesheet = love.graphics.newImage('graphics/masterSheet.png')
    --textures = love.graphics.newImage('graphics/textures.png')
    quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)
end

function validNoteChecker(string)
    if #activeNotes > 0 then
        for k, v in ipairs(activeNotes[1]) do
            if activeNotes[1][k].x < 12 and activeNotes[1][k].string == string and activeNotes[1][k].fret == fretsHeld[1] then
                if not activeNotes[1][k].invalidTiming then
                    activeNotes[1][k].validTiming = true
                end
            elseif activeNotes[1][k].string == string then
                activeNotes[1][k].invalidTiming = true
            end
        end
    end
end

function PlayState:update(dt)
    if luteState then
        --bassNotes1:update(dt)
        songTimer = songTimer - dt

        if songTimer < 0 then
            if #song1 > 0 then
                table.insert(activeNotes, song1[1])
                songTimer = song1[1][1].timer
            end
            table.remove(song1, 1)
        end

        --DEINSTANTIATE NOTES WHEN OFFSCREEN
        if #activeNotes > 0 then
            for key, value in ipairs(activeNotes) do --EVERY CHORD IN THE SONG
                for index, note in ipairs(value) do --EVERY NOTE IN THE CHORD
                    note:update(dt)
                end
                if activeNotes[1][1].x < - 12 then
                    table.remove(activeNotes, 1)
                end
            end
        end
    end

    if love.keyboard.wasPressed('l') then
        if luteState then
            luteState = false
        else
            luteState = true
        end
    end

    if luteState then
        if love.keyboard.wasPressed('1') or love.keyboard.isDown('1') then
            table.insert(fretsHeld, 1)
        end
        if love.keyboard.wasPressed('2') or love.keyboard.isDown('2') then
            table.insert(fretsHeld, 2)
        end
        if love.keyboard.wasPressed('3') or love.keyboard.isDown('3') then
            table.insert(fretsHeld, 3)
        end
        if love.keyboard.wasPressed('4') or love.keyboard.isDown('4') then
            table.insert(fretsHeld, 4)
        end



        if love.keyboard.isDown('u') then
            F1Pressed = true
        else
            F1Pressed = false
        end
        if love.keyboard.isDown('i') then
            A1Pressed = true
        else
            A1Pressed = false
        end
        if love.keyboard.isDown('o') then
            D1Pressed = true
        else
            D1Pressed = false
        end
        if love.keyboard.isDown('p') then
            F2Pressed = true
        else
            F2Pressed = false
        end
    end

    if love.keyboard.wasReleased('1') then
        for k, v in pairs(fretsHeld) do
            if v == 1 then
                table.remove(fretsHeld, k)
            end
        end
    end
    if love.keyboard.wasReleased('2') then
        for k, v in pairs(fretsHeld) do
            if v == 2 then
                table.remove(fretsHeld, k)
            end
        end
    end
    if love.keyboard.wasReleased('3') then
        for k, v in pairs(fretsHeld) do
            if v == 3 then
                table.remove(fretsHeld, k)
            end
        end
    end
    if love.keyboard.wasReleased('4') then
        for k, v in pairs(fretsHeld) do
            if v == 4 then
                table.remove(fretsHeld, k)
            end
        end
    end

    if #fretsHeld > 0 then
        local highest = 0
        for k, v in pairs(fretsHeld) do
            if v > highest then
                highest = v
            end
        end
        fretsHeld = {}
        table.insert(fretsHeld, highest)
    end

    if luteState then
        --STRING 1
        if love.keyboard.wasPressed('u') then
            validNoteChecker(4)
            if #fretsHeld == 0 then
                sounds['F1']:play()
                luteStringF1.animation:refresh()
            elseif fretsHeld[1] == 1 then
                sounds['G1']:play()
                luteStringF1.animation:refresh()
            elseif fretsHeld[1] == 2 then
                sounds['A1']:play()
                luteStringF1.animation:refresh()
            elseif fretsHeld[1] == 3 then
                sounds['Bb1']:play()
                luteStringF1.animation:refresh()
            elseif fretsHeld[1] == 4 then
                sounds['C1']:play()
                luteStringF1.animation:refresh()
            end
        end

        --STRING 2
        if love.keyboard.wasPressed('i') then
            validNoteChecker(3)
            if #fretsHeld == 0 then
                sounds['A1']:play()
                luteStringA1.animation:refresh()
            elseif fretsHeld[1] == 1 then
                sounds['Bb1']:play()
                luteStringA1.animation:refresh()
            elseif fretsHeld[1] == 2 then
                sounds['C1']:play()
                luteStringA1.animation:refresh()
            elseif fretsHeld[1] == 3 then
                sounds['D1']:play()
                luteStringA1.animation:refresh()
            elseif fretsHeld[1] == 4 then
                sounds['E1']:play()
                luteStringA1.animation:refresh()
            end
        end

        --STRING 3
        if love.keyboard.wasPressed('o') then
            validNoteChecker(2)
            if #fretsHeld == 0 then
                sounds['D1']:play()
                luteStringD1.animation:refresh()
            elseif fretsHeld[1] == 1 then
                sounds['E1']:play()
                luteStringD1.animation:refresh()
            elseif fretsHeld[1] == 2 then
                sounds['F2']:play()
                luteStringD1.animation:refresh()
            elseif fretsHeld[1] == 3 then
                sounds['G2']:play()
                luteStringD1.animation:refresh()
            elseif fretsHeld[1] == 4 then
                sounds['A2']:play()
                luteStringD1.animation:refresh()
            end
        end

        --STRING 4
        if love.keyboard.wasPressed('p') then
            validNoteChecker(1)
            if #fretsHeld == 0 then
                sounds['F2']:play()
                luteStringF2.animation:refresh()
            elseif fretsHeld[1] == 1 then
                sounds['G2']:play()
                luteStringF2.animation:refresh()
            elseif fretsHeld[1] == 2 then
                sounds['A2']:play()
                luteStringF2.animation:refresh()
            elseif fretsHeld[1] == 3 then
                sounds['Bb2']:play()
                luteStringF2.animation:refresh()
            elseif fretsHeld[1] == 4 then
                sounds['C2']:play()
                luteStringF2.animation:refresh()
            end
        end
    end
--[[
    for k, v in pairs(activeNotes) do
        if v.x < - 12 then
            v.validTiming = false
        end
    end
    --]]

    luteStringF1:update(dt)
    luteStringD1:update(dt)
    luteStringA1:update(dt)
    luteStringF2:update(dt)

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
            self.focusIndicatorX = math.max(self.focusIndicatorX - self.manisDrain + self.unFocus * dt, 0)
            if self.manis == 0 then
                self.focusIndicatorX = math.max(self.focusIndicatorX - self.manisDrain - self.unFocus * dt, 0)
            end
        else
            self.focusIndicatorX = math.max(self.focusIndicatorX - self.manisDrain - self.unFocus * dt, 0)
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
        --sounds['spellcast']:play()
    else
        successfulCast = false
    end


    cameraX = cameraX + 1

    sceneView:update(dt)

    rotate = rotate + .05

    --LOCK SCREEN POSITION
    love.window.setPosition(400, 85)
end

function PlayState:render()
	love.graphics.clear(BLACK)

    love.graphics.push()
    sceneView:render()
    love.graphics.pop()

    --HUD RENDER
    ---[[
    love.graphics.setColor(142/255, 146/255, 171/255, 255/255)
    love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 16, VIRTUAL_WIDTH, 16)
    love.graphics.setColor(WHITE)
    --]]

    love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
    heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
    love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
    --love.graphics.print('health: ' .. tostring(sceneView.player.health), VIRTUAL_WIDTH - 130, SCREEN_HEIGHT_LIMIT + 4)
    love.graphics.setColor(0,0,0,255)
    love.graphics.print('Tashio Tempo', VIRTUAL_WIDTH - 150, SCREEN_HEIGHT_LIMIT + 4)

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
    if love.keyboard.isDown('5') then
        love.graphics.setColor(DEBUG_BG)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(WHITE)
        love.graphics.setFont(pixelFont)
        love.graphics.print('MAP[' .. tostring(sceneView.currentMap.row) .. '][' .. tostring(sceneView.currentMap.column) .. ']', 5, 15)
        love.graphics.print('player.x: ' .. string.format("%.1f", self.player.x), 5, 25)
        love.graphics.print('player.y: ' .. string.format("%.1f", self.player.y), 5, 35)
        love.graphics.print('direction: ' .. tostring(self.player.direction), 5, 45)
        love.graphics.print('playerLastInput: ' .. tostring(self.player.lastInput), 5, 55)
        love.graphics.print('Cast: ' .. tostring(successfulCast), 5, 65)
        love.graphics.print('animatables: ' .. tostring(sceneView.currentMap.tiles[4][1].id), 5, 75)
        love.graphics.print('INPUT_LIST: ' .. inspect(INPUT_LIST), 5, 85)
        love.graphics.print('player_state: ' .. tostring(PLAYER_STATE), 5, 95)
        love.graphics.print('fallTimer: ' .. tostring(sceneView.player.fallTimer), 5, 105)
        love.graphics.print('falling: ' .. tostring(sceneView.player.falling), 5, 115)
        love.graphics.print('safeFFall: ' .. tostring(sceneView.player.safeFromFall), 85, 115)
    elseif love.keyboard.isDown('6') then
        love.graphics.setColor(DEBUG_BG)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(WHITE)
        --love.graphics.print('pits: ' .. inspect(sceneView.currentMap.pits), 5, 15)
        --love.graphics.print('graveyard: ' .. inspect(sceneView.player.graveyard), 5, 25)
        love.graphics.print('checkpoint: ' .. inspect(self.player.checkPointPositions), 5, 35)
        --love.graphics.print('testNumber' .. inspect(testNumber), 5, 35)
        --love.graphics.print('pits: ' .. tostring(PITS), 5, 25)
        --print('leftCount: ' .. inspect(leftCount), 5, 15)
        --print(inspect(sceneView.player.animations['falling']))

    end

    --love.graphics.print('luteState' .. tostring(luteState), 0, VIRTUAL_HEIGHT - 50)
    love.graphics.setFont(pixelFont)
    if luteState then
        love.graphics.setColor(55/255, 0/255, 255/255, 255/255)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('line', 1, LUTE_STRING_YOFFSET, 11, 47)
        love.graphics.setColor(DEBUG_BG2)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

        if F2Pressed then
            love.graphics.setColor(BLUE)
        else
            love.graphics.setColor(WHITE)
        end
        luteStringF2:render()
        --love.graphics.rectangle('fill', 0, 10, VIRTUAL_WIDTH, STRING_WIDTH)


        if D1Pressed then
            love.graphics.setColor(BLUE)
        else
            love.graphics.setColor(WHITE)
        end
        luteStringD1:render()
        --love.graphics.rectangle('fill', 0, 10 + LUTE_STRING_SPACING, VIRTUAL_WIDTH, STRING_WIDTH)


        if A1Pressed then
            love.graphics.setColor(BLUE)
        else
            love.graphics.setColor(WHITE)
        end
        luteStringA1:render()
        --love.graphics.rectangle('fill', 0, 10 + LUTE_STRING_SPACING * 2, VIRTUAL_WIDTH, STRING_WIDTH)



        if F1Pressed then
            love.graphics.setColor(BLUE)
        else
            love.graphics.setColor(WHITE)
        end
        luteStringF1:render()
        --love.graphics.rectangle('fill', 0, 10 + LUTE_STRING_SPACING * 3, VIRTUAL_WIDTH, STRING_WIDTH)

    end
    --[[
    love.graphics.draw(fretOpen,0,0)
    love.graphics.draw(fret1,0,10)
    love.graphics.draw(fret2,0,20)
    love.graphics.draw(fret3,0,30)
    love.graphics.draw(fret4,0,40)
    --]]



    --BEAT BOX RENDER
    love.graphics.setLineStyle("rough")
    if #fretsHeld > 0 then
        love.graphics.setColor(55/255, 0/255, 255/255, 255/255)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('line', 1, LUTE_STRING_YOFFSET, 11, 47)
    end

    if luteState then
        --FRET GUIDES
        love.graphics.setColor(WHITE)
        if #fretsHeld > 0 then
            if fretsHeld[1] == 1 then
                for i = 0, 3 do
                    love.graphics.draw(fret1,1,LUTE_STRING_YOFFSET + (12 * i))
                end
            end
            if fretsHeld[1] == 2 then
                for i = 0, 3 do
                    love.graphics.draw(fret2,1,LUTE_STRING_YOFFSET + (12 * i))
                end
            end
            if fretsHeld[1] == 3 then
                for i = 0, 3 do
                    love.graphics.draw(fret3,1,LUTE_STRING_YOFFSET + (12 * i))
                end
            end
            if fretsHeld[1] == 4 then
                for i = 0, 3 do
                    love.graphics.draw(fret4,1,LUTE_STRING_YOFFSET + (12 * i))
                end
            end
        end
        love.graphics.print('fretsHeld: ' .. inspect(fretsHeld), 0, 100)
        for k, v in ipairs(activeNotes) do
            for index, note in ipairs(v) do
                note:render()
            end
        end
        print("#activeNotes: " .. tostring(activeNotes))
    end
end
