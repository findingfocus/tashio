PlayerWalkState = Class{__includes = BaseState}
topCollidesCount = 0
function PlayerWalkState:init(player, scene)
    self.player = player
    self.scene = scene
    PLAYER_STATE = 'WALK'
end

function PlayerWalkState:update(dt)
    if not self.player.falling and not luteState then
        if #OUTPUT_LIST > 0 then
            self.player.direction = OUTPUT_LIST[#OUTPUT_LIST]
            self.player:changeAnimation('walk-' .. tostring(OUTPUT_LIST[#OUTPUT_LIST]))
        end
        if #TOUCH_OUTPUT_LIST > 0 then
            self.player.direction = TOUCH_OUTPUT_LIST[#TOUCH_OUTPUT_LIST]
            self.player:changeAnimation('walk-' .. tostring(TOUCH_OUTPUT_LIST[#TOUCH_OUTPUT_LIST]))
        end

        self.player.walkSpeed = PLAYER_WALK_SPEED

        if #OUTPUT_LIST == 2 then
            self.player.walkSpeed = (math.sqrt(2) / 2) * PLAYER_WALK_SPEED
        end
        if #TOUCH_OUTPUT_LIST == 2 then
            self.player.walkSpeed = (math.sqrt(2) / 2) * PLAYER_WALK_SPEED
        end

        for key, value in ipairs(OUTPUT_LIST) do
            if value == 'left' then
                for k, v in ipairs(MAP[sceneView.mapRow][sceneView.mapColumn].pushables) do
                    if gPlayer:leftCollidesMapObject(v) then
                        --gPlayer.pushing = true
                    end
                end
                self.player.x = math.max(self.player.x - self.player.walkSpeed * dt, -SIDE_EDGE_BUFFER_PLAYER)
            elseif value == 'right' then
                for k, v in ipairs(MAP[sceneView.mapRow][sceneView.mapColumn].pushables) do
                    if gPlayer:rightCollidesMapObject(v) then
                        --gPlayer.pushing = true
                    end
                end
                self.player.x = math.min(self.player.x + self.player.walkSpeed * dt, VIRTUAL_WIDTH - self.player.width + SIDE_EDGE_BUFFER_PLAYER)
            elseif value == 'down' then
                for k, v in ipairs(MAP[sceneView.mapRow][sceneView.mapColumn].pushables) do
                    if gPlayer:bottomCollidesMapObject(v) then
                        --gPlayer.pushing = true
                    end
                end
                self.player.y = math.min(self.player.y + self.player.walkSpeed * dt, SCREEN_HEIGHT_LIMIT + BOTTOM_BUFFER - self.player.height)
            elseif value == 'up' then
                for k, v in ipairs(MAP[sceneView.mapRow][sceneView.mapColumn].pushables) do
                    if gPlayer:topCollidesMapObject(v) then
                        --gPlayer.pushing = true
                    end
                end
                self.player.y = math.max(self.player.y - self.player.walkSpeed * dt, -SIDE_EDGE_BUFFER_PLAYER)
            end
        end
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
    sceneView.player:changeAnimation('falling')
  end

  gPlayer.pushing = false
  --PLAYER TO PUSHABLES COLLISION
  if not sceneView.shifting then
      for k, v in pairs(MAP[sceneView.mapRow][sceneView.mapColumn].pushables) do
          if gPlayer:leftCollidesMapObject(v) or gPlayer:rightCollidesMapObject(v) or gPlayer:topCollidesMapObject(v) or gPlayer:bottomCollidesMapObject(v) then --gPlayer.pushing = true
              if #OUTPUT_LIST > 0 or #TOUCH_OUTPUT_LIST > 0 then
                  gPlayer.pushTimer = gPlayer.pushTimer + dt
              end
          end

          if gPlayer:rightCollidesMapObject(v) then
            if OUTPUT_LIST[1] == 'right' then
                gPlayer.pushing = true
            end
          end

          --if (v.tileX < 1 or v.tileX <= 10) or (v.tileY < 1 or v.tileY >= 8) then

          --end
          if gPlayer:leftCollidesMapObject(v) then
              if gPlayer.pushTimer > PUSH_TIMER_THRESHOLD then
                  gPlayer.pushTimer = 0
                  if v:legalPush(v.tileY, v.tileX - 1) then
                      v:pushLeft()
                  end
              end

              if gPlayer.direction == 'left' then
                  gPlayer:changeAnimation('push-left')
              end
              gPlayer.x = v.x + v.width - AABB_SIDE_COLLISION_BUFFER
          end
          if gPlayer:rightCollidesMapObject(v) then
              if gPlayer.pushTimer > PUSH_TIMER_THRESHOLD then
                  gPlayer.pushTimer = 0
                  if v:legalPush(v.tileY, v.tileX + 1) then
                      v:pushRight()
                  end
              end
              if gPlayer.direction == 'right' then
                  gPlayer:changeAnimation('push-right')
              end
              gPlayer.x = v.x - gPlayer.width + 1
         end
          if gPlayer:topCollidesMapObject(v) then
              if gPlayer.pushTimer > PUSH_TIMER_THRESHOLD then
                  gPlayer.pushTimer = 0
                  if v:legalPush(v.tileY - 1, v.tileX) then
                      v:pushUp()
                  end
              end
              topCollidesCount = topCollidesCount + 1
              if gPlayer.direction == 'up' then
                  gPlayer:changeAnimation('push-up')
              end
              gPlayer.y = v.y + v.height - AABB_TOP_COLLISION_BUFFER
          end
          if gPlayer:bottomCollidesMapObject(v) then
              if gPlayer.pushTimer > PUSH_TIMER_THRESHOLD then
                  gPlayer.pushTimer = 0
                  if v:legalPush(v.tileY + 1, v.tileX) then
                      v:pushDown()
                  end
              end
              if gPlayer.direction == 'down' then
                  gPlayer:changeAnimation('push-down')
              end
              gPlayer.y = v.y - gPlayer.height
          end
      end
  end
end

function PlayerWalkState:render()
    local anim = self.player.currentAnimation

    --PLAYER BASE LAYER
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    --love.graphics.print('timer: ' .. tostring(self.player.animations['walk-down'].timer), 5, 55)
    if not self.player.falling then
        --TODO NEXT EPISODE
        if self.player.currentAnimation == {['push-right']} then
        for k, v in ipairs(MAP[sceneView.mapRow][sceneView.mapColumn].pushables) do
            if gPlayer:leftCollidesMapObject(v) or gPlayer:rightCollidesMapObject(v) or gPlayer:topCollidesMapObject(v) or gPlayer:bottomCollidesMapObject(v) then --gPlayer.pushing = true
                if self.player.blueTunicEquipped then
                    love.graphics.draw(gTextures['character-push-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
                elseif self.player.redTunicEquipped then
                    love.graphics.draw(gTextures['character-push-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
                elseif self.player.greenTunicEquipped then
                    love.graphics.draw(gTextures['character-push-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
                elseif self.player.yellowTunicEquipped then
                    love.graphics.draw(gTextures['character-push-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
                end
            end
        end
        else --IF NOT PUSHING
            if self.player.blueTunicEquipped then
                love.graphics.draw(gTextures['character-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
            elseif self.player.redTunicEquipped then
                love.graphics.draw(gTextures['character-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
            elseif self.player.greenTunicEquipped then
                love.graphics.draw(gTextures['character-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
            elseif self.player.yellowTunicEquipped then
                love.graphics.draw(gTextures['character-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
            end
        end
    else --IF FALLING
        if self.player.blueTunicEquipped then
            love.graphics.draw(gTextures['character-fall-blueTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        elseif self.player.redTunicEquipped then
            love.graphics.draw(gTextures['character-fall-redTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        elseif self.player.greenTunicEquipped then
            love.graphics.draw(gTextures['character-fall-greenTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        elseif self.player.yellowTunicEquipped then
            love.graphics.draw(gTextures['character-fall-yellowTunic'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        end
    end

    if self.player.fireSpellEquipped then
        love.graphics.setColor(gKeyItemInventory.elementColor)
        love.graphics.draw(gTextures['character-element'], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
    end

    if gItemInventory.itemSlot[1] ~= nil then
        if gItemInventory.itemSlot[1].type == 'lute' and not self.player.falling then
            love.graphics.setColor(WHITE)
            love.graphics.draw(gTextures['lute-equip'], gFrames['lute-equip'][anim:getCurrentFrame()], math.floor(self.player.x), math.floor(self.player.y))
        end
    end
end
