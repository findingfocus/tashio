PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)

end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
        love.keyboard.isDown('up') or love.keyboard.isDown('down') then
            self.entity:changeState('walk')
    end

    --DONT CHANGE TO WALK IF CONTRIDICTING INPUTS HELD
end
