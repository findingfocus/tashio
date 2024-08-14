SignPost = Class{}

function SignPost:init(x, y, text)
    self.x = x + 1
    self.y = y + 1
    self.width = TILE_SIZE - 2
    self.height = TILE_SIZE - 2
    self.text = text
end

function SignPost:update(dt)

end

function SignPost:render()
    --[[
    love.graphics.setColor(0,1,0,1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    --]]

    if PAUSED then
        love.graphics.setColor(200/255, 200/255, 200/255, 255/255)
        love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT - 40, VIRTUAL_WIDTH, 40)
        love.graphics.setColor(BLACK)
        love.graphics.print(tostring(self.text), 5, SCREEN_HEIGHT_LIMIT - 40)
    end
end
