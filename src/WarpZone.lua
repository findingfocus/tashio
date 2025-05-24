WarpZone = Class{}

function WarpZone:init(x, y, playerX, playerY, warpRow, warpCol, disjoint, stateChange, option, dungeon)
  self.x = x
  self.y = y
  self.option = option or nil
  self.playerX = playerX
  self.playerY = playerY
  self.width = 10
  self.height = 10
  self.warpRow = warpRow
  self.warpCol = warpCol
  self.disjoint = disjoint or false
  self.stateChange = stateChange or nil
  self.color = GREEN
  self.dungeon = dungeon or false
end

function WarpZone:collides()
  if self.x < gPlayer.x + gPlayer.width and self.x + self.width > gPlayer.x then
    if self.y < gPlayer.y + gPlayer.height and self.y + self.height > gPlayer.y then
      if not sceneView.shifting then
        return true
      end
    end
  end
  return false
end

function WarpZone:render(adjacentOffsetX, adjacentOffsetY)
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x + adjacentOffsetX, self.y + adjacentOffsetY, self.width, self.height)
end
