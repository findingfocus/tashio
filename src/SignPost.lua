SignPost = Class{}

local spaceCount = 0

function SignPost:init(x, y, text)
    self.x = x + 1
    self.y = y + 1
    self.width = TILE_SIZE - 2
    self.height = TILE_SIZE - 2
    self.text = text
    self.textTimer = 0
    self.textLength = #text
    self.textIndex = 1
    self.nextTextTrigger = 0.03
    self.result = ''
    self.line1Result = ''
    self.line2Result = ''
    self.line3Result = ''
    self.pReleased = false
    --self.pageLength = math.ceil(self.textLength / MAX_TEXTBOX_CHAR_LENGTH)
    self.currentPage = 1
    self.pages = {}
    self.totalLineCount = 0
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
    --[[
    self.pages[1][1].string = 'TEST1'
    self.pages[1][2].string = 'TEST2'
    self.pages[1][3].string = 'TEST3'
    --]]
    self.pages[1][1].string = ''
    self.pages[1][2].string = ''
    self.pages[1][3].string = ''

    self.charactersToCheck = true
    self.textIndex = 0
    self.wordIndexGrabbed = false
    printThis = 0

    self.totalLineCount = 1
    self.wordCharacterIndex = 0
    self.wordCharCount = 0
    self.lineCharCount = 0


    while self.charactersToCheck do
        self.textIndex = self.textIndex + 1
        local char = self.text:sub(self.textIndex, self.textIndex)
        if not char:match("%s") then --IF A LETTER
            if not self.wordIndexGrabbed then
                self.wordIndex = self.textIndex
                self.wordIndexGrabbed = true
            end
            self.wordCharCount = self.wordCharCount + 1
            if self.textIndex == self.textLength then
                self.pages[self.pageWeAreOn][self.lineWeAreOn].string = self.pages[self.pageWeAreOn][self.lineWeAreOn].string .. self.text:sub(self.wordIndex, self.wordIndex + self.wordCharCount)
                break
            end
        elseif char:match("%s") then --IF SPACE CHARACTER
            --CHECK IF WORD CAN FIT ON CURRENT LINE
            ---[[
            if self.lineCharCount + self.wordCharCount <= MAX_TEXTBOX_LINE_LENGTH then
                ---[[
                self.pages[self.pageWeAreOn][self.lineWeAreOn].string = self.pages[self.pageWeAreOn][self.lineWeAreOn].string .. self.text:sub(self.wordIndex, self.wordIndex + self.wordCharCount)
                self.wordIndexGrabbed = false
                self.lineCharCount = self.lineCharCount + self.wordCharCount + 1 --SPACE ADDED
                self.wordCharCount = 0
                --]]
            elseif self.lineCharCount + self.wordCharCount > MAX_TEXTBOX_LINE_LENGTH then --INCREMENT LINE NUMBER
                self.lineWeAreOn = self.lineWeAreOn + 1
                self.totalLineCount = self.totalLineCount + 1
                if self.lineWeAreOn > 3 then
                    self.lineWeAreOn = 1
                    self.pageWeAreOn = self.pageWeAreOn + 1
                    self.pages[self.pageWeAreOn] = {}
                    self.pages[self.pageWeAreOn][1] = {}
                    self.pages[self.pageWeAreOn][2] = {}
                    self.pages[self.pageWeAreOn][3] = {}
                    self.pages[self.pageWeAreOn][1].string = ''
                    self.pages[self.pageWeAreOn][2].string = ''
                    self.pages[self.pageWeAreOn][3].string = ''
                end
                self.pages[self.pageWeAreOn][self.lineWeAreOn].string = self.pages[self.pageWeAreOn][self.lineWeAreOn].string .. self.text:sub(self.wordIndex, self.wordIndex + self.wordCharCount)
                self.wordIndexGrabbed = false
                self.lineCharCount = self.wordCharCount
                self.wordCharCount = 0
            end
        end

        if self.textIndex >= self.textLength then
            break
        end
    end
    self.textIndex = 1

    --self.pages[1][1].string = self.text

    --[[
    while charactersToCheck do
        --self.lineCharacterIndex = self.lineCharacterIndex + 1
        local char = self.text:sub(textIndex, textIndex)
        if not char:match("%s") then
            self.inAWord = true
            self.currentWordLength = 0
            if self.inAWord then
                local wordIndex = textIndex
                local wordChar = self.text:sub(wordIndex, wordIndex)
                while not wordChar:match("%s") do
                    self.lineCharacterIndex = self.lineCharacterIndex + 1
                    self.currentWordLength = self.currentWordLength + 1
                    wordIndex = wordIndex + 1
                    wordChar = self.text:sub(wordIndex, wordIndex)
                    if self.lineCharacterIndex > self.textLength then
                        self.inAWord = false
                        charactersToCheck = false
                        break
                    end
                end
                if wordChar:match("%s") then
                    self.inAWord = false
                end

                if self.lineCharacterIndex + self.currentWordLength > 19 then
                    --ADD TO NEXT PAGE
                    ---[[
                    self.lineCharacterIndex = 0
                    self.pageWeAreOn = self.pageWeAreOn + 1
                    self.lineWeAreOn = 1
                    self.pages[self.pageWeAreOn] = {}
                    self.pages[self.pageWeAreOn][1] = {}
                    self.pages[self.pageWeAreOn][2] = {}
                    self.pages[self.pageWeAreOn][3] = {}
                    self.pages[self.pageWeAreOn][1].string = self.text:sub(textIndex, textIndex + self.currentWordLength)
                    self.pages[self.pageWeAreOn][2].string = ''
                    self.pages[self.pageWeAreOn][3].string = ''
                    --i = self.currentWordLength
                else --ADD WHOLE WORD TO CURRENT LINE
                    self.pages[self.pageWeAreOn][self.lineWeAreOn].string = self.pages[self.pageWeAreOn][self.lineWeAreOn].string .. self.text:sub(textIndex, textIndex + self.currentWordLength)
                    --self.lineCharacterIndex = self.lineCharacterIndex + self.currentWordLength
                    --i = i + self.currentWordLength
                end
            end
        end
        textIndex = textIndex + self.currentWordLength
        if textIndex > self.textLength then
            charactersToCheck = false
            break
        end
    end
    --]]

    --self.pages[1][1].string = 'Test1'
    --[[
    self.pages[1][1].string = 'Test 1'
    self.pages[1][2].string = 'Test 2'
    self.pages[1][3].string = 'Test 3'
    --]]
    --TODO CALCULATE TOTALLINECOUNT
    --TODO CALCULATE
    self.pageLength = math.ceil(self.totalLineCount / 3)

    local test = ""
    ---[[
    for i = 1, #test do
        local char = test:sub(i, i)
        if char:match("%s") then
            self.spaceCount = self.spaceCount + 1
        end
    end
    --]]

    --[[
    for i = 1, self.pageLength do
        self.pages[i] = {}
    end
    self.pages[1][1] = {}
    self.pages[1][2] = {}
    self.pages[1][3] = {}
    self.pages[1][1].string = 'This is line 1'
    self.pages[1][1].characterCount = 14
    self.pages[1][2].string = 'This is line 2'
    self.pages[1][2].characterCount = 14
    self.pages[1][3].string = 'This is line 3'
    self.pages[1][2].characterCount = 14
    self.lineCount = 1
    --]]
    --[[
    for i = 1, self.pageLength do
        self.pages[i] = self.text:sub(i * 57 - 56)
    end
    --]]
    --
    --TODO FIX CRASHING UPON EXITING INVENTORY WITH DIALOGUE SYSTEM INITIALIZED
end

function SignPost:flushText()
    self.textIndex = 1
end

function SignPost:update(dt)
    --ADD UNPAUSE IN HERE
    if love.keyboard.wasReleased('p') then
        self.pReleased = true
    --]]
    end
    if love.keyboard.wasPressed('p') and self.pReleased then
        if self.currentPage == self.pageLength then
            PAUSED = false
            self.pReleased = false
            self:flushText()
            self.currentPage = 1
        else
            self.currentPage = self.currentPage + 1
            self.textIndex = 1
        end
    end

    ---[[
    self.textTimer = self.textTimer + dt
    if self.textTimer > self.nextTextTrigger and self.textIndex <= MAX_TEXTBOX_CHAR_LENGTH then
        if self.lineCount == 1 then
            self.line1Result = self.line1Result .. self.pages[self.currentPage][1].string:sub(self.textIndex, self.textIndex)
            self.textIndex = self.textIndex + 1
            self.textTimer = 0
            if self.textIndex > MAX_TEXTBOX_LINE_LENGTH then
                self.lineCount = 2
                self.textIndex = 1
            end
        end
        if self.lineCount == 2 then
            self.line2Result = self.line2Result .. self.pages[self.currentPage][2].string:sub(self.textIndex, self.textIndex)
            self.textIndex = self.textIndex + 1
            self.textTimer = 0
            if self.textIndex > MAX_TEXTBOX_LINE_LENGTH then
                self.lineCount = 3
                self.textIndex = 1
            end
        end
        if self.lineCount == 3 then
            self.line3Result = self.line3Result .. self.pages[self.currentPage][3].string:sub(self.textIndex, self.textIndex)
            self.textIndex = self.textIndex + 1
            self.textTimer = 0
        end
        --[[
        self.result = self.result .. self.pages[self.currentPage]:sub(self.textIndex, self.textIndex)
        self.textIndex = self.textIndex + 1
        self.textTimer = 0
        --]]
    end
    --]]
end

function SignPost:render()
    if PAUSED then
        love.graphics.setColor(1/255, 5/255, 10/255, 255/255)
        love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT - 40, VIRTUAL_WIDTH, 40)
        love.graphics.setColor(200/255, 200/255, 200/255, 255/255)
        love.graphics.rectangle('fill', 1, SCREEN_HEIGHT_LIMIT - 40 + 1, VIRTUAL_WIDTH, 40)
        love.graphics.setColor(BLACK)

        love.graphics.setFont(pixelFont2)
        --love.graphics.printf(tostring(self.result), 5, SCREEN_HEIGHT_LIMIT - 38, VIRTUAL_WIDTH - 5, 'left')
        love.graphics.print(tostring(self.line1Result), 5, SCREEN_HEIGHT_LIMIT - 38)
        love.graphics.print(tostring(self.line2Result), 5, SCREEN_HEIGHT_LIMIT - 26)
        love.graphics.print(tostring(self.line3Result), 5, SCREEN_HEIGHT_LIMIT - 14)
    end
    love.graphics.print('pageLength: ' .. tostring(self.pageLength), 0, 0)
    love.graphics.print('currentPage: ' .. tostring(self.currentPage), 0, 15)
    --love.graphics.print('textLength: ' .. tostring(self.textLength), 0, 25)
    love.graphics.print('textIndex: ' .. tostring(self.textIndex), 0, 35)

    love.graphics.print('lineCharCount: ' .. tostring(self.lineCharCount), 0, 45)
    --love.graphics.print('page1: ' .. tostring(self.pages[2]), 0, 45)
    --love.graphics.print('test: ' .. tostring(textPrint), 0, 35)
    --print(Inspect(self.pages))
end
