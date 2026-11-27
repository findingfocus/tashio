CinematicTemplate = Class{__includes = CinematicState}

function CinematicTemplate:init()
  CinematicState.init(self)
  self.stateName = 'cinematicTemplate'
end

function CinematicTemplate:enter()
  local row, col = sceneView.mapRow, sceneView.mapColumn
  local npc = #MAP[row][col].npc > 0 and MAP[row][col].npc[1] or nil
  local isSpawnedNPC = false
  if not npc then
    npc = Entity{animations = ENTITY_DEFS['mage'].animations, x = -16, y = gPlayer.y, width = 16, height = 16, type = 'mage'}
    npc.stateMachine = StateMachine{['npc-idle'] = function() return NPCIdleState(npc) end}
    npc:changeState('npc-idle')
    table.insert(MAP[row][col].npc, npc)
    isSpawnedNPC = true
  end

  local originalX, originalY = npc.x, npc.y
  local originalDir = npc.direction or 'down'
  if not isSpawnedNPC then npc:changeState('npc-idle') end
  npc.x, npc.y, npc.direction = -16, gPlayer.y, 'right'
  npc.offscreen = false

  local id = #MAP[row][col].dialogueBox + 1
  table.insert(MAP[row][col].dialogueBox, DialogueBox(npc.x, npc.y, "Fly, you fool.", 'npc', npc, id))
  local targetX = math.max(16, math.min(VIRTUAL_WIDTH - 32, gPlayer.x - 32))

  local script = {
    {type = 'custom', onUpdate = function(dt)
      npc.x = npc.x + 50 * dt
      npc:changeAnimation('walk-right')
      npc:update(dt)
      if npc.x >= targetX then npc.x = targetX; npc:changeAnimation('idle-right'); return true end
    end},
    {type = 'dialogue', dialogueID = id},
    {type = 'custom', onEnter = function() npc:changeAnimation('idle-down'); npc.direction = 'down' end, onUpdate = function(dt) return true end},
    {type = 'wait', duration = 0.4},
    {type = 'fadeToBlack'},
    {type = 'custom', onUpdate = function(dt)
      npc.offscreen = true
      if isSpawnedNPC then
        for i = #MAP[row][col].npc, 1, -1 do
          if MAP[row][col].npc[i] == npc then
            table.remove(MAP[row][col].npc, i)
            break
          end
        end
      end
      return true
    end},
    {type = 'fadeFromBlack'},
    {type = 'wait', duration = 0.2}
  }

  CinematicState.enter(self, {script = script, onComplete = function() PAUSED = false; sceneView.activeDialogueID = nil; gStateMachine:change('playState') end})
end
