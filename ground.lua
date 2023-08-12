local Ground = {
  x = {},
  x2 = {},
  image = {}
}

function Ground:setImage(image)
  self.image = image
end

function Ground:setup(moveSpeed)
  local image = love.graphics.newImage(self.image)
  local imageWidth = image:getWidth()
  local imageHeight = image:getHeight()

  self.moveSpeed = moveSpeed
  self.imageWidth = imageWidth
  self.imageHeight = imageHeight
  self.image = image
  self.x = 0
  self.x2 = imageWidth
end

function Ground:draw()
  love.graphics.draw(self.image, self.x, WINDOW_HEIGHT - self.imageHeight, 0, 1, 1)
  love.graphics.draw(self.image, self.x2, WINDOW_HEIGHT - self.imageHeight, 0, 1, 1)
end

function Ground:move(dt)
  self.x = self.x - self.moveSpeed * dt
  self.x2 = self.x2 - self.moveSpeed * dt
end

function Ground:replace()
  if (self.x + self.imageWidth < 0) then
    self.x = self.x2 + self.imageWidth
  end

  if (self.x2 + self.imageWidth < 0) then
    self.x2 = self.x + self.imageWidth
  end
end

function Ground:update(dt)
  self:move(dt)
  self:replace()
end

return Ground
