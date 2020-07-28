# Pong_Game

This repository contains source code of the Pong game.

Pong is a game originally programmed by Atari in 1972. It features two paddles, controlled by players, with the goal of getting the ball past your opponent's edge. First to 10 points wins.

I have developed this game using LOVE2D gaming framework (version 0.10.2) with Lua as the scripting language.

For running this game you will need to install LOVE2D on your system. [Click here to download LOVE2D](https://bitbucket.org/rude/love/downloads/)

Download Lua from this [link](https://excellmedia.dl.sourceforge.net/project/luabinaries/5.2.4/Tools%20Executables/lua-5.2.4_Win64_bin.zip)

For Visual Studio Code, install following extensions:

> vscode-lua - [Click here to download](https://marketplace.visualstudio.com/items?itemName=trixnz.vscode-lua)

> Lua Debug - [Click here to download](https://marketplace.visualstudio.com/items?itemName=actboy168.lua-debug)

> LOVE2D Support by Pixelbyte Studios - [Click here to download](https://marketplace.visualstudio.com/items?itemName=pixelbyte-studios.pixelbyte-love2d)

LOVE2D Support by Pixelbyte Studios allows you to run the love application directly through Visual Studio Code by a simple shortcut : Left-Alt + L

As of now, I have provided two game modes : first one is the Player vs Player and the second is Player vs AI.

In the Player vs Player, Player1 can move the paddle up and down using 'W' and 'S' keys respectively while Player2 can move the paddle up and down using 'Up Arrow Key' and 'Down Arrow Key' respectively. Player scoring 10 points first wins the game.

In the Player vs AI mode, Player can move the paddle up and down using 'W' and 'S' keys respectively. AI player will behave as per the logic implemented. Player scoring 10 points first wins the game.