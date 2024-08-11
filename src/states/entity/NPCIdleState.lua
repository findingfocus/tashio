NPCIdleState = Class{__includes = BaseState}

function NPCIdleState:init(entity)
    self.entity = entity
    self.direction = entity.direction
    self.entity:changeAnimation('idle-' .. tostring(self.direction))
    self.cClockwiseDirections = {'down', 'right', 'up', 'left'}
    self.directionIndex = 1
end

local timer = 0
local walkTimer = 0

function NPCIdleState:update(dt)
    self.entity:changeState('npc-walk')
    timer = timer + dt
    walkTimer = walkTimer + dt
    if timer > 1 then
        self.directionIndex = self.directionIndex + 1
        if self.directionIndex > 4 then
            self.directionIndex = 1
        end
        self.entity:changeAnimation('idle-' .. tostring(self.cClockwiseDirections[self.directionIndex]))
        self.entity.direction = tostring(self.cClockwiseDirections[self.directionIndex])
        timer = 0
    end
    if walkTimer > 3 then
        self.entity:changeState('npc-walk')
    end
end

function NPCIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))
end
