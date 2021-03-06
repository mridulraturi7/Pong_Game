--[[
    Paddle class.
    It represents a paddle that can move up and down.
]]

Paddle = Class{}

--[[
    init function is same as constructor in C or C++ used to 
    initialize class variables.
    self is similar to this in C++.
]]
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

--[[
    Computer Player Control.
    following funtion takes ball and a random variable hitposition as arguments.
    hitposition will decide randomly as to where the ball will hit the paddle. 
]]
function Paddle:movementAI(ball, hitPosition)
    if ball.dy < 0 then
        self.y = math.max(0, ball.y - hitPosition)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, ball.y - hitPosition)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end