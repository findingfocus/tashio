require 'src/constants'

MAP = {}
TILEDMAP = {}
OVERWORLD_MAP_WIDTH = 10
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

tiledMapCount = #tiledMap

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
    if sceneRowsInserted == MAP_WIDTH then
        mapCol = 1
        sceneCol = 1
        globalRowsInserted = globalRowsInserted + 1
        sceneRowsInserted = 0
    end
    if globalRowsInserted == MAP_HEIGHT then
      mapRow = mapRow + 1
      globalRowsInserted = 0
      sceneCol = 1
    end
    
    table.insert(MAP[mapRow][mapCol], tiledMap[tileId])
    sceneCol = sceneCol + 1
end

mapCount = #MAP[1][1]

for i = 1, OVERWORLD_MAP_HEIGHT do
    for j = 1, OVERWORLD_MAP_WIDTH do
        MAP[i][j].animatables = {}
        MAP[i][j].entities = {}
    end
end

--ENTITY DECLARATIONS
local entities = 4
for i = 1, entities do
    local random = math.random(25, 35)
    random = random / 100
    table.insert(MAP[7][3].entities, Entity {
        animations = ENTITY_DEFS['geckoC'].animations,
        x = math.random(80, VIRTUAL_WIDTH - TILE_SIZE * 2),
        y = math.random(10, SCREEN_HEIGHT_LIMIT),
        --[[
        x = VIRTUAL_WIDTH / 2 - 8,
        y = VIRTUAL_HEIGHT / 2 - 8,
        --]]
        width = TILE_SIZE,
        height = TILE_SIZE,
        health = 2,
        direction = 'left',
        type = 'gecko',
        walkSpeed = random,
        aiPath = math.random(1, 2),
        corrupted = true,
        enemy = true,
    })

    MAP[7][3].entities[i].stateMachine = StateMachine {
        ['entity-walk'] = function() return EntityWalkState(MAP[7][3].entities[i]) end,
        ['entity-idle'] = function() return EntityIdleState(MAP[7][3].entities[i]) end,
    }

    MAP[7][3].entities[i]:changeState('entity-idle')
    MAP[7][3].entities[i].hit = false


    FLOWERS = AnimSpitter(1012, 1015, 0.75)
    AUTUMN_FLOWERS = AnimSpitter(1008, 1011, 0.75)
    WATER = AnimSpitter(102, 105, .5)

    --ANIMATABLES
    table.insert(MAP[1][1].animatables, function() insertAnim(2, 3, FLOWERS.frame) end)
    table.insert(MAP[1][1].animatables, function() insertAnim(5, 7, FLOWERS.frame) end)

    table.insert(MAP[1][2].animatables, function() insertAnim(3, 2, FLOWERS.frame) end)
    table.insert(MAP[1][2].animatables, function() insertAnim(6, 5, FLOWERS.frame) end)
    table.insert(MAP[1][2].animatables, function() insertAnim(4, 9, FLOWERS.frame) end)

    table.insert(MAP[2][1].animatables, function() insertAnim(2, 2, FLOWERS.frame) end)
    --table.insert(MAP[7][2].animatables, function() insertAnim(4, 1, WATER.frame) end)
    --table.insert(MAP[7][2].animatables, function() insertAnim(4, 2, WATER.frame) end)
    --table.insert(MAP[7][2].animatables, function() insertAnim(5, 1, WATER.frame) end)
    table.insert(MAP[7][2].animatables, function() insertAnim(5, 2, WATER.frame) end)
    table.insert(MAP[7][2].animatables, function() insertAnim(6, 2, WATER.frame) end)
    table.insert(MAP[7][2].animatables, function() insertAnim(2, 3, FLOWERS.frame) end)
    table.insert(MAP[7][2].animatables, function() insertAnim(5, 7, FLOWERS.frame) end)


    table.insert(MAP[8][2].animatables, function() insertAnim(1, 1, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(1, 2, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(2, 1, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(2, 2, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(3, 1, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(3, 2, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(4, 1, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(4, 2, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(5, 1, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(5, 2, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(6, 1, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(6, 2, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(7, 1, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(7, 2, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(8, 1, WATER.frame) end)
    table.insert(MAP[8][2].animatables, function() insertAnim(8, 2, WATER.frame) end)

    table.insert(MAP[8][3].animatables, function() insertAnim(3, 4, AUTUMN_FLOWERS.frame) end)
    table.insert(MAP[8][3].animatables, function() insertAnim(3, 5, AUTUMN_FLOWERS.frame) end)
    table.insert(MAP[8][3].animatables, function() insertAnim(3, 8, AUTUMN_FLOWERS.frame) end)
    table.insert(MAP[8][3].animatables, function() insertAnim(4, 9, AUTUMN_FLOWERS.frame) end)
    table.insert(MAP[8][3].animatables, function() insertAnim(7, 8, AUTUMN_FLOWERS.frame) end)


end
