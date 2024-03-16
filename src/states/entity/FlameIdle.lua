FlameIdle = Class{__includes = BaseState}

function FlameIdle:init(entity, scene)
    self.entity = entity
    self.scene = scene
    self.entity:changeAnimation('flame')
    ---[[
    local time = 0
    flameCount = 3
    --]]
    self.circleY = 0
    self.circleX = 0
end

function FlameIdle:update(dt)
    ---[[
    time = time + dt

    local step = math.pi * 2 / flameCount
    for i = 0, flameCount - 1 do
        self.circleX =  math.cos(time * 3 + i * step) * 20
        self.circleY = math.sin(time * 3 + i * step) * 20
    end
    self.entity.x = self.scene.player.x + self.circleX
    self.entity.y = self.scene.player.y + self.circleY
    --]]
end

function FlameIdle:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))
end
