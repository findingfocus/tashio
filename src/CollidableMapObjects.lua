CollidableMapObjects = Class{}

function CollidableMapObjects:init(row, column)
    self.x = TILE_SIZE * column - TILE_SIZE
    self.y = TILE_SIZE * row - TILE_SIZE
    self.width = TILE_SIZE
    self.height = TILE_SIZE
end
