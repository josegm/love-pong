local push = require 'push'
Class = require 'class'

require 'GameState'
require 'Paddle'
require 'Ball'
require 'Score'

WINDOW_WIDTH=1280
WINDOW_HEIGHT=720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20

BALL_SIZE = 4
BALL_SPEED_INCREASE = 1.08 -- 8%
BALL_MAX_SPEED = 190

PADDLE_SPEED = 150

MAX_SCORE = 3

SOUND = true

SOUNDS = {
  ['paddle_hit'] = love.audio.newSource('sounds/paddle-hit.wav', 'static'),
  ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
  ['wall_hit'] = love.audio.newSource('sounds/wall-hit.wav', 'static'),
  ['victory'] = love.audio.newSource('sounds/victory.mp3', 'static'),
}

local showFPS= true

local player1 = Paddle('player1', 0, 0, PADDLE_WIDTH, PADDLE_HEIGHT)
local player2 = Paddle('player2', VIRTUAL_WIDTH - PADDLE_WIDTH, 0, PADDLE_WIDTH, PADDLE_HEIGHT)
local game = GameState(player1, player2, Ball(BALL_SIZE), Score(MAX_SCORE))

-- TODO: Implement alterations to regular game play
-- This 'alteed states' could be combined(ie. inverted & forwarded & intermitent)
local alteredStates = {
  'none', -- up id down and down is up
  'inverted', -- up id down and down is up
  'swapped', -- players swap screen positions
  'forwarded', -- players paddles are closer now
  'intermitent', -- players paddles cycle between visible - invisible
}

local function displayFPS()
  if showFPS == false then
    return
  end

  love.graphics.setFont(SmallFont)
  love.graphics.setColor(0, 255/255, 0, 255/255)
  love.graphics.print(tostring(love.timer.getFPS()), 10, 10)
--  love.graphics.print(game.state.state)
  love.graphics.setColor(1, 1, 1, 1)
end

function love.load()
  math.randomseed(os.time())

  love.graphics.setDefaultFilter('nearest', 'nearest')

  ScoreFont = love.graphics.newFont('font.ttf', 32)
  SmallFont = love.graphics.newFont('font.ttf', 8)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
end

function PlaySound(key)
  if SOUND == true then
    love.audio.play(key)
  end
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  push:start()

  love.graphics.clear(40/255, 45/255, 52/255, 255/255)
  displayFPS()
  game:draw()

  push:finish()
end

function love.keypressed(key)
  game:keypressed(key)
end
