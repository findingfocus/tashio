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
end

function SignPost:update(dt)
    self.textTimer = self.textTimer + dt
    if self.textTimer > self.nextTextTrigger and self.textIndex <= self.textLength then
        self.result = self.result .. self.text:sub(self.textIndex, self.textIndex)
        self.textIndex = self.textIndex + 1
        self.textTimer = 0
    end
end

function SignPost:render()
    --[[
    love.graphics.setColor(0,1,0,1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    --]]

    if PAUSED then
        love.graphics.setColor(1/255, 5/255, 10/255, 255/255)
        love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT - 40, VIRTUAL_WIDTH, 40)
        love.graphics.setColor(200/255, 200/255, 200/255, 255/255)
        love.graphics.rectangle('fill', 1, SCREEN_HEIGHT_LIMIT - 40 + 1, VIRTUAL_WIDTH, 40)
        love.graphics.setColor(BLACK)
        love.graphics.printf(tostring(self.result), 5, SCREEN_HEIGHT_LIMIT - 40, VIRTUAL_WIDTH - 5, 'left')
    end
end
