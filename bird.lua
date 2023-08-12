local Bird = {}
Bird.__index = Bird

function Bird:new(imagePaths, frameDuration, groundHeight)
  local self = setmetatable({}, Bird)
  self.images = {}
  for i, path in ipairs(imagePaths) do
    table.insert(self.images, love.graphics.newImage(path))
  end
  self.frameDuration = frameDuration or 0.2
  self.timer = 0
  self.currentFrame = 1
  self.y = love.graphics.getHeight() / 2
  self.dy = 0
  self.gravity = 500
  self.jumpPower = -300
  self.groundHeight = groundHeight or 0
  self.birdWidth = self.images[1]:getWidth()
  self.birdHeight = self.images[1]:getHeight()
  self.targetRotation = 0
  self.currentRotation = 0
  self.rotationSpeed = 5
  return self
end

function Bird:update(dt)
  self.timer = self.timer + dt
  if self.timer > self.frameDuration then
    self.timer = self.timer - self.frameDuration
    self.currentFrame = (self.currentFrame % #self.images) + 1
  end

  local screenHeight = love.graphics.getHeight()


  if self.y < 0 then
    self.y = 0
    self.dy = 0
  end


  if self.y > screenHeight - self.groundHeight - self.birdHeight then
    self.y = screenHeight - self.groundHeight - self.birdHeight
    self.dy = 0
  end


  local targetRotation = 0.2
  if self.dy < 0 then
    targetRotation = -0.2
  end
  self.targetRotation = targetRotation
  self.currentRotation = self.currentRotation + (self.targetRotation - self.currentRotation) * self.rotationSpeed * dt

  self.dy = self.dy + self.gravity * dt
  self.y = self.y + self.dy * dt
end

function Bird:draw()
  local image = self.images[self.currentFrame]
  local x = 100
  local y = self.y + self.birdHeight / 2
  local scaleX = 1
  local scaleY = 1


  love.graphics.draw(image, x, y, self.currentRotation, scaleX, scaleY, self.birdWidth / 2, self.birdHeight / 2)
end

function Bird:jump()
  self.dy = self.jumpPower
end

function Bird:resetAnimation()
  self.timer = 0
  self.currentFrame = 1
  self.y = love.graphics.getHeight() / 2
  self.dy = 0
  self.targetRotation = 0
  self.currentRotation = 0
end

function Bird:getBoundingBox()
  return {
    x = 100 - self.birdWidth / 2,
    y = self.y - self.birdHeight / 2 + 15,
    width = self.birdWidth - 10,
    height = self.birdHeight - 10
  }
end

function Bird:touchesGround()
  local screenHeight = love.graphics.getHeight()
  return self.y >= screenHeight - self.groundHeight - self.birdHeight
end

function Bird:passesPipes(pipes)
  local birdRight = 100 + self.birdWidth / 2
  local pipesLeft = pipes.x
  return birdRight > pipesLeft
end

function Bird:drawCollider()
  local birdBox = self:getBoundingBox()

  love.graphics.setColor(1, 0, 0, 0.5)
  love.graphics.rectangle("fill", birdBox.x, birdBox.y, birdBox.width, birdBox.height)
  love.graphics.setColor(1, 1, 1, 1)
end

return Bird
