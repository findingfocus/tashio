Spitball = Class{}

function Spitball:init(entity)
    self.entity = entity
    self.x = math.floor(entity.x + entity.displacementX + 0.5) + 12
    self.y = math.floor(entity.y + entity.displacementY + 0.5) + 4
    self.lifespan = 0.1
    self.remove = false
end

function Spitball:update(dt)
    Timer.tween(0.1, {
        [self] = {x = sceneView.player.x + 8, y = sceneView.player.y + 6},
    })
    self.lifespan = self.lifespan - dt
    if self.lifespan < 0 then
        self.remove = true
    end
end

function Spitball:render()
    love.graphics.setColor(WHITE)
    love.graphics.circle('fill', self.x, self.y, 2)
end
