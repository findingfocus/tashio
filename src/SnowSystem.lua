SnowSystem = Class{}

local EMISSION_RATE = 800
local WIND_ANGLE = 0
local MAX_ANGLE = 120
local MIN_ANGLE = 40
local MIN_Y = 30
local MAX_Y = 80
local LIFESPAN = 4
local increase = false

function SnowSystem:init()
  self.psystems = love.graphics.newParticleSystem(particle, 800)
  self.initialEmissionRate = 800
  self.initialLightEmissionRate = 400
  self.initialHeavyEmissionRate = 1200
  self.psystems:setEmissionRate(self.initialEmissionRate)
end

function SnowSystem:update(dt)
  if not increase then
    WIND_ANGLE = WIND_ANGLE + 1
  else
    WIND_ANGLE = WIND_ANGLE - 0.5
  end
  if WIND_ANGLE > MAX_ANGLE then
    increase = true
    WIND_ANGLE = MAX_ANGLE
  end
  if WIND_ANGLE < MIN_ANGLE then
    increase = false
    WIND_ANGLE = MIN_ANGLE
  end

  self.psystems:moveTo(0, 0)
  self.psystems:setEmissionArea('normal', SCREEN_WIDTH_LIMIT, 0)
  self.psystems:setParticleLifetime(1, LIFESPAN)
  self.psystems:setLinearAcceleration(WIND_ANGLE, MIN_Y, WIND_ANGLE, MAX_Y)
  self.psystems:setColors(255/255, 255/255, 255/255, 255/255, 255/255, 255/255, 255/255, 255/255)
  self.psystems:update(dt)
end

function SnowSystem:render()
  if love.keyboard.isDown('5') then
    love.graphics.clear(0,0,0,255)
    love.graphics.print('SNOW: ' .. WIND_ANGLE, 0, 0)
  end
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.psystems,0,0)
  --love.graphics.print('THIS IS WEATHER', 0, 0)
end
