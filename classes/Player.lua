Player = Class{}

function Player:init()
    kvothe1 = love.graphics.newImage('/src/pics/kvothe.png')
    self.width = 16
    self.height = 16
    self.x = 0
    self.y = 0
    self.dx = 1
end

function Player:update(dt)
    if love.keyboard.isDown('right') then
        self.x = math.min(self.x + self.dx, VIRTUAL_WIDTH - self.width)
    end
    if love.keyboard.isDown('left') then
        self.x = math.max(self.x - self.dx, 0)
    end
    if love.keyboard.isDown('down') then
        self.y = math.min(self.y + self.dx, SCREEN_HEIGHT_LIMIT - self.height)
    end
    if love.keyboard.isDown('up') then
        self.y = math.max(self.y - self.dx, 0)
    end
end

function Player:render()
    love.graphics.setColor(WHITE)
    love.graphics.draw(kvothe1, self.x, self.y)
end
