Player = Class{}

function Player:init()
    --kvothe1 = love.graphics.newImage('/src/pics/kvothe.png')
    self.width = 16
    self.height = 16
    self.atlas = kvothe
    kvotheDown1 = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
    kvotheDown2 = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
    kvotheUp1 = love.graphics.newQuad(16, 0, self.width, self.height, self.atlas:getDimensions())
    kvotheUp2 = love.graphics.newQuad(16, 0, self.width, self.height, self.atlas:getDimensions())
    kvotheLeft1 = love.graphics.newQuad(32, 0, self.width, self.height, self.atlas:getDimensions())
    kvotheLeft2 = love.graphics.newQuad(48, 0, self.width, self.height, self.atlas:getDimensions())
    kvotheRight1 = love.graphics.newQuad(32, 0, self.width, self.height, self.atlas:getDimensions())
    kvotheRight2 = love.graphics.newQuad(48, 0, self.width, self.height, self.atlas:getDimensions())
    self.x = 20
    self.y = 20
    self.dx = VELOCITY
    self.dy = VELOCITY
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

    inputsHeldDown = 0

    if love.keyboard.isDown('right') then
        inputsHeldDown = inputsHeldDown + 1
    end
    if love.keyboard.isDown('left') then
        inputsHeldDown = inputsHeldDown + 1
    end
    if love.keyboard.isDown('up') then
        inputsHeldDown = inputsHeldDown + 1
    end
    if love.keyboard.isDown('down') then
        inputsHeldDown = inputsHeldDown + 1
    end

    if inputsHeldDown == 1 then
        if love.keyboard.isDown('right') then
            self.dx = VELOCITY
            self.x = math.min(self.x + self.dx, VIRTUAL_WIDTH - self.width)
            walkingRight = true
            walkingDown = false
            walkingLeft = false
            walkingUp = false
        end
        if love.keyboard.isDown('left') then
            self.dx = VELOCITY
            self.x = math.max(self.x - self.dx, 0)
            walkingLeft = true
            walkingDown = false
            walkingRight = false
            walkingUp = false
        end
        if love.keyboard.isDown('down') then
            self.dy = VELOCITY
            self.y = math.min(self.y + self.dy, SCREEN_HEIGHT_LIMIT - self.height)
            walkingDown = true
            walkingLeft = false
            walkingRight = false
            walkingUp = false
        end
        if love.keyboard.isDown('up') then
            self.dy = VELOCITY
            self.y = math.max(self.y - self.dy, 0)
            walkingLeft = false
            walkingRight = false
            walkingDown = false
            walkingUp = true
        end
    end

    if love.keyboard.isDown('up') and love.keyboard.isDown('right') then
        if inputsHeldDown == 2 then
            walkingDown = false
            walkingLeft = false
            walkingRight = false
            walkingUp = true
            self.dx = math.sqrt(2) / 2
            self.dy = math.sqrt(2) / 2
            self.x = math.min(self.x + self.dx, VIRTUAL_WIDTH - self.width)
            self.y = math.max(self.y - self.dy, 0)
            --[[
            if self.x / 100 , .5 then
                self.x = math.ceil(self.x)
            else
                self.x = math.floor(self.x)
            end
            if self.y / 100 > .5 then
                self.y = math.ceil(self.y)
            else
                self.y = math.floor(self.y)
            end
            --]]
            --self.x = math.floor(math.min(self.x + self.dx, VIRTUAL_WIDTH - self.width))
            --self.y = math.floor(math.max(self.y - self.dy, 0))
        end
    end
    if love.keyboard.isDown('up') and love.keyboard.isDown('left') then
        if inputsHeldDown == 2 then
            walkingDown = false
            walkingLeft = false
            walkingRight = false
            walkingUp = true
            self.dx = math.sqrt(2) / 2
            self.dy = math.sqrt(2) / 2
            self.x = math.min(self.x - self.dx, VIRTUAL_WIDTH - self.width)
            self.y = math.max(self.y - self.dy, 0)
            --[[
            if self.x / 100 > .5 then
                self.x = math.ceil(self.x)
            else
                self.x = math.floor(self.x)
            end
            if self.y / 100 > .5 then
                self.y = math.ceil(self.y)
            else
                self.y = math.floor(self.y)
            end
            --]]
        end
    end
    if love.keyboard.isDown('down') and love.keyboard.isDown('left') then
        if inputsHeldDown == 2 then
            walkingDown = true
            walkingLeft = false
            walkingRight = false
            walkingUp = false
            self.dx = math.sqrt(2) / 2
            self.dy = math.sqrt(2) / 2
            self.x = math.min(self.x - self.dx, VIRTUAL_WIDTH - self.width)
            self.y = math.max(self.y + self.dy, 0)
            --[[
            if self.x / 100 > .5 then
                self.x = math.ceil(self.x)
            else
                self.x = math.floor(self.x)
            end
            if self.y / 100 > .5 then
                self.y = math.ceil(self.y)
            else
                self.y = math.floor(self.y)
            end
            --]]
        end
    end
    if love.keyboard.isDown('down') and love.keyboard.isDown('right') then
        if inputsHeldDown == 2 then
            walkingDown = true
            walkingLeft = false
            walkingRight = false
            walkingUp = false
            self.dx = math.sqrt(2) / 2
            self.dy = math.sqrt(2) / 2
            self.x = math.min(self.x + self.dx, VIRTUAL_WIDTH - self.width)
            self.y = math.max(self.y + self.dy, 0)
            --[[
            if self.x / 100 > .5 then
                self.x = math.ceil(self.x)
            else
                self.x = math.floor(self.x)
            end
            if self.y / 100 > .5 then
                self.y = math.ceil(self.y)
            else
                self.y = math.floor(self.y)
            end
            --]]
        end
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
end

function Player:render()
    love.graphics.setColor(WHITE)
    if self.frame == 1 then --DOWN LEFT STEP
        love.graphics.draw(self.atlas, kvotheDown1, self.x, self.y, 0, 1, 1)
    elseif self.frame == 2 then --DOWN RIGHT STEP
        love.graphics.draw(self.atlas, kvotheDown2, self.x, self.y, 0, -1, 1, self.width)
    elseif self.frame == 3 then --UP LEFT STEP
        love.graphics.draw(self.atlas, kvotheUp1, self.x, self.y, 0, 1, 1)
    elseif self.frame == 4 then --UP RIGHT STEP
        love.graphics.draw(self.atlas, kvotheUp2, self.x, self.y, 0, -1, 1, self.width)
    elseif self.frame == 5 then --LEFT TALL
        love.graphics.draw(self.atlas, kvotheLeft1, self.x, self.y, 0, 1, 1)
    elseif self.frame == 6 then --LEFT SMALL
        love.graphics.draw(self.atlas, kvotheLeft2, self.x, self.y, 0, 1, 1)
    elseif self.frame == 7 then --RIGHT TALL
        love.graphics.draw(self.atlas, kvotheRight1, self.x, self.y, 0, -1, 1, self.width)
    elseif self.frame == 8 then --RIGHT SMALL
        love.graphics.draw(self.atlas, kvotheRight2, self.x, self.y, 0, -1, 1, self.width)

    end
    love.graphics.print('frame: ' .. tostring(math.floor(self.frame)), 0, 0)
    love.graphics.print('inputs: ' .. tostring(inputsHeldDown), 5, 15)
    love.graphics.print('x: ' .. tostring(self.x), 5, 25)
    love.graphics.print('y: ' .. tostring(self.y), 5, 35)
end
