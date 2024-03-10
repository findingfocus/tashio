push = require 'src/push'
Class = require 'src/class'
Event = require 'lib/knife.event'
Timer = require 'lib/knife.timer'
require 'src/constants'

require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/game/TitleScreenState'
require 'src/states/game/PlayState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'

require 'src/Entity'
require 'src/Animation'
require 'src/Player'
require 'src/Scene'
require 'src/Map'
require 'src/MapDeclarations'
require 'src/AnimSpitter'
require 'src/InsertAnimation'
require 'src/CollidableMapObjects'
require 'src/util'
require 'src/entity_defs'

pixelFont = love.graphics.newFont('fonts/Pixel.ttf', 8)
classicFont = love.graphics.newFont('fonts/classic.ttf', 8)

gTextures = {
    ['character-walk'] = love.graphics.newImage('graphics/playerAtlas.png'),
    ['gecko'] = love.graphics.newImage('graphics/geckoAtlas.png'),
}

gFrames = {
    ['character-walk'] = GenerateQuads(gTextures['character-walk'], TILE_SIZE, TILE_SIZE),
    ['gecko'] = GenerateQuads(gTextures['gecko'], TILE_SIZE, TILE_SIZE),
}
playerSpriteSheet = love.graphics.newImage('graphics/playerAtlas.png')
arrowKeyLogger = love.graphics.newImage('graphics/arrowKey.png')
--dirt = love.graphics.newImage('graphics/dirt.png')
--sand = love.graphics.newImage('graphics/sand.png')
--grass = love.graphics.newImage('graphics/grass.png')
--tallGrass = love.graphics.newImage('graphics/tallGrass.png')
testSprites = love.graphics.newImage('graphics/testSprites.png')
tileSheet = love.graphics.newImage('graphics/masterSheet.png')

sounds = {
    ['beep'] = love.audio.newSource('music/beep.wav', 'static'),
    ['select'] = love.audio.newSource('music/select.wav', 'static')
}
