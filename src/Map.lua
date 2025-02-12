Map = Class{}

SPELLCAST_FADE = 0
local EMISSION_RATE = 80
local inspect = require "lib/inspect"
local graveyardTimer = 0
local pitCount = 0
local damage = 5

function Map:init(row, column, spellcastEntities)
    testNumber = 0
    self.psystems = {}
    self.rainSystem = RainSystem()
    self.snowSystem = SnowSystem()
    for i = 1, spellcastEntities do
        self.psystems[i] = love.graphics.newParticleSystem(particle, 400)
    end
    self.tiles = {}
    self.topLevelTiles = {}
    self.aboveGroundTiles = {}
    self.row = row
    self.column = column
    self.spellcastEntityCount = spellcastEntities
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
    self.renderOffsetY = MAP_RENDER_OFFSET_Y
    self.insertAnimations = InsertAnimation(self.row, self.column)
    self.entityCount = #MAP[row][column].entities
    self.npcCount = #MAP[row][column].npc
    self.warpZones = MAP[row][column].warpZones

    local count = 1
    for y = 1, MAP_HEIGHT do
        table.insert(self.tiles, {})
        for x = 1, MAP_WIDTH do
            table.insert(self.tiles[y], {
                id = MAP[row][column][count]
            })
            count = count + 1
        end
    end

    local count = 1
    for y = 1, MAP_HEIGHT do
        table.insert(self.topLevelTiles, {})
        for x = 1, MAP_WIDTH do
            if MAP[row][column].topLevelTileIds[count] == 0 then
                MAP[row][column].topLevelTileIds[count] = 75
            end
            table.insert(self.topLevelTiles[y], {
                id = MAP[row][column].topLevelTileIds[count]
            })
            count = count + 1
        end
    end
    --TODO
    local count = 1
    for y = 1, MAP_HEIGHT do
        table.insert(self.aboveGroundTiles, {})
        for x = 1, MAP_WIDTH do
            if MAP[row][column].aboveGroundTileIds[count] == 0 then
                MAP[row][column].aboveGroundTileIds[count] = 75
            end
            table.insert(self.aboveGroundTiles[y], {
                id = MAP[row][column].aboveGroundTileIds[count]
            })
            count = count + 1
        end
    end
    ---[[
    --COLLIDABLE MAP OBJECTS
    self.collidableMapObjects = {}
    for i = 1, MAP_HEIGHT do
        for j = 1, MAP_WIDTH do
            local tile = self.tiles[i][j]
            if tile.id >= 97 and tile.id <= 256 then
                table.insert(self.collidableMapObjects, CollidableMapObjects(i, j))
            end
            local tile = self.aboveGroundTiles[i][j]
            if tile.id >= 97 and tile.id <= 256 then
                table.insert(self.collidableMapObjects, CollidableMapObjects(i, j))
            end
        end
    end
    --]]
    self.testTimer = 0
end



function Map:update(dt)
    --self.rainSystem:update(dt)
    --self.snowSystem:update(dt)
    self.insertAnimations:update(dt)
    self.testTimer = self.testTimer + dt

    --ENTITY UPDATES
    if not sceneView.shifting then
        for i = 1, self.entityCount do
            local entity = MAP[self.row][self.column].entities[i]
            if not MAP[self.row][self.column].entities[i].offscreen then
                entity:processAI({scene = sceneView}, dt, sceneView.player)
                entity:update(dt)
            end
        end

        for i = 1, self.npcCount do
            local npc = MAP[self.row][self.column].npc[i]
            if not MAP[self.row][self.column].npc[i].offscreen then
                npc:update(dt)
            end
        end

        --PLAYER TO ENTITY COLLISION
        if not sceneView.player.dead then
            for i = 1, #MAP[self.row][self.column].entities do
                local entity = MAP[self.row][self.column].entities[i]
                if MAP[self.row][self.column].entities[i].corrupted then
                    if sceneView.player:topCollidesMapObject(entity) then
                        entity.y = sceneView.player.y - sceneView.player.height + 9
                        if not sceneView.player.damageFlash then
                            sounds['hurt']:play()
                            sceneView.player.hit = true
                            sceneView.player.dy = SPELL_KNOCKBACK
                            sceneView.player.damageFlash = true
                            sceneView.player.health = sceneView.player.health - 1
                        end
                    elseif sceneView.player:rightCollidesMapObject(entity) then
                        entity.x = sceneView.player.x + sceneView.player.width
                        if not sceneView.player.damageFlash then
                            sounds['hurt']:play()
                            sceneView.player.damageFlash = true
                            sceneView.player.health = sceneView.player.health - 1
                            sceneView.player.dx = -SPELL_KNOCKBACK
                            sceneView.player.hit = true
                        end
                    elseif sceneView.player:leftCollidesMapObject(entity) then
                        entity.x = sceneView.player.x - sceneView.player.width
                        if not sceneView.player.damageFlash then
                            sounds['hurt']:play()
                            sceneView.player.damageFlash = true
                            sceneView.player.health = sceneView.player.health - 1
                            sceneView.player.dx = SPELL_KNOCKBACK
                            sceneView.player.hit = true
                        end
                    elseif sceneView.player:bottomCollidesMapObject(entity) then
                        entity.y = sceneView.player.y + sceneView.player.height
                        if not sceneView.player.damageFlash then
                            sounds['hurt']:play()
                            sceneView.player.damageFlash = true
                            sceneView.player.health = sceneView.player.health - 1
                            sceneView.player.dy = -SPELL_KNOCKBACK
                            sceneView.player.hit = true
                        end
                    end
                end
            end
        end
        --PLAYER TO CHASM COLLISION
        if not gPlayer.chasmFalling then
            for k, v in pairs(MAP[self.row][self.column].chasms) do
                if sceneView.player:chasmTopLeftCollide(v) then
                    if sceneView.player:chasmTopRightCollide(v) then
                        sceneView.player.chasmCollided = v
                        sceneView.player.UpFall = true
                        break
                    elseif sceneView.player:chasmBottomLeftCollide(v) then
                        sceneView.player.chasmCollided = v
                        sceneView.player.LeftFall = true
                        break
                    end
                    sceneView.player.chasmCollided = v
                    sceneView.player.UpLeftFall = true
                    break
                end

                if sceneView.player:chasmTopRightCollide(v) then
                    if sceneView.player:chasmBottomRightCollide(v) then
                        sceneView.player.chasmCollided = v
                        sceneView.player.RightFall = true
                        break
                    end
                    sceneView.player.chasmCollided = v
                    sceneView.player.UpRightFall = true
                    break
                end

                if sceneView.player:chasmBottomRightCollide(v) then
                    if sceneView.player:chasmBottomLeftCollide(v) then
                        sceneView.player.chasmCollided = v
                        sceneView.player.DownFall = true
                        break
                    end
                    sceneView.player.chasmCollided = v
                    sceneView.player.DownRightFall = true
                    break
                end

                if sceneView.player:chasmBottomLeftCollide(v) then
                    sceneView.player.chasmCollided = v
                    sceneView.player.DownLeftFall = true
                    break
                end
            end
        end

        if sceneView.player.DownFall then
            sceneView.player.chasmFallTimer = sceneView.player.chasmFallTimer + dt
            Timer.tween(CHASM_FALL_TWEEN, {
                [sceneView.player] = {x = sceneView.player.chasmCollided.x, y = sceneView.player.chasmCollided.y},
            })
        elseif sceneView.player.DownLeftFall then
            sceneView.player.chasmFallTimer = sceneView.player.chasmFallTimer + dt
            Timer.tween(CHASM_FALL_TWEEN, {
                [sceneView.player] = {x = sceneView.player.chasmCollided.x, y = sceneView.player.chasmCollided.y},
            })
        elseif sceneView.player.LeftFall then
            sceneView.player.chasmFallTimer = sceneView.player.chasmFallTimer + dt
            Timer.tween(CHASM_FALL_TWEEN, {
                [sceneView.player] = {x = sceneView.player.chasmCollided.x, y = sceneView.player.chasmCollided.y},
            })
        elseif sceneView.player.UpLeftFall then
            sceneView.player.chasmFallTimer = sceneView.player.chasmFallTimer + dt
            Timer.tween(CHASM_FALL_TWEEN, {
                [sceneView.player] = {x = sceneView.player.chasmCollided.x, y = sceneView.player.chasmCollided.y},
            })
        elseif sceneView.player.UpFall then
            sceneView.player.chasmFallTimer = sceneView.player.chasmFallTimer + dt
            Timer.tween(CHASM_FALL_TWEEN, {
                [sceneView.player] = {x = sceneView.player.chasmCollided.x, y = sceneView.player.chasmCollided.y},
            })
        elseif sceneView.player.UpRightFall then
            sceneView.player.chasmFallTimer = sceneView.player.chasmFallTimer + dt
            Timer.tween(CHASM_FALL_TWEEN, {
                [sceneView.player] = {x = sceneView.player.chasmCollided.x, y = sceneView.player.chasmCollided.y},
            })
        elseif sceneView.player.RightFall then
            sceneView.player.chasmFallTimer = sceneView.player.chasmFallTimer + dt
            Timer.tween(CHASM_FALL_TWEEN, {
                [sceneView.player] = {x = sceneView.player.chasmCollided.x, y = sceneView.player.chasmCollided.y},
            })
        elseif sceneView.player.DownRightFall then
            sceneView.player.chasmFallTimer = sceneView.player.chasmFallTimer + dt
            Timer.tween(CHASM_FALL_TWEEN, {
                [sceneView.player] = {x = sceneView.player.chasmCollided.x, y = sceneView.player.chasmCollided.y},
            })
        end

        --CHASM FALL
        if sceneView.player.chasmFallTimer >= CHASM_FALL_ANIM_TIMER then
            sceneView.player:changeAnimation('falling')
            sceneView.player.falling = true
            sceneView.player.chasmFalling = false
        end

        --]]
        --COIN COLLISION
        if MAP[self.row][self.column].coins[1] ~= nil then
            for k, v in pairs(MAP[self.row][self.column].coins) do
                if sceneView.player:coinCollides(v) then
                    sounds['coinPickup']:play()
                    gPlayer.coinCount = gPlayer.coinCount + 1
                    if gPlayer.coinCount > 999 then
                        gPlayer.coinCount = 999
                    end
                    table.remove(MAP[self.row][self.column].coins, k)
                end
            end
        end

        --ATTACK UPDATES
        if MAP[self.row][self.column].attacks[1] ~= nil then
            for i = 1, #MAP[self.row][self.column].attacks do
                MAP[self.row][self.column].attacks[i]:update(dt)
                if MAP[self.row][self.column].attacks[i].remove then
                    table.remove(MAP[self.row][self.column].attacks, i)
                    break
                end
            end
        end
    end

    --SPELLCAST_FADE CLAMPING
    if successfulCast then
        SPELLCAST_FADE = math.min(255, SPELLCAST_FADE + 11)
    else
        SPELLCAST_FADE = math.max(0, SPELLCAST_FADE - 11)
    end

    --SPELLCAST PARTICLE SYSTEMS
    for i = 1, self.spellcastEntityCount do
        if not sceneView.shifting then
            self.psystems[i]:moveTo(sceneView.spellcastEntities[i].x + 4, sceneView.spellcastEntities[i].y + 13)
            if SPELLCAST_FADE > 30 then
                self.psystems[i]:setEmissionArea('normal', 2, 1)
                self.psystems[i]:setParticleLifetime(1, 3)
                self.psystems[i]:setEmissionRate(EMISSION_RATE / self.spellcastEntityCount)
                self.psystems[i]:setLinearAcceleration(-5, -20, 10, 0)
                self.psystems[i]:setColors(0, 1, 1, 200/255, 0, 0, 153/255, 0)
            else
                self.psystems[i]:setEmissionRate(0)
            end
            self.psystems[i]:update(dt)
        end
    end


    --FALLING TRIGGER
    if sceneView.player.fallTimer > FALL_TIMER_THRESHOLD then
        sceneView.player.fallTimer = 0
        sceneView.player:changeAnimation('falling')
        sceneView.player.falling = true
    end

    --GRAVEYARD TRIGGER
    if sceneView.player.falling then
        if sceneView.player.animations['falling'].timesPlayed >= 1 then
            Timer.clear()
            sceneView.player.chasmFallTimer = 0
            sceneView.player:resetFallingDirection()
            sceneView.player.falling = false
            sceneView.player.chasmDeath = true
            sceneView.player.chasmFalling = false
            sceneView.player.tweenAllowed = false
            sceneView.player.animations['falling'].currentFrame = 1
            sounds['hurt']:play()
            sceneView.player.health = sceneView.player.health - 1
            sceneView.player.animations['falling'].timesPlayed = 0
            sceneView.player.fallTimer = -2
            sceneView.player.graveyard = true

            sceneView.player.deadTimer = 0
            sceneView.player.dead = false
            sceneView.player.damageFlash = false
            --sceneView.player.graveyard = false
            sceneView.player.dx = 0
            sceneView.player.dy = 0
            sceneView.player.hit = false
            sceneView.player.dead = false
            sceneView.player.deadTimer = 0
            --sceneView.player.animations['falling'].currentFrame = 1
            sceneView.player:changeAnimation('walk-down')
            if sceneView.player.health <= 0 then
                MAP[sceneView.currentMap.row][sceneView.currentMap.column].attacks = {}
                gStateMachine:change('chasmFallingState')
            else
                sceneView.player.x = sceneView.player.checkPointPositions.x
                sceneView.player.y = sceneView.player.checkPointPositions.y
            end
        end
    end

    if sceneView.player.graveyard then
        sceneView.player.x = SCREEN_WIDTH_LIMIT
        sceneView.player.y = 0
        graveyardTimer = graveyardTimer + dt
        if graveyardTimer > .5 then
            sceneView.player.graveyard = false
            sceneView.player.x = sceneView.player.checkPointPositions.x
            sceneView.player.y = sceneView.player.checkPointPositions.y
            sceneView.player.damageFlash = true
            sceneView.player.tweenAllowed = true
            sceneView.player.chasmDeath = false
            graveyardTimer = 0
            Timer.clear()
        end
    end

    --UPDATE PUSHABLES
    --[[
    if MAP[self.row][self.column].pushables[1] ~= nil then
        for k, v in pairs(MAP[self.row][self.column].pushables) do
            v:update(dt)
        end
    end
    --]]

    --COLLIDABLE MAP OBJECTS
    for k, v in pairs(MAP[self.row][self.column].collidableMapObjects) do
        v:update(dt)

        if v.type == 'crate' then
            if successfulCast then
                for i = 1, sceneView.spellcastEntityCount do
                    if v:spellCollides(sceneView.spellcastEntities[i]) then
                        v.health = math.max(0, v.health - damage)
                    end
                end
            end

            if v.health == 0 then
                if not v.brokenCrate then
                    v:breakCrate()
                end
                --REMOVE CRATE
                if v.currentAnimation.timesPlayed == 1 then
                    table.remove(MAP[self.row][self.column].collidableMapObjects, k)
                end
            end
        end
    end
end

function Map:render()
    --RENDER MAP DECLARATION TILES
    for y = 1, MAP_HEIGHT do
        for x = 1, MAP_WIDTH do
            local tile = self.tiles[y][x]
            love.graphics.draw(tileSheet, quads[tile.id], (x - 1) * TILE_SIZE + self.adjacentOffsetX, (y - 1) * TILE_SIZE + self.adjacentOffsetY)
        end
    end
    --RENDER ABOVE GROUND TILES
    for y = 1, MAP_HEIGHT do
        for x = 1, MAP_WIDTH do
            local tile = self.aboveGroundTiles[y][x]
            love.graphics.draw(tileSheet, quads[tile.id], (x - 1) * TILE_SIZE + self.adjacentOffsetX, (y - 1) * TILE_SIZE + self.adjacentOffsetY)
        end
    end
    --self.insertAnimations:render()

    love.graphics.setColor(WHITE)
    --SPELLCAST ENTITY RENDERS
    for i = 1, self.spellcastEntityCount do
        love.graphics.draw(self.psystems[i], self.psystems[i].x, self.psystems[i].y)
    end

    --ENTITY RENDERS
    for k, entity in pairs(MAP[self.row][self.column].entities) do
        if not entity.offscreen and entity.spawning then
            entity:render(self.adjacentOffsetX, self.adjacentOffsetY)
        end
    end

    --NPC RENDERS
    for k, npc in pairs(MAP[self.row][self.column].npc) do
        if not npc.offscreen then
            npc:render(self.adjacentOffsetX, self.adjacentOffsetY)
        end
    end
    love.graphics.setColor(255, 0, 0, 255)

    --love.graphics.print("pitCountMap: " .. pitCount, 0, 0)
    --self.rainSystem:render()
    --self.snowSystem:render()
    --love.graphics.print('.option: ' .. tostring(inspect(MAP[7][2].npc[1].stateMachine.current.option)), 0, 0)
    --print(inspect(MAP[7][2].npc[1].stateMachine))

    --RENDER WARPZONES
    if MAP[self.row][self.column].warpZones[1] ~= nil then
        for k, v in pairs(MAP[self.row][self.column].warpZones) do
            v:render(self.adjacentOffsetX, self.adjacentOffsetY)
        end
    end

    --RENDER COINS
    if MAP[self.row][self.column].coins[1] ~= nil then
        for k, v in pairs(MAP[self.row][self.column].coins) do
            v:render(self.adjacentOffsetX, self.adjacentOffsetY)
        end
    end

    --RENDER PUSHABLES
    if MAP[self.row][self.column].pushables[1] ~= nil then
        for k, v in pairs(MAP[self.row][self.column].pushables) do
            v:render(self.adjacentOffsetX, self.adjacentOffsetY)
        end
    end

    if MAP[self.row][self.column].collidableMapObjects[1] ~= nil then
        for k, v in pairs(MAP[self.row][self.column].collidableMapObjects) do
            v:render(self.adjacentOffsetX, self.adjacentOffsetY)
        end
    end
    ---[[
  love.graphics.setColor(WHITE)

  --MAP DEBUG
  --[[
  love.graphics.print('player.falling: ' .. tostring(gPlayer.falling), 0, 0)
  love.graphics.print('player.fallTimer: ' .. tostring(gPlayer.fallTimer), 0, 20)
  love.graphics.print('anim.timesPlayed' .. tostring(sceneView.player.animations['falling'].timesPlayed), 0, 30)
  --]]
  --[[
  love.graphics.print('UpLeftFall: ' .. tostring(gPlayer.UpLeftFall), 0, 0)
  love.graphics.print('UpRightFall: ' .. tostring(gPlayer.UpRightFall), 0, 10)
  love.graphics.print('Up: ' .. tostring(gPlayer.UpFall), 0, 20)
  love.graphics.print('RightFall: ' .. tostring(gPlayer.RightFall), 0, 30)
  love.graphics.print('DownRightFall: ' .. tostring(gPlayer.DownRightFall), 0, 40)
  love.graphics.print('DownFall: ' .. tostring(gPlayer.DownFall), 0, 50)
  love.graphics.print('DownLeftFall: ' .. tostring(gPlayer.DownLeftFall), 0, 60)
  love.graphics.print('LeftFall: ' .. tostring(gPlayer.LeftFall), 0, 70)
  --]]
  --love.graphics.print('BL: ' .. tostring(sceneView.player.BLCollide), 0, 20)
  --love.graphics.print('BR: ' .. tostring(sceneView.player.BRCollide), 0, 30)
  --[[
  love.graphics.print('y: ' .. tostring(MAP[self.row][self.column].entities[1].y), 0, 10)
  love.graphics.print('walkSpeed: ' .. tostring(MAP[self.row][self.column].entities[1].walkSpeed), 0, 20)
  love.graphics.print('dx: ' .. tostring(MAP[self.row][self.column].entities[1].dx), 0, 30)
  love.graphics.print('dy: ' .. tostring(MAP[self.row][self.column].entities[1].dy), 0, 40)
  love.graphics.print('PAUSED: ' .. tostring(PAUSED), 0, 50)
  --]]
end
