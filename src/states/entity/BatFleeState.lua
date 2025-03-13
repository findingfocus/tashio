BatFleeState = Class{__includes = BaseState}

function BatFleeState:init(entity)
  self.entity = entity
  self.entity.dx = 0
  self.entity.dy = 0
  self.stateName = 'flee'
  sounds['cleanse']:play()
  self.entity.damageFlash = true
  self.entity.corrupted = false
  self.entity.animations = self.entity:createAnimations(ENTITY_DEFS['bat'].animations)
  self.entity:changeAnimation('flee')
  self.entity.flyTL = false
  self.entity.flyTR = false
  self.entity.flyBL = false
  self.entity.flyBR = false
  self.entity.hit = false
  self.blocked = false

  --RIGHT EXIT
  if self.entity.x < gPlayer.x + (gPlayer.width / 2) then
    self.entity.dx = -BAT_EXIT_SPEED
  else
    self.entity.dx = BAT_EXIT_SPEED
  end

  if self.entity.y + self.entity.height < gPlayer.y + (gPlayer.width / 2) then
    self.entity.dy = -BAT_EXIT_SPEED
  else
    self.entity.dy = BAT_EXIT_SPEED
  end
end

function BatFleeState:resetOriginalPosition()
  self.entity.health = 1
  self.entity.spawning = true
  self.entity.corrupted = true
  self.entity.zigzagTime = 0
  self.entity.walkSpeed = self.entity.originalWalkSpeed
  self.entity.zigzagFrequency = math.random(1, 5)
  --self.entity.zigzagAmplitude = math.random(.3, .35)
  self.entity.zigzagAmplitude = math.random(1, 5) / 10
  self.entity.spawnTimer = 2
  self.entity.setLocation = false
  self.entity.pursueTimer = 0
  self.entity:changeState('bat-spawn')
  self.entity:changeAnimation('pursue')
end

function BatFleeState:processAI(params, dt, player)

end

function BatFleeState:update(dt)
  if self.entity.x < -self.entity.width or self.entity.x > VIRTUAL_WIDTH then
    if self.entity.y + self.entity.height < 0 or self.entity.y > VIRTUAL_HEIGHT then
      for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do
        if v.classType == 'pushable' then
          if self.entity.spawnRow == 1 then
            if v.y == TILE_SIZE and v.x == self.entity.spawnColumn * TILE_SIZE - TILE_SIZE then
              self.blocked = true
              break
            else
              self.blocked = false
            end
          elseif self.spawnRow == 8 then --BOTTOM ENTRANCE
            if v.y == TILE_SIZE * 6 and v.x == self.entity.spawnColumn * TILE_SIZE - TILE_SIZE then
              self.blocked = true
              break
            else
              self.blocked = false
            end
          elseif self.spawnColumn == 10 then --RIGHT SIDE ENTRANCE
            if v.y == self.entity.spawnRow * TILE_SIZE - TILE_SIZE and v.x == TILE_SIZE * 8 then
              self.blocked = true
              break
            else
              self.blocked = false
            end
          elseif self.spawnColumn == 1 then --LEFT SIDE ENTRANCE
            if v.y == self.entity.spawnRow * TILE_SIZE - TILE_SIZE and v.x == TILE_SIZE then
              self.blocked = true
              break
            else
              self.blocked = false
            end
          end
        end

        if not self.blocked then
          self:resetOriginalPosition()
        end
      end
    end
  end
end

function BatFleeState:render()
  love.graphics.setColor(WHITE)
  local anim = self.entity.currentAnimation
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
  self.entity.x, self.entity.y)
  --love.graphics.print(tostring(self.entity.stateMachine.current.stateName), self.entity.x, self.entity.y)

  --[[
  love.graphics.print('dx: ' .. tostring(self.entity.dx), 0, 0)
  love.graphics.print('dy: ' .. tostring(self.entity.dy), 0, 10)
  love.graphics.print('walkSpeed: ' .. tostring(self.entity.walkSpeed), 0, 20)
  --]]
  --love.graphics.print('blocked: ' .. tostring(self.blocked), 0, 10)
end
