InsertAnimation = Class{}

function InsertAnimation:init(mapRow, mapColumn)
    self.mapRow = mapRow
    self.mapColumn = mapColumn
end

function InsertAnimation:update(dt)
    FLOWERS:update(dt)
    AUTUMN_FLOWERS:update(dt)
    WATER:update(dt)
    LAVA_LEFT_EDGE:update(dt)
    LAVA_RIGHT_EDGE:update(dt)
    LAVA_FLOW:update(dt)

    for i = 1, #MAP[self.mapRow][self.mapColumn].animatables do
        if self.mapRow == 8 then
            --self.mapRow = 7
        end
        MAP[self.mapRow][self.mapColumn].animatables[i]()
    end
end

function insertAnim(row, column, anim)
    sceneView.currentMap.tiles[row][column].id = anim
end

function InsertAnimation:render()

end
