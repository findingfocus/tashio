Player = Class{__includes = Entity}

local heartSpeed = 0.5
local counter = 0
local safeCounter = 0

function Player:init(def)
    Entity.init(self, def)
    self.lastInput = nil
    self.inputsHeld = 0
    self.health = 14
    self.heartTimer = heartSpeed
    self.decrement = true
    self.dead = false
    self.checkPointPositions = {x = 0, y = 0}
    self.safeFromFall = false
end

function updateHearts(player)
    healthDifference = totalHealth - player.health
    HEART_CROP = 56 - (4 * healthDifference)
end

function Player:update(dt)
    counter = counter + dt
    if counter > 3 then
        self.checkPointPositions.x = self.x
        self.checkPointPositions.y = self.y
        counter = 0
    end
    if self.safeFromFall then
        safeCounter = safeCounter + dt
        if safeCounter > 3 then
            self.safeFromFall = false
            safeCounter = 0
        end
    end

    --PLAYER DEATH
    if self.health <= 0 and not self.dead then
        sounds['death']:play()
        self.dead = true
    end
    --TODO
    healthDifference = totalHealth - self.health
    HEART_CROP = math.max(56 - (4 * healthDifference), 0)
    --[[
    if self.heartTimer > 0 then
        self.heartTimer = self.heartTimer - dt
    end
    if self.heartTimer < 0 and self.decrement then
        self.heartTimer = heartSpeed
        if self.health == 1 then
            self.decrement = false
            self.health = self.health + 1
            updateHearts(self)
        else
            self.health = self.health - 1
            updateHearts(self)
        end
    end

    if self.heartTimer < 0 and not self.decrement then
        self.heartTimer = heartSpeed
        if self.health == 14 then
            self.decrement = true
            self.health = self.health - 1
            updateHearts(self)
        else
            self.health = self.health + 1
            updateHearts(self)
        end
    end
    --]]
    --POPULATE INPUT LIST
    if love.keyboard.isDown('left') then
        local inputCount = 0 
        for k, v in pairs(INPUT_LIST) do
            if v == 'left' then
               inputCount = inputCount + 1
            end
        end
        if inputCount == 0 then
          table.insert(INPUT_LIST, 'left')
        end
    end
    if love.keyboard.isDown('right') then
        local inputCount = 0 
        for k, v in pairs(INPUT_LIST) do
            if v == 'right' then
               inputCount = inputCount + 1
            end
        end
        if inputCount == 0 then
          table.insert(INPUT_LIST, 'right')
        end

    end
    if love.keyboard.isDown('up') then
        local inputCount = 0 
        for k, v in pairs(INPUT_LIST) do
            if v == 'up' then
               inputCount = inputCount + 1
            end
        end
        if inputCount == 0 then
          table.insert(INPUT_LIST, 'up')
        end
    end
    if love.keyboard.isDown('down') then
        local inputCount = 0 
        for k, v in pairs(INPUT_LIST) do
            if v == 'down' then
               inputCount = inputCount + 1
            end
        end
        if inputCount == 0 then
          table.insert(INPUT_LIST, 'down')
        end
    end

    --REMOVE VALUES FROM INPUT LIST
    if love.keyboard.wasReleased('left') then
        local index = 0
        for k, position in pairs(INPUT_LIST) do
            if position == 'left' then
                index = k
            end
            table.remove(INPUT_LIST, index)
        end
    end
    if love.keyboard.wasReleased('right') then
        local index = 0
        for k, position in pairs(INPUT_LIST) do
            if position == 'right' then
                index = k
            end
            table.remove(INPUT_LIST, index)
        end
    end
    if love.keyboard.wasReleased('up') then
        local index = 0
        for k, position in pairs(INPUT_LIST) do
            if position == 'up' then
                index = k
            end
            table.remove(INPUT_LIST, index)
        end
    end
    if love.keyboard.wasReleased('down') then
        local index = 0
        for k, position in pairs(INPUT_LIST) do
            if position == 'down' then
                index = k
            end
            table.remove(INPUT_LIST, index)
        end
    end

    self.lastInput = INPUT_LIST[#INPUT_LIST]


    if self.lastInput then
        self:changeAnimation('walk-' .. self.lastInput)
    end

    --TRANSITION EVENT TRIGGERS
    if not sceneView.shifting then
        if love.keyboard.isDown('right') then
            if self.x + self.width >= VIRTUAL_WIDTH + SIDE_EDGE_BUFFER_PLAYER then
                Event.dispatch('right-transition')
            end
        end

        if love.keyboard.isDown('left') then
            if self.x <= -SIDE_EDGE_BUFFER_PLAYER then
                Event.dispatch('left-transition')
            end
        end

        if love.keyboard.isDown('up') then
            if self.y <= -SIDE_EDGE_BUFFER_PLAYER then
                Event.dispatch('up-transition')
            end
        end

        if love.keyboard.isDown('down') then
            if self.y + self.height >= SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER then
                Event.dispatch('down-transition')
            end
        end
    end
    Entity.update(self, dt)
end

function Player:render()
    Entity.render(self)
end
