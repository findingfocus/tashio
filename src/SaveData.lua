SaveData = Class{}

function SaveData:init()

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
  else
    saveData['itemSlotType'] = nil
    saveData['itemSlotQuantity'] = nil
  end

  if gItemInventory.grid[1][1][1] then
    saveData['inventoryGrid1-1Type'] = gItemInventory.grid[1][1][1].type
    saveData['inventoryGrid1-1Quantity'] = gItemInventory.grid[1][1][1].quantity
  else
   saveData['inventoryGrid1-1Type'] = nil
   saveData['inventoryGrid1-1Quantity'] = nil
  end
  if gItemInventory.grid[1][2][1] ~= nil then
    saveData['inventoryGrid1-2Type'] = gItemInventory.grid[1][2][1].type
    saveData['inventoryGrid1-2Quantity'] = gItemInventory.grid[1][2][1].quantity
  else
   saveData['inventoryGrid1-2Type'] = nil
   saveData['inventoryGrid1-2Quantity'] = nil
  end

  local success, err = love.filesystem.write("saves/savePlayerData.bin", bitser.dumps(saveData))
  if success then
    print("Game saved successfully!")
  else
    print("Error saving game: " .. (err or "Unknown error"))
  end
end

function SaveData:loadPlayerData()
  --gPlayer.currentAnimation:refresh()
  local success, err = love.filesystem.createDirectory("saves")
  if not success then
    print("Failed to create saves directory: " .. (err or "Unknown error"))
    return
  end

  local save = love.filesystem.getInfo("saves/savePlayerData.bin")

  if save == nil then
    print("No save data found, starting new game.")
    sceneView.activeDialogueID = nil
    gStateMachine:change('openingCinematic')
    gPlayer:changeState('player-death')
    goto earlybreak
  else
    print(Inspect(save))
  end

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
    if k == 'itemSlotType' then
      gItemInventory.itemSlot[1] = Item(v)
      gItemInventory.itemSlot[1]:equip()
      --HERE
      gItemInventory.itemSlot[1].quantity = load['itemSlotQuantity']
    end
    if k == 'inventoryGrid1-1Type' then
      table.insert(gItemInventory.grid[1][1], Item(v))
      gItemInventory.grid[1][1][1].quantity = load['inventoryGrid1-1Quantity']
    end
    if k == 'inventoryGrid1-2Type' then
      table.insert(gItemInventory.grid[1][2], Item(v))
      gItemInventory.grid[1][2][1].quantity = load['inventoryGrid1-2Quantity']
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

  ::earlybreak::
end
