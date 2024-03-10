Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.lastInput = nil
    self.inputsHeld = 0
end

function Player:update(dt)
    --POPULATE INPUT LIST
    if love.keyboard.wasPressed('left') then
        table.insert(INPUT_LIST, 'left')
    end
    if love.keyboard.wasPressed('right') then
        table.insert(INPUT_LIST, 'right')
    end
    if love.keyboard.wasPressed('up') then
        table.insert(INPUT_LIST, 'up')
    end
    if love.keyboard.wasPressed('down') then
        table.insert(INPUT_LIST, 'down')
    end

    --REMOVE VALUES FROM INPUT LIST
    if love.keyboard.wasReleased('left') then
        local index = 0
        for k, position in pairs(INPUT_LIST) do
            if position == 'left' then
                index = k
            end
        end
            table.remove(INPUT_LIST, index)
    end
    if love.keyboard.wasReleased('right') then
        local index = 0
        for k, position in pairs(INPUT_LIST) do
            if position == 'right' then
                index = k
            end
        end
            table.remove(INPUT_LIST, index)
    end
    if love.keyboard.wasReleased('up') then
        local index = 0
        for k, position in pairs(INPUT_LIST) do
            if position == 'up' then
                index = k
            end
        end
            table.remove(INPUT_LIST, index)
    end
    if love.keyboard.wasReleased('down') then
        local index = 0
        for k, position in pairs(INPUT_LIST) do
            if position == 'down' then
                index = k
            end
        end
            table.remove(INPUT_LIST, index)
    end


    self.lastInput = INPUT_LIST[#INPUT_LIST]
    if self.lastInput then
        self:changeAnimation('walk-' .. self.lastInput)
    end

    if not sceneView.shifting then
        if love.keyboard.isDown('right') then
            if self.x + self.width >= VIRTUAL_WIDTH + EDGE_BUFFER_PLAYER then
                Event.dispatch('right-transition')
            end
        end

        if love.keyboard.isDown('left') then
            if self.x <= -EDGE_BUFFER_PLAYER then
                Event.dispatch('left-transition')
            end
        end

        if love.keyboard.isDown('up') then
            if self.y <= -EDGE_BUFFER_PLAYER then
                Event.dispatch('up-transition')
            end
        end

        if love.keyboard.isDown('down') then
            if self.y + self.height >= SCREEN_HEIGHT_LIMIT then
                Event.dispatch('down-transition')
            end
        end
    end

    Entity.update(self, dt)
end

--[[
function Player:collides(target)
    if self.x > target.x + target.width and self.x + self.width < target.x and self.y > target.y + target.height and self.y + self.height < target.y then
        return false
    else
        return true
    end
end
--]]

function Player:render()
    Entity.render(self)
end
