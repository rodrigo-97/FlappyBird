local Pipes = {}
Pipes.__index = Pipes

function Pipes:new(imagePath, pipeGap, moveSpeed, groundHeight)
  local self = setmetatable({}, Pipes)
  self.image = love.graphics.newImage(imagePath)
  self.x = love.graphics.getWidth()
  self.pipeGap = pipeGap or 150
  self.moveSpeed = moveSpeed or 100
  self.pipeWidth = self.image:getWidth()
  self.pipeHeight = self.image:getHeight()
  self.groundHeight = groundHeight or 112
  self:updatePipePositions()
  self.pipeCounted = false
  self.pipePairs = {}
  self.pipeCounted = false
  return self
end

function Pipes:updatePipePositions()
  local maxTopPipeY = love.graphics.getHeight() - self.pipeGap - self.groundHeight - 50
  self.topPipeY = love.math.random(50, maxTopPipeY)
  self.bottomPipeY = self.topPipeY + self.pipeGap
end

function Pipes:move(dt)
  local speed = self.moveSpeed
  self.x = self.x - speed * dt
  if self.x < -self.pipeWidth then
    self.x = love.graphics.getWidth()
    self:updatePipePositions()
  end
end

function Pipes:draw()
  love.graphics.draw(self.image, self.x, self.topPipeY, 0, 1, -1)
  love.graphics.draw(self.image, self.x, self.bottomPipeY)
end

local function checkCollision(box1, box2)
  return box1.x < box2.x + box2.width and
      box1.x + box1.width > box2.x and
      box1.y < box2.y + box2.height and
      box1.y + box1.height > box2.y
end

function Pipes:checkCollision(bird)
  local birdBox = bird:getBoundingBox()
  local topPipeBox = {
    x = self.x,
    y = 0,
    width = self.pipeWidth,
    height = self.topPipeY
  }
  local bottomPipeBox = {
    x = self.x,
    y = self.bottomPipeY,
    width = self.pipeWidth,
    height = love.graphics.getHeight() - self.bottomPipeY
  }

  return checkCollision(birdBox, topPipeBox) or checkCollision(birdBox, bottomPipeBox)
end

function Pipes:isPipeCounted()
  return self.pipeCounted
end

function Pipes:setPipeCounted(value)
  self.pipeCounted = value
end

function Pipes:resetPipeCounters()
  for i, pipePair in ipairs(self.pipePairs) do
    pipePair:setPipeCounted(false)
  end
end

function Pipes:reset()
  self.x = love.graphics.getWidth()
  self:updatePipePositions()
end

function Pipes:drawColliders()
  local topPipeBox = {
    x = self.x,
    y = 0,
    width = self.pipeWidth,
    height = self.topPipeY
  }
  local bottomPipeBox = {
    x = self.x,
    y = self.bottomPipeY,
    width = self.pipeWidth,
    height = love.graphics.getHeight() - self.bottomPipeY
  }

  love.graphics.setColor(1, 0, 0, 0.5)
  love.graphics.rectangle("fill", topPipeBox.x, topPipeBox.y, topPipeBox.width, topPipeBox.height)
  love.graphics.rectangle("fill", bottomPipeBox.x, bottomPipeBox.y, bottomPipeBox.width, bottomPipeBox.height)
  love.graphics.setColor(1, 1, 1, 1)
end

return Pipes
