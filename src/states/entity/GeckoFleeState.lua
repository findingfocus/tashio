GeckoFleeState = Class{__includes = BaseState}

function GeckoFleeState:init(entity, scene)
  self.entity = entity
  self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['gecko'].animations)
  self.stateName = 'flee'
  self.direction = ''
  self.entity:changeAnimation('walk-right')
  self.alpha = 255
end

function GeckoFleeState:processAI()

end

function GeckoFleeState:update(dt)
  self.alpha = (self.alpha - dt * 150)
  if self.entity.type == 'gecko' then
    self.entity.dx = 0
    self.entity.dy = 0
    self.entity.walkSpeed = math.min(self.entity.walkSpeed, 20)
    if self.entity.direction == 'down' then
      self.entity.y = self.entity.y + self.entity.walkSpeed * dt * 2.5
      self.entity:changeAnimation('walk-down')
    elseif self.entity.direction == 'up' then
      self.entity.y = self.entity.y - self.entity.walkSpeed * dt * 2.5
      self.entity:changeAnimation('walk-up')
    elseif self.entity.direction == 'left' then
      self.entity.x = self.entity.x - self.entity.walkSpeed * dt * 2.5
      self.entity:changeAnimation('walk-left')
    elseif self.entity.direction == 'right' then
      self.entity.x = self.entity.x + self.entity.walkSpeed * dt * 2.5
      self.entity:changeAnimation('walk-right')
    end
  end
  --[[
  if self.entity.type == 'gecko' then
    if self.entity.direction == 'down' then
      self.entity.dy = self.entity.walkSpeed * 2
      self.entity.dx = 0
      self.entity:changeAnimation('walk-down')
    elseif self.entity.direction == 'up' then
      self.entity.dy = -self.entity.walkSpeed * 2
      self.entity.dx = 0
      self.entity:changeAnimation('walk-up')
    elseif self.entity.direction == 'left' then
      self.entity.dx = -self.entity.walkSpeed * 2
      self.entity.dy = 0
      self.entity:changeAnimation('walk-left')
    elseif self.entity.direction == 'right' then
      self.entity.dx = self.entity.walkSpeed * 2
      self.entity.dy = 0
      self.entity:changeAnimation('walk-right')
    end
  end
  --]]
end

function GeckoFleeState:render()
  love.graphics.setColor(1,1,1,self.alpha/255)
  local anim = self.entity.currentAnimation
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
  self.entity.x, self.entity.y)
end
