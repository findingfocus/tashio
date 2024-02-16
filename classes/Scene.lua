Scene = Class{}

function Scene:init(player, mapRow, mapColumn)
    self.player = player
    self.mapRow = mapRow
    self.mapColumn = mapColumn
    self.currentMap = Map(self.mapRow, self.mapColumn)
    self.nextMap = Map(1, 2)
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false


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
end

function Scene:beginShifting(shiftX, shiftY)
    self.shifting = true

    ---[[
    if shiftX < 0 then
        playerX = VIRTUAL_WIDTH + 5
        --self.nextMap = MAP[1][2] --CHANGE TO BE ARITHMETIC INSTEAD OF HARD CODED
    elseif shiftX > 0 then
        playerX = VIRTUAL_WIDTH - self.player.width
    elseif shiftY > 0 then
        playerY = SCREEN_HEIGHT_LIMIT - self.player.height
    elseif shiftY < 0 then
        playerY = -VIRTUAL_HEIGHT
    end

    Timer.tween(5, {
        [self] = {cameraX = shiftX, cameraY = shiftY},
        [self.player] = {x = playerX, y = playerY}
    }):finish(function()

        self:finishShifting()

        if shiftX < 0 then
            self.player.x = 5
            --self.nextRoom
        elseif shiftX > 0 then
            self.player.x = self.player.width
        elseif shiftY < 0 then
            self.player.y = VIRTUAL_HEIGHT - self.player.height
        elseif shiftY > 0 then
            self.player.y = self.height
        end
        --self.player.x = 0
        --self.player.y = 0
     end)
end

function Scene:finishShifting()
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false
    --self.currentMap = self.nextMap
    --self.nextMap = nil
end

function Scene:update(dt)

end

function Scene:render()
    love.graphics.setColor(WHITE)
    --love.graphics.translate(-100, 0)
    self.currentMap:render()
    --self.nextMap:render()
    if self.shifting then
        love.graphics.translate(self.cameraX, self.cameraY)
        self.nextMap:render()
    end
end
