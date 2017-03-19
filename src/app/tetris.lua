local _, X = false, true

local bricks = {{
  {X,X},
  {X,X},
}, {
  {X},
  {X},
  {X},
  {X},
}, {
  {_,X},
  {X,X},
  {X,_},
},
}


local brick
local next
local brickPos
local lastBrickMoved


local drawBitmap = function (d, map, pos, onOff)
  for cy, line in ipairs(map) do
    for cx, val in ipairs(line) do
      if val then d.set(cx-1+pos[1], cy-1+pos[2], onOff) end
    end
  end
end

local collision = function (d, map, pos)
  for cy, line in ipairs(map) do
    for cx, val in ipairs(line) do
      local dx, dy = cx-1+pos[1], cy-1+pos[2]
      if val
        and ( d.get(dx, dy)
        or dx>=d.w
        or dx<0
        or dy>=d.h
      ) then return true end
    end
  end
end

local move = function(d, newPos, dir)
  if not collision(d, brick, {newPos[1] + dir, newPos[2]}) then newPos[1] = newPos[1] + dir end
end

local function newBrick()
  brick = next
  next = bricks[math.random(#bricks)]
  if not brick then newBrick() end
  brickPos = {3,0}
end

newBrick()

local time = 0
return function(m)
  time = time+1
  if time<10-m.speed then return end
  time = 0

  local newPos = {brickPos[1], brickPos[2]+1}

  m.display.next.clear()
  drawBitmap(m.display.next, next, {0,0}, X)

  drawBitmap(m.display.main, brick, brickPos, _) -- remove the current brick before collision check

  -- handle input
  if m.input.left then move(m.display.main, newPos, -1) end
  if m.input.right then move(m.display.main, newPos, 1) end
  if m.input.down then end
  if m.input.rotate then  end -- TODO

  if collision(m.display.main, brick, newPos) then
    drawBitmap(m.display.main, brick, brickPos, X) -- put the old brick back
    if not lastBrickMoved then m.gameover = true end
    newBrick()
    lastBrickMoved = false
  else
    lastBrickMoved = true
    brickPos = newPos
    drawBitmap(m.display.main, brick, brickPos, X) -- put the current brick at new pos
  end

end
