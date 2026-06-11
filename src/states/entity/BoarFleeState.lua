BoarFleeState = Class{__includes = BaseState}

function BoarFleeState:init(entity, scene)
  self.entity = entity
  self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['geckoC'].animations)
  --self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['geckoC'].animations)
  self.stateName = 'flee'
  self.direction = ''
  self.entity:changeAnimation('walk-right')
  self.alpha = 255
end

function BoarFleeState:processAI()

end

function BoarFleeState:update(dt)
  self.alpha = (self.alpha - dt * 150)
  if self.entity.type == 'boar' then
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
end

function BoarFleeState:render()
  local anim = self.entity.currentAnimation
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
  self.entity.x, self.entity.y)
end
