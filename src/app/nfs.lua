local _ = false
local X = true

-- TODO bitmap

local car = {
  {_,X,_},
  {X,X,X},
  {_,X,_},
  {X,_,X},
}

local track = {}



-- TODO vector/pixel/position
local posX = 3
local posY = 16

local time = 0
local move = 0

local drawLine = function (d, x1, y1, x2, y2)
  if x1==x2 then
    for y=y1, y2 do d.on(x1, y) end
  elseif y1==y2 then
    for x=x1, x2 do d.on(x, y1) end
  end
end

local drawBitmap = function (d, map, posX, posY)
  for cy, line in ipairs(map) do
    for cx, val in ipairs(line) do
      if val then d.on(cx-1+posX, cy-1+posY) end
    end
  end
end

local addObstacle = function (obstacle)
  -- TODO helper rectangle, transform
  local line = {}
  for i = 1, obstacle.l do table.insert(line, _) end
  for i = 1, obstacle.w do table.insert(line, X) end
  for i = 1, obstacle.h do table.insert(track, 1, line) end
end


return function(m)

  -- handle input
  if m.input.left then move = -1
  elseif m.input.right then move = 1
  end

  -- do the rest only each 10th tick -- TODO helper function
  time = time+1
  if time%2~=0 then return end

  if time%22==0 then
    local w=math.random(2, 3)
    addObstacle{w=w, h=math.random(2, 3), l=math.random(1, 7)}
    time = 0
    -- TODO timer helpers
    m.score = m.score +1
  else
    table.insert(track, 1, {})
  end

  if #track > m.display.main.h+5 then for i=1, 5 do table.remove(track) end end

  -- update state
  posX = math.max(1, math.min(6, posX + move))
  move = 0

  if track[posY] and track[posY][posX+1] or
     track[posY+1] and track[posY+1][posX] or
     track[posY+1] and track[posY+1][posX+2] then
    m.gameover = true
  end

  -- redraw
  m.display.main.clear()
  drawBitmap(m.display.main, track, 1, 0)
  drawBitmap(m.display.main, car, posX, posY)
  drawBitmap(m.display.next, car, 0, 0)
  drawLine(m.display.main, 0, 0, 0, m.display.main.h)
  drawLine(m.display.main, m.display.main.w-1, 0, m.display.main.w-1, m.display.main.h-1)
end
