Item = Class{}

function Item:init(row, col)
    self.gridRow = row
    self.gridCol = col
    self.image = love.graphics.newImage('graphics/bag.png')
    self.quantity = 20
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
end

function Item:update(dt)

end

function Item:render()
    love.graphics.setColor(WHITE)
    love.graphics.draw(self.image, self.x, self.y)
    love.graphics.print(tostring(self.quantity), self.x, self.y)
end
