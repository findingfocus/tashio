push = require 'src/push'
Class = require 'src/class'
Event = require 'lib/knife.event'
Timer = require 'lib/knife.timer'
require 'lib/slam'

globalMap = require 'graphics/globalMap'

require 'src/constants'

require 'src/Animation'
require 'src/LuteString'
require 'src/Note'
require 'src/BassNotes'
require 'src/SignPost'
require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/game/TitleScreenState'
require 'src/states/game/PlayState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/NPCIdleState'
require 'src/states/entity/NPCWalkState'
require 'src/states/entity/FlameIdle'
require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'

require 'src/Entity'
require 'src/entity_defs'
require 'src/Player'
require 'src/Scene'
require 'src/Map'
require 'src/RainSystem'
require 'src/SnowSystem'
require 'src/LavaSystem'
require 'src/SandSystem'
require 'src/AnimSpitter'
require 'src/MapDeclarations'
require 'src/InsertAnimation'
require 'src/CollidableMapObjects'
require 'src/util'

love.graphics.setDefaultFilter('nearest', 'nearest')

pixelFont = love.graphics.newFont('fonts/Pixel.ttf', 8)
classicFont = love.graphics.newFont('fonts/classic.ttf', 8)
smallFont = love.graphics.newFont('fonts/classic.ttf', 4)
particle = love.graphics.newImage('graphics/particle.png')

fretOpen = love.graphics.newImage('graphics/fretOpen.png')
fret1 = love.graphics.newImage('graphics/fret1.png')
fret2 = love.graphics.newImage('graphics/fret2.png')
fret3 = love.graphics.newImage('graphics/fret3.png')
fret4 = love.graphics.newImage('graphics/fret4.png')

gTextures = {
    ['character-walk'] = love.graphics.newImage('graphics/playerAtlas.png'),
    ['villager1-walk'] = love.graphics.newImage('graphics/villager1Atlas.png'),
    ['mage-walk'] = love.graphics.newImage('graphics/mageAtlas.png'),
    ['character-fall'] = love.graphics.newImage('graphics/falling-sheet.png'),
    ['gecko'] = love.graphics.newImage('graphics/geckoAtlas.png'),
    ['geckoC'] = love.graphics.newImage('graphics/geckoCAtlas.png'),
    ['flame'] = love.graphics.newImage('graphics/flameAtlas2.png'),
    ['orb'] = love.graphics.newImage('graphics/orb.png'),
    ['luteString'] = love.graphics.newImage('graphics/string-sheet.png')
}

gFrames = {
    ['character-walk'] = GenerateQuads(gTextures['character-walk'], TILE_SIZE, TILE_SIZE),
    ['villager1-walk'] = GenerateQuads(gTextures['villager1-walk'], TILE_SIZE, TILE_SIZE),
    ['mage-walk'] = GenerateQuads(gTextures['mage-walk'], TILE_SIZE, TILE_SIZE),
    ['character-fall'] = GenerateQuads(gTextures['character-fall'], TILE_SIZE, TILE_SIZE),
    ['gecko'] = GenerateQuads(gTextures['gecko'], TILE_SIZE, TILE_SIZE),
    ['geckoC'] = GenerateQuads(gTextures['geckoC'], TILE_SIZE, TILE_SIZE),
    ['flame'] = GenerateQuads(gTextures['flame'], TILE_SIZE, TILE_SIZE),
    ['luteString'] = GenerateQuads(gTextures['luteString'], TILE_SIZE * 10, 13)
}
heart = love.graphics.newImage('graphics/heart.png')
heartRow = love.graphics.newImage('graphics/heartRow.png')
heartRowEmpty = love.graphics.newImage('graphics/heartRowEmpty.png')
heartRowQuad = love.graphics.newQuad(0, 0, 56, 7, heartRow:getDimensions())
--love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth, tileheight, atlas:getDimensions())
--playerSpriteSheet = love.graphics.newImage('graphics/playerAtlas.png')
playerSpriteSheet = love.graphics.newImage('graphics/villager1Atlas.png')
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
    ['A1'] = love.audio.newSource('sounds/lute/A1.mp3', 'static'),
    ['A2'] = love.audio.newSource('sounds/lute/A2.mp3', 'static'),
    ['Bb1'] = love.audio.newSource('sounds/lute/Bb1.mp3', 'static'),
    ['Bb2'] = love.audio.newSource('sounds/lute/Bb2.mp3', 'static'),
    ['C1'] = love.audio.newSource('sounds/lute/C1.mp3', 'static'),
    ['C2'] = love.audio.newSource('sounds/lute/C2.mp3', 'static'),
    ['D1'] = love.audio.newSource('sounds/lute/D1.mp3', 'static'),
    ['E1'] = love.audio.newSource('sounds/lute/E1.mp3', 'static'),
    ['F1'] = love.audio.newSource('sounds/lute/F1.mp3', 'static'),
    ['F2'] = love.audio.newSource('sounds/lute/F2.mp3', 'static'),
    ['G1'] = love.audio.newSource('sounds/lute/G1.mp3', 'static'),
    ['G2'] = love.audio.newSource('sounds/lute/G2.mp3', 'static'),
}

sounds['cleanse']:setVolume(.2)
