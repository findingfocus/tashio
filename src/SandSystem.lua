SandSystem = Class{}
local EMISSION_RATE = 8000
local WIND_ANGLE = 0
local MAX_ANGLE = 20
local MIN_ANGLE = -20
local MIN_Y = -100
local MAX_Y = 100
local LIFESPAN = 2
local increase = false

function SandSystem:init()
    self.psystems = love.graphics.newParticleSystem(particle, 8000)
end

function SandSystem:update(dt)
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

    self.psystems:moveTo(SCREEN_WIDTH_LIMIT, SCREEN_HEIGHT_LIMIT / 2)
    self.psystems:setEmissionArea('normal', 30, SCREEN_HEIGHT_LIMIT)
    self.psystems:setLinearAcceleration(-200, MIN_Y, -250, MAX_Y)
    self.psystems:setParticleLifetime(1, LIFESPAN)
    self.psystems:setEmissionRate(EMISSION_RATE)
    self.psystems:setColors(235/255, 235/255, 0/255, 255/255, 250/255, 150/255, 20/255, 255/255)
    self.psystems:update(dt)
end

function SandSystem:render()
    if love.keyboard.isDown('5') then
        love.graphics.clear(0,0,0,255)
        love.graphics.print('SAND: ' .. WIND_ANGLE, 0, 0)
    end
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(self.psystems,0,0)
    --love.graphics.print('THIS IS WEATHER', 0, 0)
end
