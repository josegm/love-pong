
local push = require 'push'

WINDOW_WIDTH=1280
WINDOW_HEIGHT=720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20

BALL_SIZE = 4

PADDLE_SPEED = 200

BALL_SPEED_X = 30
BALL_SPEED_Y = 20

require 'paddle'
require 'ball'

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  SmallFont = love.graphics.newFont('font.ttf', 8)
  love.graphics.setFont(SmallFont)
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  Player1 = Paddle:create(0, 0, PADDLE_WIDTH, PADDLE_HEIGHT)
  Player2 = Paddle:create(VIRTUAL_WIDTH - PADDLE_WIDTH, 0, PADDLE_WIDTH, PADDLE_HEIGHT)
  Ball = Ball:create(VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2, BALL_SIZE)
end

function love.draw()
  -- begin rendering at virtual resolution
  push:start()

  -- clear the screen with a specific color; in this case, a color similar
  -- to some versions of the original Pong
  love.graphics.clear(40/255, 45/255, 52/255, 255/255)
  -- condensed onto one line from last example
  -- note we are now using virtual width and height now for text placement
  love.graphics.printf('Hello LOVE!', 0, 10, VIRTUAL_WIDTH, 'center')

  -- draw player1 paddle
  Player1:render()
  Player2:render()
  Ball:render()

  -- end rendering at virtual resolution
  push:finish()
end

function love.keypressed(key)
  -- keys can be accessed by string name
  if key == 'escape' then
    -- function LÖVE gives us to terminate application
    love.event.quit()
  end
end

function love.update(dt)
  if love.keyboard.isDown('s') then
    Player1:update(PADDLE_SPEED, dt)
  elseif love.keyboard.isDown('w') then
    Player1:update(-PADDLE_SPEED, dt)
  end

  if love.keyboard.isDown('j') then
    Player2:update(PADDLE_SPEED, dt)
  elseif love.keyboard.isDown('k') then
    Player2:update(-PADDLE_SPEED, dt)
  end

  Ball:update(BALL_SPEED_X, BALL_SPEED_Y, dt)
end
