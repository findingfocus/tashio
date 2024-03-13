InsertAnimation = Class{}

function InsertAnimation:init(mapRow, mapColumn)
    self.mapRow = mapRow
    self.mapColumn = mapColumn
    self.flowers = AnimSpitter(1012, 1015, 0.75)
    --self.animatables = {}

    --[[
    self.func = {}
    table.insert(self.func, function() funcTest() end)
    table.insert(self.func, function() funcTest() end)
    table.insert(self.func, function() funcTest() end)
    --]]
    --MAP[1][1].animatables = {}
    --MAP[2][1].animatables = {}
    table.insert(MAP[1][1].animatables, function() insertAnim(2, 3, self.flowers.frame) end)
    table.insert(MAP[1][1].animatables, function() insertAnim(5, 7, self.flowers.frame) end)

    table.insert(MAP[1][2].animatables, function() insertAnim(3, 3, self.flowers.frame) end)
    table.insert(MAP[1][2].animatables, function() insertAnim(3, 4, self.flowers.frame) end)

    table.insert(MAP[2][1].animatables, function() insertAnim(2, 2, self.flowers.frame) end)


    --[[
    for i = 1, #MAP[self.mapRow][self.mapColumn].animatables do
        table.insert(self.animatables, MAP[self.mapRow][self.mapColumn].animatables[i])
    end
    --]]
end

function InsertAnimation:update(dt)
    self.flowers:update(dt)

    for i = 1, #MAP[self.mapRow][self.mapColumn].animatables do
        MAP[self.mapRow][self.mapColumn].animatables[i]()
    end
    
    --MAP[1][1].animatables[1]()
    --MAP[1][1].animatables[2]()
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

--[[
function insertAnimatable(mapRow, mapColumn, gridRow, gridColumn, anim)
    tile = gridRow * gridColumn
    MAP[mapRow][mapColumn][tile].id = anim
end
--]]

---[[
function insertAnim(row, column, anim)
    sceneView.currentMap.tiles[row][column].id = anim
end
--]]
--[[
function insertAnim(mapRow, mapColumn, gridRow, gridColumn, anim)
    local tile = gridRow * gridColumn
    MAP[mapRow][mapColumn][tile].id = 1
end
--]]

function InsertAnimation:render()
    love.graphics.setColor(WHITE)
    --love.graphics.print('TEST: ' .. tostring(self.flowers.frame), 5, 5)
end
