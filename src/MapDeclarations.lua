require 'src/constants'
require 'src/Pit'

MAP = {}
TILEDMAP = {}
--OVERWORLD_MAP_WIDTH = 10
OVERWORLD_MAP_WIDTH = 20
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
        MAP[i][j].npc = {}
        MAP[i][j].pits = {}
        MAP[i][j].topLevelTileIds = {}
        MAP[i][j].aboveGroundTileIds = {}
        MAP[i][j].dialogueBox = {}
        MAP[i][j].dialogueBoxCollided = {}
        MAP[i][j].warpZones = {}
        MAP[i][j].disjointUp = false
        MAP[i][j].pushables = {}
        MAP[i][j].collidableMapObjects = {}
        MAP[i][j].coins = {}
        MAP[i][j].attacks = {}
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

---[[
table.insert(MAP[1][12].entities, Entity {
    animations = ENTITY_DEFS['bat'].animations,
    x = math.random(30, VIRTUAL_WIDTH - TILE_SIZE * 2),
    y = math.random(10, SCREEN_HEIGHT_LIMIT - 30),
    width = 24,
    height = 10,
    health = 2,
    type = 'bat',
    corrupted = true,
    enemy = true,
    zigzagTime = 0,
    walkSpeed = math.random(8, 14),
    zigzagFrequency = math.random(4.5, 6),
    zigzagAmplitude = math.random(.5, .75),
})

---[[
table.insert(MAP[1][12].entities, Entity {
    animations = ENTITY_DEFS['bat'].animations,
    x = math.random(80, VIRTUAL_WIDTH - TILE_SIZE * 2),
    y = math.random(10, SCREEN_HEIGHT_LIMIT),
    width = 24,
    height = 10,
    health = 2,
    type = 'bat',
    corrupted = true,
    enemy = true,
    zigzagTime = 0,
    walkSpeed = math.random(8, 14),
    zigzagFrequency = math.random(4.5, 6),
    zigzagAmplitude = math.random(.5, .75),
})
--]]

---[[
table.insert(MAP[1][12].entities, Entity {
    animations = ENTITY_DEFS['bat'].animations,
    x = math.random(80, VIRTUAL_WIDTH - TILE_SIZE * 2),
    y = math.random(10, SCREEN_HEIGHT_LIMIT),
    width = 24,
    height = 10,
    health = 2,
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
    end

    if MAP[1][12].entities[i].type == 'bat' then
        MAP[1][12].entities[i].stateMachine = StateMachine {
            ['entity-idle'] = function() return EntityIdleState(MAP[1][12].entities[i]) end,
            ['bat-walk'] = function() return BatWalkState(MAP[1][12].entities[i]) end,
            ['bat-attack'] = function() return BatAttackState(MAP[1][12].entities[i]) end,
            ['bat-flee'] = function() return BatFleeState(MAP[1][12].entities[i]) end,
        }
    end
    MAP[1][12].entities[i]:changeState('entity-idle')
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

--TAVERN
insertWarpZone(7, 2, 1, 11, 9, 3, 3, 8)

--DUNGEON
insertWarpZone(7, 4, 1, 12, 4, 4, 3, 8)

--INN
insertWarpZone(8, 3, 2, 11, 3, 7, 6, 8)

FLOWERS = AnimSpitter(FLOWER_ANIM_STARTER, 1015, 0.75)
AUTUMN_FLOWERS = AnimSpitter(AUTUMN_FLOWER_ANIM_STARTER, 1011, 0.75)
WATER = AnimSpitter(WATER_ANIM_STARTER, 105, .5)

--MAGE NPC
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

--VILLAGER 1
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

local villagerIndex = 1
MAP[1][11].npc[villagerIndex].stateMachine = StateMachine {
    ['npc-idle'] = function() return NPCIdleState(MAP[1][11].npc[villagerIndex]) end,
    ['npc-walk'] = function() return NPCWalkState(MAP[1][11].npc[villagerIndex]) end,
}
MAP[1][11].npc[villagerIndex]:changeState('npc-walk')
MAP[1][11].npc[villagerIndex].stateMachine.current.option = 'horizontal'
table.insert(MAP[1][11].dialogueBox, DialogueBox(MAP[1][11].npc[villagerIndex].x, MAP[1][11].npc[villagerIndex].y, 'Whaddya want?', 'npc', MAP[1][11].npc[villagerIndex]))
MAP[1][11].disjointUp = true

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
table.insert(MAP[2][11].dialogueBox, DialogueBox(MAP[2][11].npc[villager2Index].x, MAP[2][11].npc[villager2Index].y, 'A bed costs 5 gems a night', 'npc', MAP[2][11].npc[villager2Index]))
--]]
--19 CHAR PER LINE = 57 CHARS for 3 lines
table.insert(MAP[7][1].dialogueBox, DialogueBox(TILE_SIZE, 4 * TILE_SIZE, 'You cannot enter without light...', 'signpost'))

table.insert(MAP[8][1].dialogueBox, DialogueBox(TILE_SIZE * 8, 2 * TILE_SIZE, 'Under Construction', 'signpost'))

table.insert(MAP[7][3].dialogueBox, DialogueBox(TILE_SIZE * 7, 3 * TILE_SIZE, 'DANGER-->', 'signpost'))

table.insert(MAP[7][4].dialogueBox, DialogueBox(TILE_SIZE * 8, 0, 'Ice Mountain^^', 'signpost'))

table.insert(MAP[8][3].dialogueBox, DialogueBox(TILE_SIZE * 4, 6 * TILE_SIZE, 'Bed Inside^^', 'signpost'))

table.insert(MAP[7][2].dialogueBox, DialogueBox(2 * TILE_SIZE, 5 * TILE_SIZE, '<-Flowerbed', 'signpost'))
table.insert(MAP[7][2].dialogueBox, DialogueBox(5 * TILE_SIZE, 0, 'Ice Mountain^^', 'signpost'))
table.insert(MAP[7][2].dialogueBox, DialogueBox(7 * TILE_SIZE, 4 * TILE_SIZE, 'Tavern^^  Dungeon-->', 'signpost'))
table.insert(MAP[7][2].dialogueBox, DialogueBox(MAP[7][2].npc[mageIndex].x, MAP[7][2].npc[mageIndex].y, 'There\'s plenty of danger around, but treasure too...', 'npc', MAP[7][2].npc[mageIndex]))

table.insert(MAP[7][2].collidableMapObjects, Pushable(2, 4, 'boulder'))
table.insert(MAP[7][2].collidableMapObjects, Pushable(5, 4, 'log'))
table.insert(MAP[7][2].collidableMapObjects, Pushable(4, 4, 'crate'))
table.insert(MAP[7][2].collidableMapObjects, Pushable(3, 4, 'crate'))
table.insert(MAP[7][2].collidableMapObjects, Pushable(3, 5, 'crate'))

table.insert(MAP[1][12].collidableMapObjects, TreasureChest(3, 2, Coin(), {DialogueBox(2 * TILE_SIZE, TILE_SIZE, 'You found a strange coin! It emenates energy... ')}))
