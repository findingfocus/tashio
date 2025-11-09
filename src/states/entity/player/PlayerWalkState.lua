PlayerWalkState = Class{__includes = BaseState}
topCollidesCount = 0
function PlayerWalkState:init(player, scene)
  self.player = player
  self.scene = scene
  PLAYER_STATE = 'WALK'
  self.test = 0
end

function PlayerWalkState:update(dt)
  self.player.meditate = false
  self.test = self.test + dt
  if not self.player.falling and not luteState then
    if #OUTPUT_LIST > 0 then
      self.player.direction = OUTPUT_LIST[#OUTPUT_LIST]
      self.player:changeAnimation('walk-' .. tostring(OUTPUT_LIST[#OUTPUT_LIST]))
    end
    if #TOUCH_OUTPUT_LIST > 0 then
      self.player.direction = TOUCH_OUTPUT_LIST[#TOUCH_OUTPUT_LIST]
      self.player:changeAnimation('walk-' .. tostring(TOUCH_OUTPUT_LIST[#TOUCH_OUTPUT_LIST]))
    end

    self.player.walkSpeed = PLAYER_WALK_SPEED * dt

    if #OUTPUT_LIST == 2 then
      self.player.walkSpeed = (math.sqrt(2) / 2) * PLAYER_WALK_SPEED * dt
    end
    if #TOUCH_OUTPUT_LIST == 2 then
      self.player.walkSpeed = (math.sqrt(2) / 2) * PLAYER_WALK_SPEED * dt 
    end

    for key, value in ipairs(OUTPUT_LIST) do
      if value == 'left' then
        self.player.x = math.max(self.player.x - self.player.walkSpeed, -SIDE_EDGE_BUFFER_PLAYER)
      elseif value == 'right' then
        self.player.x = math.min(self.player.x + self.player.walkSpeed, VIRTUAL_WIDTH - self.player.width + SIDE_EDGE_BUFFER_PLAYER)
      elseif value == 'down' then
        self.player.y = math.min(self.player.y + self.player.walkSpeed, SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER - self.player.height)
      elseif value == 'up' then
        self.player.y = math.max(self.player.y - self.player.walkSpeed, -SIDE_EDGE_BUFFER_PLAYER)
      end
    end
    --[[
    for key, value in ipairs(TOUCH_OUTPUT_LIST) do
      if value == 'left' then
        self.player.x = math.max(self.player.x - self.player.walkSpeed * dt, -SIDE_EDGE_BUFFER_PLAYER)
      elseif value == 'right' then
        self.player.x = math.min(self.player.x + self.player.walkSpeed * dt, VIRTUAL_WIDTH - self.player.width + SIDE_EDGE_BUFFER_PLAYER)
      elseif value == 'down' then
        self.player.y = math.min(self.player.y + self.player.walkSpeed * dt, SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER - self.player.height)
      elseif value == 'up' then
        self.player.y = math.max(self.player.y - self.player.walkSpeed * dt, -SIDE_EDGE_BUFFER_PLAYER)
      end
    end
    --]]

    --TRIGGER IDLE
    if #TOUCH_OUTPUT_LIST == 0 and #OUTPUT_LIST == 0 then
      self.player.pushTimer = 0
      self.player.animations['walk-' .. tostring(self.player.direction)]:refresh()
      self.player:changeAnimation('idle-' .. tostring(self.player.direction))
      self.player:changeState('player-idle')
      self.player.x = math.floor(self.player.x)

      --ROUND PLAYER TO NEAREST WHOLE PIXEL
      if self.player.x % 1 >= 0.5 then
        self.player.x = math.ceil(self.player.x)
      else
        self.player.x = math.floor(self.player.x)
      end

      if self.player.y % 1 >= 0.5 then
        self.player.y = math.ceil(self.player.y)
      else
        self.player.y = math.floor(self.player.y)
      end
    end
  end

  if sceneView.player.falling then
    --CHECK
    --sceneView.player:changeAnimation('falling')
  end

  --PLAYER TO PUSHABLES COLLISION
  if not sceneView.shifting then
    local collideCount = 0
    for k, v in pairs(MAP[sceneView.mapRow][sceneView.mapColumn].collidableMapObjects) do
      --INITIALIZE COLLIDABLE CLASS TYPES
      --PUSHING OBJECTS
      if v.classType == 'pushable' and not v.falling and not gPlayer.falling and not v.crateCompletelyBroken and v.active then
        if gPlayer:leftCollidesMapObject(v) or gPlayer:rightCollidesMapObject(v) or gPlayer:topCollidesMapObject(v) or gPlayer:bottomCollidesMapObject(v) then --gPlayer.pushing = true
          collideCount = collideCount + 1
          if #OUTPUT_LIST > 0 or #TOUCH_OUTPUT_LIST > 0 then
            gPlayer.pushTimer = gPlayer.pushTimer + dt
          end
        end
        if gPlayer:leftCollidesMapObject(v) then
          if gPlayer.pushTimer > PUSH_TIMER_THRESHOLD then
            gPlayer.pushTimer = 0
            if v:legalPush(v.tileY, v.tileX - 1) then
              if gPlayer.tunicEquipped == 'greenTunic' then
                v:pushLeft()
              end
            end
          end

          if gPlayer.direction == 'left' then
            gPlayer.pushing = true
            gPlayer:changeAnimation('push-left')
          end
          gPlayer.x = v.x + v.width - AABB_SIDE_COLLISION_BUFFER
        end
        if gPlayer:rightCollidesMapObject(v) then
          if gPlayer.pushTimer > PUSH_TIMER_THRESHOLD then
            gPlayer.pushTimer = 0
            if v:legalPush(v.tileY, v.tileX + 1) then
              if gPlayer.tunicEquipped == 'greenTunic' then
                v:pushRight()
              end
            end
          end
          if gPlayer.direction == 'right' then
            gPlayer.pushing = true
            gPlayer:changeAnimation('push-right')
          end
          gPlayer.x = v.x - gPlayer.width + 1
        end
        if gPlayer:topCollidesMapObject(v) then
          if gPlayer.pushTimer > PUSH_TIMER_THRESHOLD then
            gPlayer.pushTimer = 0
            if v:legalPush(v.tileY - 1, v.tileX) then
              if gPlayer.tunicEquipped == 'greenTunic' then
                v:pushUp()
              end
            end
          end
          topCollidesCount = topCollidesCount + 1
          if gPlayer.direction == 'up' then
            gPlayer.pushing = true
            gPlayer:changeAnimation('push-up')
          end
          gPlayer.y = v.y + v.height - AABB_TOP_COLLISION_BUFFER
        end
        if gPlayer:bottomCollidesMapObject(v) then
          if gPlayer.pushTimer > PUSH_TIMER_THRESHOLD then
            gPlayer.pushTimer = 0
            if v:legalPush(v.tileY + 1, v.tileX) then
              if gPlayer.tunicEquipped == 'greenTunic' then
                v:pushDown()
              end
            end
          end
          if gPlayer.direction == 'down' then
            gPlayer.pushing = true
            gPlayer:changeAnimation('push-down')
          end
          gPlayer.y = v.y - gPlayer.height
        end
      end
    end
    if collideCount == 0 then
      gPlayer.pushing = false
    end
  end
  --PLAYER TO MAP OBJECT COLLISION DETECTION
  ---[[
  for k, v in pairs(MAP[sceneView.currentMap.row][sceneView.currentMap.column].collidableMapObjects) do
    local object = v

    if v.active then
      if self.player:leftCollidesMapObject(object) then
        self.player.x = object.x + object.width - AABB_SIDE_COLLISION_BUFFER
      end
      if self.player:rightCollidesMapObject(object) then
        self.player.x = object.x - self.player.width + AABB_SIDE_COLLISION_BUFFER
      end
      if self.player:topCollidesMapObject(object) then
        self.player.y = object.y + object.height - AABB_TOP_COLLISION_BUFFER
      end
      if self.player:bottomCollidesMapObject(object) then
        self.player.y = object.y - self.player.height
      end
    end
  end
  --]]
end

function PlayerWalkState:render()
  local anim = self.player.currentAnimation

  --PLAYER BASE LAYER
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
  --love.graphics.print('timer: ' .. tostring(self.player.animations['walk-down'].timer), 5, 55)
  if not self.player.falling then
    if self.player.currentAnimation == self.player.animations['walk-right'] or (self.player.currentAnimation == self.player.animations['walk-left']) or (self.player.currentAnimation == self.player.animations['walk-up']) or (self.player.currentAnimation == self.player.animations['walk-down']) then
      if not self.player.showOff then
        if self.player.tunicEquipped == 'blueTunic' then
          love.graphics.draw(gTextures['character-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        elseif self.player.tunicEquipped == 'redTunic' then
          love.graphics.draw(gTextures['character-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        elseif self.player.tunicEquipped == 'greenTunic' then
          love.graphics.draw(gTextures['character-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        elseif self.player.tunicEquipped == 'yellowTunic' then
          love.graphics.draw(gTextures['character-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        end
      end
    elseif self.player.currentAnimation == self.player.animations['push-right'] or self.player.animations['push-left'] or self.player.animations['push-up'] or self.player.animations['push-down'] then
      for k, v in ipairs(MAP[sceneView.mapRow][sceneView.mapColumn].collidableMapObjects) do
        if v.classType == 'pushable' then
          gPlayer.pushable = true
          if gPlayer:leftCollidesMapObject(v) or gPlayer:rightCollidesMapObject(v) or gPlayer:topCollidesMapObject(v) or gPlayer:bottomCollidesMapObject(v) then
            if self.player.tunicEquipped == 'blueTunic' then
              love.graphics.draw(gTextures['character-push-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
            elseif self.player.tunicEquipped == 'redTunic' then
              love.graphics.draw(gTextures['character-push-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
            elseif self.player.tunicEquipped == 'greenTunic' then
              love.graphics.draw(gTextures['character-push-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
            elseif self.player.tunicEquipped == 'yellowTunic' then
              love.graphics.draw(gTextures['character-push-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
            end
          end
        end
      end
    end
  else --IF FALLING
    if self.player.tunicEquipped == 'blueTunic' then
      love.graphics.draw(gTextures['character-fall-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    elseif self.player.tunicEquipped == 'redTunic' then
      love.graphics.draw(gTextures['character-fall-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    elseif self.player.tunicEquipped == 'greenTunic' then
      love.graphics.draw(gTextures['character-fall-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    elseif self.player.tunicEquipped == 'yellowTunic' then
      love.graphics.draw(gTextures['character-fall-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    end
  end

  --ELEMENT IN HAND
  if self.player.elementEquipped == 'flamme' then
    if not gPlayer.pushing and not gPlayer.showOff then
      love.graphics.setColor(gKeyItemInventory.elementColor)
      love.graphics.draw(gTextures['character-element'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    end
  end

  if gItemInventory.itemSlot[1] ~= nil then
    if gItemInventory.itemSlot[1].type == 'lute' and not self.player.falling then
      if not gPlayer.pushing and not gPlayer.showOff then
        love.graphics.setColor(WHITE)
        love.graphics.draw(gTextures['lute-equip'], gFrames['lute-equip'][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
      end
    end
  end

  --SHOW OFF
  if self.player.showOff then
    if self.player.tunicEquipped == 'greenTunic' then
      love.graphics.setColor(WHITE)
      love.graphics.draw(showOffGreenTunic, math.floor(self.player.x), math.floor(self.player.y))
    end
  end
end
