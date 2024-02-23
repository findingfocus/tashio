Map = Class{}

function Map:init(row, column)
    self.tiles = {}
    self.row = row
    self.column = column
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
    self.renderOffsetY = MAP_RENDER_OFFSET_Y
    -- animationValues[row][column].
    count = 1
    for y = 1, MAP_HEIGHT do
        table.insert(self.tiles, {})
        for x = 1, MAP_WIDTH do
            table.insert(self.tiles[y], {
                id = MAP[row][column][count]
            })
            count = count + 1
        end
    end
    self.flowers = AnimSpitter(1012, 1015, 0.75)
end

function Map:update(dt)
    self.flowers:update(dt)
    --if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end
    self.tiles[2][2].id = self.flowers.frame
    self.tiles[5][5].id = self.flowers.frame
end

function Map:render()
    --RENDER DEFAULT TILES FIRST
    for y = 1, MAP_HEIGHT do
        for x = 1, MAP_WIDTH do
            local tile = self.tiles[y][x]
            love.graphics.draw(sand, (x - 1) * TILE_SIZE + self.adjacentOffsetX, (y - 1) * TILE_SIZE + self.adjacentOffsetY)
        end
    end
    --TILE
    for y = 1, MAP_HEIGHT do
        for x = 1, MAP_WIDTH do
            local tile = self.tiles[y][x]
            love.graphics.draw(tileSheet, quads[tile.id], (x - 1) * TILE_SIZE + self.adjacentOffsetX, (y - 1) * TILE_SIZE + self.adjacentOffsetY)
        end
    end
end
