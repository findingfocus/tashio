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
  saveData['flammeUnlocked'] = gPlayer.flammeUnlocked
  saveData['keyItemElementColor'] = gKeyItemInventory.elementColor
  saveData['tunicEquipped'] = gPlayer.tunicEquipped
  saveData['greenTunicUnlocked'] = gPlayer.greenTunicUnlocked
  saveData['playerTome1Unlocked'] = gPlayer.tome1Unlocked
  saveData['keyItemTomeEquipped'] = gKeyItemInventory.tomeEquipped
  saveData['keyItemTome1Equipped'] = gKeyItemInventory.tome1Equipped

  if GREEN_TUNIC_CHEST_OPENED then
    saveData['greenTunicChestOpened'] = true
  else
    saveData['greenTunicChestOpened'] = false
  end
  if MAGIC_POTION_CHEST_OPENED then
    saveData['magicPotionChestOpened'] = true
  else
    saveData['magicPotionChestOpened'] = false
  end
  if TOME1_CHEST_OPENED then
    saveData['tome1ChestOpened'] = true
  else
    saveData['tome1ChestOpened'] = false
  end

  saveData['demoWaterCleansed'] = DEMO_WATER_CLEANSED
  saveData['desertShortcutUnlocked'] = DESERT_SHORTCUT_UNLOCKED
  if gPlayer.elementEquipped == 'flamme' then
    saveData['flammeEquipped'] = true
  end

  ---[[
  if gItemInventory.itemSlot[1] ~= nil then
    saveData['itemSlotType'] = gItemInventory.itemSlot[1].type
    saveData['itemSlotQuantity'] = gItemInventory.itemSlot[1].quantity
  else
    saveData['itemSlotType'] = nil
    saveData['itemSlotQuantity'] = nil
  end

  --SAVE ITEM INVENTORY
  ---[[
  if #gItemInventory.grid[1][1] > 0 then
    saveData['inventoryGrid1-1Type'] = gItemInventory.grid[1][1][1].type
    saveData['inventoryGrid1-1Quantity'] = gItemInventory.grid[1][1][1].quantity
  else
    saveData['inventoryGrid1-1Type'] = nil
    saveData['inventoryGrid1-1Quantity'] = nil
  end

  if #gItemInventory.grid[1][2] > 0 then
    print('Grid 1 2 was not empty')
    saveData['inventoryGrid1-2Type'] = gItemInventory.grid[1][2][1].type
    saveData['inventoryGrid1-2Quantity'] = gItemInventory.grid[1][2][1].quantity
  else
    print('Grid 1 2 was empty')
   saveData['inventoryGrid1-2Type'] = nil
   saveData['inventoryGrid1-2Quantity'] = nil
  end
  --]]

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

  local saveDataExists = love.filesystem.getInfo("saves/savePlayerData.bin")

  if saveDataExists == nil then
    print("No saveDataExists data found, starting new game.")
    sceneView.activeDialogueID = nil
    gStateMachine:change('openingCinematic')
    gPlayer.meditate = false
    gPlayer:changeState('player-death')
  else
    --SAVE_DATA_NEEDS_LOADING = true
  end

  local load = bitser.loadLoveFile("saves/savePlayerData.bin")
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
    if k == 'flammeUnlocked' then
      gPlayer.flammeUnlocked = v
    end
    if k == 'flammeEquipped' then
      if v then
        gPlayer.elementEquipped = 'flamme'
      end
    end
    if k == 'keyItemElementColor' then
      gKeyItemInventory.elementColor = v
    end
    if k == 'greenTunicUnlocked' then
      gPlayer.greenTunicUnlocked = v
    end
    if k == 'tunicEquipped' then
      gPlayer.tunicEquipped = v
    end
    if k == 'playerTome1Unlocked' then
      gPlayer.tome1Unlocked = v
    end
    if k == 'keyItemTomeEquipped' then
      gKeyItemInventory.tomeEquipped = v
    end
    if k == 'keyItemTome1Equipped' then
      gKeyItemInventory.tome1Equipped = v
    end
    if k == 'demoWaterCleansed' then
      if v == true then
        Event.dispatch('cleanseDemoWater')
      end
    end
    if k == 'desertShortcutUnlocked' then
      if v == true then
        Event.dispatch('solveDesertShortcutBoulders')
      end
    end
    if k == 'greenTunicChestOpened' then
      if v == true then
        for k, v in pairs(MAP[4][11].collidableMapObjects) do
          if v.classType == 'treasureChest' then
            v:loadOpenedChest()
            GREEN_TUNIC_CHEST_OPENED = true
          end
        end
      end
    end
    if k == 'magicPotionChestOpened' then
      if v == true then
        for k, v in pairs(MAP[3][5].collidableMapObjects) do
          if v.classType == 'treasureChest' then
            v:loadOpenedChest()
            MAGIC_POTION_CHEST_OPENED = true
          end
        end
      end
    end
    if k == 'tome1ChestOpened' then
      if v == true then
        for k, v in pairs(MAP[7][5].collidableMapObjects) do
          if v.classType == 'treasureChest' then
            v:loadOpenedChest()
            TOME1_CHEST_OPENED = true
          end
        end
      end
    end

    --]]
    ---[[
    if k == 'itemSlotType' then
      gItemInventory.itemSlot[1] = Item(v)
      gItemInventory.itemSlot[1]:equip()
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
    --]]
    print('loaded: ' .. k .. ' as: ' .. tostring(v))
  end

  MAP[10][19].psystems[1]:activate()
  MAP[10][19].psystems[1].active = true
  table.insert(MAP[10][19].collidableMapObjects, CollidableMapObjects(1, 5, TILE_SIZE, TILE_SIZE))
  table.insert(MAP[10][19].collidableMapObjects, CollidableMapObjects(1, 6, TILE_SIZE, TILE_SIZE))

  print('GAME LOADED')

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

  --Event.dispatch('cleanseDemoWater')
  local animatables = InsertAnimation(sceneView.mapRow, sceneView.mapColumn)
  gStateMachine.current.animatables = animatables
end
