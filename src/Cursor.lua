Cursor = Class{}

function Cursor:init(x, y)
    self.image = love.graphics.newImage('/graphics/itemCursor.png')
    self.x = x
    self.y = y
    self.blinkTimer = 0
    self.visible = true
    --PROSTO HACK
    --[[
    visible = timer % blinkDuration < (blinkDuration / 2)
    --]]
end

function Cursor:blinkReset()
    self.blinkTimer = 0
    self.visible = true
end

function Cursor:update(dt, row, col)
    self.blinkTimer = self.blinkTimer + dt

    if self.blinkTimer > 1 then
        if self.visible then
            self.visible = false
        else
            self.visible = true
        end
        self.blinkTimer = 0
    end

    if row == 1 then
        self.y = GRID_YOFFSET
    else
        self.y = row * GRID_ITEM_HEIGHT + GRID_YOFFSET - GRID_ITEM_HEIGHT
    end
    if col == 1 then
        self.x = GRID_XOFFSET
    else
        self.x = col * GRID_ITEM_WIDTH + GRID_XOFFSET - GRID_ITEM_WIDTH
    end

end

function Cursor:render()
    if self.visible then
        love.graphics.draw(self.image, self.x, self.y)
    end
end


