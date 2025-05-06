LavaSystem = Class{}
local SOOT_EMISSION_RATE = 5
local WIND_ANGLE = 0
local MAX_ANGLE = 10
local MIN_ANGLE = -10
local SOOT_MIN_Y = 5
local SOOT_MAX_Y = 15
local LAVA_MIN_Y = -5
local LAVA_MAX_Y = -18
local LAVA_EMISSION_RATE = 10
local LIFESPAN = 15
local increase = false

function LavaSystem:init()
  self.soot = love.graphics.newParticleSystem(particle, 10)
  self.lavaBubbles = love.graphics.newParticleSystem(particle, 50)
end

function LavaSystem:update(dt)
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

  self.soot:moveTo(0, 0)
  --self.soot:setEmissionArea('normal', SCREEN_WIDTH_LIMIT / 8, 1)
  self.soot:setEmissionArea('normal', SCREEN_WIDTH_LIMIT, 0)
  self.soot:setParticleLifetime(1, LIFESPAN)
  self.soot:setEmissionRate(SOOT_EMISSION_RATE)
  self.soot:setLinearAcceleration(WIND_ANGLE, SOOT_MIN_Y, WIND_ANGLE, SOOT_MAX_Y)
  self.soot:setColors(0/255, 0/255, 0/255, 255/255, 0/255, 0/255, 0/255, 0/255)
  self.soot:update(dt)



  self.lavaBubbles:moveTo(80, 64)
  self.lavaBubbles:setEmissionArea('normal', SCREEN_WIDTH_LIMIT / 2, SCREEN_HEIGHT_LIMIT / 2)
  self.lavaBubbles:setParticleLifetime(1, LIFESPAN)
  self.lavaBubbles:setEmissionRate(LAVA_EMISSION_RATE)
  self.lavaBubbles:setLinearAcceleration(-10, LAVA_MIN_Y, 10, LAVA_MAX_Y)
  self.lavaBubbles:setColors(250/255, 0/255, 0/255, 150/255, 255/255, 0/255, 0/255, 0/255)
  self.lavaBubbles:update(dt)
end

function LavaSystem:render()
  if love.keyboard.isDown('5') then
    --love.graphics.clear(0,0,0,255)
    love.graphics.clear(1,1,1,255)
    love.graphics.print('LAVA: ' .. WIND_ANGLE, 0, 0)
  end
  --love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.soot,0,0)
  love.graphics.draw(self.lavaBubbles,0,0)
  --love.graphics.print('THIS IS WEATHER', 0, 0)
end
