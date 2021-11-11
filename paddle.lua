Paddle = {}
Paddle.__index = Paddle

function Paddle:create(posX, posY, width, height)
  local paddle = {}
  setmetatable(paddle, Paddle)

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

function Paddle:update(speed, dt)
  self.y = self.y + speed * dt
end
