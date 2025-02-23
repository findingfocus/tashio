Pit = Class{}

function Pit:init(sceneRow, sceneCol)
  self.x = sceneCol * 16 - 16
  self.y = sceneRow * 16 - 16
  self.width = TILE_SIZE
  self.height = TILE_SIZE
end

function Pit:collide(player)
  if player.x + SIDE_EDGE_BUFFER_PLAYER < self.x + self.width and player.x + player.width - SIDE_EDGE_BUFFER_PLAYER > self.x and player.y + SIDE_EDGE_BUFFER_PLAYER < self.y + self.height and player.y + player.height - SIDE_EDGE_BUFFER_PLAYER > self.y then
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
