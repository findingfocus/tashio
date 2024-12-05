Pushable = Class{}

function Pushable:init(x, y, type)
    self.tileX = x
    self.tileY = y
    self.x = (x * TILE_SIZE) - TILE_SIZE
    self.y = (y * TILE_SIZE) - TILE_SIZE
    self.width = TILE_SIZE
    self.height = TILE_SIZE
    self.type = type
    if self.type == 'log' then
        self.image = log
    elseif self.type == 'boulder' then
        self.image = boulder
    end
    self.pushUpInitiated = false
end

function Pushable:pushUp()
    self.pushUpInitiated = true
end

function Pushable:pushDown()
    self.pushDownInitiated = true
end

function Pushable:pushLeft()
    self.pushLeftInitiated = true
end

function Pushable:pushRight()
    self.pushRightInitiated = true
end

function Pushable:update(dt)
    if self.pushUpInitiated then
        local tileAbove = (self.tileY * TILE_SIZE) - TILE_SIZE * 2
        if self.y > tileAbove then
            self.y = self.y - PUSH_SPEED
        else
            self.y = tileAbove
            self.pushUpInitiated = false
            self.tileY = self.tileY - 1
        end
    end

    if self.pushDownInitiated then
        local tileBelow = self.tileY * TILE_SIZE
        if self.y < tileBelow then
            self.y = self.y + PUSH_SPEED
        else
            self.y = tileBelow
            self.pushDownInitiated = false
            self.tileY = self.tileY + 1
        end
    end

    if self.pushLeftInitiated then
        local tileLeft = (self.tileX * TILE_SIZE) - TILE_SIZE * 2
        if self.x > tileLeft then
            self.x = self.x - PUSH_SPEED
        else
            self.x = tileLeft
            self.pushLeftInitiated = false
            self.tileX = self.tileX - 1
        end
    end

    if self.pushRightInitiated then
        local tileRight = self.tileX * TILE_SIZE
        if self.x < tileRight then
            self.x = self.x + PUSH_SPEED
        else
            self.x = tileRight
            self.pushRightInitiated = false
            self.tileX = self.tileX + 1
        end
    end
end

function Pushable:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.setColor(WHITE)
    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    love.graphics.draw(self.image, self.x, self.y)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end
