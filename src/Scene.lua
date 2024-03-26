Scene = Class{}

local TIME = 0
local SPEED = 3
local PLAYER_OFFSET = TILE_SIZE / 2
local AMP = 20
local TRANSITION_SPEED = 0.65
local spellcastEntityCount = 1
local count = spellcastEntityCount
local step = math.pi * 2 / count

function Scene:init(player, mapRow, mapColumn)
    self.player = player
    self.mapRow = mapRow
    self.mapColumn = mapColumn
    self.currentMap = Map(mapRow, mapColumn, spellcastEntityCount)
    self.nextMap = nil
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false
    self.entities = {}
    self.spellcastEntities = {}
    self.possibleDirections = {'left', 'right', 'up', 'down'}
    for i = 1, spellcastEntityCount do
        table.insert(self.spellcastEntities, Entity {
            animations = ENTITY_DEFS['spellcast'].animations,
            x = 25,
            y = 25,
            width = TILE_SIZE,
            height = TILE_SIZE,
        })
        self.spellcastEntities[i].stateMachine = StateMachine {
            ['flame-idle'] = function() return FlameIdle(self.spellcastEntities[i], self, spellcastEntityCount) end,
        }
        self.spellcastEntities[i]:changeState('flame-idle')
    end

    --[[
    table.insert(self.entities, Entity {
        animations = ENTITY_DEFS['geckoC'].animations,
        x = VIRTUAL_WIDTH / 2 - 8,
        y = VIRTUAL_HEIGHT / 2 - 8,
        width = TILE_SIZE,
        height = TILE_SIZE,
    })

    self.entities[1].direction = 'up'
    self.entities[1].type = 'gecko'

    self.entities[1].stateMachine = StateMachine {
        ['entity-walk'] = function() return EntityWalkState(self.entities[1]) end,
        ['entity-idle'] = function() return EntityIdleState(self.entities[1]) end,
    }

    self.entities[1]:changeState('entity-idle')
    --]]






    --[[
    for i = 1, 12 do
        local randomIndex = math.random(4)
        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS['geckoC'].animations,
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
    --]]

    Event.on('left-transition', function()
        if self.currentMap.column ~= 1 then
            self.nextMap = Map(self.currentMap.row, self.currentMap.column - 1, spellcastEntityCount)
            self:beginShifting(-VIRTUAL_WIDTH, 0)
        end
    end)
    Event.on('right-transition', function()
        if self.currentMap.column ~= OVERWORLD_MAP_WIDTH then
            self.nextMap = Map(self.currentMap.row, self.currentMap.column + 1, spellcastEntityCount)
            --resetEntities(self.currentMap.row, self.currentMap.column + 1)
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

    ---[[
    if shiftX < 0 then --SHIFT LEFT
        playerX = VIRTUAL_WIDTH - self.player.width
        playerY = self.player.y
        --self.nextMap = MAP[1][2] --CHANGE TO BE ARITHMETIC INSTEAD OF HARD CODED
    elseif shiftX > 0 then --SHIFT RIGHT
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


    for k, v in pairs(self.spellcastEntities) do
        Timer.tween(TRANSITION_SPEED, {
            [self.spellcastEntities[k]] = {x = playerX + math.cos(k * step + TIME * SPEED) * AMP, y = playerY + math.sin(k * step + TIME * SPEED) * AMP - 5},
        }):finish()
    end


    Timer.tween(TRANSITION_SPEED, {
        [self] = {cameraX = shiftX, cameraY = shiftY},
        [self.player] = {x = math.floor(playerX), y = math.floor(playerY)},
    }):finish(function()
        self:finishShifting()
     end)
--[[

     --]]
     --[self.spellcastEntities[1]] = {x = playerX + math.cos(1 * step + TIME * SPEED) * AMP, y = playerY + math.sin(1 * step + TIME * SPEED) * AMP - 5},
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
    MAP[1][2].entities[1]:resetOriginalPosition()
    --MAP[1][2].entities[1].psystem:release()
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

    --[[
    psystem:moveTo(self.entities[1].x + 8, self.entities[1].y + 8)
    psystem:setParticleLifetime(1, 4)
    psystem:setEmissionArea('borderellipse', 2, 2)
    psystem:setEmissionRate(40)
    --psystem:setLinearAcceleration(-2, -2, 2, 2)
    --psystem:setRadialAcceleration(1)
    psystem:setTangentialAcceleration(0, 4)
    psystem:setColors(67/255, 25/255, 36/255, 255/255, 25/255, 0/255, 51/255, 0/255)
    psystem:update(dt)
    --]]





    --[[
    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]
        if not self.entities.offscreen then
            entity:processAI({scene = self}, dt, self.player)
            entity:update(dt)
        end
    end
    --]]

    self.currentMap:update(dt)
    if not self.shifting then
        self.player:update(dt)
    end

    if not self.shifting then
        TIME = TIME + dt
    end

    for i = 1, #self.spellcastEntities do
        if not self.shifting then
            ---[[
            self.spellcastEntities[i].x = self.player.x + math.cos(i * step + TIME * SPEED) * AMP
            self.spellcastEntities[i].y = self.player.y + math.sin(i * step + TIME * SPEED) * AMP - 5
            self.spellcastEntities[i]:update(dt)
            --]]
        end
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

    --[[
    love.graphics.draw(psystem, 0, 0)
    for k, entity in pairs(self.entities) do
        if not entity.offscreen then
            entity:render()
        end
    end
    --]]

    --love.graphics.print('FADE: ' .. tostring(SPELLCAST_FADE), 5, 10)
    --SET FADE FOR SPELLCAST
    love.graphics.setColor(255/255, 255/255, 255/255, SPELLCAST_FADE/225)
    for i = 1, spellcastEntityCount do
        if successfulCast then
            self.spellcastEntities[i]:render()
        end
        self.spellcastEntities[i]:render()
    end

    --love.graphics.setColor(24/255, 24/255, 24/255, 255/255)
    --love.graphics.rectangle('fill', 0, 0, 16, 16)
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
