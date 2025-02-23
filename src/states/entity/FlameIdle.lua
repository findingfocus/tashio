FlameIdle = Class{__includes = BaseState}

function FlameIdle:init(entity, scene)
  self.entity = entity
  self.scene = scene
  self.entity:changeAnimation('flame')
end

function FlameIdle:update(dt)
  --[[
  TIME = TIME + dt
  local step = math.pi * 2 / self.count
  for i = 1, #sceneView.spellcastEntities do
    self.entity.x = self.scene.player.x + math.cos(TIME + i * step * SPEED) * AMP
    self.entity.y = self.scene.player.y + math.sin(TIME + i * step * SPEED) * AMP
  end
  --]]
end

function FlameIdle:render()
  local anim = self.entity.currentAnimation
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
  math.floor(self.entity.x), math.floor(self.entity.y))
end
