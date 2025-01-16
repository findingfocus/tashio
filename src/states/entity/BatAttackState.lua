BatAttackState = Class{__includes = BaseState}

function BatAttackState:init(entity, scene)
    self.entity = entity
    self.scene = scene
    if self.entity.corrupted then
        self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['batC'].animations)
    elseif not self.entity.corrupted then
        self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['batC'].animations)
    end
    self.timer = 1
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

function BatAttackState:processAI(params, dt, player)
    getDistanceToPlayer(player, self.entity)
    if self.entity.distanceToPlayer > 10 then
        self.entity:changeState('bat-walk')
    end


end

function BatAttackState:update(dt)
    self.timer = self.timer - dt
    if self.timer <= 0 then
        table.insert(MAP[sceneView.currentMap.row][sceneView.currentMap.column].attacks, Spitball(self.entity))
        self.timer = 1
    end
end

function BatAttackState:render()
    love.graphics.setColor(RED)
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.entity.x, self.entity.y)
end
