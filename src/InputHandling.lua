InputHandling = Class{}

local inspect = require 'lib/inspect'

function InputHandling:init()

end

function insertDirection(direction)
    local directionCount = 0
    for key, value in ipairs(INPUT_LIST) do
        if value == direction then
            directionCount = directionCount + 1
        end
    end
    if directionCount == 0 then
        table.insert(INPUT_LIST, direction)
    end
end

function removeDirection(direction)
    for key, value in ipairs(INPUT_LIST) do
        if value == direction then
            table.remove(INPUT_LIST, key)
            break
        end
    end
end

function InputHandling:update(dt)
    if love.keyboard.wasPressed('a') then
        insertDirection('left')
    end
    if love.keyboard.wasPressed('w') then
        insertDirection('up')
    end
    if love.keyboard.wasPressed('d') then
        insertDirection('right')
    end
    if love.keyboard.wasPressed('s') then
        insertDirection('down')
    end

    if love.keyboard.wasReleased('a') then
        removeDirection('left')
    end
    if love.keyboard.wasReleased('w') then
        removeDirection('up')
    end
    if love.keyboard.wasReleased('d') then
        removeDirection('right')
    end
    if love.keyboard.wasReleased('s') then
        removeDirection('down')
    end
end

function InputHandling:render()
    love.graphics.setColor(DEBUG_BG2)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, 40)
    love.graphics.setFont(pixelFont)
    love.graphics.setColor(WHITE)
    love.graphics.print("INPUT: " .. inspect(INPUT_LIST), 0, 0)
    love.graphics.print("INPUT#: " .. tostring(#INPUT_LIST), 0, 10)
    love.graphics.print("TOUCH: " .. inspect(TOUCH_LIST), 0, 20)
    love.graphics.print("TOUCH#: " .. tostring(#TOUCH_LIST), 0, 30)

end
