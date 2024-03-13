InsertAnimation = Class{}

function InsertAnimation:init(mapRow, mapColumn)
    self.mapRow = mapRow
    self.mapColumn = mapColumn
    self.flowers = AnimSpitter(1012, 1015, 0.75)

    for i = 1, 80 do
        if MAP[self.mapRow][self.mapColumn][i] == FLOWER then
            MAP[self.mapRow][self.mapColumn][i] = self.flower.frame
        end
    end
    --]]

end

function InsertAnimation:update(dt)
    self.flowers:update(dt)

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
