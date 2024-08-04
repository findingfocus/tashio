Note = Class{}

function Note:init(string, fret, timer)
    self.x = SCREEN_WIDTH_LIMIT
    self.string = string
    self.fret = fret
    self.speed = 35
    self.timer = timer
    self.validTiming = false
    self.invalidTiming = false
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
        love.graphics.draw(fret1, self.x, LUTE_STRING_YOFFSET)
    elseif self.fret == 2 then
        love.graphics.draw(fret2, self.x, LUTE_STRING_YOFFSET + self.string * 12 - 12)
    elseif self.fret == 3 then
        love.graphics.draw(fret3, self.x, LUTE_STRING_YOFFSET + self.string * 12 - 12)
    elseif self.fret == 4 then
        love.graphics.draw(fret4, self.x, LUTE_STRING_YOFFSET + self.string * 12 - 12)
    elseif self.fret == 5 then
        love.graphics.draw(fretOpen, self.x, LUTE_STRING_YOFFSET + self.string * 12 - 12)
    end

    --[[
    if self.validTiming then
        love.graphics.setColor(0,1,0,1)
        love.graphics.rectangle('fill', self.x, 0, 12, 12)
    end
    --]]
end
