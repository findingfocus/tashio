require 'src/constants'
require 'src/Pit'

MAP = {}
TILEDMAP = {}
OVERWORLD_MAP_WIDTH = 10
OVERWORLD_MAP_HEIGHT = 10
MAP_WIDTH = 10
MAP_HEIGHT = 8
PITS = 0


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
        MAP[i][j].pits = {}
        MAP[i][j].topLevelTileIds = {}
        MAP[i][j].aboveGroundTileIds = {}
    end
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

    if aboveGroundTiledMap[tileId] == 14 then
      PITS = PITS + 1
      table.insert(MAP[mapRow][mapCol].pits, Pit(sceneRow, sceneCol))
    end

    table.insert(MAP[mapRow][mapCol].aboveGroundTileIds, aboveGroundTiledMap[tileId])

    sceneCol = sceneCol + 1
end

--table.insert(MAP[7][2].pits, {row = 1, col = 2})




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
            end
        end
    end
end

mapCount = #MAP[1][1]

--ENTITY DECLARATIONS
local entities = 4
for i = 1, entities do
    local random = math.random(25, 35)
    random = (random / 100) * 60
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
        health = 3,
        direction = 'left',
        type = 'gecko',
        walkSpeed = random,
        aiPath = math.random(1, 2),
        corrupted = true,
        enemy = true,
    })
    --[[
    table.insert(MAP[7][3].entities, Entity {
        animations = ENTITY_DEFS['villager1'].animations,
        walkSpeed = ENTITY_DEFS['villager1'].walkSpeed,
        height = ENTITY_DEFS['villager1'].height,
        width = ENTITY_DEFS['villager1'].width,
        x = ENTITY_DEFS['villager1'].x,
        y = ENTITY_DEFS['villager1'].y,
        direction = 'left',
    })
    --]]

    MAP[7][3].entities[i].stateMachine = StateMachine {
        ['entity-walk'] = function() return EntityWalkState(MAP[7][3].entities[i]) end,
        ['entity-idle'] = function() return EntityIdleState(MAP[7][3].entities[i]) end,
    }

    MAP[7][3].entities[i]:changeState('entity-idle')
    MAP[7][3].entities[i].hit = false
end

FLOWERS = AnimSpitter(FLOWER_ANIM_STARTER, 1015, 0.75)
AUTUMN_FLOWERS = AnimSpitter(AUTUMN_FLOWER_ANIM_STARTER, 1011, 0.75)
WATER = AnimSpitter(WATER_ANIM_STARTER, 105, .5)
---[[
table.insert(MAP[7][3].entities, Entity {
    animations = ENTITY_DEFS['villager1'].animations,
    walkSpeed = ENTITY_DEFS['villager1'].walkSpeed,
    height = ENTITY_DEFS['villager1'].height,
    width = ENTITY_DEFS['villager1'].width,
    x = ENTITY_DEFS['villager1'].x,
    y = ENTITY_DEFS['villager1'].y,
    --direction = 'right',
})
---[[

local villagerIndex = #MAP[7][3].entities
MAP[7][3].entities[villagerIndex].stateMachine = StateMachine {
    ['entity-walk'] = function() return EntityWalkState(MAP[7][3].entities[villagerIndex]) end,
    ['entity-idle'] = function() return EntityIdleState(MAP[7][3].entities[villagerIndex]) end,
}
MAP[7][3].entities[villagerIndex]:changeState('entity-idle')
--]]
--]]

