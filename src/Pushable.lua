Pushable = Class{}

function Pushable:init(x, y, type)
    self.x = (x * TILE_SIZE) - TILE_SIZE
    self.y = (y * TILE_SIZE) - TILE_SIZE
    self.width = TILE_SIZE
    self.height = TILE_SIZE
    self.type = type
    if self.type == 'log' then
        self.image = log
    elseif self.type == 'boulder' then
        self.image = boulder
    end
end

function Pushable:update()

end

function Pushable:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.setColor(WHITE)
    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    love.graphics.draw(self.image, self.x, self.y)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end
