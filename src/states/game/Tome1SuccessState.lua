Tome1SuccessState = Class{__includes = BaseState}

function Tome1SuccessState:init()
  self.stateName = 'Tome1SuccessState'
  sceneView.currentMap = Map(9, 2, gPlayer.spellcastCount)
  self.row = 9
  self.column = 2
  self.animatables = {}
  self.animatables = InsertAnimation(sceneView.currentMap.row, sceneView.currentMap.column)
  self.waterAlpha = 0
  self.waterCleansed = false
  self.triggerCredits = false
  self.demoScreenOpacity = 0
  self.demoCreditsSequence = false
  self.creditsY = VIRTUAL_HEIGHT
  self.creditsTimer = 0
  self.lavaSystem = LavaSystem()
  self.lavaAlpha = 0
  self.creditsFinishedScroll = false
  self.step = 0
end

function Tome1SuccessState:update(dt)
  self.lavaSystem:update(dt)
  if self.step == 0 and not self.waterCleansed then
    self.waterAlpha = math.min(255, self.waterAlpha + dt * 80)
  end

  self.animatables:update(dt)
  if not PAUSED then
    sceneView:update(dt)
  end

  if INPUT:pressed('start') then
    if not PAUSED and not gPlayer.dead and not luteState then
      gStateMachine:change('pauseState')
    end
  end

  Event.on('cleanseDemoWater', function()
    for i = 1, OVERWORLD_MAP_HEIGHT do
      for j = 1, OVERWORLD_MAP_WIDTH do
        MAP[i][j].animatables = {}
      end
    end

    for i = 1, OVERWORLD_MAP_HEIGHT do
      for j = 1, OVERWORLD_MAP_WIDTH do
        for k = 1, MAP_HEIGHT * MAP_WIDTH do
          local animRow = math.floor((k - 1) / 10) + 1
          local animCol = (k % 10)
          if animCol == 0 then
            animCol = 10
          end
          if MAP[i][j][k] == WATER_ANIM_STARTER then
            MAP[i][j][k] = CLEAN_WATER_ANIM_STARTER
            table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, CLEANSED_WATER.frame) end)
          elseif MAP[i][j][k] == LAVA_LEFT_EDGE_ANIM_STARTER then
            table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, LAVA_LEFT_EDGE.frame) end)
          elseif MAP[i][j][k] == LAVA_RIGHT_EDGE_ANIM_STARTER then
            table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, LAVA_RIGHT_EDGE.frame) end)
          elseif MAP[i][j][k] == LAVA_FLOW_ANIM_STARTER then
            table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, LAVA_FLOW.frame) end)
          end

          if MAP[i][j].aboveGroundTileIds[k] == SCONCE_ANIM_STARTER then
            table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, SCONCE.frame, 'aboveGround') end)
          elseif MAP[i][j].aboveGroundTileIds[k] == FLOWER_ANIM_STARTER then
            table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, FLOWERS.frame, 'aboveGround') end)
          end
        end
      end
    end
    DEMO_WATER_CLEANSED = true
  end)


  if self.waterAlpha >= 255 and self.step == 0 then
    self.waterCleansed = true
    cleanseTheGlobalWater()
    DEMO_WATER_CLEANSED = true
    self.step = 1
  end

  if self.step == 1 then --CREDIT TIMER
    self.creditsTimer = self.creditsTimer + dt
    --self.demoScreenOpacity = math.min(170, self.demoScreenOpacity + dt * 80)
    self.lavaAlpha = math.min(255, self.lavaAlpha + dt * 90)
    if self.creditsTimer > 1.5 then
      self.step = 2
    end
  end

  if self.step == 2 then
    self.lavaAlpha = math.min(255, self.lavaAlpha + dt * 70)
    self.demoScreenOpacity = math.min(170, self.demoScreenOpacity + dt * 80)
  end

  if self.demoScreenOpacity == 170 then
    self.creditsY = self.creditsY - CREDITS_SPEED
  end

  if self.creditsY < -330 then
    self.step = 3
  end

  if self.step == 3 then
    self.demoScreenOpacity = math.max(0, self.demoScreenOpacity - dt * 80)
    self.lavaAlpha = math.min(255, self.lavaAlpha + dt * 70)
    if self.demoScreenOpacity == 0 then
      self.step = 4
    end
  end

  if self.step == 4 then
    gPlayer:changeState('player-idle')
    gStateMachine:change('playState')
  end

  if INPUT:down('action') then
    self.creditsY = self.creditsY - CREDITS_SPEED * 10
  end
end

function cleanseTheGlobalWater()
  for i = 1, OVERWORLD_MAP_HEIGHT do
    for j = 1, OVERWORLD_MAP_WIDTH do
      MAP[i][j].animatables = {}
    end
  end

  for i = 1, OVERWORLD_MAP_HEIGHT do
    for j = 1, OVERWORLD_MAP_WIDTH do
      for k = 1, MAP_HEIGHT * MAP_WIDTH do
        local animRow = math.floor((k - 1) / 10) + 1
        local animCol = (k % 10)
        if animCol == 0 then
          animCol = 10
        end
        if MAP[i][j][k] == WATER_ANIM_STARTER then
          MAP[i][j][k] = CLEAN_WATER_ANIM_STARTER
          table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, CLEANSED_WATER.frame) end)
        elseif MAP[i][j][k] == LAVA_LEFT_EDGE_ANIM_STARTER then
          table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, LAVA_LEFT_EDGE.frame) end)
        elseif MAP[i][j][k] == LAVA_RIGHT_EDGE_ANIM_STARTER then
          table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, LAVA_RIGHT_EDGE.frame) end)
        elseif MAP[i][j][k] == LAVA_FLOW_ANIM_STARTER then
          table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, LAVA_FLOW.frame) end)
        end

        if MAP[i][j].aboveGroundTileIds[k] == SCONCE_ANIM_STARTER then
          table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, SCONCE.frame, 'aboveGround') end)
        elseif MAP[i][j].aboveGroundTileIds[k] == FLOWER_ANIM_STARTER then
          table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, FLOWERS.frame, 'aboveGround') end)
        end
      end
    end
  end

end

function Tome1SuccessState:insertCleansedWater()
  for y = 1, 8 do
    love.graphics.setColor(255/255, 255/255, 255/255, self.waterAlpha/255)
    love.graphics.draw(tileSheet, quads[CLEANSED_WATER.frame], 0, (y - 1) * TILE_SIZE)
    love.graphics.draw(tileSheet, quads[CLEANSED_WATER.frame], TILE_SIZE * 9, (y - 1) * TILE_SIZE)
  end
  for x = 1, 10 do
    if x == 2 or x == 8 then
    love.graphics.setColor(255/255, 255/255, 255/255, self.waterAlpha/255)
    love.graphics.draw(tileSheet, quads[CLEANSED_WATER.frame], (x - 1) * TILE_SIZE, 0)
    end
  end
end

function Tome1SuccessState:render()
  love.graphics.push()
  sceneView:render()
  love.graphics.pop()
  love.graphics.setFont(pixelFont2)

  love.graphics.setColor(WHITE)
  love.graphics.draw(hudOverlay, 0, VIRTUAL_HEIGHT - 16)
  if gItemInventory.itemSlot[1] ~= nil then
    love.graphics.setFont(pixelFont)
    gItemInventory.itemSlot[1]:render()
  end

  love.graphics.setColor(gKeyItemInventory.elementColor)
  love.graphics.circle('fill', VIRTUAL_WIDTH - 86, VIRTUAL_HEIGHT - 8, 6)

  love.graphics.setColor(WHITE)
  love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
  heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
  love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)

  if gPlayer.elementEquipped == 'flamme' then
    --VIBRANCY RENDER
    --love.graphics.draw(flamme, VIRTUAL_WIDTH / 2 - 11, VIRTUAL_HEIGHT - 13)
    --EMPTY VIBRANCY BAR
    love.graphics.setColor(255/255, 30/255, 30/255, 255/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 2, VIRTUAL_HEIGHT - 13, 2, 10)
    --VIBRANCY BAR
    love.graphics.setColor(30/255, 30/255, 30/255, 255/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 2, VIRTUAL_HEIGHT - 13, 2, gPlayer.flammeVibrancy / 10)
    --love.graphics.print('vibrancy: ' .. tostring(gPlayer.flammeVibrancy), 0, 0)
    --A SLOT SPELL SLOT
    love.graphics.setColor(WHITE)
    love.graphics.draw(flamme2, VIRTUAL_WIDTH / 2 - 11 , VIRTUAL_HEIGHT - 13)
  end

  love.graphics.setColor(255/255, 255/255, 255/255, self.waterAlpha)
  self:insertCleansedWater()

  --CREDITED SUPPORTERS
  love.graphics.setFont(pixelFont)
  love.graphics.setColor(0, 0, 0, self.demoScreenOpacity/255)
  love.graphics.rectangle('fill',0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  love.graphics.setColor(WHITE)

  love.graphics.printf('Thanks for playing!\n\n\nTashio Tempo will release in 2027\n\n\nView the source code:\ngithub.com/findingfocus/tashio\n\n\nCreated by:\nPaul Thompson\nfindingfocus.dev\n\n\nSound Effects Designer:\nCaine Deegan\n\n\nSteam Art Assets made by:\nSam Dalton\nsaltomanga.com\n\n\nSupporters:\nakabob56\njeanniegrey\nsoup_or_king\nsaltomanga\nmeesegamez\nk_tronix\nhimeh3\nflatulenceknocker\nofficial_wutnot\nroughcookie\ntheshakycoder\ntjtheprogrammer\npunymagus\nprostokotylo\ntheveryrealrev\nsqwinge\nbrettdoestwitch\nbrightsidemovement\nlokitrixter\nkviktus\ncainedeegan\ndukeofgod', 0, self.creditsY, VIRTUAL_WIDTH, 'center')

  love.graphics.setColor(1, 1, 1, self.lavaAlpha/255)
  self.lavaSystem:render()
end
