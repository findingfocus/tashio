InsertAnimation = Class{}

function InsertAnimation:init(mapRow, mapColumn)
    self.mapRow = mapRow
    self.mapColumn = mapColumn
    self.flowers = AnimSpitter(1012, 1015, 0.75)
    self.water = AnimSpitter(102, 105, .25)

    table.insert(MAP[1][1].animatables, function() insertAnim(2, 3, self.flowers.frame) end)
    table.insert(MAP[1][1].animatables, function() insertAnim(5, 7, self.flowers.frame) end)

    table.insert(MAP[1][2].animatables, function() insertAnim(3, 2, self.flowers.frame) end)
    table.insert(MAP[1][2].animatables, function() insertAnim(6, 5, self.flowers.frame) end)
    table.insert(MAP[1][2].animatables, function() insertAnim(4, 9, self.flowers.frame) end)

    table.insert(MAP[2][1].animatables, function() insertAnim(2, 2, self.flowers.frame) end)
    table.insert(MAP[7][2].animatables, function() insertAnim(4, 1, self.water.frame) end)
    table.insert(MAP[7][2].animatables, function() insertAnim(4, 2, self.water.frame) end)
    table.insert(MAP[7][2].animatables, function() insertAnim(5, 1, self.water.frame) end)
    table.insert(MAP[7][2].animatables, function() insertAnim(5, 2, self.water.frame) end)
end

function InsertAnimation:update(dt)
    self.flowers:update(dt)
    self.water:update(dt)

    for i = 1, #MAP[self.mapRow][self.mapColumn].animatables do
        MAP[self.mapRow][self.mapColumn].animatables[i]()
    end
end

function insertAnim(row, column, anim)
    sceneView.currentMap.tiles[row][column].id = anim
end

function InsertAnimation:render()

end
