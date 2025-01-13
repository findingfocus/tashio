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
    self.entity.displacementX = 0
    self.entity.displacementY = 0
    self.entity.displaceIncrease = true
end

function getDistanceToPlayer(player, entity)
    local aLength, bLength, cLength, aSquared, bSquared, cSquared = 0, 0, 0, 0, 0, 0
    entity.distanceToPlayer = 0
    if math.abs(entity.x - player.x) <= 10 then
        if entity.y < player.y then
            --BOTTOM OF BAT to TOP OF PLAYER
            entity.distanceToPlayer = player.y - (entity.y + entity.height)
        else
            --TOP OF BAT TO BOTTOM PLAYER
            entity.distanceToPlayer = entity.y - (player.y + player.height)
        end
    end
    if math.abs(entity.y - player.y) <= 10 then
        if entity.x < player.x then
            --RIGHT OF BAT TO LEFT OF PLAYER
            entity.distanceToPlayer = player.x - (entity.x + entity.width)
        else
            --LEFT OF BAT TO RIGHT OF PLAYER
            entity.distanceToPlayer = entity.x - (player.x + player.width)
        end
    end
    ---[[
    if entity.x < player.x then --BAT IS ON THE LEFT
        if entity.y < player.y then --BAT IS IN TOPLEFT
            --BR OF BAT to TL of PLAYER
            aLength = math.abs((entity.x + entity.width) - player.x - BAT_DISTANCE)
            bLength = math.abs((entity.y + entity.height) - player.y - BAT_DISTANCE)
        else --BAT IS IN BOTTOM LEFT
            --TR OF BAT to BL of PLAYER
            aLength = math.abs((entity.x + entity.width - BAT_DISTANCE) - player.x)
            bLength = math.abs(entity.y - (player.y + player.height - BAT_DISTANCE))
        end
    else --BAT IS ON THE RIGHT
        if entity.y < player.y then --BAT IS IN TOPRIGHT
            --BL OF BAT TO TR of PLAYER
            aLength = math.abs(entity.x - (player.x + player.width - BAT_DISTANCE))
            bLength = math.abs((entity.y + entity.height - BAT_DISTANCE) - player.y)
        else --BAT IS IN BOTTOM RIGHT
            --TL OF BAT TO BR of PLAYER
            aLength = math.abs(entity.x - (player.x + player.width - BAT_DISTANCE))
            bLength = math.abs(entity.y - (player.y + player.height - BAT_DISTANCE))
        end
    end
    --]]

    aSquared = aLength * aLength
    bSquared = bLength * bLength
    cSquared = aSquared + bSquared
    cLength = math.sqrt(cSquared)
    if entity.distanceToPlayer == 0 then
        entity.distanceToPlayer = cLength
    end
end

function BatWalkState:update(dt)
    if self.entity.displaceIncrease then
        self.entity.displacementX = self.entity.displacementX + dt * 5
        self.entity.displacementY = self.entity.displacementY + dt * 5
        if self.entity.displacementX >= self.entity.displacementMagnitude then
            self.entity.displaceIncrease = false
        end
    end

    if not self.entity.displaceIncrease then
        self.entity.displacementX = self.entity.displacementX - dt * 5
        self.entity.displacementY = self.entity.displacementY - dt * 5
        if self.entity.displacementX <= -self.entity.displacementMagnitude then
            self.entity.displaceIncrease = true
        end
    end

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
    ---[[
    if self.entity.distanceToPlayer > 10 then
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
    ---[[
    --]]
    self.entity.x = self.entity.displacementX + self.entity.x
    self.entity.y = self.entity.displacementY + self.entity.y
    getDistanceToPlayer(player, self.entity)
end

function BatWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.entity.x, self.entity.y)
    --[[
    love.graphics.setColor(WHITE)
    love.graphics.print(self.entity.distanceToPlayer, self.entity.x, self.entity.y - 5)
    --]]
    ---[[
    self.entity.y = self.entity.y - self.entity.displacementY
    self.entity.x = self.entity.x - self.entity.displacementX
    --]]
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
end
