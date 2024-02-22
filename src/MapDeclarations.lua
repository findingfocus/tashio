require 'src/constants'
MAP = {}
OVERWORLD_MAP_WIDTH = 10
OVERWORLD_MAP_HEIGHT = 10
MAP_WIDTH = 10
MAP_HEIGHT = 8
---[[

for x = 1, OVERWORLD_MAP_HEIGHT do
    table.insert(MAP, {})
    for y = 1, OVERWORLD_MAP_WIDTH do
        table.insert(MAP[x], {})
    end
end
--]]


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

---[[
MAP[1][1] = {
    GRASS_TL, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TE, GRASS_TR,
    GRASS_LE, GRASS   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS_RE,
    GRASS_LE, GRASS   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS_RE,
    GRASS_LE, GRASS   , GRASS   , DIRT_PATH, DIRT_PATH, DIRT_PATH, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
    GRASS_LE, GRASS   , GRASS   , DIRT_PATH   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS_RE,
    GRASS_LE, GRASS   , GRASS   , DIRT_PATH   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS_RE,
    TREE_TL, TREE_TR   , GRASS   , DIRT_PATH   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS   , GRASS_RE,
    TREE_BL, TREE_BR, GRASS_BE, DIRT_PATH, GRASS_BE, GRASS_BE, GRASS_BE, GRASS_BE, GRASS_BE, GRASS_BR,
}
--]]

--MAP[1][1] = {1, 2}

MAP[1][2] = {
    GRASS_FADED_TL, GRASS_FADED_TE, GRASS_FADED_TE, GRASS_FADED_TE, GRASS_FADED_TE, GRASS_FADED_TE, GRASS_FADED_TE, GRASS_FADED_TE, GRASS_FADED_TE, GRASS_FADED_TR,
    GRASS_FADED_LE, GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED_RE,
    GRASS_FADED_LE, GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED_RE,
    BRICK_BLUE, BRICK_BLUE  , BRICK_BLUE  , BRICK_BLUE  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED_RE,
    GRASS_FADED_LE, GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED_RE,
    GRASS_FADED_LE, GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED_RE,
    GRASS_FADED_LE, GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED  , GRASS_FADED_RE,
    GRASS_FADED_BL, GRASS_FADED_BE, GRASS_FADED_BE, GRASS_FADED_BE, GRASS_FADED_BE, GRASS_FADED_BE, GRASS_FADED_BE, GRASS_FADED_BE, GRASS_FADED_BE, GRASS_FADED_BR,
}

MAP[2][1] = {
    GRASS_ISLAND_TL, GRASS_ISLAND_TE, GRASS_ISLAND_TE, DIRT_PATH, GRASS_ISLAND_TE, GRASS_ISLAND_TE, GRASS_ISLAND_TE, GRASS_ISLAND_TE, GRASS_ISLAND_TE, GRASS_ISLAND_TR,
    GRASS_ISLAND_LE, GRASS_ISLAND  , GRASS_ISLAND  , DIRT_PATH  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND_RE,
    GRASS_ISLAND_LE, GRASS_ISLAND  , GRASS_ISLAND  , DIRT_PATH  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND_RE,
    GRASS_ISLAND_LE, GRASS_ISLAND  , GRASS_ISLAND  , DIRT_PATH  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND_RE,
    GRASS_ISLAND_LE, GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND_RE,
    GRASS_ISLAND_LE, GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND_RE,
    GRASS_ISLAND_LE, GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND  , GRASS_ISLAND_RE,
    GRASS_ISLAND_BL, GRASS_ISLAND_BE, GRASS_ISLAND_BE, GRASS_ISLAND_BE, GRASS_ISLAND_BE, GRASS_ISLAND_BE, GRASS_ISLAND_BE, GRASS_ISLAND_BE, GRASS_ISLAND_BE, GRASS_ISLAND_BR,
}

MAP[2][2] = {
BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE, BRICK_BLUE,
}

MAP[2][3] = {
BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED, BRICK_RED,
}

MAP[1][3] = {
BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN,
BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN,
BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN,
BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN,
BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN,
BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN,
BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN,
BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN, BRICK_GREEN,
}
