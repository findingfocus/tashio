Lute = Class{}

local luteStringF2 = LuteString(1)
local luteStringD1 = LuteString(2)
local luteStringA1 = LuteString(3)
local luteStringF1 = LuteString(4)
local validTiming = false
local F1Pressed = false
local D1Pressed = false
local A1Pressed = false
local F2Pressed = false
local fretsHeld = {}
local song1 = {}
song1 = {{Note(4,3,2), Note(2,3,1), Note(3,3,1)}, {Note(3,4,1)}, {Note(2,2,1)}, {Note(3,4,1), Note(4,4,1)}, {Note(2,2,1)}}
bassNotes1 = BassNotes({'Bb1', 'A1', 'G1', 'F1'})
local activeNotes = {}
local songTimer = 1

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

function Lute:update(dt)
    for k, v in pairs(touches) do
        --STRING 1 RIGHT
        if dpad[5]:collides(touches[k]) and touches[k].wasTouched then
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
            end
        end

        --STRINGS DOWN
        if dpad[7]:collides(touches[k]) and touches[k].wasTouched then
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
            end
        end

        --STRING 2 DOWNRIGHT
        if dpad[8]:collides(touches[k]) and touches[k].wasTouched then
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
            end
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
            end
        end


        --STRING 3 LEFT
        if dpad[4]:collides(touches[k]) and touches[k].wasTouched then
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
            end
        end

        --STRING DOWNLEFT
        if dpad[6]:collides(touches[k]) and touches[k].wasTouched then
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
            end
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
            end
        end

        --STRING 4 UP
        if dpad[2]:collides(touches[k]) and touches[k].wasTouched then
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
            end
        end

        --STRING UPLEFT
        if dpad[1]:collides(touches[k]) and touches[k].wasTouched then
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
            end
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
            end
        end

        --STRING UPRIGHT
        if dpad[3]:collides(touches[k]) and touches[k].wasTouched then
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
            end

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
            end
        end
    end

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

    --FLUSH FRETS HELD
    fretsHeld = {}
    --KEYBOARD FRETS HELD
    if love.keyboard.wasPressed('o') or love.keyboard.isDown('o') then
        table.insert(fretsHeld, 1)
    end
    if love.keyboard.wasPressed('p') or love.keyboard.isDown('p') then
        table.insert(fretsHeld, 2)
    end

    --KEYBOARD FRETS REMOVED
    if love.keyboard.wasReleased('o') then
        for k, v in pairs(fretsHeld) do
            if v == 1 then
                table.remove(fretsHeld, k)
            end
        end
    end

    if love.keyboard.wasReleased('p') then
        for k, v in pairs(fretsHeld) do
            if v == 2 then
                table.remove(fretsHeld, k)
            end
        end
    end

    --TODO TOUCHES FRETS HELD
    for k, v in pairs(touches) do
        if buttons[2]:collides(touches[k]) then
            local fret1Count = 0
            for k, v in ipairs(fretsHeld) do
                if v == 1 then
                    fret1Count = fret1Count + 1
                end
            end
            if fret1Count == 0 then
                table.insert(fretsHeld, 1)
            end
        end
        if buttons[1]:collides(touches[k]) then
            local fret2Count = 0
            for k, v in ipairs(fretsHeld) do
                if v == 2 then
                    fret2Count = fret2Count + 1
                end
            end
            if fret2Count == 0 then
                table.insert(fretsHeld, 2)
            end
        end
    end

    local highest = 0
    for k, v in ipairs(fretsHeld) do
        if v > highest then
            highest = v
        end
    end
    fretsHeld = {}
    table.insert(fretsHeld, highest)

    --STRING 1
    if love.keyboard.wasPressed('d') then
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
        end
    end

    --STRING 2
    if love.keyboard.wasPressed('s') then
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
        end
    end

    --STRING 3
    if love.keyboard.wasPressed('a') then
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
        end
    end

    --STRING 4
    if love.keyboard.wasPressed('w') then
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
        end
    end

    luteStringF1:update(dt)
    luteStringD1:update(dt)
    luteStringA1:update(dt)
    luteStringF2:update(dt)
end

function Lute:render()
    love.graphics.setColor(55/255, 0/255, 255/255, 255/255)
    love.graphics.setLineWidth(1)
    --love.graphics.rectangle('line', 1, LUTE_STRING_YOFFSET, 11, 47)
    love.graphics.setColor(DEBUG_BG2)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(55/255, 0/255, 255/255, 255/255)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', 1, LUTE_STRING_YOFFSET, 11, 47)
    love.graphics.setColor(DEBUG_BG2)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    luteStringF2:render()
    luteStringD1:render()
    luteStringA1:render()
    luteStringF1:render()

    --BEAT BOX RENDER
    love.graphics.setLineStyle("rough")
    if #fretsHeld > 0 then
        love.graphics.setColor(55/255, 0/255, 255/255, 255/255)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('line', 1, LUTE_STRING_YOFFSET, 11, 47)
    end
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
    love.graphics.print('fretsHeld: ' .. Inspect(fretsHeld), 0, 100)
    for k, v in ipairs(activeNotes) do
        for index, note in ipairs(v) do
            note:render()
        end
    end
end
