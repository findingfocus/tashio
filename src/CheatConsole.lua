CheatConsole = Class{}

local DOUBLE_TAP_WINDOW = 0.4

function CheatConsole:init()
  self.open = false
  self.lastGTime = 0
  self.selected = 1
  self.blinkTimer = 0
  self.blinkOn = true
  self.status = ''

  self.options = {
    {
      label = 'HEAL FULL',
      action = function()
        if gPlayer then
          gPlayer.health = DEMO_MAX_HEALTH
          gPlayer.manis = gPlayer.manisMax
          gPlayer.flammeVibrancy = 0
          gPlayer.aquisVibrancy = 0
          return 'HP + MANIS FULL'
        end
      end
    },
    {
      label = 'INVINCIBLE',
      getState = function()
        return gPlayer and gPlayer.invincible
      end,
      action = function()
        if gPlayer then
          gPlayer.invincible = not gPlayer.invincible
          return gPlayer.invincible and 'NO DMG / NO FALL' or 'INVINCIBLE OFF'
        end
      end
    },
    {
      label = 'VISIONQUEST',
      getState = function()
        return gPlayer and gPlayer.visionQuest
      end,
      action = function()
        if gPlayer then
          gPlayer.visionQuest = not gPlayer.visionQuest
          return gPlayer.visionQuest and 'PHASE + INVINCIBLE' or 'VISIONQUEST OFF'
        end
      end
    },
    {
      label = 'GREEN TUNIC',
      getState = function()
        return gPlayer and gPlayer.greenTunicUnlocked and gPlayer.tunicEquipped == 'greenTunic'
      end,
      action = function()
        if gPlayer then
          gPlayer.greenTunicUnlocked = true
          gPlayer.tunicEquipped = 'greenTunic'
          return 'GREEN TUNIC ON'
        end
      end
    },
    {
      label = 'UNLOCK FLAMME',
      getState = function()
        return gPlayer and gPlayer.flammeUnlocked
      end,
      action = function()
        if gPlayer then
          gPlayer.flammeUnlocked = true
          gPlayer.elementEquipped = 'flamme'
          gKeyItemInventory.elementColor = FLAMME_COLOR
          return 'FLAMME EQUIPPED'
        end
      end
    },
    {
      label = 'UNLOCK LUTE',
      getState = function()
        return LUTE_CHEST_OPENED
      end,
      action = function()
        if not LUTE_CHEST_OPENED then
          for row = 1, 4 do
            for col = 1, 3 do
              if #gItemInventory.grid[row][col] == 0 then
                table.insert(gItemInventory.grid[row][col], Item('lute'))
                gItemInventory.grid[row][col][1].quantity = nil
                gItemInventory.grid[row][col][1]:update(row, col)
                LUTE_CHEST_OPENED = true
                gPlayer.luteUnlocked = true
                return 'LUTE ADDED'
              end
            end
          end
        end
        return 'LUTE OWNED'
      end
    },
    {
      label = '+100 COINS/RUBY',
      action = function()
        if gPlayer then
          gPlayer.coinCount = math.min(999, gPlayer.coinCount + 100)
          gPlayer.rubyCount = math.min(999, gPlayer.rubyCount + 100)
          return '+100 COINS/RUBY'
        end
      end
    },
    {
      label = 'UNLOCK POTION',
      getState = function()
        return gPlayer and gPlayer.healthPotionUnlocked
      end,
      action = function()
        gPlayer.healthPotionUnlocked = true
        MAGIC_POTION_CHEST_OPENED = true
        for row = 1, 4 do
          for col = 1, 3 do
            if #gItemInventory.grid[row][col] > 0 and gItemInventory.grid[row][col][1].type == 'healthPotion' then
              gItemInventory.grid[row][col][1].quantity = 10
              return 'POTION x10'
            end
          end
        end
        for row = 1, 4 do
          for col = 1, 3 do
            if #gItemInventory.grid[row][col] == 0 then
              table.insert(gItemInventory.grid[row][col], Item('healthPotion'))
              gItemInventory.grid[row][col][1].quantity = 10
              gItemInventory.grid[row][col][1]:update(row, col)
              return 'POTION x10'
            end
          end
        end
        return 'BAG FULL'
      end
    },
    {
      label = 'EXIT CONSOLE',
      action = function()
        self:close()
        return ''
      end
    },
  }
end

function CheatConsole:close()
  self.open = false
  self.lastGTime = 0
  INPUT_LIST = {}
  OUTPUT_LIST = {}
  if gStateMachine and gStateMachine.current and gStateMachine.current.stateName == 'Minimap' then
    gStateMachine:change('playState')
    minimapCooldown = MINIMAP_COOLDOWN
  end
end

function CheatConsole:keypressed(key)
  if self.open then
    if key == 'g' then
      local now = love.timer.getTime()
      if now - self.lastGTime <= DOUBLE_TAP_WINDOW then
        sounds['select']:play()
        self:close()
      else
        self.lastGTime = now
      end
    elseif key == 'escape' or key == 'backspace' then
      sounds['select']:play()
      self:close()
    elseif key == 'up' or key == 'w' then
      sounds['beep']:play()
      self.selected = self.selected - 1
      if self.selected < 1 then
        self.selected = #self.options
      end
    elseif key == 'down' or key == 's' then
      sounds['beep']:play()
      self.selected = self.selected + 1
      if self.selected > #self.options then
        self.selected = 1
      end
    elseif key == 'return' or key == 'space' then
      sounds['select']:play()
      local opt = self.options[self.selected]
      if opt and opt.action then
        local msg = opt.action()
        if msg then
          self.status = msg
        end
      end
    end
    return true
  end

  if key == 'g' then
    local now = love.timer.getTime()
    if now - self.lastGTime <= DOUBLE_TAP_WINDOW then
      self.open = true
      self.lastGTime = 0
      self.status = ''
      INPUT_LIST = {}
      OUTPUT_LIST = {}
      sounds['select']:play()
      return true
    else
      self.lastGTime = now
    end
  end

  return false
end

function CheatConsole:update(dt)
  if not self.open then
    return
  end
  self.blinkTimer = self.blinkTimer + dt
  if self.blinkTimer >= 0.4 then
    self.blinkTimer = 0
    self.blinkOn = not self.blinkOn
  end
end

function CheatConsole:render()
  if not self.open then
    return
  end

  local x, y, w, h = 10, 6, 140, 132

  love.graphics.setColor(0, 0, 0, 210 / 255)
  love.graphics.rectangle('fill', x, y, w, h)

  love.graphics.setFont(pixelFont)
  love.graphics.setColor(0, 1, 0, 1)
  local cursor = self.blinkOn and '_' or ''
  love.graphics.print('tashio.dev' .. cursor, x + 4, y + 4)

  for i, opt in ipairs(self.options) do
    local rowY = y + 16 + (i - 1) * 11
    local prefix = (i == self.selected) and '> ' or '  '
    local suffix = ''
    if opt.getState then
      suffix = opt.getState() and ' ON' or ' OFF'
    end
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print(prefix .. opt.label .. suffix, x + 4, rowY)
  end

  love.graphics.setColor(WHITE)
  love.graphics.print(self.status, x + 4, y + h - 12)
end
