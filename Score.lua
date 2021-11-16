Score = Class{}

function Score:init(maxScore)
  self.maxScore = maxScore
  self:reset()
end

function Score:render()
  love.graphics.setFont(ScoreFont)
  love.graphics.printf(self.player1, 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH / 2, 'center')
  love.graphics.printf(self.player2, VIRTUAL_WIDTH / 2 , VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH / 2, 'center')
end

function Score:player1Goal()
  self.player1 = self.player1 + 1
end

function Score:player2Goal()
  self.player2 = self.player2 + 1
end

function Score:winner()
  if self.player1 == self.maxScore then
    return 'Player 1'
  end

  if self.player2 == self.maxScore then
    return 'Player 2'
  end

  return false
end

function Score:reset()
  self.player1 = 0
  self.player2 = 0
end
