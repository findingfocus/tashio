BatFleeState = Class{__includes = tate}

function BatFleeState:init(entity)
    self.entity = entity
    self.entity.dx = 4
    self.entity.dy = -4
end

function BatFleeState:update(dt)
    self.entity.x = self.entity.x + self.entity.dx * dt
    self.entity.y = self.entity.y + self.entity.dy * dt
end

function BatFleeState:render()
    love.graphics.setColor(WHITE)
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.entity.x, self.entity.y)
    self.entity.y = self.entity.y - self.entity.displacementY
    self.entity.x = self.entity.x - self.entity.displacementX
end
