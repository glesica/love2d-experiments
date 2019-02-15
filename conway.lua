local function addBlinker(auto, row, col)
  auto.cellStates[row + 0][col + 1] = 1
  auto.cellStates[row + 1][col + 1] = 1
  auto.cellStates[row + 2][col + 1] = 1
end

local function addGlider(auto, row, col)
  auto.cellStates[row + 0][col + 2] = 1
  auto.cellStates[row + 1][col + 2] = 1
  auto.cellStates[row + 2][col + 2] = 1
  auto.cellStates[row + 2][col + 1] = 1
  auto.cellStates[row + 1][col + 0] = 1
end

local function makeAutomaton(rows, cols, prob)
  local updateDelta = 0.25

  local auto = {
    rows = rows,
    cols = cols,
    cellBuffer = {},
    cellStates = {},
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

local function updateAutomaton(auto)
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

conway = {
  addBlinker = addBlinker,
  addGlider = addGlider,
  makeAutomaton = makeAutomaton,
  updateAutomaton = updateAutomaton
}
