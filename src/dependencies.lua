push = require 'src/push'
Class = require 'src/class'
Event = require 'lib/knife.event'
Timer = require 'lib/knife.timer'
Inspect = require 'lib/inspect'
bitser = require 'lib/bitser'
baton = require 'lib/baton'
require 'lib/slam'

INPUT = baton.new {
  controls = {
    left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
    right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
    up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
    action = {'key:space', 'button:a'},
    actionB = {'key:lshift', 'key:rshift', 'button:b'},
    start = {'key:tab', 'button:start'},
    select = {'key:h', 'button:back'}
  },
  pairs = {
    move = {'left', 'right', 'up', 'down'}
  },
  joystick = love.joystick.getJoysticks()[1],
}

minimap = love.graphics.newImage('graphics/minimap.png')
minimapCursor = love.graphics.newImage('graphics/minimapCursor.png')
love.graphics.setDefaultFilter('nearest', 'nearest')
globalMap = require 'graphics/globalMap'
bag = love.graphics.newImage('graphics/bag.png')
berry = love.graphics.newImage('graphics/berry.png')
lute = love.graphics.newImage('graphics/lute.png')
boulder = love.graphics.newImage('graphics/boulder.png')
crate = love.graphics.newImage('graphics/crate.png')
log = love.graphics.newImage('graphics/log.png')
treasureChestClosed = love.graphics.newImage('graphics/chest-closed.png')
treasureChestOpen = love.graphics.newImage('graphics/chest-open.png')

require 'src/constants'
require 'src/Coin'
require 'src/WarpZone'
require 'src/InputHandling'
require 'src/TouchHandling'
require 'src/Animation'
require 'src/LuteString'
require 'src/TouchDetection'
require 'src/Note'
require 'src/BassNotes'
require 'src/Lute'
require 'src/Cursor'
require 'src/DialogueBox'
require 'src/Item'
require 'src/Inventory'
require 'src/Pushable'
require 'src/Spitball'
require 'src/SaveData'

require 'src/states/BaseState'
require 'src/StateMachine'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/GeckoWalkState'
require 'src/states/entity/BatWalkState'
require 'src/states/entity/BatFleeState'
require 'src/states/entity/BatSpawnState'
require 'src/states/entity/NPCIdleState'
require 'src/states/entity/NPCWalkState'
require 'src/states/entity/FlameIdle'
require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'
require 'src/states/entity/player/PlayerDeathState'
require 'src/states/entity/player/PlayerMeditateState'
require 'src/states/entity/player/PlayerCinematicState'
require 'src/states/game/FallingChasmState'

require 'src/Entity'
require 'src/entity_defs'
require 'src/Player'
require 'src/Scene'
require 'src/Pit'
require 'src/Chasm'
require 'src/Map'
require 'src/RainSystem'
require 'src/SnowSystem'
require 'src/LavaSystem'
require 'src/SandSystem'
require 'src/AnimSpitter'
require 'src/TreasureChest'
require 'src/MapDeclarations'
require 'src/InsertAnimation'
require 'src/CollidableMapObjects'
require 'src/util'

require 'src/states/game/TitleScreenState'
require 'src/states/game/PlayState'
require 'src/states/game/Minimap'
require 'src/states/game/PauseState'
require 'src/events/OpeningCinematic'


pixelFont = love.graphics.newFont('fonts/Pixel.ttf', 8)
pixelFont2 = love.graphics.newFont('fonts/712_serif.ttf', 16)
classicFont = love.graphics.newFont('fonts/classic.ttf', 8)
smallFont = love.graphics.newFont('fonts/classic.ttf', 4)
particle = love.graphics.newImage('graphics/particle.png')

rightArrowSelector = love.graphics.newImage('graphics/rightArrowSelector.png')
textAdvance = love.graphics.newImage('graphics/textAdvance.png')
fretOpen = love.graphics.newImage('graphics/fretOpen.png')
fret1 = love.graphics.newImage('graphics/fret1.png')
fret2 = love.graphics.newImage('graphics/fret2.png')
fret3 = love.graphics.newImage('graphics/fret3.png')
fret4 = love.graphics.newImage('graphics/fret4.png')
gameboyOverlay = love.graphics.newImage('graphics/gameboyOverlay.png')
aPress = love.graphics.newImage('graphics/aPress.png')
bPress = love.graphics.newImage('graphics/bPress.png')
upPress = love.graphics.newImage('graphics/upPress.png')
downPress = love.graphics.newImage('graphics/downPress.png')
leftPress = love.graphics.newImage('graphics/leftPress.png')
rightPress = love.graphics.newImage('graphics/rightPress.png')
pauseMockup = love.graphics.newImage('graphics/pauseMockup.png')
tashioTester = love.graphics.newImage('graphics/tashioTester.png')
titleScreenTemp = love.graphics.newImage('graphics/titleScreenTemp.png')

gTextures = {
  ['character-walk'] = love.graphics.newImage('graphics/playerAtlas.png'),
  ['character-push'] = love.graphics.newImage('graphics/playerPushingAtlas.png'),
  ['character-element'] = love.graphics.newImage('graphics/elementAtlas.png'),
  ['character-blueTunic'] = love.graphics.newImage('graphics/blueTunicAtlas.png'),
  ['character-redTunic'] = love.graphics.newImage('graphics/redTunicAtlas.png'),
  ['character-greenTunic'] = love.graphics.newImage('graphics/greenTunicAtlas.png'),
  ['character-yellowTunic'] = love.graphics.newImage('graphics/yellowTunicAtlas.png'),
  ['character-showOff'] = love.graphics.newImage('graphics/showOff.png'),
  ['lute-equip'] = love.graphics.newImage('graphics/luteEquip.png'),
  ['villager1-walk'] = love.graphics.newImage('graphics/villager1Atlas.png'),
  ['mage-walk'] = love.graphics.newImage('graphics/mageAtlas.png'),
  ['character-fall'] = love.graphics.newImage('graphics/falling-sheet.png'),
  ['character-fall-yellowTunic'] = love.graphics.newImage('graphics/falling-sheet-yellowTunic.png'),
  ['character-fall-redTunic'] = love.graphics.newImage('graphics/falling-sheet-redTunic.png'),
  ['character-fall-greenTunic'] = love.graphics.newImage('graphics/falling-sheet-greenTunic.png'),
  ['character-fall-blueTunic'] = love.graphics.newImage('graphics/falling-sheet-blueTunic.png'),
  ['character-push-yellowTunic'] = love.graphics.newImage('graphics/playerPushingAtlasYellow.png'),
  ['character-push-redTunic'] = love.graphics.newImage('graphics/playerPushingAtlasRed.png'),
  ['character-push-greenTunic'] = love.graphics.newImage('graphics/playerPushingAtlasGreen.png'),
  ['character-push-blueTunic'] = love.graphics.newImage('graphics/playerPushingAtlasBlue.png'),
  ['player-death'] = love.graphics.newImage('graphics/playerDeath.png'),
  ['gecko'] = love.graphics.newImage('graphics/geckoAtlas.png'),
  ['geckoC'] = love.graphics.newImage('graphics/geckoCAtlas.png'),
  ['batC'] = love.graphics.newImage('graphics/batlas.png'),
  ['bat'] = love.graphics.newImage('graphics/batAtlas.png'),
  ['flame'] = love.graphics.newImage('graphics/flameAtlas2.png'),
  ['crate'] = love.graphics.newImage('graphics/crate-break.png'),
  ['orb'] = love.graphics.newImage('graphics/orb.png'),
  ['luteString'] = love.graphics.newImage('graphics/string-sheet.png'),
}

gFrames = {
  ['character-walk'] = GenerateQuads(gTextures['character-walk'], TILE_SIZE, TILE_SIZE),
  ['character-push'] = GenerateQuads(gTextures['character-push'], TILE_SIZE, TILE_SIZE),
  ['character-element'] = GenerateQuads(gTextures['character-element'], TILE_SIZE, TILE_SIZE),
  ['character-yellowTunic'] = GenerateQuads(gTextures['character-yellowTunic'], TILE_SIZE, TILE_SIZE),
  ['character-redTunic'] = GenerateQuads(gTextures['character-redTunic'], TILE_SIZE, TILE_SIZE),
  ['character-greenTunic'] = GenerateQuads(gTextures['character-greenTunic'], TILE_SIZE, TILE_SIZE),
  ['character-blueTunic'] = GenerateQuads(gTextures['character-blueTunic'], TILE_SIZE, TILE_SIZE),
  ['character-showOff'] = GenerateQuads(gTextures['character-showOff'], TILE_SIZE, TILE_SIZE),
  ['crate'] = GenerateQuads(gTextures['crate'], TILE_SIZE, TILE_SIZE),
  ['lute-equip'] = GenerateQuads(gTextures['lute-equip'], TILE_SIZE, TILE_SIZE),
  ['villager1-walk'] = love.graphics.newImage('graphics/villager1Atlas.png'),
  ['villager1-walk'] = GenerateQuads(gTextures['villager1-walk'], TILE_SIZE, TILE_SIZE),
  ['mage-walk'] = GenerateQuads(gTextures['mage-walk'], TILE_SIZE, TILE_SIZE),
  ['character-fall'] = GenerateQuads(gTextures['character-fall'], TILE_SIZE, TILE_SIZE),
  ['character-fall-yellowTunic'] = GenerateQuads(gTextures['character-fall-yellowTunic'], TILE_SIZE, TILE_SIZE),
  ['character-fall-redTunic'] = GenerateQuads(gTextures['character-fall-redTunic'], TILE_SIZE, TILE_SIZE),
  ['character-fall-greenTunic'] = GenerateQuads(gTextures['character-fall-greenTunic'], TILE_SIZE, TILE_SIZE),
  ['character-fall-blueTunic'] = GenerateQuads(gTextures['character-fall-blueTunic'], TILE_SIZE, TILE_SIZE),
  ['character-push-yellowTunic'] = GenerateQuads(gTextures['character-push-yellowTunic'], TILE_SIZE, TILE_SIZE),
  ['character-push-redTunic'] = GenerateQuads(gTextures['character-push-yellowTunic'], TILE_SIZE, TILE_SIZE),
  ['character-push-greenTunic'] = GenerateQuads(gTextures['character-push-yellowTunic'], TILE_SIZE, TILE_SIZE),
  ['character-push-blueTunic'] = GenerateQuads(gTextures['character-push-yellowTunic'], TILE_SIZE, TILE_SIZE),
  ['player-death'] = GenerateQuads(gTextures['player-death'], TILE_SIZE, TILE_SIZE),
  ['gecko'] = GenerateQuads(gTextures['gecko'], TILE_SIZE, TILE_SIZE),
  ['geckoC'] = GenerateQuads(gTextures['geckoC'], TILE_SIZE, TILE_SIZE),
  ['batC'] = GenerateQuads(gTextures['batC'], 24, 10),
  ['bat'] = GenerateQuads(gTextures['bat'], 24, 10),
  ['flame'] = GenerateQuads(gTextures['flame'], TILE_SIZE, TILE_SIZE),
  ['luteString'] = GenerateQuads(gTextures['luteString'], TILE_SIZE * 10, 13),
}
heart = love.graphics.newImage('graphics/heart.png')
heartRow = love.graphics.newImage('graphics/heartRow.png')
heartRowEmpty = love.graphics.newImage('graphics/heartRowEmpty.png')
hudOverlay = love.graphics.newImage('graphics/hudOverlay.png')
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
  ['coinPickup'] = love.audio.newSource('sounds/coinPickup.wav', 'static'),

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
