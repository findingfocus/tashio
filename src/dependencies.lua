push = require 'src/push'

Class = require 'src/class'

require 'src/StateMachine'
require 'src/states/BaseState'

Event = require 'lib/knife.event'
Timer = require 'lib/knife.timer'

require 'src/states/game/TitleScreenState'
require 'src/states/game/PlayState'
require 'src/Player'
require 'src/Scene'
require 'src/Map'
require 'src/MapDeclarations'
require 'src/constants'
require 'src/AnimSpitter'
require 'src/InsertAnimation'
require 'src/util'

pixelFont = love.graphics.newFont('fonts/Pixel.ttf', 16)
tinyFont = love.graphics.newFont('fonts/Pixel.ttf', 8)

--kvotheSpriteSheet = love.graphics.newImage('graphics/kvotheAtlas.png')
arrowKeyLogger = love.graphics.newImage('graphics/arrowKey.png')
dirt = love.graphics.newImage('graphics/dirt.png')
sand = love.graphics.newImage('graphics/sand.png')
grass = love.graphics.newImage('graphics/grass.png')
tallGrass = love.graphics.newImage('graphics/tallGrass.png')
testSprites = love.graphics.newImage('graphics/testSprites.png')
tileSheet = love.graphics.newImage('graphics/masterSheet.png')

sounds = {
    ['beep'] = love.audio.newSource('music/beep.wav', 'static'),
    ['select'] = love.audio.newSource('music/select.wav', 'static')
}
