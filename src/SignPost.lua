SignPost = Class{}

function SignPost:init(x, y, text)
    self.x = x + 1
    self.y = y + 1
    self.width = TILE_SIZE - 2
    self.height = TILE_SIZE - 2
    self.text = text
    self.textLength = #text
    self.pageLength = math.ceil(self.textLength / MAX_TEXTBOX_CHAR_LENGTH)
    self.pages = {}
    for i = 1, self.pageLength do
        table.insert(self.pages, {})
        self.pages[i] = 'TEXT'
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
        PAUSED = false
        self.pReleased = false
    end
    self.textTimer = self.textTimer + dt
    if self.textTimer > self.nextTextTrigger and self.textIndex <= self.textLength then
        self.result = self.result .. self.text:sub(self.textIndex, self.textIndex)
        self.textIndex = self.textIndex + 1
        self.textTimer = 0
    end
end

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
    print(Inspect(self.pages))
end
