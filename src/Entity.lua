Entity = Class{}

function Entity:init(def)
    self.direction = 'down'
    self.animations = self:createAnimations(def.animations)

    self.x = def.x
    self.y = def.y
    self.height = def.height
    self.width = def.width
    self.width = def.width
    self.walkSpeed = def.walkSpeed
    self.offscreen = false

    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0
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

function Entity:leftCollides(target)
    return not (self.x > target.x + target.width or self.x + COLLISION_BUFFER < target.x or
                self.y + COLLISION_BUFFER > target.y + target.height or self.y + self.height - COLLISION_BUFFER < target.y)
end

function Entity:rightCollides(target)
    return not (self.x + self.width - COLLISION_BUFFER > target.x + target.width or self.x + self.width < target.x or
                self.y + COLLISION_BUFFER > target.y + target.height or self.y + self.height - COLLISION_BUFFER < target.y)
end

function Entity:topCollides(target)
    return not (self.x + self.width - COLLISION_BUFFER < target.x or self.x + COLLISION_BUFFER > target.x + target.width or
                self.y + COLLISION_BUFFER < target.y or self.y > target.y + target.height)
end

function Entity:bottomCollides(target)
    return not (self.x + self.width - COLLISION_BUFFER < target.x or self.x + COLLISION_BUFFER > target.x + target.width or
                self.y + self.height < target.y or self.y + self.height - COLLISION_BUFFER > target.y + target.height)
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
end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.setColor(WHITE)
    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    self.stateMachine:render()
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end
