Weather = Class{}
local EMISSION_RATE = 600
local WIND_ANGLE = -55
local increase = false

particle2 = love.graphics.newImage('graphics/particle.png')

function Weather:init()
    self.psystems = love.graphics.newParticleSystem(particle2, 600)
end

function Weather:update(dt)
    if not increase then
        WIND_ANGLE = WIND_ANGLE + 1
    else
        WIND_ANGLE = WIND_ANGLE - 1
    end
    if WIND_ANGLE > 400 then
        increase = true
        WIND_ANGLE = 400
    end
    if WIND_ANGLE < -400 then
        increase = false
        WIND_ANGLE = -400
    end

    self.psystems:moveTo(0, -50)
    --self.psystems:setEmissionArea('normal', SCREEN_WIDTH_LIMIT / 8, 1)
    self.psystems:setEmissionArea('normal', SCREEN_WIDTH_LIMIT, 0)
    self.psystems:setParticleLifetime(1, 5)
    self.psystems:setEmissionRate(EMISSION_RATE)
    self.psystems:setLinearAcceleration(WIND_ANGLE, 190, WIND_ANGLE, 250)
    self.psystems:setColors(0, 8/255, 60/255, 255/255, 0, 130, 229, 255/255)
    self.psystems:update(dt)
end

function Weather:render()
    if love.keyboard.isDown('3') then
        love.graphics.clear(0,0,0,255)
        love.graphics.print('WIND: ' .. WIND_ANGLE, 0, 0)
    end
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(self.psystems,10, 10)
    --love.graphics.print('THIS IS WEATHER', 0, 0)
end
