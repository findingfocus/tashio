SaveSelectState = Class{__includes = BaseState}

function SaveSelectState:init()
  self.selection = 1
  self.optionX = (VIRTUAL_WIDTH - 140) / 2
  self.optionY = 0
  self.optionYOffset = 7
  self.state1 = SaveSelect(self.optionX, self.optionY + self.optionYOffset)
  self.state2 = SaveSelect(self.optionX, self.optionY + self.optionYOffset + 40 + 5)
  self.state3 = SaveSelect(self.optionX, self.optionY + self.optionYOffset + 80 + 10)
end

function SaveSelectState:update(dt)
  if INPUT:pressed('down') then
    self.selection = self.selection + 1
    if self.selection == 4 then
      self.selection = 1
    end
  end
  if INPUT:pressed('up') then
    self.selection = self.selection - 1
    if self.selection == 0 then
      self.selection = 3
    end
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
end
