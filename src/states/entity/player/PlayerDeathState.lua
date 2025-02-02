PlayerDeathState = Class{__includes = BaseState}

function PlayerDeathState:init(player, scene)
    self.player = player
    self.scene = scene
    PLAYER_STATE = 'DEATH'
    self.timer = 0
    self.player:changeAnimation('death')
end

function PlayerDeathState:update(dt)
end

function PlayerDeathState:render()
    local anim = self.player.currentAnimation

    --love.graphics.draw('HELOOO', 0, 0)
    --PLAYER BASE LAYER
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
end
