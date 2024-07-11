EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, scene)
    self.entity = entity
    if self.entity.corrupted and self.entity.type == 'gecko' then
        self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['geckoC'].animations)
    elseif not self.entity.corrupted and self.entity.type == 'gecko' then
        self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['gecko'].animations)
    end
    self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    --self.entity.walkSpeed = .5
    self.scene = scene

    self.moveDuration = 0
    self.movementTimer = 0

    self.collided = false
end

function EntityWalkState:update(dt)
    --CLEANSE
    if self.entity.corrupted then
        --self.entity.health = math.max(self.entity.health - 0.5, 0)
        if self.entity.health <= 0 then
            sounds['cleanse']:play()
            self.entity.damageFlash = false
            self.entity.flashing = false
            self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['gecko'].animations)
            local random = math.random(4)
            self.entity.direction = sceneView.possibleDirections[random]
            self.entity.corrupted = false
        end
    end

    self.collided = false

    if self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.walkSpeed--ADD WALK SPEED
        self.entity:changeAnimation('walk-down')
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - self.entity.walkSpeed--ADD WALK SPEED
        self.entity:changeAnimation('walk-up')
    elseif self.entity.direction == 'left' then
        self.entity.x = self.entity.x - self.entity.walkSpeed
        self.entity:changeAnimation('walk-left')
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + self.entity.walkSpeed
        self.entity:changeAnimation('walk-right')
    end

    --TRIGGER OFFSCREEN
    if self.entity.x + self.entity.width < -TILE_SIZE or self.entity.x > VIRTUAL_WIDTH + TILE_SIZE or self.entity.y + self.entity.height < -TILE_SIZE then
        --ADD IN BOTTOM RULE AS WELL
       self.entity.offscreen = true
    end
    ---[[
    if self.entity.y > SCREEN_HEIGHT_LIMIT then
        self.entity.offscreen = true
    end
    --]]

    --ADD COLLISION DETECTION AND RESET POSITIONS
end

function EntityWalkState:processAI(params, dt, player)
    local tashio = player
    local velocity = .5
    if self.entity.type == 'gecko' then
        if self.entity.corrupted then
            --TRACK PLAYERS X POSITION
            if self.entity.aiPath == 1 then
                if self.entity.x > tashio.x + 2 then
                    self.entity.direction = 'left'
                elseif self.entity.x + 2 < tashio.x then
                    self.entity.direction = 'right'
                elseif self.entity.y > tashio.y then
                    self.entity.direction = 'up'
                elseif self.entity.y < tashio.y then
                    self.entity.direction = 'down'
                end
                --TRACK PLAYERS Y POSITION
            elseif self.entity.aiPath == 2 then
                if self.entity.y > tashio.y + 2 then
                    self.entity.direction = 'up'
                elseif self.entity.y + 2 < tashio.y then
                    self.entity.direction = 'down'
                elseif self.entity.x > tashio.x then
                    self.entity.direction = 'left'
                elseif self.entity.x < tashio.x then
                    self.entity.direction = 'right'
                end
            end
        end
    end
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))


        --[[
    love.graphics.setColor(RED)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 8, 32, 16, 16)
    love.graphics.setColor(WHITE)
    --]]

    --HEALTH BARS
    --[[
    if self.entity.type == 'gecko' then
        love.graphics.setColor(1,0,0,1)
        love.graphics.rectangle('fill', self.entity.x, self.entity.y - 1, self.entity.health * 5.3, 1)
        love.graphics.setColor(WHITE)
        love.graphics.print(self.entity.health, self.entity.x, self.entity.y - 5)
    end
    --]]
end
