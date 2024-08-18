SignPost = Class{}

function SignPost:init(x, y, text)
    self.x = x + 1
    self.y = y + 1
    self.width = TILE_SIZE - 2
    self.height = TILE_SIZE - 2
    self.text = text
    self.textLength = #text
    self.textIndex = 1
    self.textTimer = 0
    self.nextTextTrigger = 0.04
    self.result = ''
    self.lineCount = 1
    self.lines = {'', '', ''}
    self.lineIndex = 1
end

function SignPost:flushText()
    self.lines = {'', '', ''}
    self.lineIndex = 1
    self.textIndex = 1
end

function SignPost:update(dt)
    ---[[
    self.textTimer = self.textTimer + dt
    if self.textTimer > self.nextTextTrigger and self.textIndex <= self.textLength then
        self.result = self.result .. self.text:sub(self.textIndex, self.textIndex)
        self.lines[self.lineIndex] = self.lines[self.lineIndex] .. self.text:sub(self.textIndex, self.textIndex)
        self.textIndex = self.textIndex + 1
        --self.textTimer = 0
    end
    ---[[
    if self.textIndex == self.textLength and self.lineIndex < 3 then
        --self.lineIndex = self.lineIndex + 1
        --self.textIndex = 1
        --self.result = ''
    end
    --]]

    --UPON FINDING A WORD, **IF CURRENT CHAR IS NOT SPACE, COUNT CHARS UNTIL SPACE
    --IF END OF THAT WORD + THE CURRENT RESULT STRING HAS WIDTH LONGER THAN TXTBOX LIMIT
        -- add newline
    --ADD ONE CHARACTER TO THE RESULT STRING
end

function SignPost:render()
    --[[
    love.graphics.setColor(0,1,0,1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    --]]
    --
    local test = 'HELLO TEST'
    --love.graphics.print(self.lines[3], 0, 0)

    if PAUSED then
        love.graphics.setColor(1/255, 5/255, 10/255, 255/255)
        love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT - 40, VIRTUAL_WIDTH, 40)
        love.graphics.setColor(200/255, 200/255, 200/255, 255/255)
        love.graphics.rectangle('fill', 1, SCREEN_HEIGHT_LIMIT - 40 + 1, VIRTUAL_WIDTH, 40)
        love.graphics.setColor(BLACK)

        love.graphics.printf(tostring(self.result), 5, SCREEN_HEIGHT_LIMIT - 40, VIRTUAL_WIDTH - 5, 'left')
        --[[
        if self.lineIndex == 1 then
            love.graphics.print(tostring(self.lines[self.lineIndex]), 5, SCREEN_HEIGHT_LIMIT - 51 + 1 * TEXT_LINE_YOFFSET)
          end
        elseif self.lineIndex == 2 then
            love.graphics.print(tostring(self.lines[1]), 5, SCREEN_HEIGHT_LIMIT - 51 + 1 * TEXT_LINE_YOFFSET)
            love.graphics.print(tostring(self.lines[self.lineIndex]), 5, SCREEN_HEIGHT_LIMIT - 51 + 2 * TEXT_LINE_YOFFSET)
        elseif self.lineIndex == 3 then
            love.graphics.print(tostring(self.lines[1]), 5, SCREEN_HEIGHT_LIMIT - 51 + 1 * TEXT_LINE_YOFFSET)
            love.graphics.print(tostring(self.lines[2]), 5, SCREEN_HEIGHT_LIMIT - 51 + 2 * TEXT_LINE_YOFFSET)
            love.graphics.print(tostring(self.lines[self.lineIndex]), 5, SCREEN_HEIGHT_LIMIT - 51 + 3 * TEXT_LINE_YOFFSET)
        end
        --]]
    end
end
