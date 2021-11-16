Ball = Class{}

function Ball:init(ballSize)
  self.size = ballSize

  self.dx = math.random(2) == 1 and -100 or 100
  self.dy = math.random(2) == 1 and math.random(-80, -100) or math.random(80, 100)

  self:reset()
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH/2
  self.y = VIRTUAL_HEIGHT/2

  self.dx = self.dx > 0 and math.random(80, 100) or math.random(-80, -100)
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end

function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function Ball:paddleHit(paddle)
  if self.x > paddle.x + paddle.width or paddle.x > self.x + self.size then
    return false
  end

  -- then check to see if the bottom edge of either is higher than the top
  -- edge of the other
  if self.y > paddle.y + paddle.height or paddle.y > self.y + self.size then
    return false
  end

  -- if the above aren't true, they're overlapping

  self.dx = math.min(math.abs(self.dx * BALL_SPEED_INCREASE), BALL_MAX_SPEED)
  self.x = paddle.x - 4

  -- keep velocity going in the same direction, but randomize it
  if self.dy < 0 then
    self.dy = -math.random(50, 150)
  else
    self.dy = math.random(50, 150)
  end

  --    playSound(self.game.sounds.paddle_hit)
  return true
end

function Ball:changeDirection(direction, paddlePosition)
  self.dx = direction * math.min(math.abs(self.dx * BALL_SPEED_INCREASE), BALL_MAX_SPEED)
  self.x = paddlePosition

  -- keep velocity going in the same direction, but randomize it
  if self.dy < 0 then
    self.dy = -math.random(50, 150)
  else
    self.dy = math.random(50, 150)
  end
end
