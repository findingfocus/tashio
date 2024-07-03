Scene = Class{}

local TIME = 0
local SPEED = 3
local PLAYER_OFFSET = TILE_SIZE / 2
local AMP = 20
local TRANSITION_SPEED = 0.65
local spellcastEntityCount = 5
local count = spellcastEntityCount
local step = math.pi * 2 / count

function Scene:init(player, mapRow, mapColumn)
    self.player = player
    self.mapRow = mapRow
    self.mapColumn = mapColumn
    self.currentMap = Map(mapRow, mapColumn, spellcastEntityCount)
    --self.nextMap = Map(mapRow, mapColumn, spellcastEntityCount)
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false
    self.entities = {}
    self.spellcastEntityCount = spellcastEntityCount
    self.spellcastEntities = {}
    self.possibleDirections = {'left', 'right', 'up', 'down'}
    for i = 1, self.spellcastEntityCount do
        table.insert(self.spellcastEntities, Entity {
            animations = ENTITY_DEFS['spellcast'].animations,
            x = 25,
            y = 25,
            width = TILE_SIZE,
            height = TILE_SIZE,
            type = 'spellcast',
        })
        self.spellcastEntities[i].stateMachine = StateMachine {
            ['flame-idle'] = function() return FlameIdle(self.spellcastEntities[i], self, spellcastEntityCount) end,
        }
        self.spellcastEntities[i]:changeState('flame-idle')
    end

    Event.on('left-transition', function()
        if self.currentMap.column ~= 1 then
            self.nextMap = Map(self.currentMap.row, self.currentMap.column - 1, spellcastEntityCount)
            self:beginShifting(-VIRTUAL_WIDTH, 0)
        end
    end)
    Event.on('right-transition', function()
        if self.currentMap.column ~= OVERWORLD_MAP_WIDTH then
            self.nextMap = Map(self.currentMap.row, self.currentMap.column + 1, spellcastEntityCount)
            self:beginShifting(VIRTUAL_WIDTH, 0)
        end
    end)
    Event.on('up-transition', function()
        if self.currentMap.row ~= 1 then
            self.nextMap = Map(self.currentMap.row - 1, self.currentMap.column, spellcastEntityCount)
            self:beginShifting(0, -VIRTUAL_HEIGHT)
        end
    end)
    Event.on('down-transition', function()
        if self.currentMap.row ~= OVERWORLD_MAP_HEIGHT then
            self.nextMap = Map(self.currentMap.row + 1, self.currentMap.column, spellcastEntityCount)
            self:beginShifting(0, VIRTUAL_HEIGHT)
        end
    end)
end

function Scene:beginShifting(shiftX, shiftY)
    self.currentMap.collidableMapObjects = {}
    self.shifting = true
    self.nextMap.adjacentOffsetY = shiftY
    self.nextMap.adjacentOffsetX = shiftX

    if shiftX < 0 then --SHIFT LEFT
        --self.nextMap.adjacentOffsetX = self.nextMap.adjacentOffsetX + 16
        playerX = VIRTUAL_WIDTH - self.player.width
        playerY = self.player.y
    elseif shiftX > 0 then --SHIFT RIGHT
        --self.nextMap.adjacentOffsetX = self.nextMap.adjacentOffsetX - 16
        playerX = 0
        playerY = self.player.y
    elseif shiftY < 0 then -- SHIFT UP
        self.nextMap.adjacentOffsetY = self.nextMap.adjacentOffsetY + 16
        shiftY = shiftY + 16
        playerY = SCREEN_HEIGHT_LIMIT - self.player.height
        playerX = self.player.x
    elseif shiftY > 0 then -- SHIFT DOWN
        self.nextMap.adjacentOffsetY = self.nextMap.adjacentOffsetY - 16
        shiftY = shiftY - 16
        playerY = 0
        playerX = self.player.x
    end

    --SPELLCAST TWEEN
    for k, v in pairs(self.spellcastEntities) do
        Timer.tween(TRANSITION_SPEED, {
            [self.spellcastEntities[k]] = {x = playerX + math.cos(k * step + TIME * SPEED) * AMP, y = playerY + math.sin(k * step + TIME * SPEED) * AMP - 5},
        }):finish()
    end

    --PLAYER AND CAMERA TWEEN
    Timer.tween(TRANSITION_SPEED, {
        [self] = {cameraX = shiftX, cameraY = shiftY},
        [self.player] = {x = math.floor(playerX), y = math.floor(playerY)},
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
    for i = 1, spellcastEntityCount do
        self.currentMap.psystems[i]:release()
    end
    for i = 1, #MAP[self.currentMap.row][self.currentMap.column].entities do
        MAP[self.currentMap.row][self.currentMap.column].entities[i]:resetOriginalPosition()
    end
    --self.currentMap.row = sceneView.currentMap.row
    --self.currentMap.column = sceneView.currentMap.column
    self.currentMap = self.nextMap

    self.nextMap = nil

    --sceneView = Scene(self.player, 1, 1)
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

    if not self.shifting then
        TIME = TIME + dt
    end

    for i = 1, #self.spellcastEntities do
        if not self.shifting then
            self.spellcastEntities[i].x = self.player.x + math.cos(i * step + TIME * SPEED) * AMP
            self.spellcastEntities[i].y = self.player.y + math.sin(i * step + TIME * SPEED) * AMP - 5
            self.spellcastEntities[i]:update(dt)
        end
    end

    ---[[
    --PLAYER TO MAP OBJECT COLLISION DETECTION
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
    --]]

end

function Scene:render()
    love.graphics.setColor(WHITE)
    love.graphics.push()
    if self.shifting then
        love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    end

    self.currentMap:render()
    love.graphics.setColor(WHITE)

    if self.nextMap then
        self.nextMap:render()
    end
    love.graphics.pop()

    if self.player then
        self.player:render()
    end

    --SET FADE FOR SPELLCAST
    love.graphics.setColor(255/255, 255/255, 255/255, SPELLCAST_FADE/225)
    for i = 1, spellcastEntityCount do
        if successfulCast then
            self.spellcastEntities[i]:render()
        end
        self.spellcastEntities[i]:render()
    end

    love.graphics.setColor(WHITE)
    --[[
    love.graphics.setColor(RED)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 8, 32, 16, 16)
    --]]

    --[[
    love.graphics.setColor(WHITE)
    for i = 1, #MAP[1][2].entities do
        love.graphics.print('entity[' .. tostring(i) .. ']: x:' .. string.format("%.2f", MAP[1][2].entities[i].x) , 0, i * 8)
        love.graphics.print(tostring(MAP[1][2].entities[i].y), 144, i * 8)
    end
    --love.graphics.print('dy: ' .. tostring(self.player.dy), 0, 10)
    --]]
end
