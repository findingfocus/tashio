PlayState = Class{__includes = BaseState}
successfulCast = false
HEART_CROP = 56
local STRING_WIDTH = 2
totalHealth = 14
healthDifference = 0
local inspect = require "lib/inspect"
local manisTimer = 0
Lute = Lute()
leftCount = 0
luteState = false
toggleHelp = false
gItemInventory = Inventory('item')
gKeyItemInventory = Inventory('keyItem')
gItems = {}

local triggerSceneTransition = false
local leftFadeTransitionX = -VIRTUAL_WIDTH / 2
local rightFadeTransitionX = VIRTUAL_WIDTH
local startingSceneTransitionFinished = false
local transitionFadeAlpha = 0

gPlayer = Player {
    animations = ENTITY_DEFS['player'].animations,
    walkSpeed = ENTITY_DEFS['player'].walkSpeed,
    x = TILE_SIZE * 3,
    y = TILE_SIZE * 4,
    --y = 30,
    width = TILE_SIZE,
    height = TILE_SIZE,
}
ninetyDegrees = math.rad(90)
oneEightyDegrees = math.rad(180)
twoSeventyDegress = math.rad(270)
rotate = 0
local columns = 10
local rows = 8
cameraX = 0
--STARTING SCENE gPlayer SPAWN
sceneView = Scene(gPlayer, 7, 2)
tilesheet = love.graphics.newImage('graphics/masterSheet.png')
--textures = love.graphics.newImage('graphics/textures.png')
quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)
local transitionTimer = 3

function PlayState:init()
    self.stateName = 'PlayState'

    --gPlayer.damageFlash = true
    gPlayer.stateMachine = StateMachine {
        ['player-walk'] = function() return PlayerWalkState(gPlayer, self.scene) end,
        ['player-idle'] = function() return PlayerIdleState(gPlayer) end,
    }

    gPlayer:changeState('player-idle')
    self.manis = 100
    self.manisMax = 100
    self.manisDrain = .45
    self.manisRegen = 1.2
    self.focusIndicatorX = 0
    self.focusMax = 4
    self.unFocus = 0
    self.unFocusGrowing = true
end


function PlayState:update(dt)
    --transitionTimer = transitionTimer - dt
    ---[[
    if transitionTimer < 0 then
        sceneView = Scene(gPlayer, 7, 3)
        transitionTimer = 100
    end
    --]]
    --gItemInventory:update(dt)
    if love.keyboard.wasPressed('g') then
        if WINDOW_HEIGHT == 144 * SCALE_FACTOR * 2 then
            SCALE_FACTOR = 4
            WINDOW_HEIGHT = 144 * SCALE_FACTOR
            WINDOW_WIDTH = 160 * SCALE_FACTOR
            VIRTUAL_HEIGHT_GB = 144
        else
            SCALE_FACTOR = SCALE_FACTOR_RESET
            WINDOW_HEIGHT = 144 * SCALE_FACTOR * 2
            WINDOW_WIDTH = 160 * SCALE_FACTOR
            VIRTUAL_HEIGHT_GB = 144 * 2
        end

        push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT_GB, WINDOW_WIDTH, WINDOW_HEIGHT)
    end

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gStateMachine:change('pauseState')
    end

    if love.keyboard.wasPressed('o') and gItemInventory.itemSlot[1] ~= nil then
        if gItemInventory.itemSlot[1].type == 'lute' then
            if not luteState then
                gPlayer.direction = 'down'
                gPlayer:changeAnimation('idle-down')
                luteState = true
            end
        end
    end

    if love.keyboard.wasPressed('h') then
        if luteState then
            luteState = false
        else
            toggleHelp = toggleHelp == false and true or false
        end
    end

    for k, v in pairs(touches) do
        if buttons[2]:collides(touches[k]) and gItemInventory.itemSlot[1] ~= nil then
            if gItemInventory.itemSlot[1].type == 'lute' then
                if not luteState then
                    gPlayer.direction = 'down'
                    gPlayer:changeAnimation('idle-down')
                    luteState = true
                end
            end
        end

        if buttons[3]:collides(touches[k]) and touches[k].wasTouched then
            if luteState then
                luteState = false
            else
                toggleHelp = toggleHelp == false and true or false
            end
        end
    end

    if luteState then
        Lute:update(dt)
    end

    if not sceneView.shifting then
        --FOCUS GAIN
        if (love.keyboard.isDown('p') and not luteState) or (buttons[1].fireSpellPressed and not luteState) then
            --UNFOCUS
            if (self.unFocus < self.focusMax) and self.unFocusGrowing then
                if self.manis > 0 then
                    self.unFocus = self.unFocus + FOCUS_GROW * dt
                else
                    self.unFocus = 0
                end
            end

            --UNFOCUS SHRINK
            if self.unFocus >= self.focusMax then
                self.unFocus = self.focusMax
                self.unFocusGrowing = false
            end

            --UNFOCUS DECREMENT
            if (self.unFocus <= self.focusMax) and not self.unFocusGrowing then
                self.unFocus = self.unFocus - FOCUS_GROW * dt
            end

            --UNFOCUS GROW
            if self.unFocus <= 0 then
                self.unFocus = 0
                self.unFocusGrowing = true
            end


            --APPLY UNFOCUS TO FOCUS INDICATOR
            self.focusIndicatorX = math.max(self.focusIndicatorX - (self.manisDrain + self.unFocus) * dt, 0)

            --CLAMP FOCUS INDICATOR TO 0 IF NO MANIS
            if self.manis == 0 then
                self.focusIndicatorX = math.max(self.focusIndicatorX - (self.manisDrain - self.unFocus) * dt, 0)
            end


            --MANIS DRAIN
            self.manis = math.max(self.manis - MANIS_DRAIN * dt, 0)
            if self.manis > 0 then
                manisTimer = manisTimer + dt
            end

            if self.manis > 0 then
                --FOCUS INDICATOR RISING
                self.focusIndicatorX = math.min(self.focusIndicatorX + (self.unFocus * UNFOCUS_SCALER) * dt, self.manisMax - 2)
            end
        else
            --MANIS REGEN
            self.manis = math.min(self.manis + MANIS_REGEN * dt, self.manisMax)
            --UNFOCUS DRAIN
            self.unFocus = 0
            self.focusIndicatorX = math.max(self.focusIndicatorX - FOCUS_DRAIN * dt, 0)
        end

        --TODO
        for k, v in ipairs(buttons) do
            if v.direction == 'B' then

            end
        end
    end

    if self.focusIndicatorX > 65 and self.focusIndicatorX < 85 then
        successfulCast = true
        --sounds['spellcast']:play()
    else
        successfulCast = false
    end


    cameraX = cameraX + 1

    --TODO MOVE FROM PLAYSTATE
    if love.keyboard.wasPressed('p') then
        for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].signposts) do
            if gPlayer:dialogueCollides(MAP[sceneView.currentMap.row][sceneView.currentMap.column].signposts[k]) then
                MAP[sceneView.currentMap.row][sceneView.currentMap.column].signposts[k].result = ''
                MAP[sceneView.currentMap.row][sceneView.currentMap.column].signposts[k].textIndex = 1
                --IF COLLIDES WITH SIGNPOST
                if gPlayer.direction ~= 'down' then
                    table.insert(MAP[sceneView.currentMap.row][sceneView.currentMap.column].signpostCollided, MAP[sceneView.currentMap.row][sceneView.currentMap.column].signposts[k])
                    PAUSED = PAUSED == false and true or false

                    MAP[sceneView.currentMap.row][sceneView.currentMap.column].signposts[k]:flushText()
                    if not PAUSED then
                        MAP[sceneView.currentMap.row][sceneView.currentMap.column].signpostCollided = {}
                    end
                end
            end
        end
    end

    if not PAUSED then
        sceneView:update(dt)
    end

    if PAUSED then
        for i = 1, 2 do
            MAP[sceneView.currentMap.row][sceneView.currentMap.column].signposts[i]:update(dt)
        end
    end

    rotate = rotate + .05

    --LOCK SCREEN POSITION
    --GAMEBOY TOGGLE
    --love.window.setPosition(400, 40)
    --DEV POSITION
    love.window.setPosition(400, 100)


    --WARP ZONES
    if #MAP[sceneView.currentMap.row][sceneView.currentMap.column].warpZones > 0 then
        for k, v in pairs(sceneView.currentMap.warpZones) do
            if v:collides() and not gPlayer.warping then
                gPlayer:changeState('player-idle')
                --gPlayer:changeState('player-walk')
                gPlayer.currentAnimation:refresh()
                triggerStartingSceneTransition = true
                gPlayer.warping = true
                --sceneView = Scene(gPlayer, v.warpRow, v.warpCol)
            end
        end
    end

    if triggerStartingSceneTransition then
        leftFadeTransitionX = leftFadeTransitionX + FADE_TRANSITION_SPEED * dt
        rightFadeTransitionX = rightFadeTransitionX - FADE_TRANSITION_SPEED * dt
        if leftFadeTransitionX > 0 then
            leftFadeTransitionX = 0
            triggerStartingSceneTransition = false
            startingSceneTransitionFinished = true
            for k, v in pairs(sceneView.currentMap.warpZones) do
                if gPlayer.warping then
                    sceneView = Scene(gPlayer, sceneView.currentMap.warpZones[k].warpRow, sceneView.currentMap.warpZones[k].warpCol)
                    gPlayer.x = v.playerX
                    gPlayer.y = v.playerY
                end
            end
            triggerFinishingSceneTransition = true
        end
        if rightFadeTransitionX < VIRTUAL_WIDTH / 2 then
            rightFadeTransitionX = VIRTUAL_WIDTH / 2
            triggerStartingSceneTransition = false
            startingSceneTransitionFinished = true
        end
        transitionFadeAlpha = math.min(transitionFadeAlpha + FADE_TO_BLACK_SPEED * dt, 255)
    end
    if triggerFinishingSceneTransition then
        leftFadeTransitionX = leftFadeTransitionX - FADE_TRANSITION_SPEED * dt
        rightFadeTransitionX = rightFadeTransitionX + FADE_TRANSITION_SPEED * dt
        if leftFadeTransitionX < -VIRTUAL_WIDTH / 2 then
            leftFadeTransitionX = -VIRTUAL_WIDTH / 2
            triggerFinishingSceneTransition = false
            startingSceneTransitionFinished = false
        end
        if rightFadeTransitionX > VIRTUAL_WIDTH then
            rightFadeTransitionX = VIRTUAL_WIDTH
            triggerFinishingSceneTransition = false
            startingSceneTransition = false
            gPlayer.warping = false
        end
        transitionFadeAlpha = math.max(transitionFadeAlpha - FADE_TO_BLACK_SPEED * dt, 0)
    end
end

function PlayState:render()
    love.graphics.clear(BLACK)

    love.graphics.push()
    sceneView:render()
    love.graphics.pop()


    love.graphics.setColor(0,0,0,255)
    --love.graphics.print('Tashio Tempo', VIRTUAL_WIDTH - 150, SCREEN_HEIGHT_LIMIT + 4)

    --MANIS BAR RENDER
    love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
    love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT - 4, self.manis, 2)

    --CAST BAR RENDER
    love.graphics.setColor(BLACK)
    love.graphics.rectangle('fill', 0, SCREEN_HEIGHT_LIMIT + 2 - 4, 100, 2)

    --SUCCESSFUL CAST RANGE
    love.graphics.setColor(GREEN)
    love.graphics.rectangle('fill', 65, SCREEN_HEIGHT_LIMIT + 2 - 4, 20, 2)

    --FOCUS INDICATOR
    love.graphics.setColor(WHITE)
    love.graphics.rectangle('fill', self.focusIndicatorX, SCREEN_HEIGHT_LIMIT + 2 - 4, 2, 2)

    --DEBUG MANIS SPELLCASTING
    --[[
    love.graphics.print('unFocus: ' .. tostring(self.unFocus), 5, SCREEN_HEIGHT_LIMIT - 15)
    love.graphics.print('unFocusGrowing: ' .. tostring(self.unFocusGrowing), 5, SCREEN_HEIGHT_LIMIT - 25)
    love.graphics.print('focusIndicatorX: ' .. tostring(self.focusIndicatorX), 5, SCREEN_HEIGHT_LIMIT - 35)
    --]]



    love.graphics.setFont(classicFont)
    love.graphics.setColor(BLACK)
    --love.graphics.printf('Tashio Tempo', 0, VIRTUAL_HEIGHT - 13, VIRTUAL_WIDTH, 'center')
    ---[[KEYLOGGER
    if love.keyboard.isDown('w') then
        love.graphics.setColor(FADED)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 11 + KEYLOGGER_YOFFSET, 0, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --UP
    else
        love.graphics.setColor(WHITE)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 11 + KEYLOGGER_YOFFSET, 0, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --UP
    end
    if love.keyboard.isDown('d') then
        love.graphics.setColor(FADED)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 8, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, ninetyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --RIGHT
    else
        love.graphics.setColor(WHITE)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 8, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, ninetyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --RIGHT
    end
    if love.keyboard.isDown('s') then
        love.graphics.setColor(FADED)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, oneEightyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --DOWN
    else
        love.graphics.setColor(WHITE)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 16, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, oneEightyDegrees, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --DOWN
    end
    if love.keyboard.isDown('a') then
        love.graphics.setColor(FADED)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 24, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, twoSeventyDegress, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --LEFT
    else
        love.graphics.setColor(WHITE)
        love.graphics.draw(arrowKeyLogger, ROTATEOFFSET + VIRTUAL_WIDTH - 24, SCREEN_HEIGHT_LIMIT - 4 + KEYLOGGER_YOFFSET, twoSeventyDegress, 1, 1, ROTATEOFFSET, ROTATEOFFSET) --LEFT
    end
    --]]

    --DEBUG PRINT
    if love.keyboard.isDown('5') then
        love.graphics.setColor(DEBUG_BG)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(WHITE)
        love.graphics.setFont(pixelFont)
        love.graphics.print('MAP[' .. tostring(sceneView.currentMap.row) .. '][' .. tostring(sceneView.currentMap.column) .. ']', 5, 15)
        love.graphics.print('player.x: ' .. string.format("%.1f", gPlayer.x), 5, 25)
        love.graphics.print('player.y: ' .. string.format("%.1f", gPlayer.y), 5, 35)
        love.graphics.print('direction: ' .. tostring(gPlayer.direction), 5, 45)
        love.graphics.print('playerLastInput: ' .. tostring(gPlayer.lastInput), 5, 55)
        love.graphics.print('Cast: ' .. tostring(successfulCast), 5, 65)
        love.graphics.print('animatables: ' .. tostring(sceneView.currentMap.tiles[4][1].id), 5, 75)
        love.graphics.print('INPUT_LIST: ' .. inspect(INPUT_LIST), 5, 85)
        love.graphics.print('player_state: ' .. tostring(PLAYER_STATE), 5, 95)
        love.graphics.print('fallTimer: ' .. tostring(sceneView.player.fallTimer), 5, 105)
        love.graphics.print('falling: ' .. tostring(sceneView.player.falling), 5, 115)
        love.graphics.print('safeFFall: ' .. tostring(sceneView.player.safeFromFall), 85, 115)
    elseif love.keyboard.isDown('6') then
        love.graphics.setColor(DEBUG_BG)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(WHITE)
        --love.graphics.print('pits: ' .. inspect(sceneView.currentMap.pits), 5, 15)
        --love.graphics.print('graveyard: ' .. inspect(sceneView.player.graveyard), 5, 25)
        love.graphics.print('checkpoint: ' .. inspect(gPlayer.checkPointPositions), 5, 35)
        --love.graphics.print('testNumber' .. inspect(testNumber), 5, 35)
        --love.graphics.print('pits: ' .. tostring(PITS), 5, 25)
        --print('leftCount: ' .. inspect(leftCount), 5, 15)
        --print(inspect(sceneView.player.animations['falling']))

    end

    --love.graphics.print('luteState' .. tostring(luteState), 0, VIRTUAL_HEIGHT - 50)
    love.graphics.setFont(pixelFont)

    --LUTE RENDER
    if luteState then
        Lute:render()
    end

    if toggleHelp then
        love.graphics.setColor(180/255, 20/255, 30/255, 190/255)
        love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

        love.graphics.setFont(classicFont)

        love.graphics.setColor(0/255, 0/255, 100/255, 255/255)
        love.graphics.printf('CONTROLS:', 10, 20, 150, 'left')
        love.graphics.printf('ARROW KEYS = MOVE', 10, 40, 150, 'left')
        love.graphics.printf('SPACE BAR = SPELLS', 10, 60, 150, 'left')
        love.graphics.printf('ENTER = INTERACT', 10, 80, 150, 'left')
        love.graphics.setColor(WHITE)
        love.graphics.printf('CONTROLS:', 9, 19, 150, 'left')
        love.graphics.printf('ARROW KEYS = MOVE', 9, 39, 150, 'left')
        love.graphics.printf('SPACE BAR = SPELLS', 9, 59, 150, 'left')
        love.graphics.printf('ENTER = INTERACT', 9, 79, 150, 'left')
    end

    --HUD RENDER
    ---[[
    love.graphics.setColor(WHITE)
    love.graphics.draw(hudOverlay, 0, VIRTUAL_HEIGHT - 16)
    --]]
    if gItemInventory.itemSlot[1] ~= nil then
        love.graphics.setFont(pixelFont)
        gItemInventory.itemSlot[1]:render()
    end

    love.graphics.setColor(gKeyItemInventory.elementColor)
    love.graphics.circle('fill', VIRTUAL_WIDTH - 86, VIRTUAL_HEIGHT - 8, 6)

    love.graphics.setColor(WHITE)
    love.graphics.draw(heartRowEmpty, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)
    heartRowQuad:setViewport(0, 0, HEART_CROP, 7, heartRow:getDimensions())
    love.graphics.draw(heartRow, heartRowQuad, VIRTUAL_WIDTH / 2 + 23, SCREEN_HEIGHT_LIMIT + 1)

    --TRANSITION START
    love.graphics.setColor(BLACK)
    love.graphics.rectangle('fill', leftFadeTransitionX, 0, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT)
    love.graphics.rectangle('fill', rightFadeTransitionX, 0, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT)

    --TRANSITION BLACK FADE
    love.graphics.setColor(0/255, 0/255, 0/255, transitionFadeAlpha/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    --[[
    love.graphics.setColor(WHITE)
       --love.graphics.print('player_wt: ' .. tostring(gPlayer.walkTimer), 5, 10)
       -- love.graphics.print('frame: ' .. tostring(gPlayer.currentAnimation:getCurrentFrame()), 5, 20)
    --]]
    --
end
