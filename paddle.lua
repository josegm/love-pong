Paddle = {}
Paddle.__index = Paddle

function Paddle:create(posX, posY, width, height)
  local paddle = {}
  setmetatable(paddle, Paddle)
  paddle.x = posX
  paddle.y = posY
  paddle.width = width
  paddle.height = height
  return paddle
end

function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:update(speed, dt)
  self.y = self.y + speed * dt
end
