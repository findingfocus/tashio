RainSystem = Class{}
local EMISSION_RATE = 600
local WIND_ANGLE = -55
local MIN_ANGLE = -400
local MAX_ANGLE = 400
local MIN_Y = 190
local MAX_Y = 250
local increase = false

function RainSystem:init()
    self.psystems = love.graphics.newParticleSystem(particle, 600)
end

function RainSystem:update(dt)
    if not increase then
        WIND_ANGLE = WIND_ANGLE + 1
    else
        WIND_ANGLE = WIND_ANGLE - 1
    end
    if WIND_ANGLE > MAX_ANGLE then
        increase = true
        WIND_ANGLE = MAX_ANGLE
    end
    if WIND_ANGLE < MIN_ANGLE then
        increase = false
        WIND_ANGLE = MIN_ANGLE
    end

    self.psystems:moveTo(0, -50)
    --self.psystems:setEmissionArea('normal', SCREEN_WIDTH_LIMIT / 8, 1)
    self.psystems:setEmissionArea('normal', SCREEN_WIDTH_LIMIT, 0)
    self.psystems:setParticleLifetime(1, 5)
    self.psystems:setEmissionRate(EMISSION_RATE)
    self.psystems:setLinearAcceleration(WIND_ANGLE, MIN_Y, WIND_ANGLE, MAX_Y)
    self.psystems:setColors(0, 8/255, 60/255, 255/255, 0, 130, 229, 255/255)
    self.psystems:update(dt)
end

function RainSystem:render()
    if love.keyboard.isDown('5') then
        love.graphics.clear(0,0,0,255)
        love.graphics.print('WIND: ' .. WIND_ANGLE, 0, 0)
    end
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(self.psystems,10, 10)
    --love.graphics.print('THIS IS WEATHER', 0, 0)
end
