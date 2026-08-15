Collider = Class{}

function Collider:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.xOffset = (TILE_SIZE - self.width) / 2
  self.active = true
end

function Collider:collides(object, option)
  if option == nil then
    if self.x < object.x + object.width and self.x + self.width > object.x then
      if self.y < object.y + object.height and self.y + self.height > object.y then
        return true
      end
    end
    return false
  end
  if option == 'pit' then
    local inset = 2
    if self.x < object.x + object.width - inset and self.x + self.width > object.x + inset then
      if self.y < object.y + object.height - inset and self.y + self.height > object.y + inset then
        if self.active then
          return true
        else
          return false
        end
      end
    end
    return false
  end
end

function Collider:update(dt)
  self.x = gPlayer.x + self.xOffset
  self.y = gPlayer.y + gPlayer.height - self.height
end

function Collider:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
