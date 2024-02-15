PlayState = Class{__includes = BaseState}


function PlayState:init()
    kvothe = Player()
    ninetyDegrees = math.rad(90)
    oneEightyDegrees = math.rad(180)
    twoSeventyDegress = math.rad(270)
    rotate = 0
    local columns = 10
    local rows = 8
    mapWidth = 10
    mapHeight = 8
    cameraX = 0
    tiles = {}
    map = {}
    for x = 1, 5 do
        table.insert(map, {})
    end
    map[3][3] = {
    FIRST, FIRST, FIRST, FIRST, FIRST, FIRST, FIRST, FIRST, FIRST, FIRST,
    FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, NINTH,
    FIRST, SECOND, THIRD, NINTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, NINTH,
    FIRST, SECOND, THIRD, NINTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, NINTH,
    FIRST, SECOND, THIRD, NINTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, NINTH,
    FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, SIXTH, SIXTH,
    FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, SIXTH, SIXTH,
    FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, SIXTH, SIXTH
    }

    map[3][4] = {
        SECOND  , SECOND, SECOND, SECOND, SECOND, SECOND, SECOND, SECOND, SECOND, SECOND,
        SECOND  , SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, NINTH,
        SECOND  , SECOND, THIRD, NINTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, NINTH,
        SECOND  , SECOND, THIRD, NINTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, NINTH,
        SECOND  , SECOND, THIRD, NINTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, NINTH,
        SECOND  , SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, SIXTH, SIXTH,
        SECOND  , SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, SIXTH, SIXTH,
        SECOND  , SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, SIXTH, SIXTH
    }


    currentScene = Scene(kvothe, map[3][3])
    tilesheet = love.graphics.newImage('/src/pics/nineCircles.png')
    quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)

end

function PlayState:update(dt)
    cameraX = cameraX + 1
    kvothe:update(dt)
    rotate = rotate + .05
    love.window.setPosition(400, 90)
end

function PlayState:render()
    --love.graphics.translate(cameraX, 0)
	love.graphics.clear(GRAY)

    --HUD RENDER
    love.graphics.setColor(YELLOW)
    love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 16, VIRTUAL_WIDTH, 16)
    love.graphics.setColor(BLACK)

	love.graphics.setFont(pixelFont)
    love.graphics.printf('KvotheDX', 0, VIRTUAL_HEIGHT - 15, VIRTUAL_WIDTH, 'center')
    if love.keyboard.isDown('up') then
        love.graphics.setColor(FADED)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 11, 0, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --UP
    else
        love.graphics.setColor(WHITE)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 11, 0, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --UP
    end
    if love.keyboard.isDown('right') then
        love.graphics.setColor(FADED)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 8, SCREEN_HEIGHT_LIMIT - 4, ninetyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --RIGHT
    else
        love.graphics.setColor(WHITE)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 8, SCREEN_HEIGHT_LIMIT - 4, ninetyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --RIGHT
    end
    if love.keyboard.isDown('down') then
        love.graphics.setColor(FADED)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 4, oneEightyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --DOWN
    else
        love.graphics.setColor(WHITE)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 4, oneEightyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --DOWN
    end
    if love.keyboard.isDown('left') then
        love.graphics.setColor(FADED)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 24, SCREEN_HEIGHT_LIMIT - 4, twoSeventyDegress, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --LEFT
    else
        love.graphics.setColor(WHITE)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 24, SCREEN_HEIGHT_LIMIT - 4, twoSeventyDegress, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --LEFT
    end

    currentScene:render()
    kvothe:render()

    --DEBUG PRINT
    if love.keyboard.isDown('h') then
        love.graphics.setColor(WHITE)
        love.graphics.setFont(tinyFont)
        love.graphics.print('frame: ' .. tostring(math.floor(kvothe.frame)), 0, 0)
        love.graphics.print('inputs: ' .. tostring(inputsHeldDown), 5, 15)
        love.graphics.print('x: ' .. string.format("%.1f", kvothe.x), 5, 25)
        love.graphics.print('y: ' .. string.format("%.1f", kvothe.y), 5, 35)
        love.graphics.print('up: ' .. tostring(walkingUp), 5, 45)
        love.graphics.print('down: ' .. tostring(walkingDown), 5, 55)
        love.graphics.print('left: ' .. tostring(walkingLeft), 5, 65)
        love.graphics.print('right: '  .. tostring(walkingRight), 5, 75)
        love.graphics.print('lastInput: '  .. tostring(lastInput), 5, 85)
    end
end
