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
playerSpriteSheet = love.graphics.newImage('graphics/playerAtlas.png')
arrowKeyLogger = love.graphics.newImage('graphics/arrowKey.png')
testSprites = love.graphics.newImage('graphics/testSprites.png')
tileSheet = love.graphics.newImage('graphics/masterSheet.png')

sounds = {
    ['beep'] = love.audio.newSource('music/beep.wav', 'static'),
    ['select'] = love.audio.newSource('music/select.wav', 'static')
}
