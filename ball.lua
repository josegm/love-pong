Ball = {}
Ball.__index = Ball

function Ball:create(ballSize)
  local ball = {}
  setmetatable(ball, Ball)
  ball.size = ballSize
  ball.speedX = 20
  ball.speedY = 50
  ball:reset()

  return ball
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH/2
  self.y = VIRTUAL_HEIGHT/2

  self.speedX = 20
  self.speedY = 50
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end

function Ball:update(dt)
  -- Walls collision
  if self.y <= 0 or self.y >= VIRTUAL_HEIGHT - BALL_SIZE then
    self.speedY = self.speedY * -1
  end

  self.x = self.x + self.speedX * dt
  self.y = self.y + self.speedY * dt
end
