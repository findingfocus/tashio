Entity = Class{}

function Enity:init(def)
    self.direction = 'down'

    self.animations = self:createAnimation(def.animation)

end



function Entity:createAnimations(animations)
    local animationReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationReturned
end

function Entity:collides(target)
    if self.x > target.x + target.width and self.x + self.width < target.x and self.y > target.y + target.width and self.y + self.height < target.y then
        return false
    else
        return true
    end
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animation[name]
end

function Entity:update(dt)
    self.stateMachine:update(dt)
end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    self.stateMachine:render()
    love.graphics.setColor(WHITE)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end



