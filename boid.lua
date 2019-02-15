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
