SplashState = Class{}

function SplashState:init(gameState)
  self.game = gameState
  self.state = 'splash'
end

function SplashState:update(dt)
end

function SplashState:draw()
  love.graphics.setFont(SmallFont)
  love.graphics.printf('Pong with LOVE2D!', 0, 10, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(SmallFont)
  love.graphics.printf('Press ENTER when ready.', 0, (VIRTUAL_HEIGHT / 2) - 6, VIRTUAL_WIDTH, 'center')
end

function SplashState:keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'return' then
    self.game:transition(PlayState(self.game))
  end

  return self.game
end
