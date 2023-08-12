local Background = {}
Background.__index = Background

function Background:new(imagePath)
  local self = setmetatable({}, Background)
  self.image = love.graphics.newImage(imagePath)
  return self
end

function Background:draw()
  love.graphics.draw(self.image, 0, 0)
end

return Background
