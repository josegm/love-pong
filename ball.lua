Ball = {}
Ball.__index = Ball

function Ball:create(posX, posY, ballSize)
  local ball = {}
  setmetatable(ball, Ball)
  ball.x = posX
  ball.y = posY
  ball.size = ballSize
  return ball
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end

function Ball:update(speedX, speedY, dt)
  self.x = self.x + speedX * dt
  self.y = self.y + speedY * dt
end
