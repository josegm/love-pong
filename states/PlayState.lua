PlayState = Class{}

DIRECTION_LEFT = -1
DIRECTION_RIGHT = 1

function PlayState:init(gameState)
  self.game = gameState
  self.state = 'play'
end

function PlayState:update(dt)
  self.game.player1:update(dt)
  self.game.player2:update(dt)
  self.game.ball:update(dt)

  -- Walls collision?
  if self.game.ball.y <= 0 or self.game.ball.y >= VIRTUAL_HEIGHT - self.game.ball.size then
    self.game.ball.dy = self.game.ball.dy * -1
    PlaySound(SOUNDS.wall_hit)
  end

  -- players hit the ball?
  if self.game.ball:paddleHit(self.game.player1) then
    self.game.ball:changeDirection(DIRECTION_RIGHT, self.game.player1.x + 5)
    PlaySound(SOUNDS.paddle_hit)
  end

  if self.game.ball:paddleHit(self.game.player2) then
    self.game.ball:changeDirection(DIRECTION_LEFT, self.game.player2.x - 4)
    PlaySound(SOUNDS.paddle_hit)
  end

  -- winning condition?
  local someoneWon = false
  if self.game.ball.x < 0 then
    self.game.score:player2Goal()
    someoneWon = true
  elseif self.game.ball.x > VIRTUAL_WIDTH then
    self.game.score:player1Goal()
    someoneWon = true
  end

  if someoneWon then
    PlaySound(SOUNDS.score)
    self.game:transition(ServeState(self.game))
    self.game.ball.dx = self.game.ball.dx * -1
    if self.game.score:winner() then
      self.game:transition(WinState(self.game))
    end
  end
end

function PlayState:draw()
  -- draw net
  love.graphics.setColor(0.5, 0.5, 0.5)
  love.graphics.line(VIRTUAL_WIDTH / 2, 0, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT)
  love.graphics.setColor(1, 1, 1)

  self.game.score:render()

  self.game.player1:render()
  self.game.player2:render()
  self.game.ball:render()
end

function PlayState:keypressed(key)
  if key == 'escape' then
    self.game:transition(SplashState(self.game))
  end
  return self.game
end
