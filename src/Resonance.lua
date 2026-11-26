Resonance = Class{}

function Resonance:init(entityType, entity, state, x, y)
  self.entityType = entityType or nil
  self.entity = entity or nil
  if self.entity then
    self.entityX = self.entity.x
    self.entityY = self.entity.y
  else
    self.entityX = 0
    self.entityY = 0
  end
  if x then
    self.entityX = x
  end
  if y then
    self.entityY = y
  end

  self.state = state or nil
  if self.entityType == 'player' then
    self.luteResonanceX = gPlayer.x + TILE_SIZE / 2
    self.luteResonanceY = gPlayer.y + TILE_SIZE / 2
  else
    self.luteResonanceX = self.entityX + TILE_SIZE / 2
    self.luteResonanceY = self.entityY + TILE_SIZE / 2
  end
  self.luteResonanceRadius = 0
  self.luteResonanceMaxRadius = 50
  self.ringActive = true
  self.luteResonanceAlpha = 255
  self.collided = {}
  self.leftCollisionTriggered = false
  self.fading = false
  self.fadeSpeed = 392
end

function Resonance:fade(fadeTime)
  self.fading = true
  if fadeTime ~= nil then
    self.fadeSpeed = 255 / fadeTime
  end
end

function Resonance:reset()
  self.luteResonanceRadius = 0
  self.luteResonanceMaxRadius = 60
  self.ringActive = true
  self.luteResonanceAlpha = 255
  self.collided = {}
  self.leftCollisionTriggered = false
  self.fading = false
  self.fadeSpeed = 392
end

function Resonance:update(dt)
  if self.fading then
    --FADE TO CLEAR ON SCENE TRANSITION
    self.luteResonanceAlpha = self.luteResonanceAlpha - self.fadeSpeed * dt
    if self.entityType == 'player' then
      self.luteResonanceX = gPlayer.x + TILE_SIZE / 2
      self.luteResonanceY = gPlayer.y + TILE_SIZE / 2
    end
    if self.luteResonanceAlpha <= 0 then
      self.luteResonanceAlpha = 0
      self.ringActive = false
      self.collided = {}
    end
    return
  end
  if self.ringActive then
    self.luteResonanceRadius = self.luteResonanceRadius + LUTE_RESONANCE_SPEED

    if self.entityType == 'player' then
      self.luteResonanceX = gPlayer.x + TILE_SIZE / 2
      self.luteResonanceY = gPlayer.y + TILE_SIZE / 2
      for k, entity in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].entities) do
        if entity.distanceToPlayer < self.luteResonanceRadius then
          --EMIT RINGS TEST
          if not self.collided[entity] then
            table.insert(entity.resonanceRings, Resonance('enemy', entity, entity.resonanceState))
            self.collided[entity] = true
          end
        end
      end
    else
      self.luteResonanceX = self.entityX + TILE_SIZE / 2
      self.luteResonanceY = self.entityY + TILE_SIZE / 2
    end


    local prog = math.max(0, math.min(1, self.luteResonanceRadius / self.luteResonanceMaxRadius))
    self.luteResonanceAlpha = 255 * (1 - prog ^ 3)

  end

  if self.luteResonanceAlpha <= 0 then
    self.ringActive = false
    self.collided = {}
  end
end

function Resonance:render()
  love.graphics.setLineWidth(1)
  if self.ringActive then
    if self.entityType == 'player' then
      love.graphics.setColor(LUTE_RESONANCE_COLOR)
      love.graphics.setColor(255/255, 206/255, 82/255, self.luteResonanceAlpha/255)
    end

    --RESONANCE RING STATE COLOR
    if self.state == 'corrupt' then
      love.graphics.setColor(195/255, 0/255, 255/255, self.luteResonanceAlpha/255)
    elseif self.state == 'cleansed' then
      love.graphics.setColor(0/255, 255/255, 0/255, self.luteResonanceAlpha/255)
    elseif self.state == 'reintegrated' then
      love.graphics.setColor(255/255, 206/255, 82/255, self.luteResonanceAlpha/255)
    end
    love.graphics.circle('line', self.luteResonanceX, self.luteResonanceY, self.luteResonanceRadius)
    love.graphics.setColor(WHITE)

    -- if self.collided then
    --   love.graphics.setColor(RED)
    --   love.graphics.circle('fill', self.luteResonanceX, self.luteResonanceY, self.luteResonanceRadius)
    -- end
  end
  --love.graphics.print('entityX: ' .. tostring(self.entityX), 0, 20)
end
