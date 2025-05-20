SaveData = Class{}

function SaveData:init()
  self.itemSlotType = ''
  self.itemSlotQuantity = 0
end

function SaveData:savePlayerData()
  local saveData = {}
  saveData['health'] = gPlayer.health
  saveData['currentMapRow'] = sceneView.currentMap.row
  saveData['currentMapColumn'] = sceneView.currentMap.column
  saveData['currentMap'] = 40
  saveData['playerCoordinates'] = {gPlayer.x, gPlayer.y}
  saveData['playerDirection'] = gPlayer.direction
  saveData['coinCount'] = gPlayer.coinCount
  saveData['rubyCount'] = gPlayer.rubyCount
  saveData['healthPotionUnlocked'] = gPlayer.healthPotionUnlocked
  if gItemInventory.itemSlot[1] ~= nil then
    saveData['itemSlotType'] = gItemInventory.itemSlot[1].type
    saveData['itemSlotQuantity'] = gItemInventory.itemSlot[1].quantity
  end

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
  --gPlayer.currentAnimation:refresh()
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
    if k == 'coinCount' then
      gPlayer.coinCount = v
    end
    if k == 'rubyCount' then
      gPlayer.rubyCount = v
    end
    if k == 'healthPotionUnlocked' then
      gPlayer.healthPotionUnlocked = v
    end
    if gItemInventory.itemSlot[1] ~= nil then
      if k == 'itemSlotType' then
        gItemInventory.itemSlot[1].type = v
        self.itemSlotType = v
      end
      if k == 'itemSlotQuantity' then
        gItemInventory.itemSlot[1].quantity = v
        self.itemSlotQuantity = v
      end
    end
    print('loaded: ' .. k .. ' ' .. tostring(v))
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
