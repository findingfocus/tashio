Cursor = Class{}

function Cursor:init(x, y, option)
  self.option = option
  if self.option == 'item' then
    self.image = love.graphics.newImage('/graphics/itemCursor.png')
  elseif self.option == 'keyItem' then
    self.image = love.graphics.newImage('/graphics/keyItemCursor.png')
  end
  self.x = x
  self.y = y
  self.blinkTimer = 0
  self.visible = true
  --PROSTO HACK
  --[[
  visible = timer % blinkDuration < (blinkDuration / 2)
  --]]
end

function Cursor:blinkReset()
  self.blinkTimer = 0
  self.visible = true
end

function Cursor:update(dt, row, col)
  self.blinkTimer = self.blinkTimer + dt

  if self.blinkTimer > .5 then
    if self.visible then
      self.visible = false
    else
      self.visible = true
    end
    self.blinkTimer = 0
  end

  if self.option == 'item' then
    if row == 1 then
      self.y = GRID_YOFFSET
    else
      self.y = row * GRID_ITEM_HEIGHT + GRID_YOFFSET - GRID_ITEM_HEIGHT
    end
    if col == 1 then
      self.x = GRID_XOFFSET
    else
      self.x = col * GRID_ITEM_WIDTH + GRID_XOFFSET - GRID_ITEM_WIDTH
    end
  elseif self.option == 'keyItem' then
    if row == 1 then
      self.y = KEYITEM_YOFFSET
    else
      self.y = row * KEYITEM_ITEM_HEIGHT + KEYITEM_YOFFSET - KEYITEM_ITEM_HEIGHT
    end
    if col == 1 then
      self.x = KEYITEM_XOFFSET
    else
      self.x = col * KEYITEM_ITEM_WIDTH + KEYITEM_XOFFSET - KEYITEM_ITEM_WIDTH
    end
  end
end

function Cursor:render()
  if self.visible then
    love.graphics.draw(self.image, self.x, self.y)
  end
end


