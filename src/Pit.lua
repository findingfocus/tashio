Pit = Class{}

function Pit:init(sceneRow, sceneCol)
    self.x = sceneCol * 16 - 16
    self.y = sceneRow * 16 - 16
    self.width = TILE_SIZE
    self.height = TILE_SIZE
end

function Pit:collide(player)
    if player.x < self.x + self.width and player.x + player.width > self.x and player.y < self.y + self.height and player.y + player.height > self.y then
        return true
    else
        return false
    end
end

function Pit:update(dt)

end

function Pit:render()
    love.graphics.setColor(255,0,0,255)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
