local love = require("love")
local Pipes = require("pipe")
local Ground = require("ground")
local Config = require("config")
local Background = require("background")
local Bird = require("bird")

local background = Background
local pipes = Pipes
local ground = Ground
local bird = Bird

local velocity = 100
local debugMode = false

local score = 0

function love.load()
  Config:setup()

  ground:setImage("assets/objects/base.png")
  pipes = Pipes:new('assets/objects/pipe_top.png', 150, velocity)
  background = Background:new("assets/objects/background.png")
  ground:setup(velocity)

  local birdImagePaths = {
    "assets/player/1.png",
    "assets/player/2.png",
    "assets/player/3.png"
  }
  bird = Bird:new(birdImagePaths, 0.1, 112)
end

function love.draw()
  background:draw()
  pipes:draw()
  ground:draw()
  bird:draw()

  if debugMode then
    bird:drawCollider()
    pipes:drawColliders()
  end

  love.graphics.print("Pontuação: " .. score, 10, 10)
end

function love.update(dt)
  ground:update(dt)
  pipes:move(dt)
  bird:update(dt)

  if pipes:checkCollision(bird) then
    ResetGame()
  end

  if bird:touchesGround() then
    ResetGame()
  end

  if bird:passesPipes(pipes) then
    if not pipes:isPipeCounted() then
      score = score + 1
      pipes:setPipeCounted(true)
    end
  else
    pipes:setPipeCounted(false)
  end
end

function love.keypressed(key)
  if key == "space" then
    bird:jump()
  end

  if love.mouse.isDown(1) then
    bird:jump()
  end
end

function ResetGame()
  bird:resetAnimation()
  pipes:reset()
  score = 0
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    bird:jump()
  end
end
