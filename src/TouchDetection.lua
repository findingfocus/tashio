TouchDetection = Class{}

function TouchDetection:init(placementX, placementY, colorOption)
    self.mouseX = 0
    self.mouseY = 0
    self.width = DPAD_DIAGONAL_WIDTH
    self.height = DPAD_DIAGONAL_WIDTH
    self.color = colorOption
    self.pressed = false
    self.x = placementX
    self.y = placementY

end

function TouchDetection:collides()
    if self.x * SCALE_FACTOR < mouseX and (self.x + self.width) * SCALE_FACTOR > mouseX and
        self.y * SCALE_FACTOR < mouseY and (self.y + self.height) * SCALE_FACTOR > mouseY then
            return true
    else
        return false
    end
end

function TouchDetection:update(dt)
    self.mouseX = mouseX
    self.mouseY = mouseY
end

function TouchDetection:render()
    if self.pressed then
        love.graphics.setColor(self.color)
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end
end
