Chasm = Class{}

function Chasm:init(sceneRow, sceneCol)
  self.tileX = sceneCol
  self.tileY = sceneRow
  self.x = sceneCol * 16 - 16
  self.y = sceneRow * 16 - 16
  self.width = TILE_SIZE
  self.height = TILE_SIZE
end

function Chasm:update(dt)

end

function Chasm:render()

end
