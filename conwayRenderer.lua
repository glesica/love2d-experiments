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

local function makeRenderer(redrawDelta)
  local renderer = {
    currentTime = 0,
    nextRedraw = redrawDelta,
    redrawDelta = redrawDelta
  }

  return renderer
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

conwayRenderer = {
  drawAutomaton = drawAutomaton,
  makeRenderer = makeRenderer,
  toggleCell = toggleCell
}
