EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity
    self.entity:changeAnimation('idle-' .. self.entity.direction)

    self.waitDuration = 0
    self.waitTimer = 0
end

function EntityIdleState:processAI(params, dt)
    if self.waitDuration == 0 then
        self.waitDuration = math.random(5)
    else
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration then
            self.entity:changeState('walk')
        end
    end
end
