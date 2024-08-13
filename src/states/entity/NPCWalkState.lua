NPCWalkState = Class{__includes = BaseState}

local waitTimer = 1
local walkTimer = 0.4

function NPCWalkState:init(entity)
    self.entity = entity
    self.direction = entity.direction
    self.entity:changeAnimation('idle-' .. tostring(self.direction))
    self.cClockwiseDirections = {'down', 'right', 'up', 'left'}
    self.directionIndex = 1
    self.step1 = false
    self.step2 = false
    self.step3 = false
    self.step4 = false
    self.waitTimer = waitTimer
    self.walkTimer = walkTimer
    self.initialTimer = 0
    self.initializedWalking = false
end

function NPCWalkState:update(dt)
    if self.option == 'square' then
        if not self.initializedWalking then
            self.initialTimer = self.initialTimer + dt
            if self.initialTimer > 1 then
                self.initializedWalking = true
                self.step1 = true
            end
        end

        if self.step1 then
            if self.directionIndex == 4 then
                self.directionIndex = 1
            else
                self.directionIndex = self.directionIndex + 1
            end
            self.direction = self.cClockwiseDirections[self.directionIndex]
            self.entity:changeAnimation('idle-' .. tostring(self.direction))
            self.step1 = false
            self.step2 = true
        elseif self.step2 then
            self.waitTimer = self.waitTimer - dt
            if self.waitTimer <= 0 then
                self.step2 = false
                self.step3 = true
                self.waitTimer = math.random(0.5, 2)
            end
        elseif self.step3 then
            self.walkTimer = self.walkTimer - dt
            if self.direction == 'right' then
                self.entity.x = self.entity.x + self.entity.walkSpeed * dt
                self.entity:changeAnimation('walk-' .. tostring(self.direction))
            elseif self.direction == 'up' then
                self.entity.y = self.entity.y - self.entity.walkSpeed * dt
                self.entity:changeAnimation('walk-' .. tostring(self.direction))
            elseif self.direction == 'left' then
                self.entity.x = self.entity.x - self.entity.walkSpeed * dt
                self.entity:changeAnimation('walk-' .. tostring(self.direction))
            elseif self.direction == 'down' then
                self.entity.y = self.entity.y + self.entity.walkSpeed * dt
                self.entity:changeAnimation('walk-' .. tostring(self.direction))
            end
            if self.walkTimer <= 0 then
                self.step3 = false
                self.step4 = true
                self.entity:changeAnimation('idle-' .. tostring(self.direction))
                self.walkTimer = walkTimer
            end
        elseif self.step4 then
            self.waitTimer = self.waitTimer - dt
            if self.waitTimer <= 0 then
                self.step4 = false
                self.step1 = true
                self.waitTimer = math.random(0.5, 2)
            end
        end
    elseif self.option == 'walkDown' then
        self.entity:changeAnimation('walk-' .. tostring(self.direction))
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt
    end
end

function NPCWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))
    --love.graphics.print('step4: ' .. tostring(self.step4), 0, 10)
end
