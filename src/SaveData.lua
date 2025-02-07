SaveData = Class{}

function SaveData:savePlayerData()
  local saveData = {}
  saveData['health'] = gPlayer.health
  saveData['currentMapRow'] = sceneView.currentMap.row
  return saveData
end
