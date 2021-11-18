ServeState = Class{}

function ServeState:init(gameState)
  self.game = gameState
  self.state = 'serve'
end

function ServeState:update(dt)
end

function ServeState:draw()
  love.graphics.setFont(SmallFont)
  love.graphics.printf('Pong with LOVE2D!', 0, 10, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(SmallFont)
  love.graphics.printf('Press ENTER when ready.', 0, (VIRTUAL_HEIGHT / 2) - 6, VIRTUAL_WIDTH, 'center')
end

function ServeState:keypressed(key)
  if key == 'escape' then
    self.game:transition(SplashState(self.game))
  elseif key == 'return' then
    self.game:reset()
    self.game:transition(PlayState(self.game))
  end

  return self.game
end
