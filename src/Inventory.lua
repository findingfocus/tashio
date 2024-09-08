Inventory = Class{}

function Inventory:init()
    self.x = 5
    self.y = 5
    self.rows = 4
    self.columns = 3
    self.itemWidth = 30
    self.itemHeight = 25
    self.width = self.columns * self.itemWidth
    self.height = self.rows * self.itemHeight
    for i = 1, self.rows do
        for k = 1, self.columns do
            INVENTORY_GRID[i][k] = {}
        end
    end
end

function Inventory:update(dt)
    --UPDATE CURSOR

    --IF A PRESSED
        --IF ITEM IN CURSOR INVENTORY GRID?
            --IF ITEM IN ITEMS SLOT?
                --copy into temp variable
                --table.remove current item
                --table.insert selected item
            --IF TEMP VARIABLE
                --PLACE TEMP INTO INVENTORY_GRID

end

function Inventory:render()
    --RENDER CURSOR
    love.graphics.setColor(1,0,0,120/255)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(WHITE)
    love.graphics.print('Hello K_Tronix!', 0, 0)
end
