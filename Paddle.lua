Paddle = {}
Paddle.__index = Paddle

PLAYER1_KEYS_UP = { 'w' }
PLAYER1_KEYS_DOWN = { 's' }

PLAYER2_KEYS_UP = { 'k', 'up' }
PLAYER2_KEYS_DOWN = { 'j', 'down' }

PADDLE_SPEED = 150

KEYS = {
  player1 = {
    UP = PLAYER1_KEYS_UP,
    DOWN = PLAYER1_KEYS_DOWN,
  },
  player2 = {
    UP = PLAYER2_KEYS_UP,
    DOWN = PLAYER2_KEYS_DOWN,
  }
}

function Paddle:create(playerName, posX, posY, width, height)
  local paddle = {}
  setmetatable(paddle, Paddle)

  paddle.player = playerName
  paddle.x = posX
  paddle.y = posY
  paddle.width = width
  paddle.height = height

  paddle:reset()

  return paddle
end

function Paddle:reset()
  self.y = (VIRTUAL_HEIGHT / 2) - self.height / 2
end

function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:update(dt)
  local speed = 0

  if love.keyboard.isDown(KEYS[self.player].DOWN) then
    speed = PADDLE_SPEED
  elseif love.keyboard.isDown(KEYS[self.player].UP) then
    speed = -PADDLE_SPEED
  end

  self.y = self.y + speed * dt
  self.y = math.max(0, self.y)
  self.y = math.min((VIRTUAL_HEIGHT - self.height), self.y)
end
