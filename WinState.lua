WinState = Class{}

function WinState:init(gameState)
  self.game = gameState
  self.state = 'win'
  self.victoryPlayed = false
end

function WinState:draw()
  if self.victoryPlayed == false then
    PlaySound(SOUNDS.victory)
  end
  self.victoryPlayed = true

  love.graphics.setFont(ScoreFont)
  love.graphics.printf('GAME OVER', 0, (VIRTUAL_HEIGHT / 2) - VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(SmallFont)
  love.graphics.printf(self.game.score:winner() .. ' wins!!', 0, (VIRTUAL_HEIGHT / 2) + 8, VIRTUAL_WIDTH, 'center')

  self.game.score:render()
end

function WinState:update(dt)
end

function WinState:keypressed(key)
  if key == 'escape' or key == 'return' then
    self.game.score:reset()
    self.game:reset()
    self.game:transition(SplashState(self.game))
  end

  return self.game
end
