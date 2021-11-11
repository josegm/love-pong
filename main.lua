
local push = require 'push'
require 'Paddle'
require 'Ball'

WINDOW_WIDTH=1280
WINDOW_HEIGHT=720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20

BALL_SIZE = 4

PADDLE_SPEED = 200

MAX_SCORE = 2

local gameState = 'splash'

local  player1 = Paddle:create(0, 0, PADDLE_WIDTH, PADDLE_HEIGHT)
local  player2 = Paddle:create(VIRTUAL_WIDTH - PADDLE_WIDTH, 0, PADDLE_WIDTH, PADDLE_HEIGHT)
local  ball = Ball:create(BALL_SIZE)

local player1Score = 0
local player2Score = 0

function love.load()
  math.randomseed(os.time())

  love.graphics.setDefaultFilter('nearest', 'nearest')

  SmallFont = love.graphics.newFont('font.ttf', 8)
  ScoreFont = love.graphics.newFont('font.ttf', 32)
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
end

local function resetGame()
  player1:reset()
  player2:reset()
  ball:reset()
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

  if ball:colides(player1) then
    ball.dx = -ball.dx * 1.03
    ball.x = player1.x + 5

    -- keep velocity going in the same direction, but randomize it
    if ball.dy < 0 then
      ball.dy = -math.random(10, 150)
    else
      ball.dy = math.random(10, 150)
    end
  end

  if ball:colides(player2) then
    ball.dx = -ball.dx * 1.03
    ball.x = player2.x - 4

    -- keep velocity going in the same direction, but randomize it
    if ball.dy < 0 then
      ball.dy = -math.random(10, 150)
    else
      ball.dy = math.random(10, 150)
    end
  end

  if ball.x < 0 then
    player2Score = player2Score + 1
    if player2Score == MAX_SCORE then
      gameState = 'done'
    end
    resetGame()
    -- check if player1 wins
  elseif ball.x > VIRTUAL_WIDTH then
    -- check if player2 wins

    player1Score = player1Score + 1
    if player1Score == MAX_SCORE then
      gameState = 'done'
    end

    resetGame()
  end

  ball:update(dt)
end

function love.draw()
  -- begin rendering at virtual resolution
  push:start()

  -- clear the screen with a specific color; in this case, a color similar
  -- to some versions of the original Pong
  love.graphics.clear(40/255, 45/255, 52/255, 255/255)
  -- condensed onto one line from last example
  -- note we are now using virtual width and height now for text placement
  love.graphics.setFont(SmallFont)
  love.graphics.printf('Pong with LOVE2D!', 0, 10, VIRTUAL_WIDTH, 'center')

  if gameState == 'splash' then
    love.graphics.setFont(SmallFont)
    love.graphics.printf('Press ENTER when ready.', 0, (VIRTUAL_HEIGHT / 2) - 6, VIRTUAL_WIDTH, 'center')
  end

  -- render score

  love.graphics.setFont(ScoreFont)
  love.graphics.printf(player1Score, 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH / 2, 'center')
  love.graphics.printf(player2Score, VIRTUAL_WIDTH / 2 , VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH / 2, 'center')

  if gameState == 'done' then
    love.graphics.setFont(SmallFont)
    love.graphics.printf('END GAME', 0, (VIRTUAL_HEIGHT / 2) - 6, VIRTUAL_WIDTH, 'center')
  end

  if gameState == 'playing' then
    player1:render()
    player2:render()
    ball:render()
  end

  -- end rendering at virtual resolution
  push:finish()
end

function love.keypressed(key)
  -- keys can be accessed by string name
  if key == 'escape' then
    if gameState == 'playing' then
      gameState = 'splash'
      resetGame()
      return
    end
    -- function LÖVE gives us to terminate application
    love.event.quit()
  elseif key == 'return' then
    gameState = 'playing'
  end
end

