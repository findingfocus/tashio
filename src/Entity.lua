Entity = Class{}

particle = love.graphics.newImage('graphics/particle.png')

function Entity:init(def)
    self.direction = 'down'
    self.animations = self:createAnimations(def.animations)

    self.x = def.x
    self.y = def.y
    self.height = def.height
    self.width = def.width
    self.walkSpeed = def.walkSpeed
    self.offscreen = false
    self.psystem = love.graphics.newParticleSystem(particle, 400)

    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0
    self.type = nil
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
    self.stateMachine:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    if self.type == 'gecko' then
        self.psystem:moveTo(self.x + 8, self.y + 8)
        self.psystem:setParticleLifetime(1, 4)
        self.psystem:setEmissionArea('borderellipse', 2, 2)
        self.psystem:setEmissionRate(40)
        --self.psystem:setLinearAcceleration(-2, -2, 2, 2)
        --self.psystem:setRadialAcceleration(1)
        self.psystem:setTangentialAcceleration(0, 4)
        self.psystem:setColors(67/255, 25/255, 36/255, 255/255, 25/255, 0/255, 51/255, 0/255)
        self.psystem:update(dt)
    end
end

function Entity:processAI(params, dt, player)
    self.stateMachine:processAI(params, dt, player)
end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
    --love.graphics.setColor(WHITE)
    love.graphics.draw(self.psystem, adjacentOffsetX, adjacentOffsetY)
    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    self.stateMachine:render()
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end
