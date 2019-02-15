function makeAutomaton(rows, cols, prob)
  local updateDelta = 0.25

  local auto = {
    rows = rows,
    cols = cols,
    cellBuffer = {},
    cellStates = {},
    nextUpdate = updateDelta,
    simTime = 0,
    updateDelta = updateDelta
  }

  for r = 0, rows do
    auto.cellStates[r] = {}
    auto.cellBuffer[r] = {}
    for c = 0, cols do
      local value = 0
      if math.random() < prob then
        value = 1
      end
      auto.cellStates[r][c] = value
      auto.cellBuffer[r][c] = 0
    end
  end

  return auto
end

function makeGlider(auto, row, col)
  auto.cellStates[row + 0][col + 2] = 1
  auto.cellStates[row + 1][col + 2] = 1
  auto.cellStates[row + 2][col + 2] = 1
  auto.cellStates[row + 2][col + 1] = 1
  auto.cellStates[row + 1][col + 0] = 1
end

function updateAutomaton(auto)
  local mr = auto.rows
  local mc = auto.cols

  for r = 0, auto.rows do
    for c = 0, auto.cols do
      local rn = (r - 1) % mr -- Row North
      local rs = (r + 1) % mr -- Row South
      local cw = (c - 1) % mc -- Col West
      local ce = (c + 1) % mc -- Col East

      local total =
        auto.cellStates[rn][c] +  -- N
        auto.cellStates[rn][ce] + -- NE
        auto.cellStates[r][ce] +  -- E
        auto.cellStates[rs][ce] + -- SE
        auto.cellStates[rs][c] +  -- S
        auto.cellStates[rs][cw] + -- SW
        auto.cellStates[r][cw] +  -- W
        auto.cellStates[rn][cw]   -- NW
      
      auto.cellBuffer[r][c] = auto.cellStates[r][c]

      if total < 2 then
        auto.cellBuffer[r][c] = 0
      end

      if total == 3 then
        auto.cellBuffer[r][c] = 1
      end

      if total > 3 then
        auto.cellBuffer[r][c] = 0
      end
    end
  end

  local temp = auto.cellStates
  auto.cellStates = auto.cellBuffer
  auto.cellBuffer = temp
end

function drawAutomaton(auto)
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  local cellWidth = width / auto.cols
  local cellHeight = height / auto.rows

  for r = 0, auto.rows do
    for c = 0, auto.cols do
      local value = auto.cellStates[r][c]
      if value == 1 then
        love.graphics.setColor(
          0.7,
          0.7,
          0.1
        )
        love.graphics.rectangle(
          'fill',
          c * cellWidth + 1,
          r * cellHeight + 1,
          cellWidth - 2,
          cellHeight - 2
        )
      end
    end
  end
end

function toggleCell(auto, x, y)
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  local cellWidth = width / auto.cols
  local cellHeight = height / auto.rows

  local r = math.floor(y / cellHeight)
  local c = math.floor(x / cellWidth)

  auto.cellStates[r][c] = math.abs(auto.cellStates[r][c] - 1)
end

-- Love2D callbacks

function love.load()
  auto = makeAutomaton(30, 30, 0.0)
  makeGlider(auto, 5, 5)
  makeGlider(auto, 5, 15)
  makeGlider(auto, 5, 25)
  makeGlider(auto, 15, 5)
  makeGlider(auto, 15, 15)
  makeGlider(auto, 15, 25)
  makeGlider(auto, 25, 5)
  makeGlider(auto, 25, 15)
  makeGlider(auto, 25, 25)

  isPaused = true
end

function love.update(dt)
  if isPaused then
    return
  end
  if auto.simTime > auto.nextUpdate then
    auto.nextUpdate = auto.nextUpdate + auto.updateDelta
    updateAutomaton(auto)
  end
  auto.simTime = auto.simTime + dt
end

function love.draw()
  drawAutomaton(auto)
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
    toggleCell(auto, x, y)
  end
end
