SaveData = Class{}

function SaveData:savePlayerData()
  local saveData = {}
  saveData['health'] = gPlayer.health
  saveData['currentMapRow'] = sceneView.currentMap.row
  saveData['currentMapColumn'] = sceneView.currentMap.column
  saveData['currentMap'] = 40
  saveData['playerCoordinates'] = {gPlayer.x, gPlayer.y}
  saveData['playerDirection'] = gPlayer.direction

  local file = io.open("saves/savePlayerData.bin", "wb")
  if file then
      local serialized = bitser.dumps(saveData)
      file:write(serialized)
      file:close()
  else
      print("Error saving game!")
  end
end

function SaveData:loadPlayerData()
    gPlayer.currentAnimation:refresh()
    local load = bitser.loadLoveFile("saves/savePlayerData.bin")
    --love.graphics.print(Inspect(fileLoad), 0, 0)
    for k, v in pairs(load) do
        if k == 'health' then
            gPlayer.health = v
        end
        if k == 'currentMapRow' then
            sceneView.currentMap.row = v
            sceneView.mapRow = v
        end
        if k == 'currentMapColumn' then
            sceneView.currentMap.column = v
            sceneView.mapColumn = v
        end
        if k == 'playerCoordinates' then
            gPlayer.x, gPlayer.y = v[1], v[2]
        end
        if k == 'playerDirection' then
            gPlayer.direction = v
        end
    end

    gPlayer.dead = false
    gPlayer.deadTimer = 0
    gPlayer.graveyard = false
    gPlayer.damageFlash = false
    gPlayer.hit = false
    gPlayer.flashing = false

    for k, v in pairs(load) do
        if k == 'currentMap' then
            sceneView.currentMap = Map(sceneView.currentMap.row, sceneView.currentMap.column, 1)
        end
    end
end
