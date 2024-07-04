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

--[[
for i = 1, 10 do
    result[i] = tiledMap[i]
end
-]]

--MAP DOWNLOADER FROM TILED
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

--[[
for x = 1, OVERWORLD_MAP_HEIGHT do
    table.insert(TILEDMAP, {})
    for y = 1, OVERWORLD_MAP_WIDTH do
        table.insert(TILEDMAP[x], {})
    end
end
--]]

--[[
MAP[1][1] = gameMap11
MAP[1][2] = gameMap12
MAP[1][3] = gameMap13
MAP[2][1] = gameMap21
--MAP[2][2] = gameMap22
MAP[2][3] = gameMap23
MAP[3][1] = gameMap31
MAP[3][2] = gameMap32
MAP[3][3] = gameMap33
--]]

---[[



--DEFAULT MAP TILES TO RANDOM SAND TILES
--[[
for x = 1, OVERWORLD_MAP_HEIGHT do
    for y = 1, OVERWORLD_MAP_WIDTH do
        for z = 1, 80 do
            random = math.random(75)
            if random == 75 then
                MAP[x][y][z] = SAND_BONE
            elseif random == 74 then
                MAP[x][y][z] = SAND_WOOD
            else
                MAP[x][y][z] = SAND
            end
        end
    end
end

--]]

--[[
MAP[1][1] = {
        1, 2, 2, 2, 2, 2, 2, 190, 191, 192,
        33, 34, 1012, 34, 34, 34, 34, 222, 223, 224,
        33, 34, 34, 34, 34, 34, 34, 254, 287, 256,
        33, 34, 34, 34, 34, 34, 34, 34, 1018, 34,
        33, 100, 34, 34, 34, 34, 1012, 99, 1018, 34,
        33, 34, 34, 34, 34, 34, 34, 99, 1018, 34,
        33, 34, 34, 34, 34, 34, 34, 99, 1018, 1018,
        33, 34, 34, 34, 34, 34, 34, 99, 34, 34,
        33, 100, 34, 34, 34, 99, 99, 99, 34, 34
      }
      --]]
      --[[
MAP[1][2] = {
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        34, 34, 34, 34, 34, 34, 34, 34, 34, 34,
        34, 1015, 34, 34, 34, 34, 34, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 34, 34, 1015, 34,
        34, 34, 34, 34, 34, 34, 34, 34, 34, 34,
        34, 100, 34, 34, 1015, 34, 34, 34, 34, 34,
        1018, 1018, 1018, 1018, 1018, 1018, 1018, 34, 34, 34,
        34, 34, 34, 99, 99, 99, 1018, 100, 34, 34,
        34, 34, 34, 34, 34, 99, 1018, 34, 34, 34
      }

MAP[1][3] = {
        2, 2, 2, 2, 2, 2, 2, 2, 2, 3,
        34, 34, 34, 34, 34, 34, 34, 100, 34, 35,
        34, 34, 34, 34, 34, 34, 34, 100, 34, 35,
        34, 34, 34, 34, 34, 34, 97, 98, 34, 35,
        34, 34, 34, 34, 34, 34, 129, 130, 34, 35,
        34, 34, 34, 34, 34, 34, 97, 98, 99, 35,
        34, 34, 34, 34, 34, 34, 129, 130, 99, 35,
        34, 34, 34, 34, 34, 34, 34, 34, 99, 35,
        34, 34, 34, 34, 99, 99, 99, 99, 99, 35
      }
MAP[2][1] = {
        33, 34, 34, 34, 34, 34, 34, 34, 34, 34,
        33, 1015, 34, 34, 34, 34, 34, 34, 34, 34,
        33, 34, 34, 34, 34, 34, 34, 34, 34, 34,
        33, 34, 34, 100, 34, 34, 34, 34, 34, 34,
        33, 34, 34, 34, 34, 34, 34, 34, 34, 34,
        33, 34, 34, 100, 34, 34, 34, 34, 34, 34,
        33, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        33, 34, 34, 34, 34, 34, 34, 34, 34, 34,
        65, 66, 66, 66, 66, 66, 66, 66, 66, 66
      }
--]]
--[[
MAP[2][2] = {
        34, 34, 34, 34, 34, 34, 1018, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 1018, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 1018, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 1018, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 1018, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 1018, 1018, 1018, 1018,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        34, 34, 34, 34, 34, 34, 34, 34, 34, 34,
        66, 66, 66, 66, 66, 66, 66, 66, 66, 66
      }
      --]]
--[[
MAP[2][3] = {
        34, 34, 34, 34, 34, 34, 34, 34, 34, 35,
        34, 34, 34, 34, 34, 34, 34, 34, 34, 35,
        34, 34, 34, 34, 34, 34, 100, 34, 34, 35,
        34, 34, 34, 100, 34, 34, 34, 34, 34, 35,
        34, 34, 34, 34, 34, 34, 34, 34, 34, 35,
        1018, 1018, 1018, 1018, 1018, 1018, 1018, 1018, 1018, 1018,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 35,
        34, 34, 34, 34, 34, 34, 34, 34, 34, 35,
        66, 66, 66, 66, 66, 66, 66, 66, 66, 67
      }
      --]]
      
--[[
--MAP DECLARATIONS
MAP[1][1] = {
    TREE_TL, TREE_TR, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TE, CABINROOF_TL, CABINROOF_TC, CABINROOF_TR,
    TREE_BL, TREE_BR   , FLOWER   , GRASS   , GRASS   , GRASS   , GRASS   , CABINROOF_BL   , CABINROOF_BC , CABINROOF_BR,
    GRASS_LE, GRASS   , WOOD_FENCE   , WOOD_FENCE   , WOOD_FENCE   , GRASS   , GRASS   , CABINWALL_L   , CABINDOOR   , CABINWALL_R,
    GRASS_LE, GRASS   , WOOD_FENCE   , DIRT_PATH, DIRT_PATH, DIRT_PATH, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN,
    GRASS_LE, GRASS   , WOOD_FENCE   , DIRT_PATH   , TREE_TL   , TREE_TR   , FLOWER   , GRASS   , GRASS   , GRASS,
    GRASS_LE, GRASS   , WOOD_FENCE   , DIRT_PATH   , TREE_BL   , TREE_BR   , STUMP   , GRASS   , GRASS   , GRASS,
    GRASS_LE, GRASS   , WOOD_FENCE   , DIRT_PATH   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS,
    GRASS_BL, GRASS_BE, GRASS_BE, DIRT_PATH, GRASS_BE, GRASS_BE, GRASS_BE, GRASS_BE, GRASS_BE, GRASS_BE,
}

MAP[1][2] = {
    WOOD_FENCE, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TR,
    WOOD_FENCE, GRASS  , GRASS  , GRASS  , GRASS  , GRASS  , GRASS  , STUMP  , GRASS  , GRASS_RE,
    WOOD_FENCE, FLOWER  , GRASS  , GRASS  , GRASS  , GRASS  , GRASS  , GRASS  , GRASS  , GRASS_RE,
    BRICK_BROWN, BRICK_BROWN  , BRICK_BROWN  , BRICK_BROWN  , GRASS  , GRASS  , GRASS  , GRASS  , FLOWER  , GRASS_RE,
    WOOD_FENCE, TALL_GRASS  , TALL_GRASS  , BRICK_BROWN  , GRASS  , GRASS  , GRASS  , GRASS  , GRASS  , GRASS_RE,
    WOOD_FENCE, STUMP  , GRASS  , BRICK_BROWN  , FLOWER  , GRASS  , GRASS  , GRASS  , GRASS  , GRASS_RE,
    WOOD_FENCE, GRASS  , GRASS , BRICK_BROWN  , TALL_GRASS  , TALL_GRASS  ,TALL_GRASS  , TALL_GRASS  , TALL_GRASS  , TALL_GRASS,
    WOOD_FENCE, STUMP, GRASS, BRICK_BROWN, TALL_GRASS, TALL_GRASS, TALL_GRASS, TALL_GRASS, TALL_GRASS, TALL_GRASS,
}

MAP[2][1] = {
    GRASS_ISLAND_TL, GRASS_ISLAND_TE, GRASS_ISLAND_TE, DIRT_PATH, GRASS_ISLAND_TE, GRASS_ISLAND_TE, GRASS_ISLAND_TE, GRASS_ISLAND_TE, GRASS_ISLAND_TE, GRASS_ISLAND_TR,
    GRASS_ISLAND_LE, FLOWER  , GRASS_ISLAND  , DIRT_PATH  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND_RE,
    GRASS_ISLAND_LE, GRASS_ISLAND  , GRASS_ISLAND  , DIRT_PATH  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND_RE,
    GRASS_ISLAND_LE, GRASS_ISLAND  , GRASS_ISLAND  , DIRT_PATH  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND_RE,
    GRASS_ISLAND_LE, GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND_RE,
    GRASS_ISLAND_LE, GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND_RE,
    GRASS_ISLAND_LE, GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , TALL_GRASS  , TALL_GRASS,
    GRASS_ISLAND_BL, GRASS_ISLAND_BE, GRASS_ISLAND_BE, GRASS_ISLAND_BE, GRASS_ISLAND_BE, GRASS_ISLAND_BE, GRASS_ISLAND_BE, GRASS_ISLAND_BE, TALL_GRASS, TALL_GRASS,
}

MAP[2][2] = {
    BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN,
    BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN,
    BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN,
    BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN,
    BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN,
    BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN,
    BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN,
    BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN, BRICK_BROWN,
}

MAP[2][3] = {
    BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
    BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
    BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
    BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
    BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
    BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
    BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
    BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
}

MAP[1][3] = {
    BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
    BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
    BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
    BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
    BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
    BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
    BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
    BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
}
--]]

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
    table.insert(MAP[1][2].entities, Entity {
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

    MAP[1][2].entities[i].stateMachine = StateMachine {
        ['entity-walk'] = function() return EntityWalkState(MAP[1][2].entities[i]) end,
        ['entity-idle'] = function() return EntityIdleState(MAP[1][2].entities[i]) end,
    }

    MAP[1][2].entities[i]:changeState('entity-idle')
    MAP[1][2].entities[i].hit = false


    FLOWERS = AnimSpitter(1012, 1015, 0.75)
    WATER = AnimSpitter(102, 105, .25)

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
    table.insert(MAP[7][2].animatables, function() insertAnim(7, 2, WATER.frame) end)
    table.insert(MAP[7][2].animatables, function() insertAnim(2, 3, FLOWERS.frame) end)
    table.insert(MAP[7][2].animatables, function() insertAnim(5, 7, FLOWERS.frame) end)
end
