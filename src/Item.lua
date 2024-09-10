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

local xOffset = 10
local yOffset = 6
local itemWidth = 27
local itemHeight = 30
function Item:update(row, col)
    if row == 1 then
        self.y = yOffset
    else
        self.y = row * itemHeight + yOffset - itemHeight
    end
    --1 = 10
    --2 = 20 - 10 - 10 = 0
    --3 = 30 - 10 - 10 = 10
    --4 = 40 - 10 - 10 = 20

    if col == 1 then
        self.x = xOffset
    else
        self.x = col * itemWidth + xOffset - itemWidth
    end
end

function Item:render()
    love.graphics.setColor(WHITE)
    love.graphics.draw(self.image, self.x, self.y)
    love.graphics.setColor(BLACK)
    love.graphics.print(tostring(self.quantity), self.x + 5, self.y + 5)
end
