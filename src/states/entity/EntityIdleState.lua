EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
  self.entity = entity
  self.stateName = 'idle'
  self.waitDuration = 0
  self.waitTimer = 0
end

function EntityIdleState:processAI(params, dt, player)
  if self.waitDuration == 0 then
    self.waitDuration = math.random(5)
  else
    self.waitTimer = self.waitTimer + dt

    if self.waitTimer > self.waitDuration then
      self.entity:changeState(tostring(self.entity.type) .. '-walk')
    end
  end
end

function EntityIdleState:render()
  local anim = self.entity.currentAnimation
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
  math.floor(self.entity.x), math.floor(self.entity.y))
end
