DialogueBox = Class{}

local spaceCount = 0
local blinking = true
local blinkTimer = .5
local blinkReset = .5

function DialogueBox:init(x, y, text, option, npc, index)
  self.dialogueID = index or 1
  self.index = index or nil
  self.x = x + 1
  self.y = y + 1
  self.width = TILE_SIZE - 2
  self.height = TILE_SIZE - 2
  self.text = text
  self.option = option or 0
  self.npc = npc or 0
  self.textTimer = 0
  self.textLength = #text
  self.nextTextTrigger = 0.02
  self.result = ''
  self.line1Result = ''
  self.line2Result = ''
  self.line3Result = ''
  self.currentPage = 1
  self.pages = {}
  self.inAWord = false
  self.lineCharacterIndex = 0
  self.wordSupplementCount = 0
  self.currentWordLength = 0
  self.pageWeAreOn = 1
  self.lineWeAreOn = 1
  self.test = 0
  self.pages[1] = {}
  self.pages[1][1] = {}
  self.pages[1][2] = {}
  self.pages[1][3] = {}
  self.pages[1][1].string = ''
  self.pages[1][2].string = ''
  self.pages[1][3].string = ''
  self.pages[1].pageCharCount = 0
  self.currentPagePrintedCharCount = 0
  self.activated = false
  self.lastCharWasSpace = false
  self.aButtonCount = 0
  self.restButtonCount = 0
  self.meditateOption = false
  self.restOption = false
  self.finishedPrinting = false
  self.saveDataUtility = SaveData()
  --TODO
  --ADD A BUTTON COUNT UPON PAUSE
  --INCREMENT A BUTTON BUTTON COUNT ON UPDATE AND PRESS/TOUCH
  --ONLY ADVANCE PAGE IF A BUTTON COUNT > 1

  self.charactersToCheck = true
  self.textIndex = 0
  self.wordIndexGrabbed = false
  self.meditateYes = true
  self.restYes = true

  self.wordCharacterIndex = 0
  self.wordCharCount = 0
  self.lineCharCount = 0
  self.pageLength = 1

  while self.charactersToCheck do
    self.textIndex = self.textIndex + 1
    local char = self.text:sub(self.textIndex, self.textIndex)
    if not char:match("%s") then --IF A LETTER
      self.pages[self.pageWeAreOn].pageCharCount = self.pages[self.pageWeAreOn].pageCharCount + 1
      if not self.wordIndexGrabbed then
        self.lastCharWasSpace = false
        self.wordIndex = self.textIndex
        self.wordIndexGrabbed = true
      end
      self.wordCharCount = self.wordCharCount + 1
      if self.textIndex == self.textLength then
        if self.lineCharCount + self.wordCharCount > MAX_TEXTBOX_LINE_LENGTH then --INCREMENT LINE NUMBER
          self.lineWeAreOn = self.lineWeAreOn + 1
          if self.lineWeAreOn > 3 then
            self.lineWeAreOn = 1
            self.pageWeAreOn = self.pageWeAreOn + 1
            self.pageLength = self.pageLength + 1
            self.pages[self.pageWeAreOn] = {}
            self.pages[self.pageWeAreOn][1] = {}
            self.pages[self.pageWeAreOn][2] = {}
            self.pages[self.pageWeAreOn][3] = {}
            self.pages[self.pageWeAreOn][1].string = ''
            self.pages[self.pageWeAreOn][2].string = ''
            self.pages[self.pageWeAreOn][3].string = ''
            self.pages[self.pageWeAreOn].pageCharCount = 0
          end
          self.lineCharCount = self.wordCharCount + 1
          self.wordCharCount = 0
        end
        self.pages[self.pageWeAreOn][self.lineWeAreOn].string = self.pages[self.pageWeAreOn][self.lineWeAreOn].string .. self.text:sub(self.wordIndex, self.wordIndex + self.wordCharCount)
      end
    elseif char:match("%s") then --IF SPACE CHARACTER
      self.pages[self.pageWeAreOn].pageCharCount = self.pages[self.pageWeAreOn].pageCharCount + 1
      self.wordIndexGrabbed = false
      if self.lastCharWasSpace then
        self.pages[self.pageWeAreOn].pageCharCount = self.pages[self.pageWeAreOn].pageCharCount - 1
        self.pageWeAreOn = self.pageWeAreOn + 1
        self.pageLength = self.pageLength + 1
        self.pages[self.pageWeAreOn] = {}
        self.pages[self.pageWeAreOn][1] = {}
        self.pages[self.pageWeAreOn][2] = {}
        self.pages[self.pageWeAreOn][3] = {}
        self.pages[self.pageWeAreOn][1].string = ''
        self.pages[self.pageWeAreOn][2].string = ''
        self.pages[self.pageWeAreOn][3].string = ''
        self.pages[self.pageWeAreOn].pageCharCount = 0
        self.wordCharCount = 0
        self.lineWeAreOn = 1
        self.lineCharCount = 0
      else
        self.lastCharWasSpace = true
        --CHECK IF WORD CAN FIT ON CURRENT LINE
        if self.lineCharCount + self.wordCharCount <= MAX_TEXTBOX_LINE_LENGTH then
          self.pages[self.pageWeAreOn][self.lineWeAreOn].string = self.pages[self.pageWeAreOn][self.lineWeAreOn].string .. self.text:sub(self.wordIndex, self.wordIndex + self.wordCharCount)
          self.lineCharCount = self.lineCharCount + self.wordCharCount + 1
          self.wordCharCount = 0
        elseif self.lineCharCount + self.wordCharCount > MAX_TEXTBOX_LINE_LENGTH then --INCREMENT LINE NUMBER
          self.lineWeAreOn = self.lineWeAreOn + 1
          if self.lineWeAreOn > 3 then
            self.lineWeAreOn = 1
            self.pageWeAreOn = self.pageWeAreOn + 1
            self.pageLength = self.pageLength + 1
            self.pages[self.pageWeAreOn] = {}
            self.pages[self.pageWeAreOn][1] = {}
            self.pages[self.pageWeAreOn][2] = {}
            self.pages[self.pageWeAreOn][3] = {}
            self.pages[self.pageWeAreOn][1].string = ''
            self.pages[self.pageWeAreOn][2].string = ''
            self.pages[self.pageWeAreOn][3].string = ''
            self.pages[self.pageWeAreOn].pageCharCount = 0
          end
          self.pages[self.pageWeAreOn][self.lineWeAreOn].string = self.pages[self.pageWeAreOn][self.lineWeAreOn].string .. self.text:sub(self.wordIndex, self.wordIndex + self.wordCharCount)
          self.lineCharCount = self.wordCharCount + 1
          self.wordCharCount = 0
        end
      end
    end

    if self.textIndex >= self.textLength then
      self.charactersToCheck = false
    end
  end

  --self.textIndex = 1
  --self.pageLength = math.ceil(self.totalLineCount / 3)
end

function DialogueBox:reinit(text)
  --self.width = TILE_SIZE - 2
  --self.height = TILE_SIZE - 2
  self.text = text
  self.textTimer = 0
  self.textLength = #text
  self.nextTextTrigger = 0.02
  self.result = ''
  self.line1Result = ''
  self.line2Result = ''
  self.line3Result = ''
  self.currentPage = 1
  self.pages = {}
  self.inAWord = false
  self.lineCharacterIndex = 0
  self.wordSupplementCount = 0
  self.currentWordLength = 0
  self.pageWeAreOn = 1
  self.lineWeAreOn = 1
  self.pages[1] = {}
  self.pages[1][1] = {}
  self.pages[1][2] = {}
  self.pages[1][3] = {}
  self.pages[1][1].string = ''
  self.pages[1][2].string = ''
  self.pages[1][3].string = ''
  self.pages[1].pageCharCount = 0
  self.currentPagePrintedCharCount = 0
  self.activated = false
  self.lastCharWasSpace = false
  self.aButtonCount = 1
  self.meditateOption = false
  self.finishedPrinting = false
  self.saveDataUtility = SaveData()
  --TODO
  --ADD A BUTTON COUNT UPON PAUSE
  --INCREMENT A BUTTON BUTTON COUNT ON UPDATE AND PRESS/TOUCH
  --ONLY ADVANCE PAGE IF A BUTTON COUNT > 1

  self.charactersToCheck = true
  self.textIndex = 0
  self.wordIndexGrabbed = false
  self.meditateYes = true

  self.wordCharacterIndex = 0
  self.wordCharCount = 0
  self.lineCharCount = 0
  self.pageLength = 1

  while self.charactersToCheck do
    self.textIndex = self.textIndex + 1
    local char = self.text:sub(self.textIndex, self.textIndex)
    if not char:match("%s") then --IF A LETTER
      self.pages[self.pageWeAreOn].pageCharCount = self.pages[self.pageWeAreOn].pageCharCount + 1
      if not self.wordIndexGrabbed then
        self.lastCharWasSpace = false
        self.wordIndex = self.textIndex
        self.wordIndexGrabbed = true
      end
      self.wordCharCount = self.wordCharCount + 1
      if self.textIndex == self.textLength then
        if self.lineCharCount + self.wordCharCount > MAX_TEXTBOX_LINE_LENGTH then --INCREMENT LINE NUMBER
          self.lineWeAreOn = self.lineWeAreOn + 1
          if self.lineWeAreOn > 3 then
            self.lineWeAreOn = 1
            self.pageWeAreOn = self.pageWeAreOn + 1
            self.pageLength = self.pageLength + 1
            self.pages[self.pageWeAreOn] = {}
            self.pages[self.pageWeAreOn][1] = {}
            self.pages[self.pageWeAreOn][2] = {}
            self.pages[self.pageWeAreOn][3] = {}
            self.pages[self.pageWeAreOn][1].string = ''
            self.pages[self.pageWeAreOn][2].string = ''
            self.pages[self.pageWeAreOn][3].string = ''
            self.pages[self.pageWeAreOn].pageCharCount = 0
          end
          self.lineCharCount = self.wordCharCount + 1
          self.wordCharCount = 0
        end
        self.pages[self.pageWeAreOn][self.lineWeAreOn].string = self.pages[self.pageWeAreOn][self.lineWeAreOn].string .. self.text:sub(self.wordIndex, self.wordIndex + self.wordCharCount)
      end
    elseif char:match("%s") then --IF SPACE CHARACTER
      self.pages[self.pageWeAreOn].pageCharCount = self.pages[self.pageWeAreOn].pageCharCount + 1
      self.wordIndexGrabbed = false
      if self.lastCharWasSpace then
        self.pages[self.pageWeAreOn].pageCharCount = self.pages[self.pageWeAreOn].pageCharCount - 1
        self.pageWeAreOn = self.pageWeAreOn + 1
        self.pageLength = self.pageLength + 1
        self.pages[self.pageWeAreOn] = {}
        self.pages[self.pageWeAreOn][1] = {}
        self.pages[self.pageWeAreOn][2] = {}
        self.pages[self.pageWeAreOn][3] = {}
        self.pages[self.pageWeAreOn][1].string = ''
        self.pages[self.pageWeAreOn][2].string = ''
        self.pages[self.pageWeAreOn][3].string = ''
        self.pages[self.pageWeAreOn].pageCharCount = 0
        self.wordCharCount = 0
        self.lineWeAreOn = 1
        self.lineCharCount = 0
      else
        self.lastCharWasSpace = true
        --CHECK IF WORD CAN FIT ON CURRENT LINE
        if self.lineCharCount + self.wordCharCount <= MAX_TEXTBOX_LINE_LENGTH then
          self.pages[self.pageWeAreOn][self.lineWeAreOn].string = self.pages[self.pageWeAreOn][self.lineWeAreOn].string .. self.text:sub(self.wordIndex, self.wordIndex + self.wordCharCount)
          self.lineCharCount = self.lineCharCount + self.wordCharCount + 1
          self.wordCharCount = 0
        elseif self.lineCharCount + self.wordCharCount > MAX_TEXTBOX_LINE_LENGTH then --INCREMENT LINE NUMBER
          self.lineWeAreOn = self.lineWeAreOn + 1
          if self.lineWeAreOn > 3 then
            self.lineWeAreOn = 1
            self.pageWeAreOn = self.pageWeAreOn + 1
            self.pageLength = self.pageLength + 1
            self.pages[self.pageWeAreOn] = {}
            self.pages[self.pageWeAreOn][1] = {}
            self.pages[self.pageWeAreOn][2] = {}
            self.pages[self.pageWeAreOn][3] = {}
            self.pages[self.pageWeAreOn][1].string = ''
            self.pages[self.pageWeAreOn][2].string = ''
            self.pages[self.pageWeAreOn][3].string = ''
            self.pages[self.pageWeAreOn].pageCharCount = 0
          end
          self.pages[self.pageWeAreOn][self.lineWeAreOn].string = self.pages[self.pageWeAreOn][self.lineWeAreOn].string .. self.text:sub(self.wordIndex, self.wordIndex + self.wordCharCount)
          self.lineCharCount = self.wordCharCount + 1
          self.wordCharCount = 0
        end
      end
    end

    if self.textIndex >= self.textLength then
      self.charactersToCheck = false
    end
  end

  --self.textIndex = 1
  --self.pageLength = math.ceil(self.totalLineCount / 3)
end

function DialogueBox:flushText()
  MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[self.dialogueID].line1Result = ''
  MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[self.dialogueID].line2Result = ''
  MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[self.dialogueID].line3Result = ''
  MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[self.dialogueID].lineCount = 1
  MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox[self.dialogueID].textIndex = 1
  self.currentPagePrintedCharCount = 0
end

function DialogueBox:clearAButtonCount()
  for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBox) do
    v.aButtonCount = 0
    v.activated = false
  end
end

function DialogueBox:clear()
  --END OF PAGE
    if self.restButtonCount == 2 then
      if self.restYes then
        self:reinit('Rest?')
        self:flushText()
        self.text = self.test + 1
      end
    else 
      self.activated = false
      self:clearAButtonCount()
      treasureChestOption = false
      for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do
        if v.classType == 'treasureChest' then
          v.showOffItem = false
        end
      end
      PAUSED = false
      --MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBoxCollided = {}
      --self:reinit('Reset Value ')
      self:flushText()
      sceneView.activeDialogueID = nil
      self.currentPage = 1
      if self.meditateOption then
        if self.meditateYes then
          gPlayer.stateMachine:change('player-meditate')
          gPlayer.flammeVibrancy = 0
          --self.saveDataUtility:savePlayerData()
        else
          --RESET DEFAULT VALUE
          self.meditateYes = true
        end
      elseif self.restOption then
        if self.restYes then
          gPlayer.stateMachine:change('player-meditate')
          gPlayer.flammeVibrancy = 0
          --self.saveDataUtility:savePlayerData()
          --[[
          MAP[2][11].dialogueBox[2].aButtonCount = MAP[2][11].dialogueBox[2].aButtonCount + 1
          MAP[2][11].dialogueBox[2]:reinit()
          MAP[2][11].dialogueBox[2]:flushText()
          MAP[2][11].dialogueBox[2].activated = true
          --]]
        else
          --RESET DEFAULT VALUE
          self.restYes = true
        end
      end
    end
end

function DialogueBox:update(dt)
  if self.option == 'idol' then
    self.meditateOption = true
  elseif self.option == 'upgrade' then
    --[[
      self:reinit('HELLO WORLD')
      self.aButtonCount = 2
      --]]
  elseif self.option == 'rest' then
    self.restOption = true
  end
  if self.textIndex > 1 then
    blinkTimer = blinkTimer - dt
    if blinkTimer <= 0 then
      blinkTimer = blinkReset
      blinking = blinking == false and true or false
    end
  end

  --TOUCH
  for k in pairs(touches) do
    if buttons[1]:collides(touches[k]) and touches[k].wasTouched then
      self.aButtonCount = self.aButtonCount + 1
      if self.aButtonCount > 1 then
        blinking = true
        blinkTimer = blinkReset
        --END OF PAGE
        if self.currentPage == self.pageLength then
          self.aButtonCount = 0
          treasureChestOption = false
          PAUSED = false
          self.activated = false
          self.finishedPrinting = true
          --MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBoxCollided = {}
          self:flushText()
          self.currentPage = 1
        else
          self.currentPage = self.currentPage + 1
          self.textIndex = 1
        end
      end
    end
  end

  if INPUT:pressed('actionB') then
    self.activated = false
    self:clearAButtonCount()
    gPlayer.showOff = false
    treasureChestOption = false
    for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do
      if v.classType == 'treasureChest' then
        v.showOffItem = false
      end
    end
    PAUSED = false
    self.finishedPrinting = true
    --MAP[sceneView.currentMap.row][sceneView.currentMap.column].dialogueBoxCollided = {}
    self:flushText()
    sceneView.activeDialogueID = nil
    --I THINK THIS IS JUNK TODO CHECK MULTIPAGE DIALOGUE BOXES UP EXITING IF THE RESET CURRENT PAGE
    --[[
    self.currentPage = 1
    if self.meditateOption then
      if self.meditateYes then
        gPlayer.stateMachine:change('player-meditate')
        self.saveDataUtility:savePlayerData()
      else
        --RESET DEFAULT VALUE
        self.meditateYes = true
      end
    end
    --]]
  end

  if INPUT:pressed('action') then
    self.aButtonCount = self.aButtonCount + 1
    if self.aButtonCount > 1 then
      blinking = true
      blinkTimer = blinkReset

      if self.currentPagePrintedCharCount >= self.pages[self.currentPage].pageCharCount then

        if self.restOption then --DIALOGUE BOX FOR REST QUERY
          self.restButtonCount = self.restButtonCount + 1
          if self.restButtonCount == 1 then
            if self.restYes then
              if gPlayer.coinCount < 5 then
                self:reinit('You need 5 coin to rest at this inn... ')
                self:flushText()
                self.activated = true
              else
                sounds['select']:play()
                gPlayer.coinCount = gPlayer.coinCount - INN_REST_COST
                gPlayer.health = DEMO_MAX_HEALTH
                gPlayer.direction = 'down'
                gPlayer.stateMachine:change('player-meditate')
                self:reinit('You took a nap and feel restored. ')
                self:flushText()
                self.activated = true
              end
              goto earlybreak
            else
              self.restButtonCount = 0
              self:reinit('Rest?')
              self:flushText()
              self:clear()
              --[[
              self:reinit('NO')
              self:flushText()
              self.activated = true
              --]]
              goto earlybreak
            end
          elseif self.restButtonCount == 2 then
            self.restButtonCount = 0
            self:reinit('Rest?')
            self:flushText() 
          end

          --[[
          if self.restButtonCount > 1 then
            self:reinit('RESET')
            self:flushText()
            self.aButtonCount = self.aButtonCount + 1
            --self.aButtonCount = 0
            --self.restButtonCount = 0
            goto earlybreak
          end
          --]]


          --END OF PAGE
          if self.currentPage == self.pageLength then
            self.finishedPrinting = true
            self.activated = false
            self:clearAButtonCount()
            treasureChestOption = false
            for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do
              if v.classType == 'treasureChest' then
                v.showOffItem = false
              end
            end
            PAUSED = false
            self:flushText()
            sceneView.activeDialogueID = nil
            self.currentPage = 1
            if self.meditateOption then
              if self.meditateYes then
                gPlayer.stateMachine:change('player-meditate')
                gPlayer.flammeVibrancy = 0
                --self.saveDataUtility:savePlayerData()
              else
                --RESET DEFAULT VALUE
                self.meditateYes = true
              end
            end
          else --MOVE TO NEXT PAGE
            self.currentPage = self.currentPage + 1
            self.lineCount = 1
            self.textIndex = 1
            self.line1Result = ''
            self.line2Result = ''
            self.line3Result = ''
            self.currentPagePrintedCharCount = 0
          end



        else --DEFAULT DIALOGUE OPTION
          --END OF PAGE
          if self.currentPage == self.pageLength then
            self.finishedPrinting = true
            self.activated = false
            self:clearAButtonCount()
            gPlayer.showOff = false
            treasureChestOption = false
            for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do
              if v.classType == 'treasureChest' then
                v.showOffItem = false
              end
            end
            PAUSED = false
            self:flushText()
            sceneView.activeDialogueID = nil
            self.currentPage = 1
            if self.meditateOption then
              if self.meditateYes then
                gPlayer.stateMachine:change('player-meditate')
                gPlayer.flammeVibrancy = 0
                --self.saveDataUtility:savePlayerData()
              else
                --RESET DEFAULT VALUE
                self.meditateYes = true
              end
            end
          else --MOVE TO NEXT PAGE
            self.currentPage = self.currentPage + 1
            self.lineCount = 1
            self.textIndex = 1
            self.line1Result = ''
            self.line2Result = ''
            self.line3Result = ''
            self.currentPagePrintedCharCount = 0
          end
        end
      end
    end

    ::earlybreak::
  end
  --]]

  self.textTimer = self.textTimer + dt
if self.textTimer > self.nextTextTrigger and self.textIndex <= MAX_TEXTBOX_CHAR_LENGTH then
    if self.lineCount == 1 then
      self.line1Result = self.line1Result .. self.pages[self.currentPage][1].string:sub(self.textIndex, self.textIndex)
      self.textIndex = self.textIndex + 1
      self.currentPagePrintedCharCount = self.currentPagePrintedCharCount + 1
      self.textTimer = 0
      if self.textIndex > MAX_TEXTBOX_LINE_LENGTH then
        self.lineCount = 2
        self.textIndex = 1
      end
    end
    if self.lineCount == 2 then
      self.line2Result = self.line2Result .. self.pages[self.currentPage][2].string:sub(self.textIndex, self.textIndex)
      self.textIndex = self.textIndex + 1
      self.currentPagePrintedCharCount = self.currentPagePrintedCharCount + 1
      self.textTimer = 0
      if self.textIndex > MAX_TEXTBOX_LINE_LENGTH then
        self.lineCount = 3
        self.textIndex = 1
      end
    end
    if self.lineCount == 3 then
      self.line3Result = self.line3Result .. self.pages[self.currentPage][3].string:sub(self.textIndex, self.textIndex)
      self.textIndex = self.textIndex + 1
      self.currentPagePrintedCharCount = self.currentPagePrintedCharCount + 1
      self.textTimer = 0
    end
  end

  if self.option == 'idol' then
    if INPUT:pressed('up') or INPUT:pressed('down') then
      self.meditateYes = not self.meditateYes
      sounds['beep']:play()
      blinking = false
      blinkTimer = blinkReset
    end
  end

  if self.option == 'rest' then
    if INPUT:pressed('up') or INPUT:pressed('down') then
      self.restYes = not self.restYes
      sounds['beep']:play()
      blinking = false
      blinkTimer = blinkReset
    end
  end
  ::earlybreak::
end

function DialogueBox:render()
  --if PAUSED then
  if self.restOption then

    local inventoryX = VIRTUAL_WIDTH - 28
    local inventoryY = SCREEN_HEIGHT_LIMIT - 40 - 13
    ---[[
    love.graphics.setColor(1/255, 5/255, 10/255, 255/255)
    love.graphics.rectangle('fill', inventoryX - 15, inventoryY + 1 , VIRTUAL_WIDTH, 40)
    love.graphics.setColor(200/255, 200/255, 200/255, 255/255)
    love.graphics.rectangle('fill', inventoryX - 14, inventoryY + 2, VIRTUAL_WIDTH - 1, 39)
    --]]

    love.graphics.setColor(WHITE)
    love.graphics.draw(coin, inventoryX - 12, inventoryY + 3)
    love.graphics.setColor(BLACK)
    love.graphics.setFont(classicFont)
    love.graphics.print(string.format("%03d", gPlayer.coinCount), inventoryX, inventoryY)
  end

  --BOX COLOR
  love.graphics.setColor(1/255, 5/255, 10/255, 255/255)
  love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT - 40, VIRTUAL_WIDTH, 40)
  love.graphics.setColor(200/255, 200/255, 200/255, 255/255)
  love.graphics.rectangle('fill', 1, SCREEN_HEIGHT_LIMIT - 40 + 1, VIRTUAL_WIDTH - 1, 39)
  love.graphics.setColor(BLACK)

  love.graphics.setFont(pixelFont2)
  love.graphics.print(tostring(self.line1Result), 5, SCREEN_HEIGHT_LIMIT - 38)
  love.graphics.print(tostring(self.line2Result), 5, SCREEN_HEIGHT_LIMIT - 26)
  love.graphics.print(tostring(self.line3Result), 5, SCREEN_HEIGHT_LIMIT - 14)
  if self.meditateOption then
    love.graphics.print('Yes', VIRTUAL_WIDTH - 30, SCREEN_HEIGHT_LIMIT - 38)
    love.graphics.print('No', VIRTUAL_WIDTH - 30, SCREEN_HEIGHT_LIMIT - 14)
  end
  if self.restOption then
    if self.restButtonCount < 1 then
      love.graphics.print('Yes', VIRTUAL_WIDTH - 30, SCREEN_HEIGHT_LIMIT - 38)
      love.graphics.print('No', VIRTUAL_WIDTH - 30, SCREEN_HEIGHT_LIMIT - 14)
    end
  end
  if blinking then
    love.graphics.setColor(1,1,1,0)
  else
    love.graphics.setColor(WHITE)
  end

  --[[
  if not self.meditateOption then
    love.graphics.draw(textAdvance, VIRTUAL_WIDTH - 7, SCREEN_HEIGHT_LIMIT - 4)
  elseif self.meditateOption then
    if self.meditateYes then
      love.graphics.draw(rightArrowSelector, VIRTUAL_WIDTH - 40, SCREEN_HEIGHT_LIMIT - 35)
    else
      love.graphics.draw(rightArrowSelector, VIRTUAL_WIDTH - 40, SCREEN_HEIGHT_LIMIT - 11)
    end
  elseif self.restOption then
    if self.restYes then
      love.graphics.draw(rightArrowSelector, VIRTUAL_WIDTH - 40, SCREEN_HEIGHT_LIMIT - 35)
    else
      love.graphics.draw(rightArrowSelector, VIRTUAL_WIDTH - 40, SCREEN_HEIGHT_LIMIT - 11)
    end

  end

  --]]
  if self.meditateOption then
    if self.meditateYes then
      love.graphics.draw(rightArrowSelector, VIRTUAL_WIDTH - 40, SCREEN_HEIGHT_LIMIT - 35)
    else
      love.graphics.draw(rightArrowSelector, VIRTUAL_WIDTH - 40, SCREEN_HEIGHT_LIMIT - 11)
    end
  elseif self.restOption then
    if self.restButtonCount < 1 then
      if self.restYes then
        love.graphics.draw(rightArrowSelector, VIRTUAL_WIDTH - 40, SCREEN_HEIGHT_LIMIT - 35)
      else
        love.graphics.draw(rightArrowSelector, VIRTUAL_WIDTH - 40, SCREEN_HEIGHT_LIMIT - 11)
      end
    end
  else
    love.graphics.draw(textAdvance, VIRTUAL_WIDTH - 7, SCREEN_HEIGHT_LIMIT - 4)
  end
  --
  --
  --
  --
  --end
  --love.graphics.print('meditateYes: ' .. tostring(self.meditateYes), 0, 0)
  --love.graphics.print('meditateOption: ' .. tostring(self.meditateOption), 0, 10)
  ---[[
  --[[
  love.graphics.setColor(BLUE)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  --]]

  --love.graphics.print('aButton: ' .. tostring(self.aButtonCount), 0, 40)
  --[[
  love.graphics.print('pageLength: ' .. tostring(self.pageLength), 0, 25)
  love.graphics.print('currentPage: ' .. tostring(self.currentPage), 0, 15)
  love.graphics.print('buttonCount: ' .. tostring(self.aButtonCount), 0, 35)
  love.graphics.print('textIndex: ' .. tostring(self.textIndex), 0, 45)
  --]]


  --DIALOGUE DEBUG
  --[[
  love.graphics.print('currentPage: ' .. tostring(self.currentPage), 0, 0)
  love.graphics.print('pageLength: ' .. tostring(self.pageLength), 0, 10)
  love.graphics.print('pageCharCount: ' .. tostring(self.pages[self.currentPage].pageCharCount), 0, 20)
  love.graphics.print('printedPCC: ' .. tostring(self.currentPagePrintedCharCount), 0, 30)
  --love.graphics.print('totalLine: ' .. tostring(self.totalLineCount), 0, 30)
  --]]
end
