Player = Class{__includes = Entity}

local heartSpeed = 0.5
local counter = 0
local safeCounter = 0
local pitCount = 0

function Player:init(def)
    Entity.init(self, def)
    self.lastInput = nil
    self.inputsHeld = 0
    self.health = 14
    self.heartTimer = heartSpeed
    self.decrement = true
    self.dead = false
    self.checkPointPositions = {x = 0, y = 0}
    self.falling = false
    self.fallTimer = 0
    self.graveyard = false
    self.tweenAllowed = true
    self.dialogueBoxX = self.x
    self.dialogueBoxY = self.y - TILE_SIZE
    self.dialogueBoxWidth = TILE_SIZE
    self.dialogueBoxHeight = TILE_SIZE
    self.fireSpellEquipped = true
    self.luteEquipped = false
end

function updateHearts(player)
    healthDifference = totalHealth - player.health
    HEART_CROP = 56 - (4 * healthDifference)
end

function Player:update(dt)
    pitCount = 0
    if not self.graveyard then
        for k, v in pairs(sceneView.currentMap.pits) do
            if v:collide(self) then
                pitCount = pitCount + 1
            end
        end
    end

    if not self.graveyard and pitCount == 0 then
        counter = counter + dt
    end

    if counter > 1 then
        self.checkPointPositions.x = self.x
        self.checkPointPositions.y = self.y
        counter = 0
    end

    --PLAYER DEATH
    if self.health <= 0 and not self.dead then
        sounds['death']:play()
        self.dead = true
    end
    --TODO
    healthDifference = totalHealth - self.health
    HEART_CROP = math.max(56 - (4 * healthDifference), 0)

    --TRANSITION EVENT TRIGGERS
    if not sceneView.shifting and not sceneView.player.falling and not sceneView.player.graveyard then
        if #OUTPUT_LIST > 0 then
            for k, v in ipairs(OUTPUT_LIST) do
                if v == 'right' then
                    if self.x + self.width >= VIRTUAL_WIDTH + SIDE_EDGE_BUFFER_PLAYER then
                        Event.dispatch('right-transition')
                    end
                elseif v == 'left' then
                    if self.x <= -SIDE_EDGE_BUFFER_PLAYER then
                        Event.dispatch('left-transition')
                    end
                elseif v == 'up' then
                    if self.y <= -SIDE_EDGE_BUFFER_PLAYER then
                        Event.dispatch('up-transition')
                    end
                elseif v == 'down' then
                    if self.y + self.height >= SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER then
                        Event.dispatch('down-transition')
                    end
                end
            end
        end
        if #TOUCH_OUTPUT_LIST > 0 then
            for k, v in ipairs(TOUCH_OUTPUT_LIST) do
                if v == 'right' then
                    if self.x + self.width >= VIRTUAL_WIDTH + SIDE_EDGE_BUFFER_PLAYER then
                        Event.dispatch('right-transition')
                    end
                elseif v == 'left' then
                    if self.x <= -SIDE_EDGE_BUFFER_PLAYER then
                        Event.dispatch('left-transition')
                    end
                elseif v == 'up' then
                    if self.y <= -SIDE_EDGE_BUFFER_PLAYER then
                        Event.dispatch('up-transition')
                    end
                elseif v == 'down' then
                    if self.y + self.height >= SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER then
                        Event.dispatch('down-transition')
                    end
                end
            end
        end
    end

    Entity.update(self, dt)

    if self.direction == 'up' then
        self.dialogueBoxX = self.x + DIALOGUE_TRIGGER_SHRINK / 2
        self.dialogueBoxY = self.y - TILE_SIZE / 2
        self.dialogueBoxWidth = TILE_SIZE - DIALOGUE_TRIGGER_SHRINK
        self.dialogueBoxHeight = TILE_SIZE / 2
    elseif self.direction == 'down' then
        self.dialogueBoxX = self.x + DIALOGUE_TRIGGER_SHRINK / 2
        self.dialogueBoxY = self.y + TILE_SIZE
        self.dialogueBoxWidth = TILE_SIZE - DIALOGUE_TRIGGER_SHRINK
        self.dialogueBoxHeight = TILE_SIZE / 2
    elseif self.direction == 'left' then
        self.dialogueBoxX = self.x - TILE_SIZE / 2 + 1
        self.dialogueBoxY = self.y + DIALOGUE_TRIGGER_SHRINK / 2
        self.dialogueBoxWidth = TILE_SIZE / 2
        self.dialogueBoxHeight = TILE_SIZE - DIALOGUE_TRIGGER_SHRINK
    elseif self.direction == 'right' then
        self.dialogueBoxX = self.x + TILE_SIZE - 1
        self.dialogueBoxY = self.y + DIALOGUE_TRIGGER_SHRINK / 2
        self.dialogueBoxWidth = TILE_SIZE / 2
        self.dialogueBoxHeight = TILE_SIZE - DIALOGUE_TRIGGER_SHRINK
    end
end

function Player:render()
    if not self.graveyard then
        --[[
        love.graphics.setColor(1,0,0,1)
        love.graphics.rectangle('fill', self.dialogueBoxX, self.dialogueBoxY, self.dialogueBoxWidth, self.dialogueBoxHeight)
        --]]
        Entity.render(self)
    end
end
