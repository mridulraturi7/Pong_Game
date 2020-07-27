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

--[[
    import our Ball Class.
]]
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--speed of the paddle
PADDLE_SPEED = 200

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Pong')

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

    --place the ball in the middle of the screen.
    ball = Ball(VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

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
        ball:update(dt)
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
            ball:reset()
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

    --render ball using it class render() method
    ball:render()

    displayFPS()

    push:apply('end')

end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end