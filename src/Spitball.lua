Spitball = Class{}

function Spitball:init(entity)
    self.entity = entity
    self.x = math.floor(entity.x + entity.displacementX + 0.5) + 12
    self.y = math.floor(entity.y + entity.displacementY + 0.5) + 4
    self.lifespan = 0.1
    self.remove = false
    self.spitball = true

    self.hitUp = false
    self.hitDown = false
    self.hitLeft = false
    self.hitRight = false
    self.hitTL = false
    self.hitBL = false
    self.hitTR = false
    self.hitBR = false

    --CALCULATE HIT DIRECTION

    --SPITBALL IS LEFT COL
    if self.x < sceneView.player.x then
        if self.y < sceneView.player.y then --BOTTOM LEFT HIT
            self.hitBR = true
        elseif self.y > sceneView.player.y + sceneView.player.height then --UP LEFT HIT
            self.hitTR = true
        else --RIGHT HIT
            self.hitRight = true
        end
    --SPITBALL IN RIGHT COL
    elseif self.x > sceneView.player.x + sceneView.player.width then
        if self.y < sceneView.player.y then --BOTTOM RIGHT HIT
            self.hitBL = true
        elseif self.y > sceneView.player.y + sceneView.player.height then -- RIGHT HIT
            self.hitTL = true
        else --LEFT HIT
            self.hitLeft = true
        end
    elseif self.y < sceneView.player.y then --HIT DOWN
        self.hitDown = true
    elseif self.y > sceneView.player.y + sceneView.player.height then --HIT UP
        self.hitUp = true
    end

end

function Spitball:update(dt)
    Timer.tween(0.1, {
        [self] = {x = sceneView.player.x + 8, y = sceneView.player.y + 6},
    })
    self.lifespan = self.lifespan - dt
    if self.lifespan < 0 then
        sounds['hurt']:play()
        sceneView.player.damageFlash = true
        sceneView.player.hit = true
        sceneView.player.health = sceneView.player.health - 1
        if self.hitLeft then
            sceneView.player.dx = -SPELL_KNOCKBACK
        elseif self.hitRight then
            sceneView.player.dx = SPELL_KNOCKBACK
        elseif self.hitDown then
            sceneView.player.dy = SPELL_KNOCKBACK
        elseif self.hitUp then
            sceneView.player.dy = -SPELL_KNOCKBACK
        elseif self.hitTL then
            sceneView.player.dx = (-SPELL_KNOCKBACK * math.sqrt(2)) / 2
            sceneView.player.dy = (-SPELL_KNOCKBACK * math.sqrt(2)) / 2
        elseif self.hitBL then
            sceneView.player.dx = (-SPELL_KNOCKBACK * math.sqrt(2)) / 2
            sceneView.player.dy = (SPELL_KNOCKBACK * math.sqrt(2)) / 2
        elseif self.hitTR then
            sceneView.player.dx = (SPELL_KNOCKBACK * math.sqrt(2)) / 2
            sceneView.player.dy = (-SPELL_KNOCKBACK * math.sqrt(2)) / 2
        elseif self.hitBR then
            sceneView.player.dx = (SPELL_KNOCKBACK * math.sqrt(2)) / 2
            sceneView.player.dy = (SPELL_KNOCKBACK * math.sqrt(2)) / 2
        end
        self.remove = true
    end
end

function Spitball:render()
    love.graphics.setColor(WHITE)
    love.graphics.circle('fill', self.x, self.y, 2)
end
