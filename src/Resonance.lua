Resonance = Class{}

function Resonance:init()
  self.luteResonanceX = gPlayer.x + TILE_SIZE / 2
  self.luteResonanceY = gPlayer.y + TILE_SIZE / 2
  self.luteResonanceRadius = 0
  self.luteResonanceMaxRadius = 60
  self.luteResonanceActive = true
  self.luteResonanceAlpha = 255
  self.collided = false
end

function Resonance:update(dt)
  if self.luteResonanceActive then
    self.luteResonanceRadius = self.luteResonanceRadius + LUTE_RESONANCE_SPEED
    self.luteResonanceX = gPlayer.x + TILE_SIZE / 2
    self.luteResonanceY = gPlayer.y + TILE_SIZE / 2
    local prog = math.max(0, math.min(1, self.luteResonanceRadius / self.luteResonanceMaxRadius))
    self.luteResonanceAlpha = 255 * (1 - prog ^ 3)

    for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].entities) do
      if v.distanceToPlayer < self.luteResonanceRadius then
        self.collided = true
      else
        self.collided = false
      end
    end
  end

  if self.luteResonanceAlpha <= 0 then
    self.luteResonanceActive = false
    self.collided = false
  end
end

function Resonance:render()
  if self.luteResonanceActive then
    love.graphics.setColor(255/255, 206/255, 82/255, self.luteResonanceAlpha/255)
    love.graphics.circle('line', self.luteResonanceX, self.luteResonanceY, self.luteResonanceRadius)
    love.graphics.setColor(WHITE)

    if self.collided then
      love.graphics.setColor(RED)
      love.graphics.circle('fill', self.luteResonanceX, self.luteResonanceY, self.luteResonanceRadius)
    end
  end

end
