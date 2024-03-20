Map = Class{}

SPELLCAST_FADE = 0
local EMISSION_RATE = 40

function Map:init(row, column, spellcastEntities)
    self.psystems = {}
    particle = love.graphics.newImage('graphics/particle.png')
    local psystem1 = love.graphics.newParticleSystem(particle, 400)
    local psystem2 = love.graphics.newParticleSystem(particle, 400)
    local psystem3 = love.graphics.newParticleSystem(particle, 400)
    local psystem4 = love.graphics.newParticleSystem(particle, 400)
    local psystem5 = love.graphics.newParticleSystem(particle, 400)


    table.insert(self.psystems, psystem1)
    table.insert(self.psystems, psystem2)
    table.insert(self.psystems, psystem3)
    table.insert(self.psystems, psystem4)
    table.insert(self.psystems, psystem5)
    self.tiles = {}
    self.row = row
    self.column = column
    self.spellcastEntityCount = spellcastEntities
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
    self.renderOffsetY = MAP_RENDER_OFFSET_Y
    self.insertAnimations = InsertAnimation(self.row, self.column)
    count = 1
    for y = 1, MAP_HEIGHT do
        table.insert(self.tiles, {})
        for x = 1, MAP_WIDTH do
            table.insert(self.tiles[y], {
                id = MAP[row][column][count]
            })
            count = count + 1
        end
    end

    self.collidableMapObjects = {}

    for i = 1, MAP_HEIGHT do
        for j = 1, MAP_WIDTH do
            local tile = self.tiles[i][j]
            if tile.id >= 97 and tile.id <= 224 then
                table.insert(self.collidableMapObjects, CollidableMapObjects(i, j))
            end
        end
    end
end

function Map:update(dt)
    self.insertAnimations:update(dt)
    if successfulCast then
        SPELLCAST_FADE = math.min(255, SPELLCAST_FADE + 11)
    else
        SPELLCAST_FADE = math.max(0, SPELLCAST_FADE - 11)
    end
    for i = 1, self.spellcastEntityCount do
        if SPELLCAST_FADE > 30 then
            self.psystems[i]:setParticleLifetime(1, 3)
            self.psystems[i]:setEmissionRate(EMISSION_RATE / self.spellcastEntityCount)
            self.psystems[i]:setSizeVariation(1)
            self.psystems[i]:setLinearAcceleration(-5, -20, 10, 0)
            self.psystems[i]:setColors(0, 1, 1, 200/255, 0, 0, 153/255, 0)
            self.psystems[i]:setEmissionArea('normal', 2, 1)
            self.psystems[i]:moveTo(sceneView.spellcastEntities[i].x - VIRTUAL_WIDTH / 2 + 4, sceneView.spellcastEntities[i].y - VIRTUAL_HEIGHT / 2 + 13)
        else
            self.psystems[i]:setEmissionRate(0)
        end
        self.psystems[i]:update(dt)
    end
end

function Map:render()
    --RENDER DEFAULT TILES FIRST
    for y = 1, MAP_HEIGHT do
        for x = 1, MAP_WIDTH do
            local tile = self.tiles[y][x]
            love.graphics.draw(tileSheet, quads[SAND], (x - 1) * TILE_SIZE + self.adjacentOffsetX, (y - 1) * TILE_SIZE + self.adjacentOffsetY)
        end
    end
    --TILE
    for y = 1, MAP_HEIGHT do
        for x = 1, MAP_WIDTH do
            local tile = self.tiles[y][x]
            love.graphics.draw(tileSheet, quads[tile.id], (x - 1) * TILE_SIZE + self.adjacentOffsetX, (y - 1) * TILE_SIZE + self.adjacentOffsetY)
        end
    end
    self.insertAnimations:render()
    --love.graphics.setColor(255/255, 255/255, 255/255, SPELLCAST_FADE/225)
    love.graphics.setColor(WHITE)
    --love.graphics.draw(psystem1, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
    for i = 1, self.spellcastEntityCount do
        love.graphics.draw(self.psystems[i], VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
    end
end
