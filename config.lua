local Config = {}

function Config:setup()
  love.window.setMode(288, 512)
  love.window.setTitle("Flappy Bird")
  WINDOW_HEIGHT = love.graphics.getHeight()
  WINDOW_WIDTH = love.graphics.getWidth()
end

return Config
