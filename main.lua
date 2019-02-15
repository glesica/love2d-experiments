require 'conway'
require 'conwayRenderer'

function love.load()
  auto = conway.makeAutomaton(30, 30, 0.0)
  renderer = conwayRenderer.makeRenderer(0.1)

  conway.addGlider(auto, 15, 15)
  conway.addBlinker(auto, 20, 20)

  isPaused = true
end

function love.update(dt)
  if isPaused then
    return
  end

  local current = renderer.currentTime
  local next = renderer.nextRedraw
  local delta = renderer.redrawDelta

  if current > next then
    renderer.nextRedraw = next + delta
    conway.updateAutomaton(auto)
  end

  renderer.currentTime = current + dt
end

function love.draw()
  conwayRenderer.drawAutomaton(auto)
end

function love.keypressed(key)
  if key == 'return' then
    isPaused = not isPaused
  end

  if key == 'escape' then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button)
  if isPaused and button == 1 then
    conwayRenderer.toggleCell(auto, x, y)
  end
end
