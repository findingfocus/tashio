FallingChasmState = Class{__includes = BaseState}

function FallingChasmState:init()
  --SCREEN LOCK POSITION
  love.window.setPosition(220, 120)
  self.init = false
  self.psystems = {}
  self.psystems[1] = love.graphics.newParticleSystem(particle, 4000)
  self.psystems[2] = love.graphics.newParticleSystem(particle, 4000)
  self.emissionArea = 0
  self.emissionAreaSpeedRamp = 0
  self.emissionArea2 = 0
  self.psystem2Trigger = false
  self.playerX = -17
  self.playerY = -8
  self.zigzagTime = 0
end

function FallingChasmState:update(dt)
  self.zigzagTime = self.zigzagTime + dt
  self.offsetX = math.sin(self.zigzagTime) / 6
  self.offsetY = math.cos(self.zigzagTime) / 6
  self.playerX = self.playerX + self.offsetX
  self.playerY = self.playerY + self.offsetY

  self.emissionArea = self.emissionArea + dt * 40
  --self.emissionArea = self.emissionArea + dt * 40
  if self.emissionArea > 50 then
    self.psystem2Trigger = true
  end
  if self.psystem2Trigger then
    self.emissionArea2 = self.emissionArea2 + dt * 40
  end
  if not self.init then
    gPlayer:changeAnimation('chasm-fall')
    self.init = true
  end
  gPlayer.currentAnimation:update(dt)

  self.psystems[1]:setParticleLifetime(2)
  self.psystems[1]:setEmissionArea('borderellipse', 20, 20)
  self.psystems[1]:setEmissionRate(400)
  self.psystems[1]:setRadialAcceleration(40, 220)
  self.psystems[1]:setColors(80/255, 50/255, 80/255, 10/255, 130/255, 7/255, 230/255, 255/255)
  self.psystems[1]:update(dt)



  --[[
  self.psystems[2]:setParticleLifetime(2, 4)
  self.psystems[2]:setEmissionArea('borderellipse', self.emissionArea, self.emissionArea)
  self.psystems[2]:setEmissionRate(400)
  self.psystems[2]:setTangentialAcceleration(10, 40)
  self.psystems[2]:setColors(40/255, 50/255, 80/255, 0/255, 25/255, 0/255, 100/255, 255/255)
  self.psystems[2]:update(dt)
  --]]

  if self.emissionArea > 100 then
    self.emissionArea = 0
    self.emissionAreaSpeedRamp = 0
  end

  if self.emissionArea2 > 100 then
    self.emissionArea2 = 0
  end
end

function FallingChasmState:render()
  love.graphics.setColor(BLACK)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  love.graphics.setColor(WHITE)

  --CHASM PARTICLE SYSTEM
  love.graphics.draw(self.psystems[1], VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
  --love.graphics.draw(self.psystems[2], VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)

  local anim = gPlayer.currentAnimation
  --PLAYER BASE LAYER
  
  --love.graphics.translate(VIRTUAL_WIDTH / 2 - 8 - 10, VIRTUAL_HEIGHT / 2 - 8 -2)
  love.graphics.push()
  love.graphics.translate(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.playerX), math.floor(self.playerY))
  love.graphics.pop()
  --love.graphics.print(tostring(self.offset), 0, 0)
end
