InsertAnimation = Class{}

function InsertAnimation:init(mapRow, mapColumn)
    self.mapRow = mapRow
    self.mapColumn = mapColumn
end

function InsertAnimation:update(dt)
    FLOWERS:update(dt)
    AUTUMN_FLOWERS:update(dt)
    WATER:update(dt)

    for i = 1, #MAP[self.mapRow][self.mapColumn].animatables do
        MAP[self.mapRow][self.mapColumn].animatables[i]()
    end
end

function insertAnim(row, column, anim)
    sceneView.currentMap.tiles[row][column].id = anim
end

function InsertAnimation:render()

end
