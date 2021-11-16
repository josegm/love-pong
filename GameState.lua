require 'PlayState'
require 'SplashState'
require 'ServeState'
require 'WinState'

GameState = Class{}

function GameState:init(p1, p2, ball, score)
  self.player1 = p1
  self.player2 = p2
  self.ball = ball
  self.score = score

  self.state = SplashState(self)
end

function GameState:transition(newGameState)
  self.state = newGameState
end

function GameState:reset()
  self.player1:reset()
  self.player2:reset()
  self.ball:reset()
end

function GameState:keypressed(key)
  self = self.state:keypressed(key)
end

function GameState:update(dt)
  self.state:update(dt)
end

function GameState:draw()
  self.state:draw()
end
