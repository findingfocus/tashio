Inventory = Class{}

function Inventory:init()
    self.x = 5
    self.y = 5
    self.rowAmount= 4
    self.columnAmount = 3
    self.itemWidth = 30
    self.itemHeight = 25
    self.width = self.columnAmount * self.itemWidth
    self.height = self.rowAmount * self.itemHeight
    self.row = {}
    self.column = {}
    self.grid = {}

    for i = 1, self.rowAmount do
        self.grid[i] =  {}
        for k = 1, self.columnAmount do
            self.grid[i][k] = {}
            table.insert(self.grid[i][k], Item())
        end
    end
    --table.remove(self.grid[1][2], 1)

    --[[
    for i = 1, self.rows do
        INVENTORY_GRID[i] = {}
        for k = 1, self.columns do
            INVENTORY_GRID[i][k] = {}
        end
    end
    --]]


    --table.insert(INVENTORY_GRID[1][1], Item(1, 1))
    ---table.insert(INVENTORY_GRID[1][2], Item(1, 2))
    --table.insert(INVENTORY_GRID[1][3], Item(1, 3))
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

    for row = 1, self.rowAmount do
        for col = 1, self.columnAmount do
            if self.grid[row][col][1] ~= nil then
                self.grid[row][col][1]:update(row, col)
            end
        end
    end
end

function Inventory:render()
    --RENDER CURSOR
    love.graphics.setColor(1,1,200/255,255/255)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height + 10)

    for i = 1, self.rowAmount do
        for k = 1, self.columnAmount do
            if self.grid[i][k][1] ~= nil then
                self.grid[i][k][1]:render()
            end
        end
    end
    --[[
    for i = 1, self.rows do
        for k = 1, self.columns do
            if INVENTORY_GRID[i][k][1] ~= nil then
                INVENTORY_GRID[i][k][1]:render()
            end
        end
    end
    --]]
end
