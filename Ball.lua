Ball = {}
Ball.__index = Ball

function Ball:create(ballSize)
  local ball = {}
  setmetatable(ball, Ball)
  ball.size = ballSize

  self.dx = math.random(2) == 1 and -100 or 100
  self.dy = math.random(2) == 1 and math.random(-80, -100) or math.random(80, 100)

  ball:reset()

  return ball
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH/2
  self.y = VIRTUAL_HEIGHT/2

  self.dx = math.random(20, 100)
  self.dy = math.random(20, 100)
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end

function Ball:colides(paddle)
  if self.x > paddle.x + paddle.width or paddle.x > self.x + self.size then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.size then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end

function Ball:update(dt)
  -- Walls collision?
  if self.y <= 0 or self.y >= VIRTUAL_HEIGHT - self.size then
    self.dy = self.dy * -1
  end

  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end
