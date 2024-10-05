--[[
WINDOW_WIDTH = 960
WINDOW_HEIGHT = 864
--]]


--DESKTOP SCALE
--[[
SCALE_FACTOR = 5
SCALE_FACTOR_RESET = 2
--]]

---[[
SCALE_FACTOR = 2
SCALE_FACTOR_RESET = 2
--]]

--TOGGLE FOR 4 TIMES UPSIZE
---[[
WINDOW_WIDTH = 160 * SCALE_FACTOR
WINDOW_HEIGHT = 144 * SCALE_FACTOR * 2
--864

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

SCENE_TILE_WIDTH = 10
SCENE_TILE_HEIGHT = 8

PLAYER_WALK_SPEED = 60
VELOCITY = 0.9
ROTATEOFFSET = 4
MAP_RENDER_OFFSET_Y = 16
FADE_TRANSITION_SPEED = 150

INVENTORY_GRID = {}
INVENTORY_XOFFSET = 5

GRID_XOFFSET = 10
GRID_YOFFSET = 6
GRID_ITEM_WIDTH = 27
GRID_ITEM_HEIGHT = 30

KEYITEM_XOFFSET = VIRTUAL_WIDTH - 58
KEYITEM_YOFFSET = 44
KEYITEM_ITEM_WIDTH = 14
KEYITEM_ITEM_HEIGHT = 17

INVENTORY_PLAYER_X = VIRTUAL_WIDTH - 38
INVENTORY_PLAYER_Y = 14

DPAD_BUTTON_WIDTH = 10
DPAD_LEFT_LEFTEDGE = 15
DPAD_LEFT_TOPEDGE = 187
DPAD_LEFT_RIGHTEDGE = 40
DPAD_DIAGONAL_WIDTH = 25
DPAD_WIDTH = 75
DPAD_X = 30 / 4
DPAD_Y = 640 / 4
DPAD_SIDE_OFFSET = 21

MANIS_DRAIN = 30
MANIS_REGEN = 30
FOCUS_GROW = 30
FOCUS_DRAIN = 40
UNFOCUS_SCALER = 60

SIDE_EDGE_BUFFER_PLAYER = 3
COLLISION_BUFFER = 2
FLAME_COLLISION_BUFFER = 8
BOTTOM_BUFFER = 2
SPELL_KNOCKBACK = 70
SLOW_TO_STOP = 100
PIT_PROXIMITY_FALL = 3
FALL_TIMER_THRESHOLD = .1
LUTE_STRING_SPACING = 12
LUTE_STRING_YOFFSET = 10
TEXT_LINE_YOFFSET = 12

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
WATER_ANIM_STARTER = 102
FLOWER_ANIM_STARTER = 1012
AUTUMN_FLOWER_ANIM_STARTER = 1008

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
RED = {255/255, 0/255, 0/255, 255/255}
BLUE = {135/255, 215/255, 255/255, 255/255}
TRANSPARENT = {0/255, 0/255, 0/255, 0/255}

DPAD_COLOR_TL = {255/255, 255/255, 0/255, 150/255}
DPAD_COLOR_TC = {0/255, 255/255, 0/255, 150/255}
DPAD_COLOR_TR = {0/255, 0/255, 255/255, 150/255}
DPAD_COLOR_LEFT = {255/255, 0/255, 0/255, 150/255}
DPAD_COLOR_RIGHT = {80/255, 30/255, 150/255, 150/255}
DPAD_COLOR_BL = {100/255, 100/255, 0/255, 150/255}
DPAD_COLOR_BC = {100/255, 150/255, 40/255, 150/255}
DPAD_COLOR_BR = {0/255, 0/255, 100/255, 150/255}

