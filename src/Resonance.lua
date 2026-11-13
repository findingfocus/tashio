Resonance = Class{}

function Resonance:init(entityType, entity, state)
  self.entityType = entityType or nil
  self.entity = entity or nil
  self.state = state or nil
  if self.entityType == 'player' then
    self.luteResonanceX = gPlayer.x + TILE_SIZE / 2
    self.luteResonanceY = gPlayer.y + TILE_SIZE / 2
  else
    self.luteResonanceX = self.entity.x + TILE_SIZE / 2
    self.luteResonanceY = self.entity.y + TILE_SIZE / 2
  end
  self.luteResonanceRadius = 0
  self.luteResonanceMaxRadius = 60
  self.luteResonanceActive = true
  self.luteResonanceAlpha = 255
  self.collided = false
end

function Resonance:update(dt)
  if self.luteResonanceActive then
    self.luteResonanceRadius = self.luteResonanceRadius + LUTE_RESONANCE_SPEED

    if self.entityType == 'player' then
      self.luteResonanceX = gPlayer.x + TILE_SIZE / 2
      self.luteResonanceY = gPlayer.y + TILE_SIZE / 2
      for k, entity in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].entities) do
        if entity.distanceToPlayer < self.luteResonanceRadius then
          --EMIT RINGS TEST
          if not self.collided then
            table.insert(entity.resonanceRings, Resonance('enemy', entity, 'corrupt'))
          end
          self.collided = true
        else
          self.collided = false
        end
      end
    else
      self.luteResonanceX = self.entity.x + TILE_SIZE / 2
      self.luteResonanceY = self.entity.y + TILE_SIZE / 2
    end


    local prog = math.max(0, math.min(1, self.luteResonanceRadius / self.luteResonanceMaxRadius))
    self.luteResonanceAlpha = 255 * (1 - prog ^ 3)

  end

  if self.luteResonanceAlpha <= 0 then
    self.luteResonanceActive = false
    self.collided = false
  end
end

function Resonance:render()
  love.graphics.setLineWidth(1)
  if self.luteResonanceActive then
    if self.entityType == 'player' then
      love.graphics.setColor(255/255, 206/255, 82/255, self.luteResonanceAlpha/255)
    end

    if self.state == 'corrupt' then
      love.graphics.setColor(195/255, 0/255, 255/255, self.luteResonanceAlpha/255)
    end
    love.graphics.circle('line', self.luteResonanceX, self.luteResonanceY, self.luteResonanceRadius)
    love.graphics.setColor(WHITE)

    -- if self.collided then
    --   love.graphics.setColor(RED)
    --   love.graphics.circle('fill', self.luteResonanceX, self.luteResonanceY, self.luteResonanceRadius)
    -- end
  end
end
