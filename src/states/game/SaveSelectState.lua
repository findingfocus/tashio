SaveSelectState = Class{__includes = BaseState}

function SaveSelectState:init()
  self.selection = 1
  self.selectionX = (VIRTUAL_WIDTH - 140) / 2
  self.selectionY = 0
  self.selectionYOffset = 7
  self.state1 = SaveSelect(self.selectionX, self.selectionY + self.selectionYOffset, 1)
  self.state2 = SaveSelect(self.selectionX, self.selectionY + self.selectionYOffset + 40 + 5, 2)
  self.state3 = SaveSelect(self.selectionX, self.selectionY + self.selectionYOffset + 80 + 10, 3)
  self.saveDataUtility = SaveData()
end

function SaveSelectState:update(dt)
  if INPUT:pressed('down') then
    sounds['beep']:play()
    self.selection = self.selection + 1
    if self.selection == 4 then
      self.selection = 1
    end
  end
  if INPUT:pressed('up') then
    sounds['beep']:play()
    self.selection = self.selection - 1
    if self.selection == 0 then
      self.selection = 3
    end
  end

  if INPUT:pressed('action') or INPUT:pressed('start') then
    sounds['select']:play()
    SAVEFILE_SELECT = self.selection

    gStateMachine:change('playState')
    gPlayer.stateMachine:change('player-meditate')
    --DO WE NEED THIS
    gPlayer.health = 6

    local animatables = InsertAnimation(sceneView.mapRow, sceneView.mapColumn)
    gStateMachine.current.animatables = animatables
    self.saveDataUtility:loadPlayerData()
    stopOST()
    SOUNDTRACK = MAP[sceneView.currentMap.row][sceneView.currentMap.column].ost
    sceneView.player.deadTimer = 0
    sceneView.player.dead = false
  end

  if self.selection == 1 then
    self.state1.selected = true
    self.state2.selected = false
    self.state3.selected = false
  end

  if self.selection == 2 then
    self.state1.selected = false
    self.state2.selected = true
    self.state3.selected = false
  end

  if self.selection == 3 then
    self.state1.selected = false
    self.state2.selected = false
    self.state3.selected = true
  end
end

function SaveSelectState:render()
  love.graphics.setColor(WHITE)
  love.graphics.print("HELLO SAVE SELECT STATE", 0, 0)

  self.state1:render()
  self.state2:render()
  self.state3:render()

  love.graphics.print("saveFileSelect: " .. SAVEFILE_SELECT, 5, VIRTUAL_HEIGHT - 7)
end
