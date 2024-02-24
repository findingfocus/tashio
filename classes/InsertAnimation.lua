InsertAnimation = Class{}

function InsertAnimation:init(mapRow, mapColumn)
    self.mapRow = mapRow
    self.mapColumn = mapColumn
    self.flowers = AnimSpitter(1012, 1015, 0.75)
end

function InsertAnimation:update(dt)
    self.flowers:update(dt)
    if self.mapRow == 1 and self.mapColumn == 1 then
        insertAnim(1, 1, self.flowers.frame)
        insertAnim(5, 5, self.flowers.frame)
    elseif self.mapRow == 1 and self.mapColumn == 2 then
        insertAnim(6, 1, self.flowers.frame)
        insertAnim(2, 4, self.flowers.frame)
    end
end

function insertAnim(row, column, anim)
    sceneView.currentMap.tiles[row][column].id = anim
end
