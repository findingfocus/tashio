SignPost = Class{}

function SignPost:init(x, y, text)
    self.x = x + 1
    self.y = y + 1
    self.width = TILE_SIZE - 2
    self.height = TILE_SIZE - 2
    self.text = text
    self.textLength = #text
    self.pageLength = math.ceil(self.textLength / MAX_TEXTBOX_CHAR_LENGTH)
    self.currentPage = 1
    self.pages = {}
    for i = 1, self.pageLength do
        self.pages[i] = self.text:sub(i * 57 - 56)
    end
    self.textIndex = 1
    self.textTimer = 0
    self.nextTextTrigger = 0.03
    self.result = ''
    self.pReleased = false
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
        self.result = self.result .. self.pages[self.currentPage]:sub(self.textIndex, self.textIndex)
        self.textIndex = self.textIndex + 1
        self.textTimer = 0
    end
    --]]
end

--[[
local testText = '12345'
local textPrint = testText:sub(4)
--]]

function SignPost:render()
    if PAUSED then
        love.graphics.setColor(1/255, 5/255, 10/255, 255/255)
        love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT - 40, VIRTUAL_WIDTH, 40)
        love.graphics.setColor(200/255, 200/255, 200/255, 255/255)
        love.graphics.rectangle('fill', 1, SCREEN_HEIGHT_LIMIT - 40 + 1, VIRTUAL_WIDTH, 40)
        love.graphics.setColor(BLACK)

        love.graphics.setFont(pixelFont2)
        love.graphics.printf(tostring(self.result), 5, SCREEN_HEIGHT_LIMIT - 38, VIRTUAL_WIDTH - 5, 'left')
    end
    love.graphics.print('pageLength: ' .. tostring(self.pageLength), 0, 0)
    love.graphics.print('currentPage: ' .. tostring(self.currentPage), 0, 15)
    love.graphics.print('textLength: ' .. tostring(self.textLength), 0, 25)
    love.graphics.print('textIndex: ' .. tostring(self.textIndex), 0, 35)
    --love.graphics.print('page1: ' .. tostring(self.pages[2]), 0, 45)
    --love.graphics.print('test: ' .. tostring(textPrint), 0, 35)
    --print(Inspect(self.pages))
end
