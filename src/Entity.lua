Entity = Class{}

particle = love.graphics.newImage('graphics/particle.png')

function Entity:init(def)
    self.x = def.x
    self.y = def.y
    self.dx = 0
    self.dy = 0
    self.hit = false
    self.flipped = false
    self.width = def.width
    self.height = def.height
    self.direction = def.direction or 'down'
    self.animations = self:createAnimations(def.animations)
    self.health = def.health
    self.corrupted = true

    self.walkSpeed = def.walkSpeed
    self.aiPath = def.aiPath
    --self.walkSpeed = math.random
    self.offscreen = false
    self.psystem = love.graphics.newParticleSystem(particle, 400)

    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0
    self.type = def.type or nil

    --ORIGINAL POSITION RESETS
    self.originalAnimations = self:createAnimations(def.animations)
    self.originalX = def.x
    self.originalY = def.y
    self.originalDirection = def.direction
    self.originalType = def.type
end

function Entity:resetOriginalPosition()
    self.animations = self.originalAnimations
    self.x = self.originalX
    self.y = self.originalY
    self.direction = self.originalDirection
    self.type = self.originalType
    self.psystem:reset()
    self:changeState('entity-idle')
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationsDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationsDef.texture or 'entities',
            frames = animationsDef.frames,
            interval = animationsDef.interval
        }
    end
    return animationsReturned
end

function Entity:collides(target)
    return not (self.x + self.width - COLLISION_BUFFER < target.x or self.x + COLLISION_BUFFER > target.x + target.width or
                self.y + self.height - COLLISION_BUFFER < target.y or self.y + COLLISION_BUFFER > target.y + target.height)
end

function Entity:fireSpellCollides(target)
    return not (self.x + self.width - COLLISION_BUFFER < target.x or self.x + COLLISION_BUFFER > target.x + target.width or
                self.y + self.height - COLLISION_BUFFER < target.y + FLAME_COLLISION_BUFFER or self.y + COLLISION_BUFFER > target.y + target.height)
end

function Entity:leftCollidesMapObject(target)
    return not (self.x + 1 > target.x + target.width or self.x + 3 < target.x or
                self.y + 8 > target.y + target.height or self.y + self.height - 2 < target.y)
end

function Entity:rightCollidesMapObject(target)
    return not (self.x + self.width - 3 > target.x + target.width or self.x + self.width - 1 < target.x or
                self.y + 8 > target.y + target.height or self.y + self.height - 2 < target.y)
end

function Entity:topCollidesMapObject(target)
    return not (self.x + 3 > target.x + target.width or self.x + self.width - 3 < target.x or
                self.y + 6 > target.y + target.height or self.y + 8 < target.y)
end

function Entity:bottomCollidesMapObject(target)
    return not (self.x + 3 > target.x + target.width or self.x + self.width - 3 < target.x or
                self.y + self.height - 2 > target.y + target.height or self.y + self.height < target.y)
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:update(dt)
    local decrease = 2.5
    if self.dx > 0 then
        self.dx = math.max(0, self.dx - decrease * dt)
    end
    if self.dy > 0 then
        self.dy = math.max(0, self.dy - decrease * dt)
    end
    ---[[
    if self.dx < 0 then
        self.dx = math.min(0, self.dx + decrease * dt)
    end
    if self.dy < 0 then
        self.dy = math.min(0, self.dy + decrease * dt)
    end
        --]]

    self.stateMachine:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    --GECKO PARTICLE SYSTEM
    if self.type == 'gecko' then
        if self.corrupted then
            self.psystem:moveTo(self.x + 8, self.y + 8)
            self.psystem:setParticleLifetime(1, 4)
            self.psystem:setEmissionArea('borderellipse', 2, 2)
            self.psystem:setEmissionRate(40)
            self.psystem:setTangentialAcceleration(0, 4)
            self.psystem:setColors(67/255, 25/255, 36/255, 255/255, 25/255, 0/255, 51/255, 0/255)
            self.psystem:update(dt)
        else
            self.psystem:reset()
        end
    end

    if self.type == 'gecko' and successfulCast then
        for i = 1, sceneView.spellcastEntityCount do
            local spellX = sceneView.spellcastEntities[i].x
            local spellY = sceneView.spellcastEntities[i].y
            if self:fireSpellCollides(sceneView.spellcastEntities[i]) then
                self.health = math.max(0, self.health - 5)
                if self.x > spellX then
                    self.dx = 1.3
                else
                    self.dx = -1.3
                end
                if self.y > spellY then
                    self.dy = 1.3
                else
                    self.dy = -1.3
                end
                self.hit = true
            end
        end
    end

    if self.hit then
        self.x = self.x + self.dx
        self.y = self.y + self.dy
        if self.dx == 0 or self.dy == 0 then
            self.hit = false
        end
    end
end

function Entity:processAI(params, dt, player)
    self.stateMachine:processAI(params, dt, player)
end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
    if self.type == 'gecko' then --IF TYPE HAS PARTICLE SYSTEM TODO
        love.graphics.draw(self.psystem, math.floor(adjacentOffsetX), math.floor(adjacentOffsetY))
    end
    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    self.stateMachine:render()
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end
