function makeBoid()
  boid = {
    x = math.random(0, love.graphics.getWidth()),
    y = math.random(0, love.graphics.getHeight()),

    ax = math.random(-10, 11),
    ay = math.random(-10, 11),
  }

  boid.x0 = boid.x
  boid.y0 = boid.y

  boid.xp = boid.x
  boid.yp = boid.y

  local dx = math.random(-100, 101)
  local dy = math.random(-100, 101)

  boid.x = boid.xp + dx * (1 / 60) + 0.5 * boid.ax * (1 / 60) ^ 2
  boid.y = boid.yp + dy * (1 / 60) + 0.5 * boid.ay * (1 / 60) ^ 2

  return boid
end

function drawBoid(boid)
  local dx = (boid.x - boid.xp) * 10
  local dy = (boid.y - boid.yp) * 10

  love.graphics.setColor(1.0, 1.0, 1.0, 0.5)
  love.graphics.line(boid.x, boid.y, boid.x + boid.ax, boid.y + boid.ay)
  love.graphics.line(boid.x, boid.y, boid.x + dx, boid.y + dy)

  love.graphics.setColor(0.7, 0.2, 0.1)
  love.graphics.circle('fill', boid.x, boid.y, 7)

  love.graphics.setColor(0.0, 1.0, 0.2)
  love.graphics.circle('fill', boid.x + boid.ax, boid.y + boid.ay, 3)

  love.graphics.setColor(0.0, 0.2, 1.0)
  love.graphics.circle('fill', boid.x + dx, boid.y + dy, 3)
end

function distance(x0, y0, x1, y1)
  return math.sqrt((x1 - x0)^2 + (y1 - y0)^2)
end

function updateBoid(boid, dt)
  local xp = boid.x
  local yp = boid.y

  boid.x = boid.x + (boid.x - boid.xp) * (dt / dtp) + boid.ax * dt ^ 2
  boid.y = boid.y + (boid.y - boid.yp) * (dt / dtp) + boid.ay * dt ^ 2

  boid.xp = xp
  boid.yp = yp

  -- Calculate the deltas from our start so we can update acceleration
  dxh = boid.x0 - boid.x
  dyh = boid.y0 - boid.y

  boid.ax = dxh * 0.1
  boid.ay = dyh * 0.1
end

function makeAutomaton(rows, cols, prob)
  local auto = {
    rows = rows,
    cols = cols,
    cells = {}
  }

  for r = 0, rows do
    auto.cells[r] = {}
    for c = 0, cols do
      local value = 0
      if math.random() < prob then
        value = 1
      end
      auto.cells[r][c] = value
    end
  end

  return auto
end

function makeGlider(rows, cols)
  local auto = makeAutomaton(rows, cols, 0.0)

  auto.cells[5][5] = 1
  auto.cells[5][7] = 1
  auto.cells[6][6] = 1
  auto.cells[6][7] = 1
  auto.cells[7][6] = 1

  return auto
end

function updateAutomaton(auto)
  local mr = auto.rows - 1
  local mc = auto.cols - 1

  for r = 0, auto.rows do
    for c = 0, auto.cols do
      local rn = (r - 1) % mr -- Row North
      local rs = (r + 1) % mr -- Row South
      local cw = (c - 1) % mc -- Col West
      local ce = (c + 1) % mc -- Col East

      local total =
        auto.cells[rn][c] +  -- N
        auto.cells[rn][ce] + -- NE
        auto.cells[r][ce] +  -- E
        auto.cells[rs][ce] + -- SE
        auto.cells[rs][c] +  -- S
        auto.cells[rs][cw] + -- SW
        auto.cells[r][cw] +  -- W
        auto.cells[rn][cw]   -- NW

      if total < 2 then
        auto.cells[r][c] = 0
      end

      if total == 3 then
        auto.cells[r][c] = 1
      end

      if total > 3 then
        auto.cells[r][c] = 0
      end
    end
  end
end

function drawAutomaton(auto)
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  local cellWidth = width / auto.cols
  local cellHeight = height / auto.rows

  love.graphics.setColor(0.7, 0.7, 0.1)
  for r = 0, auto.rows do
    for c = 0, auto.cols do
      local value = auto.cells[r][c]
      if value == 1 then
        love.graphics.rectangle('fill', c * cellWidth + 1, r * cellHeight + 1, cellWidth - 2, cellHeight - 2)
      end
    end
  end
end

-- Love2D callbacks

function love.load()
  -- auto = makeAutomaton(25, 25, 0.2)
  auto = makeGlider(25, 25)
end

function love.update(dt)
  updateAutomaton(auto)
end

function love.draw()
  drawAutomaton(auto)
end