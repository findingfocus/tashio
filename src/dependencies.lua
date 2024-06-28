push = require 'src/push'
Class = require 'src/class'
Event = require 'lib/knife.event'
Timer = require 'lib/knife.timer'
--[[
sti = require ('lib/sti')
gameMap11 = sti('graphics/tiled/1_1.lua')
gameMap12 = sti('graphics/tiled/1_2.lua')
gameMap13 = sti('graphics/tiled/1_3.lua')
gameMap21 = sti('graphics/tiled/2_1.lua')
gameMap22 = sti('graphics/tiled/2_2.lua')
gameMap23 = sti('graphics/tiled/2_3.lua')
gameMap31 = sti('graphics/tiled/3_1.lua')
gameMap32 = sti('graphics/tiled/3_2.lua')
gameMap33 = sti('graphics/tiled/3_3.lua')
--]]

sti = require ('lib/sti')
--globalMap = sti('graphics/MasterTiledTest.lua')
globalMap = require 'graphics/MasterTiledTest'

require 'src/constants'

require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/game/TitleScreenState'
require 'src/states/game/PlayState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/FlameIdle'
require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'

require 'src/Entity'
require 'src/entity_defs'
require 'src/Animation'
require 'src/Player'
require 'src/Scene'
require 'src/Map'
require 'src/MapDeclarations'
require 'src/AnimSpitter'
require 'src/InsertAnimation'
require 'src/CollidableMapObjects'
require 'src/util'

love.graphics.setDefaultFilter('nearest', 'nearest')

pixelFont = love.graphics.newFont('fonts/Pixel.ttf', 8)
classicFont = love.graphics.newFont('fonts/classic.ttf', 8)
smallFont = love.graphics.newFont('fonts/classic.ttf', 4)

gTextures = {
    ['character-walk'] = love.graphics.newImage('graphics/playerAtlas.png'),
    ['gecko'] = love.graphics.newImage('graphics/geckoAtlas.png'),
    ['geckoC'] = love.graphics.newImage('graphics/geckoCAtlas.png'),
    ['flame'] = love.graphics.newImage('graphics/flameAtlas2.png'),
    ['orb'] = love.graphics.newImage('graphics/orb.png'),
}

gFrames = {
    ['character-walk'] = GenerateQuads(gTextures['character-walk'], TILE_SIZE, TILE_SIZE),
    ['gecko'] = GenerateQuads(gTextures['gecko'], TILE_SIZE, TILE_SIZE),
    ['geckoC'] = GenerateQuads(gTextures['geckoC'], TILE_SIZE, TILE_SIZE),
    ['flame'] = GenerateQuads(gTextures['flame'], TILE_SIZE, TILE_SIZE),
}
heart = love.graphics.newImage('graphics/heart.png')
heartRow = love.graphics.newImage('graphics/heartRow.png')
heartRowEmpty = love.graphics.newImage('graphics/heartRowEmpty.png')
heartRowQuad = love.graphics.newQuad(0, 0, 56, 7, heartRow:getDimensions())
--love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth, tileheight, atlas:getDimensions())
playerSpriteSheet = love.graphics.newImage('graphics/playerAtlas.png')
arrowKeyLogger = love.graphics.newImage('graphics/arrowKey.png')
testSprites = love.graphics.newImage('graphics/testSprites.png')
tileSheet = love.graphics.newImage('graphics/masterSheet.png')

sounds = {
    ['beep'] = love.audio.newSource('music/beep.wav', 'static'),
    ['select'] = love.audio.newSource('music/select.wav', 'static'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    ['death'] = love.audio.newSource('sounds/death.wav', 'static'),
    ['spellcast'] = love.audio.newSource('sounds/spellcast.wav', 'static'),
    ['cleanse'] = love.audio.newSource('sounds/cleanse.wav', 'static'),
}

sounds['cleanse']:setVolume(.2)
