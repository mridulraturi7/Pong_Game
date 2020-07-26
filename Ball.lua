--[[
    Ball CLass.
    It represents a ball which will bounce back and forth 
    between padles and walls until it passes a left or right 
    boundary of the screen, scoring a point for the opponent.
]]

Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    --These variables are for tracking the velocity of the ball.
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

--[[
    reset() will place the ball in the middle of the sceen
    with an initial random velocity on both axes.
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH/2 - 2
    self.y = VIRTUAL_HEIGHT/2 - 2
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end