require 'src/constants'
math.randomseed(os.time())

MAP = {}
TILEDMAP = {}
--OVERWORLD_MAP_WIDTH = 10
OVERWORLD_MAP_WIDTH = 20
OVERWORLD_MAP_HEIGHT = 10
MAP_WIDTH = 10
MAP_HEIGHT = 8


--DECLARING EMPTY TABLES IN GLOBAL MAP
for x = 1, OVERWORLD_MAP_HEIGHT do
  table.insert(MAP, {})
  for y = 1, OVERWORLD_MAP_WIDTH do
    table.insert(MAP[x], {})
  end
end

tiledMap = {}
for k, v in pairs(globalMap.layers[1].data) do
  tiledMap[k] = v
end
aboveGroundTiledMap = {}
for k, v in pairs(globalMap.layers[2].data) do
  aboveGroundTiledMap[k] = v
end

topLevelTiledMap = {}
for k, v in pairs(globalMap.layers[3].data) do
  topLevelTiledMap[k] = v
end



--tiledMapCount = #tiledMap
for i = 1, OVERWORLD_MAP_HEIGHT do
  for j = 1, OVERWORLD_MAP_WIDTH do
    MAP[i][j].animatables = {}
    MAP[i][j].entities = {}
    MAP[i][j].npc = {}
    MAP[i][j].chasms = {}
    MAP[i][j].topLevelTileIds = {}
    MAP[i][j].aboveGroundTileIds = {}
    MAP[i][j].dialogueBox = {}
    MAP[i][j].dialogueBoxCollided = {}
    MAP[i][j].warpZones = {}
    MAP[i][j].disjointUp = false
    MAP[i][j].pushables = {}
    MAP[i][j].collidableMapObjects = {}
    MAP[i][j].collidableWallObjects = {}
    MAP[i][j].coins = {}
    MAP[i][j].attacks = {}
    MAP[i][j].psystems = {}
  end
end

table.insert(MAP[10][19].collidableMapObjects, CollidableMapObjects(10, 19, TILE_SIZE * 4, 0, TILE_SIZE, TILE_SIZE))
table.insert(MAP[10][19].collidableMapObjects, CollidableMapObjects(10, 19, TILE_SIZE * 5, 0, TILE_SIZE, TILE_SIZE))

--MAP DOWNLOADER FROM TILED DATA DOWNLOADER
local mapRow = 1
local mapCol = 1
local sceneRow = 1
local sceneCol = 1
local sceneRowsInserted = 0
local globalRowsInserted = 0

for tileId = 1, MAP_WIDTH * MAP_HEIGHT * OVERWORLD_MAP_WIDTH * OVERWORLD_MAP_HEIGHT do
  if sceneCol > MAP_WIDTH then
    sceneCol = 1
    mapCol = mapCol + 1
    sceneRowsInserted = sceneRowsInserted + 1
  end
  if sceneRowsInserted == OVERWORLD_MAP_WIDTH then
    mapCol = 1
    globalRowsInserted = globalRowsInserted + 1
    sceneRow = sceneRow + 1
    sceneRowsInserted = 0
  end
  if globalRowsInserted == MAP_HEIGHT then --CYCLE TO NEXT MAP ROW
    sceneRow = 1
    mapRow = mapRow + 1
    globalRowsInserted = 0
  end

  --tileId = 1
  table.insert(MAP[mapRow][mapCol], tiledMap[tileId])

  ---[[
  --if tileId == WATER_ANIM_STARTER then
  --test1 = 2
  --table.insert(MAP[mapRow][mapCol].animatables, function() insertAnim(sceneRow, sceneCol, WATER.frame) end)
  --end
  --]]
  sceneCol = sceneCol + 1
end



--TOP LEVEL TILE DOWNLOADER
local mapRow = 1
local mapCol = 1
local sceneRow = 1
local sceneCol = 1
local sceneRowsInserted = 0
local globalRowsInserted = 0

for tileId = 1, MAP_WIDTH * MAP_HEIGHT * OVERWORLD_MAP_WIDTH * OVERWORLD_MAP_HEIGHT do
  if sceneCol > MAP_WIDTH then
    sceneCol = 1
    mapCol = mapCol + 1
    sceneRowsInserted = sceneRowsInserted + 1
  end
  if sceneRowsInserted == OVERWORLD_MAP_WIDTH then
    mapCol = 1
    globalRowsInserted = globalRowsInserted + 1
    sceneRow = sceneRow + 1
    sceneRowsInserted = 0
  end
  if globalRowsInserted == MAP_HEIGHT then --CYCLE TO NEXT MAP ROW
    sceneRow = 1
    mapRow = mapRow + 1
    globalRowsInserted = 0
  end

  --tileId = 1
  table.insert(MAP[mapRow][mapCol].topLevelTileIds, topLevelTiledMap[tileId])
  --[[
  --if tileId == WATER_ANIM_STARTER then
  --test1 = 2
  --table.insert(MAP[mapRow][mapCol].animatables, function() insertAnim(sceneRow, sceneCol, WATER.frame) end)
  --end
  --]]
  sceneCol = sceneCol + 1
end

--MAP DOWNLOADER FROM TILED DATA DOWNLOADER
local mapRow = 1
local mapCol = 1
local sceneRow = 1
local sceneCol = 1
local sceneRowsInserted = 0
local globalRowsInserted = 0

for tileId = 1, MAP_WIDTH * MAP_HEIGHT * OVERWORLD_MAP_WIDTH * OVERWORLD_MAP_HEIGHT do
  if sceneCol > MAP_WIDTH then
    sceneCol = 1
    mapCol = mapCol + 1
    sceneRowsInserted = sceneRowsInserted + 1
  end
  if sceneRowsInserted == OVERWORLD_MAP_WIDTH then
    mapCol = 1
    globalRowsInserted = globalRowsInserted + 1
    sceneRow = sceneRow + 1
    sceneRowsInserted = 0
  end
  if globalRowsInserted == MAP_HEIGHT then --CYCLE TO NEXT MAP ROW
    sceneRow = 1
    mapRow = mapRow + 1
    globalRowsInserted = 0
  end

  --CHASMS
  if (aboveGroundTiledMap[tileId] >= CHASM_DEF_BEGIN and aboveGroundTiledMap[tileId] <= CHASM_DEF_END) then
    table.insert(MAP[mapRow][mapCol].chasms, Chasm(sceneRow, sceneCol))
  end

  table.insert(MAP[mapRow][mapCol].aboveGroundTileIds, aboveGroundTiledMap[tileId])

  sceneCol = sceneCol + 1
end

for i = 1, OVERWORLD_MAP_HEIGHT do
  for j = 1, OVERWORLD_MAP_WIDTH do
    for k = 1, MAP_HEIGHT * MAP_WIDTH do
      local animRow = math.floor((k - 1) / 10) + 1
      local animCol = (k % 10)
      if animCol == 0 then
        animCol = 10
      end
      if MAP[i][j][k] == WATER_ANIM_STARTER then
        table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, WATER.frame) end)
      elseif MAP[i][j][k] == FLOWER_ANIM_STARTER then
        table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, FLOWERS.frame) end)
      elseif MAP[i][j][k] == AUTUMN_FLOWER_ANIM_STARTER then
        table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, AUTUMN_FLOWERS.frame) end)
      elseif MAP[i][j][k] == LAVA_LEFT_EDGE_ANIM_STARTER then
        table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, LAVA_LEFT_EDGE.frame) end)
      elseif MAP[i][j][k] == LAVA_RIGHT_EDGE_ANIM_STARTER then
        table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, LAVA_RIGHT_EDGE.frame) end)
      elseif MAP[i][j][k] == LAVA_FLOW_ANIM_STARTER then
        table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, LAVA_FLOW.frame) end)
      end
    end
  end
end

mapCount = #MAP[1][1]

--ENTITY DECLARATIONS
---[[
--[[
local entities = 4
for i = 1, entities do
  local random = math.random(25, 35)
  random = (random / 100) * 60
  table.insert(MAP[1][12].entities, Entity {
    animations = ENTITY_DEFS['geckoC'].animations,
    x = math.random(80, VIRTUAL_WIDTH - TILE_SIZE * 2),
    y = math.random(10, SCREEN_HEIGHT_LIMIT),
    width = TILE_SIZE,
    height = TILE_SIZE,
    health = 3,
    direction = 'left',
    type = 'gecko',
    walkSpeed = random,
    aiPath = math.random(1, 2),
    corrupted = true,
    enemy = true,
  })
end
--]]


--DUNGEON 1
table.insert(MAP[4][11].collidableMapObjects, Pushable(8,6, 'boulder'))
table.insert(MAP[4][11].collidableMapObjects, Pushable(7,2, 'crate'))


--TOP LEFT ROOM
table.insert(MAP[3][11].collidableMapObjects, Pushable(3,7, 'crate'))
table.insert(MAP[3][11].collidableMapObjects, Pushable(9,6, 'crate'))


--BOTTOM RIGHT ROOM
table.insert(MAP[4][13].collidableMapObjects, Pushable(9,3, 'crate'))
table.insert(MAP[4][13].collidableMapObjects, Pushable(6,2, 'crate'))
table.insert(MAP[4][13].collidableMapObjects, Pushable(3,6, 'crate'))
table.insert(MAP[4][13].collidableMapObjects, Pushable(2,5, 'crate'))

--BOTTOM LEFT ROOM
---[[
table.insert(MAP[4][11].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 8,
  spawnRow = 8,
  width = 24,
  height = 10,
  health = 1,
  spawning = true,
  spawnTimer = 3,
  type = 'bat',
  corrupted = true,
  enemy = true,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})


local entityCount = 1
for i = 1, entityCount do
  MAP[4][11].entities[i].animations = MAP[4][11].entities[i]:createAnimations(ENTITY_DEFS['bat'].animations)
  MAP[4][11].entities[i]:changeAnimation('pursue')
  MAP[4][11].entities[i].stateMachine = StateMachine {
    ['bat-spawn'] = function() return BatSpawnState(MAP[4][11].entities[i], MAP[4][11].entities[i].spawnRow, MAP[4][11].entities[i].spawnColumn) end,
    ['bat-walk'] = function() return BatWalkState(MAP[4][11].entities[i]) end,
    ['bat-attack'] = function() return BatAttackState(MAP[4][11].entities[i]) end,
    ['bat-flee'] = function() return BatFleeState(MAP[4][11].entities[i]) end,
    ['entity-idle'] = function() return EntityIdleState(MAP[4][11].entities[i]) end,
  }
  --.entities[i].originalState = 'bat-spawn'
  MAP[4][11].entities[i]:changeState('bat-spawn')

  MAP[4][11].entities[i].hit = false
end
--]]


--TOP LEFT ROOM
table.insert(MAP[3][11].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 3,
  spawnRow = 8,
  width = 24,
  height = 10,
  health = 1,
  spawning = true,
  attackSpeed = BAT_ATTACK_SPEED / 2,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 1,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})

table.insert(MAP[3][11].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 10,
  spawnRow = 6,
  width = 24,
  height = 10,
  health = 1,
  spawning = true,
  attackSpeed = BAT_ATTACK_SPEED / 2,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 1,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})

table.insert(MAP[3][11].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 3,
  spawnRow = 1,
  width = 24,
  height = 10,
  health = 1,
  spawning = true,
  attackSpeed = BAT_ATTACK_SPEED / 2,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = .25,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})

local entityCount = 3
for k, v in pairs(MAP[3][11].entities) do
  MAP[3][11].entities[k].animations = MAP[3][11].entities[k]:createAnimations(ENTITY_DEFS['bat'].animations)
  MAP[3][11].entities[k]:changeAnimation('pursue')
  MAP[3][11].entities[k].stateMachine = StateMachine {
    ['bat-spawn'] = function() return BatSpawnState(MAP[3][11].entities[k], MAP[3][11].entities[k].spawnRow, MAP[3][11].entities[k].spawnColumn) end,
    ['bat-walk'] = function() return BatWalkState(MAP[3][11].entities[k]) end,
    ['bat-attack'] = function() return BatAttackState(MAP[3][11].entities[k]) end,
    ['bat-flee'] = function() return BatFleeState(MAP[3][11].entities[k]) end,
    ['entity-idle'] = function() return EntityIdleState(MAP[3][11].entities[k]) end,
  }
  --.entities[i].originalState = 'bat-spawn'
  MAP[3][11].entities[k]:changeState('bat-spawn')

  MAP[3][11].entities[k].hit = false
end



--TOP MIDDLE ROOM
---[[
table.insert(MAP[3][12].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 5,
  spawnRow = 1,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = BAT_ATTACK_SPEED,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 1 ,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})
--]]

table.insert(MAP[3][12].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 10,
  spawnRow = 3,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = BAT_ATTACK_SPEED,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 1,
  pursueTrigger = 2,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})

local entityCount = 2
for k, v in pairs(MAP[3][12].entities) do
  MAP[3][12].entities[k].animations = MAP[3][12].entities[k]:createAnimations(ENTITY_DEFS['bat'].animations)
  MAP[3][12].entities[k]:changeAnimation('pursue')
  MAP[3][12].entities[k].stateMachine = StateMachine {
    ['bat-spawn'] = function() return BatSpawnState(MAP[3][12].entities[k], MAP[3][12].entities[k].spawnRow, MAP[3][12].entities[k].spawnColumn) end,
    ['bat-walk'] = function() return BatWalkState(MAP[3][12].entities[k]) end,
    ['bat-attack'] = function() return BatAttackState(MAP[3][12].entities[k]) end,
    ['bat-flee'] = function() return BatFleeState(MAP[3][12].entities[k]) end,
    ['entity-idle'] = function() return EntityIdleState(MAP[3][12].entities[k]) end,
  }
  --.entities[i].originalState = 'bat-spawn'
  MAP[3][12].entities[k]:changeState('bat-spawn')

  MAP[3][12].entities[k].hit = false
end
--]]


--TOP RIGHT ROOM
---[[
table.insert(MAP[3][13].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 3,
  spawnRow = 1,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = BAT_ATTACK_SPEED,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 4,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})
--]]

table.insert(MAP[3][13].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 5,
  spawnRow = 8,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = BAT_ATTACK_SPEED,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 3,
  pursueTrigger = 2,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})

table.insert(MAP[3][13].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 10,
  spawnRow = 3,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = BAT_ATTACK_SPEED,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 9,
  pursueTrigger = 2,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})

table.insert(MAP[3][13].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 10,
  spawnRow = 6,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = BAT_ATTACK_SPEED,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 18,
  pursueTrigger = 2,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})

local entityCount = 4
for k, v in pairs(MAP[3][13].entities) do
  MAP[3][13].entities[k].animations = MAP[3][13].entities[k]:createAnimations(ENTITY_DEFS['bat'].animations)
  MAP[3][13].entities[k]:changeAnimation('pursue')
  MAP[3][13].entities[k].stateMachine = StateMachine {
    ['bat-spawn'] = function() return BatSpawnState(MAP[3][13].entities[k], MAP[3][13].entities[k].spawnRow, MAP[3][13].entities[k].spawnColumn) end,
    ['bat-walk'] = function() return BatWalkState(MAP[3][13].entities[k]) end,
    ['bat-attack'] = function() return BatAttackState(MAP[3][13].entities[k]) end,
    ['bat-flee'] = function() return BatFleeState(MAP[3][13].entities[k]) end,
    ['entity-idle'] = function() return EntityIdleState(MAP[3][13].entities[k]) end,
  }
  --.entities[i].originalState = 'bat-spawn'
  MAP[3][13].entities[k]:changeState('bat-spawn')

  MAP[3][13].entities[k].hit = false
end



--BOTTOM RIGHT ROOM
---[[
--
--NORMIE BAT
table.insert(MAP[4][13].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 7,
  spawnRow = 1,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = BAT_ATTACK_SPEED,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 5,
  zigzagTime = 0,
  walkSpeed = 25,
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})

table.insert(MAP[4][13].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 1,
  spawnRow = 2,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = BAT_ATTACK_SPEED / 2,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 12,
  pursueTrigger = 2,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})

table.insert(MAP[4][13].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 1,
  spawnRow = 4,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = BAT_ATTACK_SPEED / 2,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 16,
  pursueTrigger = 2,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})

table.insert(MAP[4][13].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 3,
  spawnRow = 8,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = BAT_ATTACK_SPEED / 2,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 14,
  pursueTrigger = 2,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})



--RIGHT SIDE DEMON BATS
table.insert(MAP[4][13].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 10,
  spawnRow = 4,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = 0.2,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 2,
  pursueTrigger = 2,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})
table.insert(MAP[4][13].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 10,
  spawnRow = 4,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = 0.2,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 2,
  pursueTrigger = 2,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})

table.insert(MAP[4][13].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnColumn = 10,
  spawnRow = 4,
  width = 24,
  height = 10,
  health = 1,
  attackSpeed = BAT_ATTACK_SPEED / 4,
  type = 'bat',
  corrupted = true,
  enemy = true,
  spawnTimer = 2,
  pursueTrigger = 2,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(1, 5),
  zigzagAmplitude = math.random(1, 5) / 10,
})
--]]

for k, v in pairs(MAP[4][13].entities) do
  MAP[4][13].entities[k].animations = MAP[4][13].entities[k]:createAnimations(ENTITY_DEFS['bat'].animations)
  MAP[4][13].entities[k]:changeAnimation('pursue')
  MAP[4][13].entities[k].stateMachine = StateMachine {
    ['bat-spawn'] = function() return BatSpawnState(MAP[4][13].entities[k], MAP[4][13].entities[k].spawnRow, MAP[4][13].entities[k].spawnColumn) end,
    ['bat-walk'] = function() return BatWalkState(MAP[4][13].entities[k]) end,
    ['bat-attack'] = function() return BatAttackState(MAP[4][13].entities[k]) end,
    ['bat-flee'] = function() return BatFleeState(MAP[4][13].entities[k]) end,
    ['entity-idle'] = function() return EntityIdleState(MAP[4][13].entities[k]) end,
  }
  --.entities[i].originalState = 'bat-spawn'
  MAP[4][13].entities[k]:changeState('bat-spawn')

  MAP[4][13].entities[k].hit = false
end
--]]
--[[
table.insert(MAP[1][12].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnRow = 8,
  spawnColumn = 7,
  width = 24,
  height = 10,
  health = 2,
  spawning = true,
  type = 'bat',
  corrupted = true,
  enemy = true,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(4.5, 6),
  zigzagAmplitude = math.random(.5, .75),
})
--]]
--[[
table.insert(MAP[1][12].entities, Entity {
  animations = ENTITY_DEFS['bat'].animations,
  spawnRow = 3,
  spawnColumn = 10,
  width = 24,
  height = 10,
  health = 2,
  spawning = true,
  type = 'bat',
  corrupted = true,
  enemy = true,
  zigzagTime = 0,
  walkSpeed = math.random(8, 14),
  zigzagFrequency = math.random(4.5, 6),
  zigzagAmplitude = math.random(.5, .75),
})
--]]

local entityCount = #MAP[1][12].entities
for i = 1, entityCount do

  if MAP[1][12].entities[i].corrupted and MAP[1][12].entities[i].type == 'gecko' then
    MAP[1][12].entities[i].animations = MAP[1][12].entities[i]:createAnimations(ENTITY_DEFS['geckoC'].animations)
  end

  if MAP[1][12].entities[i].type == 'bat' then
    MAP[1][12].entities[i].animations = MAP[1][12].entities[i]:createAnimations(ENTITY_DEFS['bat'].animations)
  end

  if MAP[1][12].entities[i].type == 'bat' then
    MAP[1][12].entities[i]:changeAnimation('pursue')
  end

  if MAP[1][12].entities[i].type == 'gecko' then
    MAP[1][12].entities[i]:changeAnimation('idle-down')
  end

  if MAP[1][12].entities[i].type == 'gecko' then
    MAP[1][12].entities[i].stateMachine = StateMachine {
      ['gecko-walk'] = function() return GeckoWalkState(MAP[1][12].entities[i]) end,
      ['entity-idle'] = function() return EntityIdleState(MAP[1][12].entities[i]) end,
    }
    MAP[1][12].entities[i]:changeState('entity-idle')
  end


  if MAP[1][12].entities[i].type == 'bat' then
    MAP[1][12].entities[i].stateMachine = StateMachine {
      ['bat-spawn'] = function() return BatSpawnState(MAP[1][12].entities[i], MAP[1][12].entities[i].spawnRow, MAP[1][12].entities[i].spawnColumn) end,
      ['bat-walk'] = function() return BatWalkState(MAP[1][12].entities[i]) end,
      ['bat-attack'] = function() return BatAttackState(MAP[1][12].entities[i]) end,
      ['bat-flee'] = function() return BatFleeState(MAP[1][12].entities[i]) end,
      ['entity-idle'] = function() return EntityIdleState(MAP[1][12].entities[i]) end,
    }
    --.entities[i].originalState = 'bat-spawn'
    MAP[1][12].entities[i]:changeState('bat-spawn')
  end

  MAP[1][12].entities[i].hit = false
end

--TAVERN
--TODO IMAGINE WAY TO SWAP PLAYER FRAME TO DEFAULT FRAME UPON TRANSITION
---[[
function insertWarpZone(warpFromRow, warpFromCol, warpToRow, warpToCol, warpFromX, warpFromY, warpToX, warpToY)
  warpFromX = warpFromX * TILE_SIZE - TILE_SIZE + 3
  warpFromY = warpFromY * TILE_SIZE - TILE_SIZE - 15
  warpToX = warpToX * TILE_SIZE - TILE_SIZE + 3
  warpToY = warpToY * TILE_SIZE - TILE_SIZE + 14
  local warpPlayerToX = warpToX - 3

  local warpPlayerToY = warpToY - 16 - 5
  local warpPlayerFromX = warpFromX - 3
  local warpPlayerFromY = warpFromY + 10

  table.insert(MAP[warpFromRow][warpFromCol].warpZones, WarpZone(warpFromX, warpFromY, warpPlayerToX, warpPlayerToY, warpToRow, warpToCol))
  table.insert(MAP[warpToRow][warpToCol].warpZones, WarpZone(warpToX, warpToY, warpPlayerFromX, warpPlayerFromY, warpFromRow, warpFromCol))
end
--]]




--warpFromRow, warpFromCol, warpToRow, warpToCol, warpFromX, warpFromY, warpToX, warpToY)


--MAGE'S CASTLE
insertWarpZone(9, 2, 10, 19, 5, 3, 5, 8)

--TAVERN
insertWarpZone(7, 2, 1, 11, 9, 3, 3, 8)

--DUNGEON
--insertWarpZone(7, 4, 1, 12, 4, 4, 3, 8)
insertWarpZone(7, 4, 4, 11, 4, 4, 3, 8)

--INN
insertWarpZone(8, 3, 2, 11, 3, 7, 6, 8)

FLOWERS = AnimSpitter(FLOWER_ANIM_STARTER, 1015, 0.75)
AUTUMN_FLOWERS = AnimSpitter(AUTUMN_FLOWER_ANIM_STARTER, 1011, 0.75)
WATER = AnimSpitter(WATER_ANIM_STARTER, 105, .5)
LAVA_LEFT_EDGE = AnimSpitter(LAVA_LEFT_EDGE_ANIM_STARTER, 1007, .35)
LAVA_RIGHT_EDGE = AnimSpitter(LAVA_RIGHT_EDGE_ANIM_STARTER, 1002, .35)
LAVA_FLOW = AnimSpitter(LAVA_FLOW_ANIM_STARTER, 121, .35)

--MAGE NPC
--[[
table.insert(MAP[7][2].npc, Entity {
  animations = ENTITY_DEFS['mage'].animations,
  walkSpeed = ENTITY_DEFS['mage'].walkSpeed,
  height = ENTITY_DEFS['mage'].height,
  width = ENTITY_DEFS['mage'].width,
  x = TILE_SIZE * 7,
  y = TILE_SIZE * 6,
  dialogueBox = {},
  direction = 'down',
  corrupted = false,
  type = 'mage',
})

local mageIndex = 1
MAP[7][2].npc[mageIndex].stateMachine = StateMachine {
  ['npc-idle'] = function() return NPCIdleState(MAP[7][2].npc[mageIndex]) end,
  ['npc-walk'] = function() return NPCWalkState(MAP[7][2].npc[mageIndex]) end,
}
MAP[7][2].npc[mageIndex]:changeState('npc-walk')
MAP[7][2].npc[mageIndex].stateMachine.current.option = 'square'
--]]

--VILLAGER 1
--[[
table.insert(MAP[1][11].npc, Entity {
  animations = ENTITY_DEFS['villager1'].animations,
  walkSpeed = ENTITY_DEFS['villager1'].walkSpeed,
  height = ENTITY_DEFS['villager1'].height,
  width = ENTITY_DEFS['villager1'].width,
  x = TILE_SIZE * 5,
  y = TILE_SIZE,
  dialogueBox = {},
  direction = 'down',
  corrupted = false,
  type = 'villager1',
})
--]]

--[[
local villagerIndex = 1
MAP[1][11].npc[villagerIndex].stateMachine = StateMachine {
  ['npc-idle'] = function() return NPCIdleState(MAP[1][11].npc[villagerIndex]) end,
  ['npc-walk'] = function() return NPCWalkState(MAP[1][11].npc[villagerIndex]) end,
}
MAP[1][11].npc[villagerIndex]:changeState('npc-walk')
MAP[1][11].npc[villagerIndex].stateMachine.current.option = 'horizontal'
MAP[1][11].disjointUp = true
--]]
--table.insert(MAP[1][11].dialogueBox, DialogueBox(MAP[1][11].npc[villagerIndex].x, MAP[1][11].npc[villagerIndex].y, 'Whaddya want?', 'npc', MAP[1][11].npc[villagerIndex], 1))
table.insert(MAP[7][2].dialogueBox, DialogueBox(TILE_SIZE * 6, TILE_SIZE * 2, 'Meditate?', 'idol', nil, 1 ))
table.insert(MAP[7][4].dialogueBox, DialogueBox(TILE_SIZE * 5, TILE_SIZE * 5, 'Meditate?', 'idol', nil, 1))

--LIBRARY
table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 1, TILE_SIZE * 1, 'Flamme is energy from Mount Kasan, it burns brightly. ', 'signpost', nil, 1 ))
table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 3, TILE_SIZE * 1, 'Aquis contains lifeforce from the Azai Ocean, it flows with great energy. ', 'signpost', nil, 2 ))
table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 6, TILE_SIZE * 1, 'Ekko is vibrant green and shimmers quite beautifully. ', 'signpost', nil, 3 ))
table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 8, TILE_SIZE * 1, 'Lox shines as bright as the sun, focusing it\'s energy can be quite powerful. ', 'signpost', nil, 4 ))

table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 1, TILE_SIZE * 3, 'WASD keys are directional buttons.  Spacebar is the A Button.  Shift is the B Button.  Tab is the Start Button.  The A Button will interact with objects, or use the item in the A Slot. ', 'signpost', nil, 5 ))
table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 3, TILE_SIZE * 3, 'Press Start Button to open inventory.  B button will swap inventory selection.  A button will equip selected item.  Start Button while in inventory will resume the game. ', 'signpost', nil, 6 ))
table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 6, TILE_SIZE * 3, 'To use an Element, you need to equip it in your A Slot.  In order to successfully cast magic, you need to balance your focus using the A Button. ', 'signpost', nil, 7 ))
table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 8, TILE_SIZE * 3, 'Once the lute is equipped Press B button to start playing music. The Directional Buttons play different strings, and the A/B Buttons play different frets.  The Start Button will exit music mode. ', 'signpost', nil, 8 ))

table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 6, TILE_SIZE * 5, 'Meditation idols are used to save your game, as well as recharge your elements. ', 'signpost', nil, 9 ))
table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 8, TILE_SIZE * 5, 'Once the lute is equipped, select the tome you want to play. Press B button to start playing music and Start Button to exit music mode. ', 'signpost', nil, 10 ))

table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 2, 0, 'Magic is cast using an Element\'s vibrancy.  Vibrancy is the energy stored inside an Element and it depletes with use. If a mage rests at an idol, they can replenish their Element\'s vibrancy. ', 'signpost', nil, 11 ))
table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 7, 0, 'In order to cast magic, a mage needs to exert their focus also known as Manis. The result of their focus isn\'t stable, so they need to strive to balance their focus to reach the desired output. Manis is the red bar. Focus output is the white square.  A successful cast is when the focus output resides in the green range of a selected element. ', 'signpost', nil, 12 ))

--table.insert(MAP[10][19].dialogueBox, DialogueBox(TILE_SIZE * 3, TILE_SIZE * 2, 'Meditation idols are used to save your game, as well as recharge your elements. ', 'signpost', nil, 1 ))

--VILLAGER 2
table.insert(MAP[2][11].npc, Entity {
  animations = ENTITY_DEFS['villager1'].animations,
  walkSpeed = ENTITY_DEFS['villager1'].walkSpeed,
  height = ENTITY_DEFS['villager1'].height,
  width = ENTITY_DEFS['villager1'].width,
  x = TILE_SIZE * 5,
  y = TILE_SIZE * 3,
  dialogueBox = {},
  direction = 'down',
  corrupted = false,
  type = 'villager1',
})

local villager2Index = 1
MAP[2][11].npc[villager2Index].stateMachine = StateMachine {
  ['npc-idle'] = function() return NPCIdleState(MAP[2][11].npc[villager2Index]) end,
  ['npc-walk'] = function() return NPCWalkState(MAP[2][11].npc[villager2Index]) end,
}
MAP[2][11].npc[villager2Index]:changeState('npc-walk')
MAP[2][11].npc[villager2Index].stateMachine.current.option = 'square'
table.insert(MAP[2][11].dialogueBox, DialogueBox(MAP[2][11].npc[villager2Index].x, MAP[2][11].npc[villager2Index].y, 'A bed costs 5 gems a night', 'npc', MAP[2][11].npc[villager2Index], 1))
--]]
--19 CHAR PER LINE = 57 CHARS for 3 lines
table.insert(MAP[7][1].dialogueBox, DialogueBox(TILE_SIZE, 4 * TILE_SIZE, 'You cannot enter without light...', 'signpost', nil, 1))

table.insert(MAP[8][1].dialogueBox, DialogueBox(TILE_SIZE * 8, 2 * TILE_SIZE, 'Under Construction', 'signpost', nil, 1))

table.insert(MAP[7][3].dialogueBox, DialogueBox(TILE_SIZE * 7, 3 * TILE_SIZE, 'DANGER-->', 'signpost', nil, 1))

table.insert(MAP[7][4].dialogueBox, DialogueBox(TILE_SIZE * 8, 0, 'Ice Mountain^^', 'signpost', nil, 2))

table.insert(MAP[8][3].dialogueBox, DialogueBox(TILE_SIZE * 4, 6 * TILE_SIZE, 'Bed Inside^^', 'signpost', nil, 1))

table.insert(MAP[7][2].dialogueBox, DialogueBox(2 * TILE_SIZE, 5 * TILE_SIZE, '<-Flowerbed', 'signpost', nil, 2))
table.insert(MAP[7][2].dialogueBox, DialogueBox(5 * TILE_SIZE, 0, 'Ice Mountain^^', 'signpost', nil, 3))
table.insert(MAP[7][2].dialogueBox, DialogueBox(7 * TILE_SIZE, 4 * TILE_SIZE, 'Library^^', 'signpost', nil, 4))
--table.insert(MAP[7][2].dialogueBox, DialogueBox(MAP[7][2].npc[mageIndex].x, MAP[7][2].npc[mageIndex].y, 'There\'s plenty of danger around, but treasure too...', 'npc', MAP[7][2].npc[mageIndex], 5))

table.insert(MAP[7][2].collidableMapObjects, Pushable(2, 4, 'boulder'))
table.insert(MAP[7][2].collidableMapObjects, Pushable(2, 4, 'boulder'))
table.insert(MAP[3][12].collidableMapObjects, Pushable(4, 3, 'boulder'))
table.insert(MAP[3][13].collidableMapObjects, Pushable(3, 7, 'crate'))
table.insert(MAP[3][13].collidableMapObjects, Pushable(3, 4, 'crate'))
table.insert(MAP[3][13].collidableMapObjects, Pushable(6, 6, 'crate'))
table.insert(MAP[3][13].collidableMapObjects, Pushable(7, 3, 'crate'))
--table.insert(MAP[7][2].collidableMapObjects, Pushable(4, 4, 'crate'))
--table.insert(MAP[7][2].collidableMapObjects, Pushable(3, 4, 'crate'))
--table.insert(MAP[7][2].collidableMapObjects, Pushable(3, 5, 'crate'))
--

--REFACTOR DIALOGUE BOX OUT OF TREASURE CHEST
table.insert(MAP[1][12].collidableMapObjects, TreasureChest(3, 2, Coin(), {DialogueBox(2 * TILE_SIZE, TILE_SIZE, 'You found a strange coin! It emenates energy... ')}))


--LUTE TREASURE CHEST
table.insert(MAP[10][18].collidableMapObjects, TreasureChest(2, 4, 'lute', 1))
table.insert(MAP[10][18].dialogueBox, DialogueBox(2 * TILE_SIZE, TILE_SIZE, 'It\'s your ancient lute! It possesses a calming power. ',  nil, 1))
table.insert(MAP[10][18].collidableMapObjects, CollidableMapObjects(10, 18, TILE_SIZE, 26, TILE_SIZE, 4))
table.insert(MAP[10][18].collidableMapObjects, CollidableMapObjects(10, 18, TILE_SIZE, TILE_SIZE * 3 - 6, TILE_SIZE, TILE_SIZE))
table.insert(MAP[10][18].collidableMapObjects, CollidableMapObjects(10, 18, 0, 26, TILE_SIZE + 1, TILE_SIZE))

--SCRIPTED EVENTS
--MAGE NPC
table.insert(MAP[10][20].npc, Entity {
  animations = ENTITY_DEFS['mage'].animations,
  walkSpeed = ENTITY_DEFS['mage'].walkSpeed,
  height = ENTITY_DEFS['mage'].height,
  width = ENTITY_DEFS['mage'].width,
  x = -TILE_SIZE * 2,
  y = TILE_SIZE * 4,
  dialogueBox = {},
  direction = 'down',
  corrupted = false,
  type = 'mage',
})

table.insert(MAP[10][19].npc, Entity {
  animations = ENTITY_DEFS['mage'].animations,
  walkSpeed = ENTITY_DEFS['mage'].walkSpeed,
  height = ENTITY_DEFS['mage'].height,
  width = ENTITY_DEFS['mage'].width,
  x = TILE_SIZE * 4 + TILE_SIZE / 2,
  y = -TILE_SIZE,
  dialogueBox = {},
  direction = 'down',
  corrupted = false,
  type = 'mage',
})

local mageIndex = 1
MAP[10][20].npc[mageIndex].stateMachine = StateMachine {
  ['npc-idle'] = function() return NPCIdleState(MAP[10][20].npc[mageIndex]) end,
  ['npc-walk'] = function() return NPCWalkState(MAP[10][20].npc[mageIndex]) end,
}
MAP[10][20].npc[mageIndex]:changeState('npc-walk')
--MAP[10][20].npc[mageIndex].stateMachine.current.option = 'horizontal'


MAP[10][19].npc[mageIndex].stateMachine = StateMachine {
  ['npc-idle'] = function() return NPCIdleState(MAP[10][19].npc[mageIndex]) end,
  ['npc-walk'] = function() return NPCWalkState(MAP[10][19].npc[mageIndex]) end,
}

MAP[10][19].npc[mageIndex]:changeState('npc-walk')
table.insert(MAP[10][19].dialogueBox, DialogueBox(0, 0, 'You\'re finally awake... How are you feeling?  ...  You don\'t remember anything?  ...  There\'s much to relearn, but take it slow.', 'signpost', nil, 13))
table.insert(MAP[10][19].dialogueBox, DialogueBox(0, 0, 'This can be dangerous if you\'re careless. But you\'ll need it for your journey.  You got the flamme element!  I have important work to finish, I\'ll find you when you\'re ready for your next lesson. ', 'signpost', nil, 14))
--table.insert(MAP[10][19].dialogueBox, DialogueBox(0, 0, 'Are you ok? ...', 'signpost', nil, 1))
