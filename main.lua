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

--[[
    class is a library that will allow us to represent anything in
    our game as code, rather than keeping track of many disparate 
    variables and methods
]]
Class = require 'class'

--[[
    import our Paddle class.
]]
require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--speed of the paddle
PADDLE_SPEED = 200

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

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

    --initialize our player paddles
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    --ball position when play starts
    ballX = VIRTUAL_WIDTH/2 - 2
    ballY = VIRTUAL_HEIGHT/2 - 2

    --ball velocity variables when play starts
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    gameState = 'start'
end

function love.update(dt)
    --player1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED

    else
        player1.dy = 0
    end

    --player2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
        
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED

    else
        player2.dy = 0
    end

    if gameState == 'play' then
        --scale the velocity by dt so that the movement is framerate - independent
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end

    player1:update(dt)
    player2:update(dt)

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            ballX = VIRTUAL_WIDTH/2 - 2
            ballY = VIRTUAL_HEIGHT/2 - 2

            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end

function love.draw()

    push:apply('start')

    love.graphics.clear(40, 45, 52, 255)

    love.graphics.setFont(smallFont)
    
    if gameState == 'start' then
        love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)

    --render paddles using their class render() method
    player1:render()
    player2:render()

    --render ball(center)
    love.graphics.rectangle('fill', ballX, ballY - 2, 4, 4)

    push:apply('end')

end