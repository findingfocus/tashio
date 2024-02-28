Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.lastInput = nil
    self.inputsHeld = 0
    INPUT_LIST = {}
end

function Player:update(dt)
    --POPULATE INPUT LIST
    if love.keyboard.wasPressed('left') then
        table.insert(INPUT_LIST, 'walk-left')
    end
    if love.keyboard.wasPressed('right') then
        table.insert(INPUT_LIST, 'walk-right')
    end
    if love.keyboard.wasPressed('up') then
        table.insert(INPUT_LIST, 'walk-up')
    end
    if love.keyboard.wasPressed('down') then
        table.insert(INPUT_LIST, 'walk-down')
    end

    --REMOVE VALUES FROM INPUT LIST
    if love.keyboard.wasReleased('left') then
        local index = 0
        for k, position in pairs(INPUT_LIST) do
            if position == 'walk-left' then
                index = k
            end
        end
            table.remove(INPUT_LIST, index)
    end
    if love.keyboard.wasReleased('right') then
        local index = 0
        for k, position in pairs(INPUT_LIST) do
            if position == 'walk-right' then
                index = k
            end
        end
            table.remove(INPUT_LIST, index)
    end
    if love.keyboard.wasReleased('up') then
        local index = 0
        for k, position in pairs(INPUT_LIST) do
            if position == 'walk-up' then
                index = k
            end
        end
            table.remove(INPUT_LIST, index)
    end
    if love.keyboard.wasReleased('down') then
        local index = 0
        for k, position in pairs(INPUT_LIST) do
            if position == 'walk-down' then
                index = k
            end
        end
            table.remove(INPUT_LIST, index)
    end


    self.lastInput = INPUT_LIST[#INPUT_LIST]
    if self.lastInput then
        self:changeAnimation(self.lastInput)
    end

    if not sceneView.shifting then
        if love.keyboard.isDown('right') then
            if self.x > VIRTUAL_WIDTH - self.width - EDGE_BUFFER_KVOTHE and self.x + self.width < VIRTUAL_WIDTH then
                Event.dispatch('right-transition')
            end
        end

        if love.keyboard.isDown('left') then
            if self.x < self.width + EDGE_BUFFER_KVOTHE and self.x + self.width > self.width then
                Event.dispatch('left-transition')
            end
        end

        if love.keyboard.isDown('up') then
            if self.y < EDGE_BUFFER_KVOTHE and self.y + self.height > self.height then
                Event.dispatch('up-transition')
            end
        end

        if love.keyboard.isDown('down') then
            if self.y > SCREEN_HEIGHT_LIMIT - self.height - EDGE_BUFFER_KVOTHE and self.y + self.height < SCREEN_HEIGHT_LIMIT then
                Event.dispatch('down-transition')
            end
        end
    end
    --[[
    --CONFLICTING INPUT HANDLING
    if love.keyboard.isDown('left') and love.keyboard.isDown('right') then

    end
    --]]

    Entity.update(self, dt)
end

function Player:collides(target)
    if self.x > target.x + target.width and self.x + self.width < target.x and self.y > target.y + target.height and self.y + self.height < target.y then
        return false
    else
        return true
    end
end

function Player:render()
    Entity.render(self)
end


--[[
--kvotheSpriteSheet = love.graphics.newImage('graphics/kvotheAtlas.png')
kvotheSpriteSheet = love.graphics.newImage('/graphics/kvotheAtlas8.png')
--kvothe1 = love.graphics.newImage('/src/pics/kvothe.png')
--self.width = 16
self.height = 16
self.atlas = kvotheSpriteSheet
--self.quads = GenerateQuads(kvotheSpriteSheet, TILE_SIZE, TILE_SIZE)
--[[
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
--[[
testX = 0
frameAdvance = 0
lastInput = 'down'
walkingUp = false
walkingRight = false
walkingDown = false
walkingLeft = false
--]]






--KVOTHE RENDER
--[[
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
--]]

--[[
inputsHeldDown = 0

if love.keyboard.wasPressed('up') then
    lastInput = 'up'
end
if love.keyboard.wasPressed('down') then
    lastInput = 'down'
end
if love.keyboard.wasPressed('left') then
    lastInput = 'left'
end
if love.keyboard.wasPressed('right') then
    lastInput = 'right'
end

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


--[[
if inputsHeldDown == 1 then
    if love.keyboard.isDown('right') then
        self.dx = VELOCITY
        self.x = math.min(self.x + self.dx, VIRTUAL_WIDTH - OFFSCREEN_BUFFER)
        walkingRight = true
        walkingDown = false
        walkingLeft = false
        walkingUp = false
    end
    if love.keyboard.isDown('left') then
        self.dx = VELOCITY
        self.x = math.max(self.x - self.dx, -self.width + OFFSCREEN_BUFFER)
        walkingLeft = true
        walkingDown = false
        walkingRight = false
        walkingUp = false
    end
    if love.keyboard.isDown('down') then
        self.dy = VELOCITY
        self.y = math.min(self.y + self.dy, SCREEN_HEIGHT_LIMIT - self.height + 1)
        walkingDown = true
        walkingLeft = false
        walkingRight = false
        walkingUp = false
    end
    if love.keyboard.isDown('up') then
        self.dy = VELOCITY
        self.y = math.max(self.y - self.dy, -OFFSCREEN_TOP_BUFFER)
        walkingLeft = false
        walkingRight = false
        walkingDown = false
        walkingUp = true
    end
end

--MULTIPLE INPUT HANDLING
if love.keyboard.isDown('up') and love.keyboard.isDown('right') then
    if inputsHeldDown == 2 then
        if lastInput == 'right' then
            walkingDown = false
            walkingLeft = false
            walkingRight = true
            walkingUp = false
        else
            walkingDown = false
            walkingLeft = false
            walkingRight = false
            walkingUp = true
        end
        NormalizeVector(self)
        self.x = math.min(self.x + self.dx, VIRTUAL_WIDTH - OFFSCREEN_BUFFER)
        self.y = math.max(self.y - self.dy, -OFFSCREEN_TOP_BUFFER)
    end
end
if love.keyboard.isDown('up') and love.keyboard.isDown('left') then
    if inputsHeldDown == 2 then
        if lastInput == 'left' then
            walkingDown = false
            walkingLeft = true
            walkingRight = false
            walkingUp = false
        else
            walkingDown = false
            walkingLeft = false
            walkingRight = false
            walkingUp = true
        end
        NormalizeVector(self)
        self.x = math.max(self.x - self.dx, -self.width + OFFSCREEN_BUFFER)
        self.y = math.max(self.y - self.dy, -OFFSCREEN_TOP_BUFFER)
    end
end
if love.keyboard.isDown('down') and love.keyboard.isDown('left') then
    if inputsHeldDown == 2 then
        if lastInput == 'left' then
            walkingDown = false
            walkingLeft = true
            walkingRight = false
            walkingUp = false
        else
            walkingDown = true
            walkingLeft = false
            walkingRight = false
            walkingUp = false
        end
        NormalizeVector(self)
        self.x = math.max(self.x - self.dx, -self.width + OFFSCREEN_BUFFER)
        self.y = math.min(self.y + self.dy, SCREEN_HEIGHT_LIMIT - self.height)
    end
end
if love.keyboard.isDown('down') and love.keyboard.isDown('right') then
    if inputsHeldDown == 2 then
        if lastInput == 'right' then
            walkingDown = false
            walkingLeft = false
            walkingRight = true
            walkingUp = false
        else
            walkingDown = true
            walkingLeft = false
            walkingRight = false
            walkingUp = false
        end
        NormalizeVector(self)
        self.x = math.min(self.x + self.dx, VIRTUAL_WIDTH - OFFSCREEN_BUFFER)
        self.y = math.min(self.y + self.dy, SCREEN_HEIGHT_LIMIT - self.height)
    end
end

if love.keyboard.isDown('left') and love.keyboard.isDown('right')then
    if lastInput == 'left' then
        walkingDown = false
        walkingLeft = true
        walkingRight = false
        walkingUp = false
    elseif lastInput == 'right' then
        walkingDown = false
        walkingLeft = false
        walkingRight = true
        walkingUp = false
    end
end

if love.keyboard.isDown('up') and love.keyboard.isDown('down')then
    if lastInput == 'up' then
        walkingDown = false
        walkingLeft = false
        walkingRight = false
        walkingUp = true
    elseif lastInput == 'down' then
        walkingDown = true
        walkingLeft = false
        walkingRight = false
        walkingUp = false
    end
end

if not love.keyboard.isDown('up') and not love.keyboard.isDown('left') and not love.keyboard.isDown('right') and not love.keyboard.isDown('down') then
    self.x = math.floor(self.x + 0.5)
    self.y = math.floor(self.y + 0.5)
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
    if not love.keyboard.isDown('right') then
        frameAdvance = frameAdvance + dt
        if frameAdvance > 0.5 then
            frameAdvance = 0
        elseif frameAdvance > 0.25 then
            self.frame = 5
        else
            self.frame = 6
        end
    else
        self.frame =  5
    end
end
if walkingRight then
    if not love.keyboard.isDown('left') then
        frameAdvance = frameAdvance + dt
        if frameAdvance > 0.5 then
            frameAdvance = 0
        elseif frameAdvance > 0.25 then
            self.frame = 7
        else
            self.frame = 8
        end
    else
        self.frame = 7
    end
end

if walkingUp then
    if not love.keyboard.isDown('down') then
        frameAdvance = frameAdvance + dt
        if frameAdvance > 0.5 then
            frameAdvance = 0
        elseif frameAdvance > 0.25 then
            self.frame = 3
        else
            self.frame = 4
        end
    end
end
if walkingDown then
    if not love.keyboard.isDown('up') then
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

if not sceneView.shifting then
    if love.keyboard.isDown('right') then
        if self.x > VIRTUAL_WIDTH - self.width - EDGE_BUFFER_KVOTHE and self.x + self.width < VIRTUAL_WIDTH then
            Event.dispatch('right-transition')
        end
    end

    if love.keyboard.isDown('left') then
        if self.x < self.width + EDGE_BUFFER_KVOTHE and self.x + self.width > self.width then
            Event.dispatch('left-transition')
        end
    end

    if love.keyboard.isDown('up') then
        if self.y < EDGE_BUFFER_KVOTHE and self.y + self.height > self.height then
            Event.dispatch('up-transition')
        end
    end

    if love.keyboard.isDown('down') then
        if self.y > SCREEN_HEIGHT_LIMIT - self.height - EDGE_BUFFER_KVOTHE and self.y + self.height < SCREEN_HEIGHT_LIMIT then
            Event.dispatch('down-transition')
        end
    end
end
--]]
