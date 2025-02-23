BassNotes = Class{}

function BassNotes:init(notes)
  self.notes = notes
  self.timingOffset = 0
  self.timer = 0
  self.currentNote = 4
  self.totalNotes = 4
end

function BassNotes:update(dt)
  self.timingOffset = self.timingOffset + dt
  if self.timingOffset > 4.5 then
    self.timer = self.timer + dt
  end
  if self.timer > 1.5 then
    if self.currentNote == 4 then
      self.currentNote = 1
    else
      self.currentNote = self.currentNote + 1
    end
    sounds[self.notes[self.currentNote]]:play()
    self.timer = 0
  end
end
