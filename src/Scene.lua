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
    self.spellcastEntities = {}
    self.possibleDirections = {'left', 'right', 'up', 'down'}
    local flameCount = 3
    time = 0
    for i = 1, flameCount do
        table.insert(self.spellcastEntities, Entity {
            animations = ENTITY_DEFS['spellcast'].animations,
            x = 25,
            y = 25,
            width = TILE_SIZE,
            height = TILE_SIZE,
        })
        self.spellcastEntities[i].stateMachine = StateMachine {
            ['flame-idle'] = function() return FlameIdle(self.spellcastEntities[i], self) end,
        }
        self.spellcastEntities[i]:changeState('flame-idle')
    end

    for i = 1, 12 do
        local randomIndex = math.random(4)
        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS['gecko'].animations,
            x = math.random(VIRTUAL_WIDTH / 2 - 20, VIRTUAL_WIDTH / 2 + 20),
            y = math.random(VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_HEIGHT / 2 + 20),
            width = TILE_SIZE,
            height = TILE_SIZE,
        })

        self.entities[i].direction = self.possibleDirections[randomIndex]

        self.entities[i].stateMachine = StateMachine {
            ['entity-walk'] = function() return EntityWalkState(self.entities[i], self) end,
            ['entity-idle'] = function() return EntityIdleState(self.entities[i]) end,
        }

        self.entities[i]:changeState('entity-walk')
    end

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
    self.currentMap.collidableMapObjects = {}
    self.shifting = true
    self.nextMap.adjacentOffsetY = shiftY
    self.nextMap.adjacentOffsetX = shiftX

    ---[[
    if shiftX < 0 then --WHERE PLAYER ENDS UP ON SCREEN
        playerX = VIRTUAL_WIDTH - self.player.width
        playerY = self.player.y
        --self.nextMap = MAP[1][2] --CHANGE TO BE ARITHMETIC INSTEAD OF HARD CODED
    elseif shiftX > 0 then
        playerX = 0
        playerY = self.player.y
    elseif shiftY < 0 then -- SHIFT UP
        self.nextMap.adjacentOffsetY = self.nextMap.adjacentOffsetY + 16
        shiftY = shiftY + 16
        playerY = SCREEN_HEIGHT_LIMIT - self.player.height
        playerX = self.player.x
    elseif shiftY > 0 then -- SHIFT DOWN
        self.nextMap.adjacentOffsetY = self.nextMap.adjacentOffsetY - 16
        shiftY = shiftY- 16
        playerY = 0
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

    for i = 1, 3 do
        self.spellcastEntities[i]:update(dt)
    end

    for i = 1, #self.currentMap.collidableMapObjects do
        local object = self.currentMap.collidableMapObjects[i]

        if self.player:leftCollidesMapObject(self.currentMap.collidableMapObjects[i]) then
            self.player.x = object.x + object.width - 1
        end
        if self.player:rightCollidesMapObject(self.currentMap.collidableMapObjects[i]) then
            self.player.x = object.x - self.player.width + 1
        end
        if self.player:topCollidesMapObject(self.currentMap.collidableMapObjects[i]) then
            self.player.y = object.y + object.height - 6
        end
        if self.player:bottomCollidesMapObject(self.currentMap.collidableMapObjects[i]) then
            self.player.y = object.y - self.player.height
        end
    end
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

    --self.spellcastEntities[1]:render()
    for i = 1, flameCount do
        self.spellcastEntities[i]:render()
    end
    love.graphics.setFont(classicFont)
    ---[[
    --]]
    --[[
    for i = 1, #self.currentMap.collidableMapObjects do
        if self.player:topCollides(self.currentMap.collidableMapObjects[i]) then
            love.graphics.setColor(RED)
            love.graphics.rectangle('fill', self.player.x + 2, self.player.y, TILE_SIZE - 4, 2)
        end
        if self.player:bottomCollides(self.currentMap.collidableMapObjects[i]) then
            love.graphics.setColor(RED)
            love.graphics.rectangle('fill', self.player.x + 2, self.player.y + self.player.height - COLLISION_BUFFER, TILE_SIZE - 4, 2)
        end
        if self.player:leftCollides(self.currentMap.collidableMapObjects[i]) then
            love.graphics.setColor(RED)
            love.graphics.rectangle('fill', self.player.x, self.player.y + COLLISION_BUFFER, 2, TILE_SIZE - 4)
        end
        if self.player:rightCollides(self.currentMap.collidableMapObjects[i]) then
            love.graphics.setColor(RED)
            love.graphics.rectangle('fill', self.player.x + self.player.width - COLLISION_BUFFER, self.player.y + COLLISION_BUFFER, 2, TILE_SIZE - 4)
        end
    end
    --]]
end
