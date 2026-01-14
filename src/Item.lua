Item = Class{}

function Item:init(option, quantity)
  --self.gridRow = row
  --self.gridCol = col
  self.type = option
  if option == 'bag' then
    self.image = bag
  elseif option == 'berry' then
    self.image = berry
  elseif option == 'healthPotion' then
    self.image = healthPotion
  elseif option == 'lute' then
    self.image = lute
  end
  self.quantity = quantity or nil
  self.x = 0
  self.y = 0
  self.equipped = false
  --[[
  if self.gridRow == 1 then
    self.y = INVENTORY_XOFFSET
  else
    self.y = self.gridRow * 25
  end
  if self.gridCol == 1 then
    self.x = INVENTORY_XOFFSET
  else
    self.x = self.gridCol * 25
  end
  --]]
end

function Item.serialize(self)
  return {
    type = self.type,
    equipped = self.equipped,
  }
end

function Item.deserialize(data)
  local item = setmetatable({}, Item)
  item.type = data.type
  item.equipped = data.equipped
  return item
end

function Item:equip()
  self.x = 13
  self.y = VIRTUAL_HEIGHT - 20
end

function Item:update(row, col)
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
end

function Item:render()
  love.graphics.setFont(pixelFont)
  love.graphics.setColor(WHITE)
  love.graphics.draw(self.image, self.x + 5, self.y + 5)

  if self.quantity ~= nil then
    love.graphics.setColor(BLACK)
    love.graphics.print(tostring(self.quantity), self.x + 14, self.y + 13)
    love.graphics.setColor(WHITE)
    love.graphics.print(tostring(self.quantity), self.x + 13, self.y + 13)
  end
end
