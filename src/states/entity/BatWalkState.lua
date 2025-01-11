BatWalkState = Class{__includes = BaseState}

function BatWalkState:init(entity, scene)
    self.entity = entity
    if self.entity.corrupted then
        self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['batC'].animations)
    elseif not self.entity.corrupted then
        self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['batC'].animations)
    end
    --self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    --self.entity.walkSpeed = .5
    self.scene = scene

    self.moveDuration = 0
    self.movementTimer = 0

    self.collided = false
end

function getDistanceToPlayer(player, entity)
    local aLength, bLength, cLength, aSquared, bSquared, cSquared = 0, 0, 0, 0, 0, 0
    aLength = math.abs(player.x - entity.x)
    bLength = math.abs(player.y - entity.y)
    aSquared = aLength * aLength
    bSquared = bLength * bLength
    cSquared = aSquared + bSquared
    cLength = math.sqrt(cSquared)
    entity.distanceToPlayer = cLength
end

function BatWalkState:update(dt)
    if self.entity.corrupted then
        if self.entity.health <= 0 then
            sounds['cleanse']:play()
            self.entity.damageFlash = false
            self.entity.flashing = false
            self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['batC'].animations)
            local random = math.random(4)
            self.entity.corrupted = false
        end
    end

    self.collided = false


    self.entity.x = self.entity.x + self.entity.dx * dt
    self.entity.y = self.entity.y + self.entity.dy * dt


    --TRIGGER OFFSCREEN
    if self.entity.x + self.entity.width < -TILE_SIZE or self.entity.x > VIRTUAL_WIDTH + TILE_SIZE or self.entity.y + self.entity.height < -TILE_SIZE then
        --ADD IN BOTTOM RULE AS WELL
       self.entity.offscreen = true
    end
    if self.entity.y > SCREEN_HEIGHT_LIMIT then
        self.entity.offscreen = true
    end

end

function BatWalkState:processAI(params, dt, player)
    getDistanceToPlayer(player, self.entity)

    ---[[
    if self.entity.distanceToPlayer > 25 then
        --ORTHOGONAL MOVEMENT
        if math.abs(player.y - self.entity.y) < .5 then
            self.entity.y = player.y
            if player.x < self.entity.x then --IF PLAYER IS TO THE LEFT OF BAT
                self.entity.x = self.entity.x - self.entity.walkSpeed
            elseif player.x > self.entity.x then --IF PLAYER IS TO THE RIGHT OF BAT
                self.entity.x = self.entity.x + self.entity.walkSpeed
            end
        end
        if math.abs(player.x - self.entity.x) < .5 then
            self.entity.x = player.x
            if player.y < self.entity.y then --IF PLAYER IS ABOVE THE BAT
                self.entity.y = self.entity.y - self.entity.walkSpeed
            elseif player.y > self.entity.y then --IF PLAYER BELOW BAT
                self.entity.y = self.entity.y + self.entity.walkSpeed
            end
        end

        --DIAGONAL MOVEMENT
        if player.x < self.entity.x and player.y < self.entity.y then --IF PLAYER UPLEFT OF BAT
            self.entity.x = self.entity.x - self.entity.walkSpeed * ((math.sqrt(2)) / 2)
            self.entity.y = self.entity.y - self.entity.walkSpeed * ((math.sqrt(2)) / 2)
        end
        if player.x < self.entity.x and player.y > self.entity.y then --IF PLAYER BOTTOMLEFT OF BAT
            self.entity.x = self.entity.x - self.entity.walkSpeed * ((math.sqrt(2)) / 2)
            self.entity.y = self.entity.y + self.entity.walkSpeed * ((math.sqrt(2)) / 2)
        end
        if player.x > self.entity.x and player.y < self.entity.y then --IF PLAYER UPRIGHT OF BAT
            self.entity.x = self.entity.x + self.entity.walkSpeed * ((math.sqrt(2)) / 2)
            self.entity.y = self.entity.y - self.entity.walkSpeed * ((math.sqrt(2)) / 2)
        end
        if player.x > self.entity.x and player.y > self.entity.y then --IF PLAYER BOTTOMRIGHT OF BAT
            self.entity.x = self.entity.x + self.entity.walkSpeed * ((math.sqrt(2)) / 2)
            self.entity.y = self.entity.y + self.entity.walkSpeed * ((math.sqrt(2)) / 2)
        end
    end
    --]]
    --[[
    Timer.tween(3, {
        [self.entity] = {x = sceneView.player.x, y = sceneView.player.y},
    })
    --]]

end

function BatWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.entity.x, self.entity.y)
    --DIALOGUE HITBOX RENDERS
    --[[
    love.graphics.setColor(RED)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 8, 32, 16, 16)
    love.graphics.setColor(WHITE)
    --]]

    --HEALTH BARS
    --[[
    love.graphics.setColor(1,0,0,1)
    love.graphics.rectangle('fill', self.entity.x, self.entity.y - 1, self.entity.health * 5.3, 1)
    --]]
    --[[
    love.graphics.setColor(WHITE)
    love.graphics.print(self.entity.distanceToPlayer, self.entity.x, self.entity.y - 5)
    --]]
end
