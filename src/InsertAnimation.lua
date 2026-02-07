InsertAnimation = Class{}

function InsertAnimation:init(mapRow, mapColumn)
  self.mapRow = mapRow
  self.mapColumn = mapColumn
end

function InsertAnimation:update(dt)
  FLOWERS:update(dt)
  FLOWERS_DARK:update(dt)
  WATER:update(dt)
  CLEANSED_WATER:update(dt)
  LAVA_LEFT_EDGE:update(dt)
  LAVA_RIGHT_EDGE:update(dt)
  LAVA_FLOW:update(dt)
  SCONCE:update(dt)
  FURNACE:update(dt)

  for i = 1, #MAP[self.mapRow][self.mapColumn].animatables do
    --print(#MAP[self.mapRow][self.mapColumn].animatables .. tostring(' animatables'), 0, 0)
    MAP[self.mapRow][self.mapColumn].animatables[i]()
    --THE ABOVE FUNCTION RUNS insertAnim() from down below
  end

end

function insertAnim(row, column, anim, option)
  if option == 'aboveGround' then
    sceneView.currentMap.aboveGroundTiles[row][column].id = anim
  else
    sceneView.currentMap.tiles[row][column].id = anim
  end
end

function InsertAnimation:render()
end
