Pit = Class{}

function Pit:init(sceneRow, sceneCol)
    self.x = sceneCol * 16 - 16
    self.y = sceneRow * 16 - 16
    self.width = TILE_SIZE
    self.height = TILE_SIZE
    self.collide = false
end

function Pit:update(dt)
        if sceneView.player.x < self.x + self.width and sceneView.player.x + sceneView.player.width > self.x and sceneView.player.y < self.y + self.height and sceneView.player.y + sceneView.player.height > self.y then
            self.collide = true
        else
            self.collide = false
        end

        --[[
        if self.collide then
            sceneView.player.x = sceneView.player.x + 10
        end
        --]]
end

function Pit:render()
    if self.collide then
        love.graphics.setColor(255, 0, 0, 255)
        --love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end
end
