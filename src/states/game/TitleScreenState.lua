TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
  --SCREEN LOCK POSITION
  love.window.setPosition(400, 60)
  self.playFlashing = false
  self.flashTimer = 0
  self.lavaSystem = LavaSystem()
  self.saveDataUtility = SaveData()
end

function TitleScreenState:update(dt)
  self.lavaSystem:update(dt)
  self.flashTimer = self.flashTimer + dt
  if self.flashTimer > 1 then
    self.playFlashing = not self.playFlashing
    self.flashTimer = 0
  end
  if INPUT:pressed('start') then
    --LOAD SAVE FILE
    --self.saveDataUtility:loadPlayerData()
    gStateMachine:change('playState')
    gPlayer.stateMachine:change('player-meditate')
    sounds['select']:play()
  end
end

function TitleScreenState:render()
  love.graphics.clear(0/255, 0/255, 0/255, 255/255)
  love.graphics.draw(titleScreenTemp, 0, 0)
  if self.playFlashing then
    love.graphics.setColor(WHITE)
  else
    love.graphics.setColor(0,0,0,0)
  end
  love.graphics.printf('START', 0, VIRTUAL_HEIGHT - 24, VIRTUAL_WIDTH, 'center')
  self.lavaSystem:render()
end
