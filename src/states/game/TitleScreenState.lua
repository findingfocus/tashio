TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
  --SCREEN LOCK POSITION
  love.window.setPosition(400, 60)
  self.playFlashing = false
  self.flashTimer = 0
  self.lavaSystem = LavaSystem()
  self.saveDataUtility = SaveData()
  self.logo = love.graphics.newImage('graphics/FindingFocus.png')
  self.step = 1
  self.logoAlpha = 0
  self.titleAlpha = 0
  self.logoTimer = 0
  stopOST()
  SOUNDTRACK = 'titleTrack'
end

function TitleScreenState:update(dt)
  if self.step == 1 then -- FADE IN LOGO
    self.logoAlpha = math.min(255, self.logoAlpha + dt * 150)
    if self.logoAlpha == 255 then
      self.logoTimer = self.logoTimer + dt
      if self.logoTimer > 1.5 then
        self.step = 2
      end
    end
    if INPUT:pressed('action') then
        self.step = 2
    end
  end

  if self.step == 2 then --FADE OUT LOGO
    self.logoAlpha = math.max(0, self.logoAlpha - dt * 150)
    self.lavaSystem:update(dt)
    if self.logoAlpha == 0 then
      self.step = 3
    end
  end

  if self.step == 3 then --TASHIO TITLE FADE IN
    self.titleAlpha = math.min(255, self.titleAlpha + dt * 100)
    self.lavaSystem:update(dt)
  end

  self.flashTimer = self.flashTimer + dt
  if self.flashTimer > 1 then
    self.playFlashing = not self.playFlashing
    self.flashTimer = 0
  end

  if self.step > 2 then
    if INPUT:pressed('start') or INPUT:pressed('action') then
      SAVE_DATA_NEEDS_LOADING = true
      --gStateMachine:change('saveSelectState')
      --OLD SINGLE STATE
      ---[[
      gStateMachine:change('playState')
      gPlayer.stateMachine:change('player-meditate')
      gPlayer.health = 6

      local animatables = InsertAnimation(sceneView.mapRow, sceneView.mapColumn)
      gStateMachine.current.animatables = animatables
      self.saveDataUtility:loadPlayerData()
      stopOST()
      SOUNDTRACK = MAP[sceneView.currentMap.row][sceneView.currentMap.column].ost
      sceneView.player.deadTimer = 0
      sceneView.player.dead = false
      sounds['select']:play()
      --]]
      --sceneView = Scene(gPlayer, 7, 4)
    end
  end
end

function TitleScreenState:render()
  love.graphics.clear(0,0,0, 255/255)

  if self.step < 3 then
    love.graphics.setColor(1,1,1, self.logoAlpha/255)
    love.graphics.draw(self.logo, 0, 0)
  end


  if self.step > 2 then
    love.graphics.setColor(1,1,1, self.titleAlpha/255)
    love.graphics.draw(titleScreen, 0, 0)
    if self.playFlashing then
      love.graphics.setColor(WHITE)
    else
      love.graphics.setColor(0,0,0,0)
    end
    love.graphics.setFont(pixelFont)
    love.graphics.printf('START', 0, VIRTUAL_HEIGHT - 24, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(WHITE)
  end

  if self.step > 1 then
    love.graphics.setColor(WHITE)
    self.lavaSystem:render()
  end

  --love.graphics.print('lAlpha: ' .. tostring(self.logoAlpha),0, 10)
end
