Inventory = Class{}
renderCircle = false

function Inventory:init(option)
    self.option = option
    self.elementSlot = {}
    self.elementColor = TRANSPARENT

    if self.option == 'item' then
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
        self.itemSlot = {}
        self.selectedRow = 1
        self.selectedCol = 1
        self.itemCursor = Cursor(self.selectedRow, self.selectedCol, 'item')

        for i = 1, self.rowAmount do
            self.grid[i] =  {}
            for k = 1, self.columnAmount do
                self.grid[i][k] = {}
                table.insert(self.grid[i][k], Item('bag', 9))
            end
        end
        table.remove(self.grid[1][2], 1)
        table.remove(self.grid[1][3], 1)
        table.remove(self.grid[2][2], 1)
        table.remove(self.grid[4][3], 1)
        table.remove(self.grid[4][2], 1)
        self.grid[1][1][1].image = berry
        self.grid[1][1][1].quantity = 20
        self.grid[3][2][1].type = 'lute'
        self.grid[3][2][1].image = lute
        self.grid[3][2][1].quantity = nil
    end
    if self.option == 'keyItem' then
        self.x = VIRTUAL_WIDTH - 40
        self.y = 40
        self.rowAmount= 3
        self.columnAmount = 4
        self.itemWidth = 30
        self.itemHeight = 25
        self.width = self.columnAmount * self.itemWidth
        self.height = self.rowAmount * self.itemHeight
        self.row = {}
        self.column = {}
        self.grid = {}
        self.itemSlot = {}
        self.selectedRow = 2
        self.selectedCol = 1
        self.keyItemCursor = Cursor(self.selectedRow, self.selectedCol, 'keyItem')

        for i = 1, self.rowAmount do
            self.grid[i] =  {}
            for k = 1, self.columnAmount do
                self.grid[i][k] = {}
            end
        end
    end
end

function handleDownInput(self)
    if self.selectedRow ~= self.rowAmount then
        self.selectedRow = self.selectedRow + 1
        if self.option == 'item' then
            self.itemCursor:blinkReset()
        elseif self.option == 'keyItem' then
            self.keyItemCursor:blinkReset()
        end
    end
end

function handleUpInput(self)
    if self.selectedRow ~= 1 then
        self.selectedRow = self.selectedRow - 1
        if self.option == 'item' then
            self.itemCursor:blinkReset()
        elseif self.option == 'keyItem' then
            self.keyItemCursor:blinkReset()
        end
    end
end

function handleLeftInput(self)
    if self.selectedCol ~= 1 then
        self.selectedCol = self.selectedCol -1
        if self.option == 'item' then
            self.itemCursor:blinkReset()
        elseif self.option == 'keyItem' then
            self.keyItemCursor:blinkReset()
        end
    end
end

function handleRightInput(self)
    if self.selectedCol ~= self.columnAmount then
        self.selectedCol = self.selectedCol + 1
        if self.option == 'item' then
            self.itemCursor:blinkReset()
        elseif self.option == 'keyItem' then
            self.keyItemCursor:blinkReset()
        end
    end
end

function Inventory:update(dt)
    if self.option == 'item' then
        for k, v in pairs(touches) do
            if dpad[7]:collides(touches[k]) and touches[k].wasTouched then
                handleDownInput(self)
            end
        end

        if love.keyboard.wasPressed('w') then
            handleUpInput(self)
        end

        if love.keyboard.wasPressed('a') then
            handleLeftInput(self)
        end
        if love.keyboard.wasPressed('s') then
            handleDownInput(self)
        end
        if love.keyboard.wasPressed('d') then
            handleRightInput(self)
        end

        if love.keyboard.wasPressed('p') then
            if self.grid[self.selectedRow][self.selectedCol][1] ~= nil then
                self.grid[self.selectedRow][self.selectedCol][1]:equip() --MOVES SELECTED ITEM TO PROPER LOCATION
                local itemCopy = nil   --COPY ITEM THAT IS EQUIPPED
                if self.itemSlot[1] ~= nil then
                    itemCopy = self.itemSlot[1]
                end
                self.itemSlot = {}
                table.insert(self.itemSlot, self.grid[self.selectedRow][self.selectedCol][1])
                table.remove(self.grid[self.selectedRow][self.selectedCol], 1)
                if itemCopy ~= nil then
                    table.insert(self.grid[self.selectedRow][self.selectedCol], itemCopy)
                end
            end
        end

        --UPDATE CURSOR
        self.itemCursor:update(dt, self.selectedRow, self.selectedCol)

        for row = 1, self.rowAmount do
            for col = 1, self.columnAmount do
                if self.grid[row][col][1] ~= nil then
                    self.grid[row][col][1]:update(row, col)
                end
            end
        end
    elseif self.option == 'keyItem' then
        if love.keyboard.wasPressed('w') then
            handleUpInput(self)
        end
        if love.keyboard.wasPressed('a') then
            handleLeftInput(self)
        end
        if love.keyboard.wasPressed('s') then
            handleDownInput(self)
        end
        if love.keyboard.wasPressed('d') then
            handleRightInput(self)
        end

        if love.keyboard.wasPressed('p') then
            if self.selectedRow == 1 then
                if self.selectedCol == 1 then
                    self.elementSlot = 'fireSpell'
                    self.elementColor = CYAN
                elseif self.selectedCol == 2 then
                    self.elementSlot = 'sandSpell'
                    self.elementColor = YELLOW
                elseif self.selectedCol == 3 then
                    self.elementSlot = 'iceSpell'
                    self.elementColor = WHITE
                elseif self.selectedCol == 4 then
                    self.elementSlot = 'waterSpell'
                    self.elementColor = BLUE
                end
            end
            if self.selectedRow == 2 then
                if self.selectedCol == 1 then
                    gPlayer.greenTunicEquipped = true
                    gPlayer.redTunicEquipped = false
                    gPlayer.yellowTunicEquipped = false
                    gPlayer.blueTunicEquipped = false
                end
                if self.selectedCol == 2 then
                    gPlayer.blueTunicEquipped = true
                    gPlayer.greenTunicEquipped = false
                    gPlayer.redTunicEquipped = false
                    gPlayer.yellowTunicEquipped = false
                end
                if self.selectedCol == 3 then
                    gPlayer.redTunicEquipped = true
                    gPlayer.greenTunicEquipped = false
                    gPlayer.yellowTunicEquipped = false
                    gPlayer.blueTunicEquipped = false
                end
                if self.selectedCol == 4 then
                    gPlayer.yellowTunicEquipped = true
                    gPlayer.greenTunicEquipped = false
                    gPlayer.redTunicEquipped = false
                    gPlayer.blueTunicEquipped = false
                end
            end
        end

        self.keyItemCursor:update(dt, self.selectedRow, self.selectedCol)
    end
end

function Inventory:render(cursorRender)
    love.graphics.setColor(WHITE)
    for i = 1, self.rowAmount do
        for k = 1, self.columnAmount do
            if self.grid[i][k][1] ~= nil then
                self.grid[i][k][1]:render()
            end
        end
    end
    if self.itemSlot[1] ~= nil then
        self.itemSlot[1]:render()
    end

    if cursorRender == 'keyItem' then
        if self.option == 'keyItem' then
            self.keyItemCursor:render()
        end
    elseif cursorRender == 'item' then
        if self.option == 'item' then
            self.itemCursor:render()
        end
    end

    love.graphics.setColor(self.elementColor)
    love.graphics.circle('fill', VIRTUAL_WIDTH - 86, VIRTUAL_HEIGHT - 8, 6)
end
