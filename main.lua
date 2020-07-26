--[[
    Pong Game.
    Features two paddles, controlled by players, with 
    the goal of getting the ball past your opponent's edge.
    First to 10 points wins.
]]

--[[
    push is a library that allows us to draw our game at a
    virtual resolution, instead of however large our window is;
    It is used to provide a more retro look and feel to the game.
]]

push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--speed of the paddle
PADDLE_SPEED = 200

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont('font.ttf', 32)

    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50
end

function love.update(dt)
    --player1 movement
    if love.keyboard.isDown('w') then
        player1Y = player1Y + -PADDLE_SPEED * dt

    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()

    push:apply('start')

    love.graphics.clear(40, 45, 52, 255)

    love.graphics.printf(
        'Hello Pong!',
        0,
        20,
        VIRTUAL_WIDTH,
        'center'
    )

    --render first paddle(left side)
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    --render second paddle(right side)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

    --render ball(center)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

    push:apply('end')

end