WarpZone = Class{}

function WarpZone:init(x, y, playerX, playerY, warpRow, warpCol)
    self.x = x
    self.y = y
    self.playerX = playerX
    self.playerY = playerY
    self.width = 10
    self.height = 10
    self.warpRow = warpRow
    self.warpCol = warpCol
    --self.warping = false
end

function WarpZone:collides()
    if self.x < gPlayer.x + gPlayer.width and self.x + self.width > gPlayer.x then
        if self.y < gPlayer.y + gPlayer.height and self.y + self.height > gPlayer.y then
            return true
        end
    end
    return false
end

function WarpZone:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.setColor(GREEN)
    love.graphics.rectangle('fill', self.x + adjacentOffsetX, self.y + adjacentOffsetY, self.width, self.height)
end
