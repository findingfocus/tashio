Scene = Class{}

function Scene:init(player, mapRow, mapColumn)
    self.player = player
    self.mapRow = mapRow
    self.mapColumn = mapColumn
    self.currentMap = Map(mapRow, mapColumn)
    self.nextMap = nil
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false
    self.entities = {}
    ---[[
    for i = 1, 800 do
        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS['gecko'].animations,
            x = math.random(VIRTUAL_WIDTH),
            y = math.random(SCREEN_HEIGHT_LIMIT, SCREEN_HEIGHT_LIMIT + 500),
            width = TILE_SIZE,
            height = TILE_SIZE,
        })

        self.entities[i].direction = 'up'

        self.entities[i].stateMachine = StateMachine {
            ['entity-walk'] = function() return EntityWalkState(self.entities[i], self) end,
            ['entity-idle'] = function() return EntityIdleState(self.entities[i]) end,
        }

        self.entities[i]:changeState('entity-walk')
    end

    --[[
    self.gecko.stateMachine = StateMachine {
        ['entity-walk'] = function() return EntityWalkState(self.gecko, self.scene) end,
        ['entity-idle'] = function() return EntityIdleState(self.gecko) end,
    }
    self.gecko.direction = 'up'
    self.gecko:changeState('entity-walk')
    --]]
    --table.insert(self.entities, self.gecko)

    Event.on('left-transition', function()
        if self.currentMap.column ~= 1 then
            self.nextMap = Map(self.currentMap.row, self.currentMap.column - 1)
            self:beginShifting(-VIRTUAL_WIDTH, 0)
        end
    end)
    Event.on('right-transition', function()
        if self.currentMap.column ~= OVERWORLD_MAP_WIDTH then
            self.nextMap = Map(self.currentMap.row, self.currentMap.column + 1)
            self:beginShifting(VIRTUAL_WIDTH, 0)
        end
    end)
    Event.on('up-transition', function()
        if self.currentMap.row ~= 1 then
            self.nextMap = Map(self.currentMap.row - 1, self.currentMap.column)
            self:beginShifting(0, -VIRTUAL_HEIGHT)
        end
    end)
    Event.on('down-transition', function()
        if self.currentMap.row ~= OVERWORLD_MAP_HEIGHT then
            self.nextMap = Map(self.currentMap.row + 1, self.currentMap.column)
            self:beginShifting(0, VIRTUAL_HEIGHT)
        end
    end)
end

function Scene:beginShifting(shiftX, shiftY)
    self.shifting = true
    self.nextMap.adjacentOffsetY = shiftY
    self.nextMap.adjacentOffsetX = shiftX

    ---[[
    if shiftX < 0 then --WHERE PLAYER ENDS UP ON SCREEN
        playerX = VIRTUAL_WIDTH - self.player.width - EDGE_BUFFER_PLAYER
        playerY = self.player.y
        --self.nextMap = MAP[1][2] --CHANGE TO BE ARITHMETIC INSTEAD OF HARD CODED
    elseif shiftX > 0 then
        playerX = EDGE_BUFFER_PLAYER
        playerY = self.player.y
    elseif shiftY < 0 then -- SHIFT UP
        self.nextMap.adjacentOffsetY = self.nextMap.adjacentOffsetY + 16
        shiftY = shiftY + 16
        playerY = SCREEN_HEIGHT_LIMIT - self.player.height - EDGE_BUFFER_PLAYER
        playerX = self.player.x
    elseif shiftY > 0 then -- SHIFT DOWN
        self.nextMap.adjacentOffsetY = self.nextMap.adjacentOffsetY - 16
        shiftY = shiftY- 16
        playerY = EDGE_BUFFER_PLAYER
        playerX = self.player.x
    end


    Timer.tween(0.9, {
        [self] = {cameraX = shiftX, cameraY = shiftY},
        [self.player] = {x = math.floor(playerX), y = math.floor(playerY)}
    }):finish(function()

        self:finishShifting()
     end)
end

function Scene:finishShifting()
    self.shifting = false
    self.cameraX = 0
    self.cameraY = 0
    self.nextMap.adjacentOffsetX = 0
    self.nextMap.adjacentOffsetY = 0
    self.currentMap = self.nextMap
    self.nextMap = nil
    self.player.direction = INPUT_LIST[#INPUT_LIST]
    INPUT_LIST = {}
    ---[[
    if love.keyboard.isDown('left') then
        table.insert(INPUT_LIST, 'left')
    end
    if love.keyboard.isDown('right') then
        table.insert(INPUT_LIST, 'right')
    end
    if love.keyboard.isDown('up') then
        table.insert(INPUT_LIST, 'up')
    end
    if love.keyboard.isDown('down') then
        table.insert(INPUT_LIST, 'down')
    end
    --]]
end

function Scene:update(dt)
    self.currentMap:update(dt)
    if not self.shifting then
        self.player:update(dt)
    end

    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]
        if not self.entities.offscreen then
            entity:update(dt)
        end
    end

    --self.gecko:update(dt)
    --[[
    if self.gecko.offscreen == true then
        table.remove(self.entities, 1)
    end
    --]]
end

function Scene:render()
    love.graphics.setColor(WHITE)
    love.graphics.push()
    if self.shifting then
        love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    end

    self.currentMap:render()

    if self.nextMap then
        self.nextMap:render()
    end
    love.graphics.pop()

    if self.player then
        self.player:render()
    end

    for k, entity in pairs(self.entities) do
        if not entity.offscreen then
            entity:render()
        end
    end
    --[[
    if self.gecko then
        self.gecko:render()
    end
    --]]
    --love.graphics.print('gOffScreen: ' .. tostring(self.gecko.offscreen), 5, 50)
    love.graphics.print('Entity#: ' .. tostring(#self.entities), 5, 60)
end
