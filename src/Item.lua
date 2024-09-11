Item = Class{}

function Item:init()
    --self.gridRow = row
    --self.gridCol = col
    self.image = love.graphics.newImage('graphics/bag.png')
    self.quantity = 20
    self.x = 0
    self.y = 0
    --[[
    if self.gridRow == 1 then
        self.y = INVENTORY_XOFFSET
    else
        self.y = self.gridRow * 25
    end
    if self.gridCol == 1 then
        self.x = INVENTORY_XOFFSET
    else
        self.x = self.gridCol * 25
    end
    --]]
end

function Item:update(row, col)
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

function Item:render()
    love.graphics.setColor(WHITE)
    love.graphics.draw(self.image, self.x + 5, self.y + 5)

    love.graphics.setColor(BLACK)
    love.graphics.print(tostring(self.quantity), self.x + 9, self.y + 9)
    love.graphics.setColor(WHITE)
    love.graphics.print(tostring(self.quantity), self.x + 8, self.y + 8)
end
