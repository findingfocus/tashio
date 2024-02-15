Scene = Class{}

function Scene:init(player, currentScene)
    self.player = player
    self.currentScene = currentScene
    self.nextScene = nil
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false
    count = 1

    Event.on('left-transition', function()
        self:beginShifting(VIRTUAL_WIDTH, 0)
    end)
    Event.on('right-transition', function()
        self:beginShifting(-VIRTUAL_WIDTH, 0)
    end)
    Event.on('up-transition', function()
        self:beginShifting(0, VIRTUAL_HEIGHT)
    end)
    Event.on('down-transition', function()
        self:beginShifting(0, -VIRTUAL_HEIGHT)
    end)
    for y = 1, mapHeight do
        table.insert(tiles, {})
        for x = 1, mapWidth do
            table.insert(tiles[y], {
                id = self.currentScene[count]
            })
            count = count + 1
        end
    end
end

function Scene:beginShifting(shiftX, shiftY)
    self.shifting = true

    ---[[
    self.nextRoom = map[3][4]
    if shiftX < 0 then
        playerX = 0
    elseif shiftX > 0 then
        playerX = VIRTUAL_WIDTH - self.player.width
    elseif shiftY > 0 then
        playerY = SCREEN_HEIGHT_LIMIT - self.player.height
    elseif shiftY < 0 then
        playerY = -VIRTUAL_HEIGHT
    end

    Timer.tween(1, {
        [self] = {cameraX = shiftX, cameraY = shiftY},
        [self.player] = {x = playerX, y = playerY}
    }):finish(function()

        self:finishShifting()

        if shiftX < 0 then
            self.player.x = 0
        elseif shiftX > 0 then
            self.player.x = self.player.width
        elseif shiftY < 0 then
            self.player.y = VIRTUAL_HEIGHT - self.player.height
        elseif shiftY > 0 then
            self.player.y = self.height
        end
        self.player.x = 0
        self.player.y = 0
     end)
end

function Scene:finishShifting()
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false
    self.currentScene = self.nextScene
    self.nextScene = nil
end

function Scene:update(dt)

end

function Scene:render()
    love.graphics.setColor(WHITE)
    love.graphics.translate(self.cameraX, self.cameraY)
    for y = 1, mapHeight do
        for x = 1, mapWidth do
            local tile = tiles[y][x]
            love.graphics.draw(tilesheet, quads[tile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
        end
    end
end
