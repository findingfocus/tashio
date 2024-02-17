Scene = Class{}

function Scene:init(player, mapRow, mapColumn)
    self.player = player
    self.mapRow = mapRow
    self.mapColumn = mapColumn
    self.currentMap = Map(self.mapRow, self.mapColumn)
    self.nextMap = nil
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false

    Event.on('left-transition', function()
        self:beginShifting(-VIRTUAL_WIDTH, 0)
    end)
    Event.on('right-transition', function()
        self:beginShifting(VIRTUAL_WIDTH, 0)
    end)
    Event.on('up-transition', function()
        self:beginShifting(0, -VIRTUAL_HEIGHT)
    end)
    Event.on('down-transition', function()
        self:beginShifting(0, VIRTUAL_HEIGHT)
    end)
end

function Scene:beginShifting(shiftX, shiftY)
    self.shifting = true

    self.nextMap = Map(1, 2)               --ASSIGN NEXT MAP

    self.nextMap.adjacentOffsetY = shiftY
    self.nextMap.adjacentOffsetX = shiftX

    ---[[
    if shiftX < 0 then --WHERE KVOTHE ENDS UP ON SCREEN
        playerX = VIRTUAL_WIDTH - self.player.width - EDGE_BUFFER_KVOTHE
        playerY = self.player.y
        --self.nextMap = MAP[1][2] --CHANGE TO BE ARITHMETIC INSTEAD OF HARD CODED
    elseif shiftX > 0 then
        playerX = EDGE_BUFFER_KVOTHE
        playerY = self.player.y
    elseif shiftY < 0 then -- SHIFT UP
        self.nextMap.adjacentOffsetY = self.nextMap.adjacentOffsetY + 16
        shiftY = shiftY + 16
        playerY = SCREEN_HEIGHT_LIMIT - self.player.height - EDGE_BUFFER_KVOTHE
        playerX = self.player.x
    elseif shiftY > 0 then -- SHIFT DOWN
        self.nextMap.adjacentOffsetY = self.nextMap.adjacentOffsetY - 16
        shiftY = shiftY- 16
        playerY = EDGE_BUFFER_KVOTHE
        playerX = self.player.x
    end


    Timer.tween(0.9, {
        [self] = {cameraX = shiftX, cameraY = shiftY},
        [self.player] = {x = playerX, y = playerY}
    }):finish(function()

        self:finishShifting()
     end)
end

function Scene:finishShifting()
    self.shifting = false
    self.cameraX = 0
    self.cameraY = 0
    self.currentMap = Map(1, 2) --ASSIGN CORRECT MAP
    self.nextMap = nil
end

function Scene:update(dt)

end

function Scene:render()
    love.graphics.setColor(WHITE)
    if self.shifting then
        love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    end

    self.currentMap:render()

    if self.nextMap then
        self.nextMap:render()
    end
end
