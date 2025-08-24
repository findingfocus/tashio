push = require 'src/push'
Class = require 'src/class'
Event = require 'lib/knife.event'
Timer = require 'lib/knife.timer'
Inspect = require 'lib/inspect'
bitser = require 'lib/bitser'
baton = require 'lib/baton'
require 'lib/slam'
require 'src/TouchDetection'
require 'src/constants'

Event.on('solveDesertShortcutBoulders', function()
  for i = #MAP[7][5].collidableMapObjects, 1, -1 do
    if MAP[7][5].collidableMapObjects[i].type == 'boulder' then
        table.remove(MAP[7][5].collidableMapObjects, i)
    end
  end
  table.insert(MAP[7][5].collidableMapObjects, Pushable(2,6, 'boulder', nil, 'keyItem1'))
  table.insert(MAP[7][5].collidableMapObjects, Pushable(3,6, 'boulder', nil, 'keyItem3'))
  table.insert(MAP[7][5].collidableMapObjects, Pushable(1,4, 'boulder', nil, 'keyItem2'))
  table.insert(MAP[7][5].collidableMapObjects, Pushable(3,3, 'boulder'))
  table.insert(MAP[7][5].collidableMapObjects, Pushable(4,4, 'boulder'))
end)

Event.on('cleanseDemoWater', function()
  for i = 1, OVERWORLD_MAP_HEIGHT do
    for j = 1, OVERWORLD_MAP_WIDTH do
      MAP[i][j].animatables = {}
    end
  end

  for i = 1, OVERWORLD_MAP_HEIGHT do
    for j = 1, OVERWORLD_MAP_WIDTH do
      for k = 1, MAP_HEIGHT * MAP_WIDTH do
        local animRow = math.floor((k - 1) / 10) + 1
        local animCol = (k % 10)
        if animCol == 0 then
          animCol = 10
        end
        if MAP[i][j][k] == WATER_ANIM_STARTER then
          MAP[i][j][k] = CLEAN_WATER_ANIM_STARTER
          table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, CLEANSED_WATER.frame) end)
        elseif MAP[i][j][k] == LAVA_LEFT_EDGE_ANIM_STARTER then
          table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, LAVA_LEFT_EDGE.frame) end)
        elseif MAP[i][j][k] == LAVA_RIGHT_EDGE_ANIM_STARTER then
          table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, LAVA_RIGHT_EDGE.frame) end)
        elseif MAP[i][j][k] == LAVA_FLOW_ANIM_STARTER then
          table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, LAVA_FLOW.frame) end)
        end

        if MAP[i][j].aboveGroundTileIds[k] == SCONCE_ANIM_STARTER then
          table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, SCONCE.frame, 'aboveGround') end)
        elseif MAP[i][j].aboveGroundTileIds[k] == FLOWER_ANIM_STARTER then
          table.insert(MAP[i][j].animatables, function() insertAnim(animRow, animCol, FLOWERS.frame, 'aboveGround') end)
        end
      end
    end
  end
  DEMO_WATER_CLEANSED = true
end)

gameBroken = false
entireGame = {}

dpad = {
  TouchDetection(DPAD_LEFT_EDGE, DPAD_TOP_EDGE, DPAD_BUTTON_WIDTH * 3, DPAD_BUTTON_WIDTH, DPAD_COLOR_TC, 'up'),
  TouchDetection(DPAD_LEFT_EDGE, DPAD_TOP_EDGE + DPAD_BUTTON_WIDTH * 2, DPAD_BUTTON_WIDTH * 3, DPAD_BUTTON_WIDTH, DPAD_COLOR_BC, 'down'),
  TouchDetection(DPAD_LEFT_EDGE, DPAD_TOP_EDGE, DPAD_BUTTON_WIDTH, DPAD_BUTTON_WIDTH * 3, DPAD_COLOR_LEFT, 'left'),
  TouchDetection(DPAD_LEFT_EDGE + DPAD_BUTTON_WIDTH * 2, DPAD_TOP_EDGE, DPAD_BUTTON_WIDTH, DPAD_BUTTON_WIDTH * 3, DPAD_COLOR_RIGHT, 'right')
}

buttons = {
  TouchDetection(VIRTUAL_WIDTH - 33, VIRTUAL_HEIGHT_GB / 2 + DPAD_BUTTON_WIDTH + 3, DPAD_BUTTON_WIDTH, DPAD_BUTTON_WIDTH, DPAD_COLOR_TL, 'A'), --A
  TouchDetection(VIRTUAL_WIDTH - 63, VIRTUAL_HEIGHT_GB / 2 + DPAD_BUTTON_WIDTH * 2 + 6, DPAD_BUTTON_WIDTH, DPAD_BUTTON_WIDTH, DPAD_COLOR_TL, 'B'), --B
  TouchDetection(VIRTUAL_WIDTH / 2 - 56, OPTIONS_Y, DPAD_BUTTON_WIDTH, DPAD_BUTTON_WIDTH, DPAD_COLOR_TL, 'SELECT'), --SELECT
  TouchDetection(VIRTUAL_WIDTH / 2 - 14, OPTIONS_Y, DPAD_BUTTON_WIDTH, DPAD_BUTTON_WIDTH, DPAD_COLOR_TL, 'START'), --START
}

--[[
TouchDetection(VIRTUAL_WIDTH - 33, VIRTUAL_HEIGHT_GB / 2 + DPAD_BUTTON_WIDTH + 2, DPAD_COLOR_TL, 'A'),
TouchDetection(VIRTUAL_WIDTH - 64, VIRTUAL_HEIGHT_GB / 2 + DPAD_BUTTON_WIDTH * 2 + 3, DPAD_COLOR_TL, 'B'),
TouchDetection(VIRTUAL_WIDTH / 2 - 56, VIRTUAL_HEIGHT_GB - 30, DPAD_COLOR_TL, 'SELECT'),
TouchDetection(VIRTUAL_WIDTH / 2 - 14, VIRTUAL_HEIGHT_GB - 30, DPAD_COLOR_TL, 'START')
--]]

INPUT = baton.new {
  controls = {
    left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft', 'touch:left'},
    right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright', 'touch:right'},
    up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup', 'touch:up'},
    down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown', 'touch:down'},
    action = {'key:space', 'key:p', 'button:a', 'touch:A'},
    actionB = {'key:lshift', 'key:rshift', 'key:o', 'button:b', 'touch:B'},
    start = {'key:tab', 'button:start', 'touch:START'},
    select = {'key:h', 'key:`', 'key:lctrl', 'key:rctrl', 'button:back', 'touch:SELECT'}
  },
  pairs = {
    move = {'left', 'right', 'up', 'down'}
  },
  joystick = love.joystick.getJoysticks()[1],
}

love.graphics.setDefaultFilter('nearest', 'nearest')
globalMap = require 'graphics/globalMap'
minimap = love.graphics.newImage('graphics/minimap.png')
minimapCursor = love.graphics.newImage('graphics/minimapCursor.png')
tashioMini = love.graphics.newImage('graphics/tashioMini.png')
bag = love.graphics.newImage('graphics/bag.png')
berry = love.graphics.newImage('graphics/berry.png')
healthPotion = love.graphics.newImage('graphics/healthPotion.png')
lute = love.graphics.newImage('graphics/lute.png')
wrongNoteX = love.graphics.newImage('graphics/wrongNoteX.png')
missingNotesBG = love.graphics.newImage('graphics/missingNotesBG.png')
tome1 = love.graphics.newImage('graphics/tome1.png')
boulder = love.graphics.newImage('graphics/boulder.png')
crate = love.graphics.newImage('graphics/crate.png')
log = love.graphics.newImage('graphics/log.png')
unminedRuby = love.graphics.newImage('graphics/rubyMineralUnmined.png')
minedRuby = love.graphics.newImage('graphics/rubyMineralMined.png')
ruby = love.graphics.newImage('graphics/rubyMineral.png')
sapphire = love.graphics.newImage('graphics/sapphireMineral.png')
topaz = love.graphics.newImage('graphics/topazMineral.png')
emerald = love.graphics.newImage('graphics/emeraldMineral.png')
optionsButtonPressed = love.graphics.newImage('graphics/optionsButtonPressed.png')
treasureChestClosed = love.graphics.newImage('graphics/chest-closed.png')
treasureChestOpen = love.graphics.newImage('graphics/chest-open.png')

require 'src/Coin'
require 'src/WarpZone'
require 'src/InputHandling'
require 'src/TouchHandling'
require 'src/Animation'
require 'src/LuteString'
require 'src/Note'
require 'src/BassNotes'
require 'src/Lute'
require 'src/Mineral'
require 'src/MineralDeposit'
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
require 'src/UpgradeElement'
require 'src/RainSystem'
require 'src/SnowSystem'
require 'src/LavaSystem'
require 'src/SandSystem'
require 'src/MageMagicWall'
require 'src/AnimSpitter'
require 'src/TreasureChest'
require 'src/CollidableMapObjects'
require 'src/MapDeclarations'
require 'src/InsertAnimation'
require 'src/util'

require 'src/states/game/TitleScreenState'
require 'src/states/game/PlayState'
require 'src/states/game/Minimap'
require 'src/states/game/PauseState'
require 'src/events/OpeningCinematic'
require 'src/events/MageIntroTopTrigger'
require 'src/states/game/RefineryState'
require 'src/states/game/Tome1SuccessState'


pixelFont = love.graphics.newFont('fonts/Pixel.ttf', 8)
pixelFont2 = love.graphics.newFont('fonts/712_serif.ttf', 16)
classicFont = love.graphics.newFont('fonts/classic.ttf', 8)
smallFont = love.graphics.newFont('fonts/classic.ttf', 4)
particle = love.graphics.newImage('graphics/particle.png')
flamme = love.graphics.newImage('graphics/flamme.png')
flamme2 = love.graphics.newImage('graphics/elements10x10/flamme.png')
aquis = love.graphics.newImage('graphics/aquis.png')
ekko = love.graphics.newImage('graphics/ekko.png')
lox = love.graphics.newImage('graphics/lox.png')
brightside = love.graphics.newImage('graphics/brightside.png')
upgradeCursor = love.graphics.newImage('graphics/upgradeCursor.png')

rightArrowSelector = love.graphics.newImage('graphics/rightArrowSelector.png')
textAdvance = love.graphics.newImage('graphics/textAdvance.png')
fretOpen = love.graphics.newImage('graphics/fretOpen.png')
fret1 = love.graphics.newImage('graphics/fret1.png')
fret2 = love.graphics.newImage('graphics/fret2.png')
--fret3 = love.graphics.newImage('graphics/fret3.png')
--fret4 = love.graphics.newImage('graphics/fret4.png')
gameboyOverlay = love.graphics.newImage('graphics/gameboyOverlay.png')
aPress = love.graphics.newImage('graphics/aPress.png')
bPress = love.graphics.newImage('graphics/bPress.png')
upPress = love.graphics.newImage('graphics/upPress.png')
downPress = love.graphics.newImage('graphics/downPress.png')
leftPress = love.graphics.newImage('graphics/leftPress.png')
rightPress = love.graphics.newImage('graphics/rightPress.png')
pauseMockup = love.graphics.newImage('graphics/pauseMockup2.png')
tashioTester = love.graphics.newImage('graphics/tashioTester.png')
titleScreenTemp = love.graphics.newImage('graphics/titleScreenTemp.png')
titleScreen = love.graphics.newImage('graphics/titleScreen.png')
greenTunicSolo = love.graphics.newImage('graphics/greenTunicSolo.png')
showOffGreenTunic = love.graphics.newImage('graphics/showOff-greenTunic.png')

gTextures = {
  ['character-walk'] = love.graphics.newImage('graphics/playerAtlas.png'),
  ['character-sleep'] = love.graphics.newImage('graphics/playerSleepAtlas.png'),
  ['character-push'] = love.graphics.newImage('graphics/playerPushingAtlas.png'),
  ['character-element'] = love.graphics.newImage('graphics/elementAtlas.png'),
  ['character-blueTunic'] = love.graphics.newImage('graphics/blueTunicAtlas.png'),
  ['character-redTunic'] = love.graphics.newImage('graphics/redTunicAtlas.png'),
  ['character-greenTunic'] = love.graphics.newImage('graphics/greenTunicAtlas.png'),
  ['character-yellowTunic'] = love.graphics.newImage('graphics/yellowTunicAtlas.png'),
  ['character-showOff'] = love.graphics.newImage('graphics/showOff.png'),
  ['lute-equip'] = love.graphics.newImage('graphics/luteEquip.png'),
  ['villager1-walk'] = love.graphics.newImage('graphics/villager1Atlas.png'),
  ['ren-walk'] = love.graphics.newImage('graphics/renAtlas.png'),
  ['mage-walk'] = love.graphics.newImage('graphics/mageAtlas.png'),
  ['character-fall'] = love.graphics.newImage('graphics/falling-sheet.png'),
  ['character-fall-yellowTunic'] = love.graphics.newImage('graphics/falling-sheet-yellowTunic.png'),
  ['character-fall-redTunic'] = love.graphics.newImage('graphics/falling-sheet-redTunic.png'),
  ['character-fall-greenTunic'] = love.graphics.newImage('graphics/falling-sheet-greenTunic.png'),
  ['character-death-greenTunic'] = love.graphics.newImage('graphics/playerDeathGreen.png'),
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
  ['character-sleep'] = GenerateQuads(gTextures['character-sleep'], TILE_SIZE, TILE_SIZE),
  ['character-push'] = GenerateQuads(gTextures['character-push'], TILE_SIZE, TILE_SIZE),
  ['character-element'] = GenerateQuads(gTextures['character-element'], TILE_SIZE, TILE_SIZE),
  ['character-yellowTunic'] = GenerateQuads(gTextures['character-yellowTunic'], TILE_SIZE, TILE_SIZE),
  ['character-redTunic'] = GenerateQuads(gTextures['character-redTunic'], TILE_SIZE, TILE_SIZE),
  ['character-greenTunic'] = GenerateQuads(gTextures['character-greenTunic'], TILE_SIZE, TILE_SIZE),
  ['character-blueTunic'] = GenerateQuads(gTextures['character-blueTunic'], TILE_SIZE, TILE_SIZE),
  ['character-showOff'] = GenerateQuads(gTextures['character-showOff'], TILE_SIZE, TILE_SIZE),
  ['crate'] = GenerateQuads(gTextures['crate'], TILE_SIZE, TILE_SIZE),
  ['lute-equip'] = GenerateQuads(gTextures['lute-equip'], TILE_SIZE, TILE_SIZE),
  ['villager1-walk'] = GenerateQuads(gTextures['villager1-walk'], TILE_SIZE, TILE_SIZE),
  ['ren-walk'] = GenerateQuads(gTextures['ren-walk'], TILE_SIZE, TILE_SIZE),
  ['mage-walk'] = GenerateQuads(gTextures['mage-walk'], TILE_SIZE, TILE_SIZE),
  ['character-fall'] = GenerateQuads(gTextures['character-fall'], TILE_SIZE, TILE_SIZE),
  ['character-fall-yellowTunic'] = GenerateQuads(gTextures['character-fall-yellowTunic'], TILE_SIZE, TILE_SIZE),
  ['character-fall-redTunic'] = GenerateQuads(gTextures['character-fall-redTunic'], TILE_SIZE, TILE_SIZE),
  ['character-fall-greenTunic'] = GenerateQuads(gTextures['character-fall-greenTunic'], TILE_SIZE, TILE_SIZE),
  ['character-death-greenTunic'] = GenerateQuads(gTextures['character-death-greenTunic'], TILE_SIZE, TILE_SIZE),
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
coin = love.graphics.newImage('graphics/coin.png')

ost = {
  ['titleTrack'] = love.audio.newSource('music/titleTrack.mp3', 'static'),
  ['dungeonTrack'] = love.audio.newSource('music/dungeonTrack.mp3', 'static'),
  ['exploreTrack'] = love.audio.newSource('music/exploreTrack.mp3', 'static'),
  ['magesCastleTrack'] = love.audio.newSource('music/magesCastleTrack.mp3', 'static'),
  ['villageTrack'] = love.audio.newSource('music/villageTrack.mp3', 'static'),
  ['darkForestTrack'] = love.audio.newSource('music/darkForestTrack.mp3', 'static'),
}

SOUNDTRACK = ''

--SFX TABLE
sfx = {
  ['bat-damaged'] = love.audio.newSource('sounds/SFX/Bat_Damaged_v4.mp3', 'static'),
  ['bat-spit'] = love.audio.newSource('sounds/SFX/Bat_Spit_v3.mp3', 'static'),
  ['bat-flap'] = love.audio.newSource('sounds/SFX/Bat_Wing_Flap_v4.mp3', 'static'),
  ['cleanse'] = love.audio.newSource('sounds/SFX/Cleanse_Corruption_v2.mp3', 'static'),
  ['coin-pickup'] = love.audio.newSource('sounds/SFX/CoinPickup_v1.mp3', 'static'),
  ['tashio-falling'] = love.audio.newSource('sounds/SFX/Falling_v1.mp3', 'static'),
  ['falling2'] = love.audio.newSource('sounds/SFX/Falling_v2.mp3', 'static'),
  ['game-over1'] = love.audio.newSource('sounds/SFX/GAME_OVER_V1.mp3', 'static'),
  ['game-over2'] = love.audio.newSource('sounds/SFX/GAME_OVER_V2.mp3', 'static'),
  ['game-over3'] = love.audio.newSource('sounds/SFX/GAME_OVER_V3.mp3', 'static'),
  ['item-equip1'] = love.audio.newSource('sounds/SFX/Item_Equip_v1.mp3', 'static'),
  ['item-equip2'] = love.audio.newSource('sounds/SFX/Item_Equip_v2.mp3', 'static'),
  ['item-equip3'] = love.audio.newSource('sounds/SFX/Item_Equip_v3.mp3', 'static'),
  ['item-pickup'] = love.audio.newSource('sounds/SFX/ITEM_PICKUP_V1.mp3', 'static'),
  ['open-chest'] = love.audio.newSource('sounds/SFX/Open_Chest_v2.mp3', 'static'),
  ['pause1'] = love.audio.newSource('sounds/SFX/Pause_v1.mp3', 'static'),
  ['pause2'] = love.audio.newSource('sounds/SFX/Pause_v2.mp3', 'static'),
  ['pause3'] = love.audio.newSource('sounds/SFX/Pause_v3.mp3', 'static'),
  ['purchase1'] = love.audio.newSource('sounds/SFX/Purchase_v1.mp3', 'static'),
  ['purchase2'] = love.audio.newSource('sounds/SFX/Purchase_v2.mp3', 'static'),
  ['push-crate'] = love.audio.newSource('sounds/SFX/Push_Crate_v1.mp3', 'static'),
  ['push-rock'] = love.audio.newSource('sounds/SFX/Push_Rock_v1.mp3', 'static'),
  ['ruby-pickup'] = love.audio.newSource('sounds/SFX/Ruby_Pickup_v3.mp3', 'static'),
  ['ruby-unsocket'] = love.audio.newSource('sounds/SFX/Ruby_Unsocket_v3.mp3', 'static'),
  ['tashio-hurt1'] = love.audio.newSource('sounds/SFX/Tashio_Hurt_v2.mp3', 'static'),
  ['tashio-hurt2'] = love.audio.newSource('sounds/SFX/Tashio_Hurt_v4.mp3', 'static'),
  ['ui-scroll1'] = love.audio.newSource('sounds/SFX/UI_Scroll_v1.mp3', 'static'),
  ['ui-scroll2'] = love.audio.newSource('sounds/SFX/UI_Scroll_v2.mp3', 'static'),
  ['ui-select1'] = love.audio.newSource('sounds/SFX/UI_Select_v1.mp3', 'static'),
  ['ui-select2'] = love.audio.newSource('sounds/SFX/UI_Select_v2.mp3', 'static'),
  ['use-potion'] = love.audio.newSource('sounds/SFX/Use_Potion_v3.mp3', 'static'),
  ['warp-zone'] = love.audio.newSource('sounds/SFX/Warp_Location_v4.mp3', 'static'),
  ['crate-break'] = love.audio.newSource('sounds/SFX/Crate_Break_v2.mp3', 'static'),
  ['idol-heal1'] = love.audio.newSource('sounds/SFX/Idol_v1.mp3', 'static'),
  ['idol-heal2'] = love.audio.newSource('sounds/SFX/Idol_v7.mp3', 'static'),
  ['idol-gong1'] = love.audio.newSource('sounds/SFX/IdolGong_v1.mp3', 'static'),
  ['fire-blast2'] = love.audio.newSource('sounds/SFX/Fire_Blast_v2.mp3', 'static'),
  ['fire-blast-spinning2'] = love.audio.newSource('sounds/SFX/Fire_Blast_Spinning_v2_loop.mp3', 'static'),
  ['dialogue1'] = love.audio.newSource('sounds/SFX/Dialogue_01_Short.mp3', 'static'),
}

tashioHurt = {}
table.insert(tashioHurt, sfx['tashio-hurt1'])
table.insert(tashioHurt, sfx['tashio-hurt2'])


sfx['bat-flap']:setVolume(0.2)
sfx['item-equip1']:setVolume(0.6)
sfx['item-equip3']:setVolume(0.6)
sfx['push-rock']:setVolume(0.8)
sfx['warp-zone']:setVolume(0.5)
sfx['crate-break']:setVolume(0.5)
sfx['idol-heal2']:setVolume(0.7)
sfx['idol-gong1']:setVolume(0.7)
sfx['dialogue1']:setVolume(0.2)
sfx['fire-blast-spinning2']:setVolume(0.5)
sfx['fire-blast2']:setVolume(0.5)

playThis = {}
for k, v in pairs(sfx) do
  table.insert(playThis, v)
end

sounds = {
  ['beep'] = love.audio.newSource('music/beep.wav', 'static'),
  ['select'] = love.audio.newSource('music/select.wav', 'static'),
  ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
  ['death'] = love.audio.newSource('sounds/death.wav', 'static'),
  ['spellcast'] = love.audio.newSource('sounds/spellcast.wav', 'static'),
  ['cleanse'] = love.audio.newSource('sounds/cleanse.wav', 'static'),
  ['coinPickup'] = love.audio.newSource('sounds/coinPickup.wav', 'static'),

  ---[[
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

  ['1-G2'] = love.audio.newSource('sounds/lute2/1-G2.wav', 'static'),
  ['2-A2'] = love.audio.newSource('sounds/lute2/2-A2.wav', 'static'),
  ['3-Bb2'] = love.audio.newSource('sounds/lute2/3-Bb2.wav', 'static'),
  ['4-C3'] = love.audio.newSource('sounds/lute2/4-C3.wav', 'static'),
  ['5-D3'] = love.audio.newSource('sounds/lute2/5-D3.wav', 'static'),
  ['6-E3'] = love.audio.newSource('sounds/lute2/6-E3.wav', 'static'),
  ['7-F3'] = love.audio.newSource('sounds/lute2/7-F3.wav', 'static'),
  ['8-G3'] = love.audio.newSource('sounds/lute2/8-G3.wav', 'static'),
  ['9-A3'] = love.audio.newSource('sounds/lute2/9-A3.wav', 'static'),
  ['10-Bb3'] = love.audio.newSource('sounds/lute2/10-Bb3.wav', 'static'),
  ['11-C4'] = love.audio.newSource('sounds/lute2/11-C4.wav', 'static'),
  ['12-D4'] = love.audio.newSource('sounds/lute2/12-D4.wav', 'static'),
}

sounds['cleanse']:setVolume(.2)
