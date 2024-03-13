InsertAnimation = Class{}

function InsertAnimation:init(mapRow, mapColumn)
    self.mapRow = mapRow
    self.mapColumn = mapColumn
    self.flowers = AnimSpitter(1012, 1015, 0.75)

    test  = 0
    self.func = {}
    table.insert(self.func, function() funcTest() end)
    table.insert(self.func, function() funcTest() end)
    table.insert(self.func, function() funcTest() end)
    MAP[1][1].animatables = {}
    table.insert(MAP[1][1].animatables, function() insertAnim(2, 3, self.flowers.frame) end)
end

function funcTest()
    test = test + 1
end

function InsertAnimation:update(dt)
    self.flowers:update(dt)
    MAP[1][1].animatables[1]()
    --[[
    self.func[1]()
    self.func[2]()
    self.func[3]()
    --]]

    --[[
    if self.mapRow == 1 and self.mapColumn == 1 then
        insertAnim(2, 3, self.flowers.frame)
        insertAnim(5, 7, self.flowers.frame)
    elseif self.mapRow == 1 and self.mapColumn == 2 then
        insertAnim(3, 3, self.flowers.frame)
        insertAnim(3, 4, self.flowers.frame)
    end
    --]]
end

function insertAnim(row, column, anim)
    sceneView.currentMap.tiles[row][column].id = anim
end

function InsertAnimation:render()
    love.graphics.setColor(WHITE)
    love.graphics.print('TEST: ' .. tostring(test), 5, 5)
    love.graphics.print('TEST: ' .. tostring(self.flowers.frame), 5, 15)
end
