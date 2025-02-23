LuteString = Class{}

function LuteString:init(stringNumber)
  self.animation = Animation {
    texture = 'luteString',
    frames = {1, 2, 3, 4, 5, 6, 7},
    interval = .08,
    looping = false
  }
  self.stringNumber = stringNumber
  self.animation.currentFrame = 7
  self.animation.timesPlayed = 1
end

function LuteString:update(dt)
  self.animation:update(dt)
end

function LuteString:render()
  local anim = self.animation
  if anim:getCurrentFrame() == 7 then
    love.graphics.setColor(WHITE)
  else
    love.graphics.setColor(CYAN)
  end
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], 0, self.stringNumber * LUTE_STRING_SPACING - LUTE_STRING_SPACING + LUTE_STRING_YOFFSET)
end
