Note = Class{}

function Note:init(string, fret, timer, first)
  self.x = SCREEN_WIDTH_LIMIT
  self.string = string
  self.fret = fret
  self.speed = 28
  self.timer = timer
  self.validTiming = false
  self.invalidTiming = false
  self.checked = false
  self.first = first or nil
end

function Note:update(dt)
  self.x = self.x - self.speed * dt
end

function Note:render()
  if self.validTiming then
    love.graphics.setColor(0,1,0,1)
  elseif self.invalidTiming then
    love.graphics.setColor(1,0,0,1)
  else
    love.graphics.setColor(WHITE)
  end
  if self.fret == 1 then
    love.graphics.draw(fret1, self.x, LUTE_STRING_YOFFSET + self.string * 12 - 12)
  elseif self.fret == 2 then
    love.graphics.draw(fret2, self.x, LUTE_STRING_YOFFSET + self.string * 12 - 12)
  else
    love.graphics.draw(fretOpen, self.x, LUTE_STRING_YOFFSET + self.string * 12 - 12)
  end

  --[[
  if self.validTiming then
    love.graphics.setColor(0,1,0,1)
    love.graphics.rectangle('fill', self.x, 0, 12, 12)
  end
  --]]
end
