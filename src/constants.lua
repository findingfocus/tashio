--[[
WINDOW_WIDTH = 960
WINDOW_HEIGHT = 864
--]]


--DESKTOP SCALE
--[[
SCALE_FACTOR = 5
SCALE_FACTOR_RESET = 2
--]]

--DEVELOPMENT
---[[
SCALE_FACTOR = 6
SCALE_FACTOR_RESET = 6
--]]

--WEB
--[[
SCALE_FACTOR = 2
SCALE_FACTOR_RESET = 2
--]]

--TOGGLE FOR 4 TIMES UPSIZE
---[[
WINDOW_WIDTH = 160 * SCALE_FACTOR
WINDOW_HEIGHT = 144 * SCALE_FACTOR * 2
--864

MINIMAP_WIDTH = 160
MINIMAP_HEIGHT = 130

MINIMAP_ROW = 1
MINIMAP_COLUMN = 1
--]]

--TOGGLE FOR GB RESOLUTION
--[[
WINDOW_WIDTH = 160
WINDOW_HEIGHT = 144
--]]

VIRTUAL_WIDTH =  160
VIRTUAL_HEIGHT = 144
VIRTUAL_HEIGHT_GB = 144 * 2


--[[DEVELOP
SCALE_FACTOR = 5
WINDOW_HEIGHT = 144 * SCALE_FACTOR
WINDOW_WIDTH = 160 * SCALE_FACTOR
VIRTUAL_HEIGHT_GB = 144
--]]



SCREEN_WIDTH_LIMIT = 160
SCREEN_HEIGHT_LIMIT = VIRTUAL_HEIGHT - 16
HEIGHT_TO_DIALOGUE_BOX = 128

SCENE_TILE_WIDTH = 10
SCENE_TILE_HEIGHT = 8

PLAYER_WALK_SPEED = 60
VELOCITY = 0.9
ROTATEOFFSET = 4
MAP_RENDER_OFFSET_Y = 16
FADE_TRANSITION_SPEED = 200
FADE_TO_BLACK_SPEED = 600
CHASM_FALL_TWEEN = .7
CHASM_FALL_ANIM_TIMER = .55
COOKIE_VIGNETTE_COLOR = {0, 0, 0, 200/255}
COOKIE_VIGNETTE = true
SQUARE_CHASM_ID = 17
CHASM_DEF_BEGIN = 15
CHASM_DEF_END = 32


INVENTORY_GRID = {}
INVENTORY_XOFFSET = 5

GRID_XOFFSET = 10
GRID_YOFFSET = 6
GRID_ITEM_WIDTH = 27
GRID_ITEM_HEIGHT = 30

AABB_SIDE_COLLISION_BUFFER = 1
AABB_TOP_COLLISION_BUFFER = 6

KEYITEM_XOFFSET = VIRTUAL_WIDTH - 58
KEYITEM_YOFFSET = 45
KEYITEM_ITEM_WIDTH = 13
KEYITEM_ITEM_HEIGHT = 16

INVENTORY_PLAYER_X = VIRTUAL_WIDTH - 38
INVENTORY_PLAYER_Y = 14

MAX_TEXTBOX_CHAR_LENGTH = 57
MAX_TEXTBOX_LINE_LENGTH = 19

DPAD_LEFT_LEFTEDGE = 15 * SCALE_FACTOR
DPAD_LEFT_TOPEDGE = 187 * SCALE_FACTOR
DPAD_LEFT_RIGHTEDGE = 40 * SCALE_FACTOR
DPAD_WIDTH = 75 * SCALE_FACTOR
DPAD_X = 30 / 4 * SCALE_FACTOR
DPAD_Y = 640 / 4 * SCALE_FACTOR
DPAD_SIDE_OFFSET = 21 * SCALE_FACTOR

--NEW
DPAD_BUTTON_WIDTH = 24
DPAD_LEFT_EDGE = 9
DPAD_TOP_EDGE = VIRTUAL_HEIGHT_GB / 2 + 18
DPAD_UP = 30 / 4 * SCALE_FACTOR - 10
DPAD_LEFT = 30 / 4 * SCALE_FACTOR - 10
DPAD_RIGHT = 30 / 4 * SCALE_FACTOR - 10
DPAD_RIGHT_OFFSET = 30 / 4 * SCALE_FACTOR - 10
OPTIONS_Y = VIRTUAL_HEIGHT_GB - 30


ABUTTON_X = (VIRTUAL_WIDTH - 33) * SCALE_FACTOR
ABUTTON_Y = (VIRTUAL_HEIGHT_GB / 2) * SCALE_FACTOR + DPAD_BUTTON_WIDTH
BBUTTON_X = (VIRTUAL_WIDTH - 64) * SCALE_FACTOR
BBUTTON_Y = (VIRTUAL_HEIGHT_GB / 2) * SCALE_FACTOR + DPAD_BUTTON_WIDTH * 2 + 3
SELECT_X = (VIRTUAL_WIDTH / 2 - 56) * SCALE_FACTOR
START_X = (VIRTUAL_WIDTH/ 2 - 14) * SCALE_FACTOR

MANIS_DRAIN = 30
MANIS_REGEN = 30
FOCUS_GROW = 30
FOCUS_DRAIN = 40
UNFOCUS_SCALER = 60

SIDE_EDGE_BUFFER_PLAYER = 3
COLLISION_BUFFER = 2
FLAME_COLLISION_BUFFER = 8
BOTTOM_BUFFER = 2
SPELL_KNOCKBACK = 60
SLOW_TO_STOP = 100
PIT_PROXIMITY_FALL = 1
FALL_TIMER_THRESHOLD = .01
LUTE_STRING_SPACING = 12
LUTE_STRING_YOFFSET = 10
TEXT_LINE_YOFFSET = 12
PUSH_SPEED = 30
PUSH_TIMER_THRESHOLD = 1
CREDITS_SPEED = 0.2
BAT_DISTANCE = 2
BAT_EXIT_SPEED = 25
BAT_SPAWN_SPEED = 0.8
BAT_FLYBACK_SPEED = 60
BAT_ATTACK_SPEED = 2
FAST_SELECT_TIMER = .2
MINERAL_HARVEST_RESET = 60

PAUSED = false
DIALOGUE_TRIGGER_SHRINK = 3

OFFSCREEN_BUFFER = 12
OFFSCREEN_TOP_BUFFER = 3
KEYLOGGER_YOFFSET = 0
TILE_SIZE = 16

FIRST = 1
SECOND = 2
THIRD = 3
FOURTH = 4
FIFTH = 5
SIXTH = 6
SEVENTH = 7
EIGHTH = 8
NINTH = 9

INPUT_LIST = {}
TOUCH_LIST = {}
OUTPUT_LIST = {}
TOUCH_OUTPUT_LIST = {}
BUTTON_LIST = {}

--ANIMATED TILE STARTER FRAMES
CLEAN_WATER_ANIM_STARTER = 240
CLEAN_WATER_ANIM_ENDER = 243
WATER_ANIM_STARTER = 102
FLOWER_ANIM_STARTER = 1012
AUTUMN_FLOWER_ANIM_STARTER = 1008
LAVA_LEFT_EDGE_ANIM_STARTER = 1003
LAVA_RIGHT_EDGE_ANIM_STARTER = 998
LAVA_FLOW_ANIM_STARTER = 117

IDOL = 131

--SINGLE TILE SPRITES
DIRT = 1021
DIRT_PATH = 1020
SAND = 1024
SAND_BONE = 1023
SAND_WOOD = 1022
TALL_GRASS = 1019
BRICK_BROWN = 1016
BRICK_BLUE = 1017
BRICK_RED = 1018
FLOWER = 1012

GRASS_TL = 1
GRASS_TE = 2
GRASS_TR = 3
GRASS_LE = 33
GRASS = 34
GRASS_RE = 35
GRASS_BL = 65
GRASS_BE = 66
GRASS_BR = 67

GRASS_FADED_TL = 4
GRASS_FADED_TE = 5
GRASS_FADED_TR = 6
GRASS_FADED_LE = 36
GRASS_FADED = 37
GRASS_FADED_RE = 38
GRASS_FADED_BL = 68
GRASS_FADED_BE = 69
GRASS_FADED_BR = 70

GRASS_ISLAND_TL = 7
GRASS_ISLAND_TE = 8
GRASS_ISLAND_TR = 9
GRASS_ISLAND_LE = 39
GRASS_ISLAND = 40
GRASS_ISLAND_RE = 41
GRASS_ISLAND_BL = 71
GRASS_ISLAND_BE = 72
GRASS_ISLAND_BR = 73

--QUADRUPLE SPRITES
TREE_BL = 129
TREE_BR = 130
TREE_TL = 97
TREE_TR = 98

CABINROOF_TL = 190
CABINROOF_TC = 191
CABINROOF_TR = 192
CABINROOF_BL = 222
CABINROOF_BC = 223
CABINROOF_BR = 224

CABINWALL_L = 254
CABINWALL_R = 256

CABINDOOR = 287

WOOD_FENCE = 99
STUMP = 100

--COLORS
FADED = {105/255, 105/255, 105/255, 255/255}
GRAY = {140/255, 140/255, 165/255, 255/255}
YELLOW = {255/255, 255/255, 140/255, 255/255}
BLACK = {0/255, 0/255, 0/255, 255/255}
WHITE = {255/255, 255/255, 255/255, 255/255}
DEBUG_BG = {0/255, 0/255, 0/255, 90/255}
DEBUG_BG2 = {0/255, 0/255, 0/255, 130/255}
GREEN = {0/255, 255/255, 0/255, 255/255}
PURPLE = {255/255, 0/255, 255/255, 255/255}
CYAN = {0/255, 255/255, 255/255, 255/255}
DARK_CYAN = {0/255, 200/255, 200/255, 255/255}
RED = {255/255, 0/255, 0/255, 255/255}
DARK_RED = {100/255, 0/255, 0/255, 255/255}
BLUE = {135/255, 215/255, 255/255, 255/255}
TRANSPARENT = {0/255, 0/255, 0/255, 0/255}
INVENTORY_COLOR = {181/255, 172/255, 138/255, 255/255}

FLAMME_COLOR = {226/255, 12/255, 32/255, 255/255}
AQUIS_COLOR = {38/255, 202/255, 239/255, 255/255}
EKKO_COLOR = {33/255, 246/255, 98/255, 255/255}
LOX_COLOR = {240/255, 245/255, 48/255, 255/255}


DPAD_COLOR_TL = {255/255, 255/255, 0/255, 150/255}
DPAD_COLOR_TC = {0/255, 255/255, 0/255, 150/255}
DPAD_COLOR_TR = {0/255, 0/255, 255/255, 150/255}
DPAD_COLOR_LEFT = {255/255, 0/255, 0/255, 150/255}
DPAD_COLOR_RIGHT = {80/255, 30/255, 150/255, 150/255}
DPAD_COLOR_BL = {100/255, 100/255, 0/255, 150/255}
DPAD_COLOR_BC = {100/255, 150/255, 40/255, 150/255}
DPAD_COLOR_BR = {0/255, 0/255, 100/255, 150/255}

