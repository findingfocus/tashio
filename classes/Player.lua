Player = Class{}

function Player:init()
    --kvothe1 = love.graphics.newImage('/src/pics/kvothe.png')
    self.width = 16
    self.height = 16
    self.atlas = kvothe
    kvotheQuad = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
    self.x = 20
    self.y = 20
    self.dx = 1
    self.frame = 1
    frameAdvance = 0
    walkingUp = false
    walkingRight = false
    walkingDown = false
    walkingLeft = false
    --FRAME 1 = DOWN LEFT STEP
    --FRAME 2 = DOWN RIGHT STEP
    --FRAME 3 = UP LEFT STEP
    --FRAME 4 = UP RIGHT STEP
    --FRAME 5 = LEFT TALL
    --FRAME 6 = LEFT SMALL
    --FRAME 7 = RIGHT TALL
    --FRAME 8 = RIGHT SMALL
end

function Player:update(dt)
    --[[
    frameAdvance = frameAdvance + dt
    if frameAdvance > 0.3 then
        self.frame = self.frame + 1
        frameAdvance = 0
        if self.frame == 3 then
            self.frame = 1
        end
    end
    --]]

    if love.keyboard.isDown('right') then
        self.x = math.min(self.x + self.dx, VIRTUAL_WIDTH - self.width)
        walkingRight = true
        walkingDown = false
        walkingLeft = false
        walkingUp = false
    end
    if love.keyboard.isDown('left') then
        self.x = math.max(self.x - self.dx, 0)
        walkingLeft = true
        walkingDown = false
        walkingRight = false
        walkingUp = false
    end
    if love.keyboard.isDown('down') then
        self.y = math.min(self.y + self.dx, SCREEN_HEIGHT_LIMIT - self.height)
        walkingDown = true
        walkingLeft = false
        walkingRight = false
        walkingUp = false
    end
    if love.keyboard.isDown('up') then
        self.y = math.max(self.y - self.dx, 0)
        walkingLeft = false
        walkingRight = false
        walkingDown = false
        walkingUp = true
    end

    if not love.keyboard.isDown('up') and not love.keyboard.isDown('down') and not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
        frameAdvance = 0
        if walkingRight then
            self.frame = 7
        elseif walkingLeft then
            self.frame = 5
        elseif walkingUp then
            self.frame = 3
        elseif walkingDown then
            self.frame = 1
        end
        walkingLeft = false
        walkingRight = false
        walkingDown = false
        walkingUp = false
    end

    if walkingLeft then
        frameAdvance = frameAdvance + dt
        if frameAdvance > 0.5 then
            frameAdvance = 0
        elseif frameAdvance > 0.25 then
           self.frame = 5
        else
            self.frame = 6
        end
    end
    if walkingRight then
        frameAdvance = frameAdvance + dt
        if frameAdvance > 0.5 then
            frameAdvance = 0
        elseif frameAdvance > 0.25 then
           self.frame = 7
        else
            self.frame = 8
        end
    end

    if walkingUp then
        frameAdvance = frameAdvance + dt
        if frameAdvance > 0.5 then
            frameAdvance = 0
        elseif frameAdvance > 0.25 then
           self.frame = 3
        else
            self.frame = 4
        end
    end
    if walkingDown then
        frameAdvance = frameAdvance + dt
        if frameAdvance > 0.5 then
            frameAdvance = 0
        elseif frameAdvance > 0.25 then
           self.frame = 1
        else
            self.frame = 2
        end
    end
    --FRAME 1 = DOWN LEFT STEP
    --FRAME 2 = DOWN RIGHT STEP
    --FRAME 3 = UP LEFT STEP
    --FRAME 4 = UP RIGHT STEP
    --FRAME 5 = LEFT TALL
    --FRAME 6 = LEFT SMALL
    --FRAME 7 = RIGHT TALL
    --FRAME 8 = RIGHT SMALL

    if self.frame == 1 then
        kvotheQuad:setViewport(0, 0, self.width, self.height)
    elseif self.frame == 2 then
        kvotheQuad:setViewport(0, 0, self.width, self.height)
    elseif self.frame == 3 then
        kvotheQuad:setViewport(16, 0, self.width, self.height)
    elseif self.frame == 4 then
        kvotheQuad:setViewport(16, 0, self.width, self.height)
    elseif self.frame == 5 then
        kvotheQuad:setViewport(32, 0, self.width, self.height)
    elseif self.frame == 6 then
        kvotheQuad:setViewport(48, 0, self.width, self.height)
    elseif self.frame == 7 then
        kvotheQuad:setViewport(32, 0, self.width, self.height)
    elseif self.frame == 8 then
        kvotheQuad:setViewport(48, 0, self.width, self.height)
    end

end

function Player:render()
    love.graphics.setColor(WHITE)
    if self.frame == 1 then
        love.graphics.draw(self.atlas, kvotheQuad, self.x, self.y, 0, 1, 1)
    elseif self.frame == 2 then
        love.graphics.draw(self.atlas, kvotheQuad, self.x, self.y, 0, -1, 1, self.width)
    elseif self.frame == 3 then
        love.graphics.draw(self.atlas, kvotheQuad, self.x, self.y, 0, 1, 1)
    elseif self.frame == 4 then
        love.graphics.draw(self.atlas, kvotheQuad, self.x, self.y, 0, -1, 1, self.width)
    elseif self.frame == 5 then
        love.graphics.draw(self.atlas, kvotheQuad, self.x, self.y, 0, 1, 1)
    elseif self.frame == 6 then
        love.graphics.draw(self.atlas, kvotheQuad, self.x, self.y, 0, 1, 1)
    elseif self.frame == 7 then
        love.graphics.draw(self.atlas, kvotheQuad, self.x, self.y, 0, -1, 1, self.width)
    elseif self.frame == 8 then
        love.graphics.draw(self.atlas, kvotheQuad, self.x, self.y, 0, -1, 1, self.width)

    end
    love.graphics.print('frame: ' .. tostring(math.floor(self.frame)), 0, 0)
end
