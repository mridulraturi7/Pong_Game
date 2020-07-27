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

    largeFont = love.graphics.newFont('font.ttf', 16)

    love.graphics.setFont(smallFont)

    --initialize sound table
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    --initialize score variables
    player1Score = 0
    player2Score = 0

    --serving player variable
    servingPlayer = 1

    -- player who won the game; not set to a proper value until we reach
    -- that state in the game
    winningPlayer = 0

    --AI paddle variable to decide where the ball will hit the paddle
    --initializing with 9 so that in the first round ball hits at the middle of the paddle
    hitPosition = 9

    --initialize our player paddles
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    --place the ball in the middle of the screen.
    ball = Ball(VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

    --variable to decide game mode - player vs player and player vs AI
    --by default PvP
    gameMode = 1

    gameState = 'start'
end

--[[
    resize funtion is called whenever we resize the screen
]]
function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if gameState == 'serve' then
        --initialize ball's velocity based on player who last scored
        --before switching to play
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end 
    elseif gameState == 'play' then
        --detecting ball collision with player1
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            --Randomize velocity in y direction
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            --genrating a random value so that ball can hit the AI paddle at any position within the paddle.
            hitPosition = math.random(0, 19)

            sounds['paddle_hit']:play()
        end

        if ball:collides(player2) then
            --detecting ball collision with player2
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            --Randomize velocity in y direction
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 250)
            end

            sounds['paddle_hit']:play()
        end

        --detecting ball collision with lower and upper boundaries of window
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        --update score if the ball goes out of left boundary
        if ball.x < 0 then
            --the player who loses will serve
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            if player2Score == 10 then
                winningPlayer = 2
                sounds['victory']:play()
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        --update score if the ball goes out of right boundary
        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            if player1Score == 10 then
                winningPlayer = 1
                sounds['victory']:play()
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end

    --player1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED

    else
        player1.dy = 0
    end

    --player2 movement
    if gameMode == 1 then
        if love.keyboard.isDown('up') then
            player2.dy = -PADDLE_SPEED
        
        elseif love.keyboard.isDown('down') then
            player2.dy = PADDLE_SPEED

        else
            player2.dy = 0
        end
        player2:update(dt)
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)

    if gameMode == 2 then
        player2:movementAI(ball, hitPosition)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'menu'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            --restart phase
            gameState = 'serve'
            --put the ball in the middle
            ball:reset()

            --reset score to 0
            player1Score = 0
            player2Score = 0

            --set the serving player to the losing player
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 2
            end
        end

    elseif gameState == 'menu' and key == '1' then
        gameMode = 1
        gameState = 'serve'

    elseif gameState == 'menu' and key == '2' then
        gameMode = 2
        gameState = 'serve'
    end
end

function love.draw()

    push:apply('start')

    love.graphics.clear(40, 45, 52, 255)

    love.graphics.setFont(smallFont)

    displayScore()
    
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'menu' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Select Mode', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('1 : Player vs Player', 0, 35, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('2 : Player vs AI', 0, 50, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
        
        if gameMode == 1 then
            love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
            love.graphics.print('Player 1', 10, 20)
            love.graphics.print('Player 2', VIRTUAL_WIDTH - 44, 20)
        elseif gameMode == 2 then
            love.graphics.printf("Player's serve!", 0, 10, VIRTUAL_WIDTH, 'center')
            love.graphics.print('Player', 10, 20)
            love.graphics.print('Computer', VIRTUAL_WIDTH - 44, 20)
        end

    elseif gameState == 'play' then
        --no message
    elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

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

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)
end