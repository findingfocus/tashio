Map = Class{}

function Map:init(row, column)
    self.tiles = {}
    self.row = row
    self.column = column
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
    self.renderOffsetY = MAP_RENDER_OFFSET_Y
    self.insertAnimations = InsertAnimation(self.row, self.column)
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

    self.collidableMapObjects = {}

    for i = 1, MAP_HEIGHT do
        for j = 1, MAP_WIDTH do
            --local tile = self.tiles[i][j]
            --table.insert(self.collidableMapObjects, CollidableMapObjects(1, 1))
            ---[[
            local tile = self.tiles[i][j]
            if tile.id >= 97 and tile.id <= 224 then
                table.insert(self.collidableMapObjects, CollidableMapObjects(i, j))
            end
            --]]
        end
    end
end

function Map:update(dt)
    self.insertAnimations:update(dt)
end

function Map:render()
    --RENDER DEFAULT TILES FIRST
    for y = 1, MAP_HEIGHT do
        for x = 1, MAP_WIDTH do
            local tile = self.tiles[y][x]
            love.graphics.draw(tileSheet, quads[SAND], (x - 1) * TILE_SIZE + self.adjacentOffsetX, (y - 1) * TILE_SIZE + self.adjacentOffsetY)
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
