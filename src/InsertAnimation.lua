InsertAnimation = Class{}

function InsertAnimation:init(mapRow, mapColumn)
    self.mapRow = mapRow
    self.mapColumn = mapColumn
    self.flowers = AnimSpitter(1012, 1015, 0.75)

    table.insert(MAP[1][1].animatables, function() insertAnim(2, 3, self.flowers.frame) end)
    table.insert(MAP[1][1].animatables, function() insertAnim(5, 7, self.flowers.frame) end)

    table.insert(MAP[1][2].animatables, function() insertAnim(3, 3, self.flowers.frame) end)
    table.insert(MAP[1][2].animatables, function() insertAnim(3, 4, self.flowers.frame) end)

    table.insert(MAP[2][1].animatables, function() insertAnim(2, 2, self.flowers.frame) end)
end

function InsertAnimation:update(dt)
    self.flowers:update(dt)

    for i = 1, #MAP[self.mapRow][self.mapColumn].animatables do
        MAP[self.mapRow][self.mapColumn].animatables[i]()
    end
end

function insertAnim(row, column, anim)
    sceneView.currentMap.tiles[row][column].id = anim
end

function InsertAnimation:render()

end
