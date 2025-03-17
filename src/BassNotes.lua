BassNotes = Class{}

function BassNotes:init(notes)
  self.notes = notes
  self.timingOffset = 0
  self.timer = 0
  self.currentNote = 1
  self.totalNotes = 4
end

function BassNotes:update(dt)
  self.timingOffset = self.timingOffset + dt
  if self.timingOffset > 3.6 then
    self.timer = self.timer + dt
  end
  if self.timer > 2 then
    sounds[self.notes[self.currentNote]]:play()
    if self.currentNote == 4 then
      self.currentNote = 1
    else
      self.currentNote = self.currentNote + 1
    end
    self.timer = 0
  end
end
