AnimSpitter = Class{}

function AnimSpitter:init(startingQuad, endingQuad, timerThreshold)
  self.startingQuad = startingQuad
  self.endingQuad = endingQuad
  self.timerThreshold = timerThreshold
  self.frame = startingQuad
  self.timer = 0
end

function AnimSpitter:update(dt)
  self.timer = self.timer + dt
  if self.timer > self.timerThreshold then
    self.timer = 0
    if self.frame == self.endingQuad then
      self.frame = self.startingQuad
    else
      self.frame = self.frame + 1
    end
  end
end
