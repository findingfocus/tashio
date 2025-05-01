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
local correctCount = 0
local incorrectCount = 0

--[[
Music = {}
Music['Bb'] -->

Music[1] = {4, 0}
Music[2] = {4, 1}
Music[3] = {4, 2}


Note(Music[1][1], Music[1][2], 2)


--]]
--
--[[
function Music(noteNumber, timeToNextNote)
  local note = Music[noteNumber] = {4, 0}
  return Note(note, timeToNextNote)
end
--]]


--[[
insertNote(number, timeToNextNote)
sounds['1-G2']
--]]

--song1 = {{Note(4,3,.5), Note(2,3,.25), Note(3,3,.25)}, {Note(3,4,.25)}, {Note(2,2,1)}, {Note(3,4,1), Note(4,4,1)}, {Note(2,2,1)}}
--song1 = {{Note(3,1,1)}, {Note(2,0,0.5)}, {Note(2,2,1)}, {Note(3,0,2)}, {Note(3,2,0.5)}, {Note(2,2,1)}, {Note(2,2,2)}, {Note(2,1,0.5)}, {Note(2,2,2)}}
--song1 = {{Note(1,1,2)}, {Note(2,2,2)}, {Note(3,1,2)}, {Note(4,1,2)}}
song1 = {{Note(4,0,2)}, {Note(4,0,2)}}
originalSong = {{Note(4,0,2)}, {Note(4,0,2)}}
for i, v in pairs(song1) do
  originalSong[i] = {v[1]}
end

bassNotes1 = BassNotes({'5-D3', '4-C3', '3-Bb2', '2-A2'})
local activeNotes = {}
local songTimer = 0
local bpm = 30
local seconds_per_beat = 60 / bpm 
local nextNoteTime = 0

function Lute:init()
  self.tomeEquipped = ''
end

function Lute:reset()
  activeNotes = {}
  songTimer = 0
  nextNoteTime = 0
  --TOME EQUIPPED

  if gKeyItemInventory.tomeEquipped ~= 'tome1' then
    song1 = {}
  else
    song1 = {{Note(4,0,2)}, {Note(4,0,2)}}
  end
  --TODO DEEP COPY
  correctCount = 0
  incorrectCount = 0
end

function validNoteChecker(string)
  if #activeNotes > 0 then
    for k, v in ipairs(activeNotes[1]) do
      --CORRECT NOTE
      if activeNotes[1][k].x < 12 and activeNotes[1][k].string == string and activeNotes[1][k].fret == fretsHeld[1] then
        if not activeNotes[1][k].invalidTiming then
          if not activeNotes[1][k].checked then
            correctCount = correctCount + 1
            activeNotes[1][k].checked = true
          end
          activeNotes[1][k].validTiming = true
        end
        --OPEN STRING CHECK
      elseif activeNotes[1][k].x < 12 and fretsHeld[1] == nil then
        if not activeNotes[1][k].checked then
          correctCount = correctCount + 1
          activeNotes[1][k].checked = true
        end
        activeNotes[1][k].validTiming = true
        --MISSED NOTE
      elseif activeNotes[1][k].string == string then
        if not activeNotes[1][k].checked then
          incorrectCount = incorrectCount + 1
          activeNotes[1][k].checked = true
        end
        activeNotes[1][k].invalidTiming = true
      end
    end
  end
end

function Lute:update(dt)
  --bassNotes1:update(dt)
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

  songTimer = songTimer + dt

  if songTimer > nextNoteTime then
    --sounds['1-G2']:play()
    if #song1 > 0 then
      table.insert(activeNotes, song1[1])
      nextNoteTime = song1[1][1].timer
      table.remove(song1, 1)
    else
      nextNoteTime = math.huge
    end
    songTimer = 0
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
  if INPUT:pressed('actionB') or INPUT:down('actionB') then
    table.insert(fretsHeld, 1)
  end

  if INPUT:pressed('action') or INPUT:down('action') then
    table.insert(fretsHeld, 2)
  end

  --KEYBOARD FRETS REMOVED
  if INPUT:released('actionB') then
    for k, v in pairs(fretsHeld) do
      if v == 1 then
        table.remove(fretsHeld, k)
      end
    end
  end

  if INPUT:released('action') then
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
  if highest ~= 0 then
    table.insert(fretsHeld, highest)
  end

  --STRING 1
  if INPUT:pressed('right') then
    validNoteChecker(4)
    if #fretsHeld == 0 then
      sounds['1-G2']:play()
      luteStringF1.animation:refresh()
    elseif fretsHeld[1] == 1 then
      sounds['2-A2']:play()
      luteStringF1.animation:refresh()
    elseif fretsHeld[1] == 2 then
      sounds['3-Bb2']:play()
      luteStringF1.animation:refresh()
    end
  end

  --STRING 2
  if INPUT:pressed('down') then
    validNoteChecker(3)
    if #fretsHeld == 0 then
      sounds['4-C3']:play()
      luteStringA1.animation:refresh()
    elseif fretsHeld[1] == 1 then
      sounds['5-D3']:play()
      luteStringA1.animation:refresh()
    elseif fretsHeld[1] == 2 then
      sounds['6-E3']:play()
      luteStringA1.animation:refresh()
    end
  end

  --STRING 3
  if INPUT:pressed('left') then
    validNoteChecker(2)
    if #fretsHeld == 0 then
      sounds['7-F3']:play()
      luteStringD1.animation:refresh()
    elseif fretsHeld[1] == 1 then
      sounds['8-G3']:play()
      luteStringD1.animation:refresh()
    elseif fretsHeld[1] == 2 then
      sounds['9-A3']:play()
      luteStringD1.animation:refresh()
    end
  end

  --STRING 4
  if INPUT:pressed('up') then
    validNoteChecker(1)
    if #fretsHeld == 0 then
      sounds['10-Bb3']:play()
      luteStringF2.animation:refresh()
    elseif fretsHeld[1] == 1 then
      sounds['11-C4']:play()
      luteStringF2.animation:refresh()
    elseif fretsHeld[1] == 2 then
      sounds['12-D4']:play()
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
  else
      for i = 0, 3 do
        love.graphics.draw(fretOpen,1,LUTE_STRING_YOFFSET + (12 * i))
      end
  end

  --BEAT BOX RENDER
  love.graphics.setLineStyle("rough")
  love.graphics.setColor(55/255, 0/255, 255/255, 255/255)
  love.graphics.setLineWidth(1)
  love.graphics.rectangle('line', 1, LUTE_STRING_YOFFSET, 11, 47)
  love.graphics.setColor(WHITE)
  --love.graphics.print('fretsHeld: ' .. Inspect(fretsHeld), 0, 100)
  love.graphics.print('correct: ' .. tostring(correctCount), 5, VIRTUAL_HEIGHT - 70)
  love.graphics.print('incorrect: ' .. tostring(incorrectCount), 5, VIRTUAL_HEIGHT - 60)

  for k, v in ipairs(activeNotes) do
    for index, note in ipairs(v) do
      note:render()
    end
  end
end
