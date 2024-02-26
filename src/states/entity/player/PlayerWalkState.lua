PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player, room)
    self.entity = player
    self.room = room
end

function PlayerWalkState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    else
        self.entity:changeState('idle')
    end

    --ADD COLLISION DETECTION
    --ADD EVENT DISPATCH FOR SHIFTING SCREENS
end
