local push = require 'push'
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

local gameState = 'splash'
local victoryPlayed = false
local showFPS= true
local showBallSpeed= true

local  player1 = Paddle:create(0, 0, PADDLE_WIDTH, PADDLE_HEIGHT)
local  player2 = Paddle:create(VIRTUAL_WIDTH - PADDLE_WIDTH, 0, PADDLE_WIDTH, PADDLE_HEIGHT)
local  ball = Ball:create(BALL_SIZE)
local score = Score:create(MAX_SCORE)

local sounds = {
  ['paddle_hit'] = love.audio.newSource('sounds/paddle-hit.wav', 'static'),
  ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
  ['wall_hit'] = love.audio.newSource('sounds/wall-hit.wav', 'static'),
  ['victory'] = love.audio.newSource('sounds/victory.mp3', 'static'),
}

local function displayFPS()
  if showFPS == false then
    return
  end

  love.graphics.setFont(SmallFont)
  love.graphics.setColor(0, 255/255, 0, 255/255)
  love.graphics.print(tostring(love.timer.getFPS()), 10, 10)
  love.graphics.setColor(1, 1, 1, 1)
end

local function displayBallSpeed()
  if showBallSpeed == false then
    return
  end

  love.graphics.setFont(SmallFont)
  love.graphics.setColor(255/255, 255/255, 0, 255/255)
  love.graphics.print("Speed: " .. math.abs(math.floor(ball.dx)), VIRTUAL_WIDTH - 80, 10)
  love.graphics.setColor(1, 1, 1, 1)
end


local function resetGame()
  player1:reset()
  player2:reset()
  ball:reset()
end

function love.load()
  math.randomseed(os.time())

  love.graphics.setDefaultFilter('nearest', 'nearest')

  SmallFont = love.graphics.newFont('font.ttf', 8)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
end

function love.update(dt)
  if gameState ~= 'playing' then
    return
  end

  if love.keyboard.isDown('s') then
    player1:update(PADDLE_SPEED, dt)
  elseif love.keyboard.isDown('w') then
    player1:update(-PADDLE_SPEED, dt)
  end

  if love.keyboard.isDown('j') then
    player2:update(PADDLE_SPEED, dt)
  elseif love.keyboard.isDown('k') then
    player2:update(-PADDLE_SPEED, dt)
  end

  -- Walls collision?
  if ball.y <= 0 or ball.y >= VIRTUAL_HEIGHT - ball.size then
    ball.dy = ball.dy * -1
    love.audio.play(sounds.wall_hit)
  end

  if ball:colides(player1) then
    ball.dx = math.min(math.abs(ball.dx * BALL_SPEED_INCREASE), BALL_MAX_SPEED)
    ball.x = player1.x + 5

    -- keep velocity going in the same direction, but randomize it
    if ball.dy < 0 then
      ball.dy = -math.random(50, 150)
    else
      ball.dy = math.random(50, 150)
    end

    love.audio.play(sounds.paddle_hit)
  end

  if ball:colides(player2) then
    ball.dx = -math.min(math.abs(ball.dx * BALL_SPEED_INCREASE), BALL_MAX_SPEED)
    ball.x = player2.x - 4

    -- keep velocity going in the same direction, but randomize it
    if ball.dy < 0 then
      ball.dy = -math.random(50, 150)
    else
      ball.dy = math.random(50, 150)
    end

    love.audio.play(sounds.paddle_hit)
  end

  if ball.x < 0 then
    love.audio.play(sounds.score)
    score:player2Goal()
    gameState = 'serve'
    ball.dx = ball.dx * -1
    if score:winner() then
      gameState = 'done'
    end
  elseif ball.x > VIRTUAL_WIDTH then
    love.audio.play(sounds.score)
    score:player1Goal()
    gameState = 'serve'
    ball.dx = ball.dx * -1
    if score:winner() then
      gameState = 'done'
    end
  end

  ball:update(dt)
end

function love.draw()
  -- begin rendering at virtual resolution
  push:start()

  love.graphics.clear(40/255, 45/255, 52/255, 255/255)

  displayFPS()

  if gameState == 'splash' or gameState == 'serve' then
    victoryPlayed = false
    love.graphics.setFont(SmallFont)
    love.graphics.printf('Pong with LOVE2D!', 0, 10, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(SmallFont)
    love.graphics.printf('Press ENTER when ready.', 0, (VIRTUAL_HEIGHT / 2) - 6, VIRTUAL_WIDTH, 'center')
  end

  score:render()

  if gameState == 'done' then
    if victoryPlayed == false then
      victoryPlayed = true
      love.audio.play(sounds.victory)
    end

    love.graphics.setFont(ScoreFont)
    love.graphics.printf('GAME OVER', 0, (VIRTUAL_HEIGHT / 2) - VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(SmallFont)
    love.graphics.printf(score:winner() .. ' wins!!', 0, (VIRTUAL_HEIGHT / 2) + 8, VIRTUAL_WIDTH, 'center')
  end

  if gameState == 'playing' then
    displayBallSpeed()
    player1:render()
    player2:render()
    ball:render()
  end

  -- end rendering at virtual resolution
  push:finish()
end

function love.keypressed(key)
  if key == 'escape' then
    if gameState == 'playing' then
      gameState = 'splash'
      resetGame()
      return
    end
    love.event.quit()
  elseif key == 'return' then
    if gameState == 'done' then
      score:reset()
    end

    resetGame()
    gameState = 'playing'
  end
end
