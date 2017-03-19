local snake = {{5,15}, {5, 16}, {5, 17}}
local dir = {0,-1}
local food = {5, 10}

local time = 0
return function(g)

  -- handle input
  if g.input.left then dir = {-1, 0} end
  if g.input.right then dir = {1, 0} end
  if g.input.rotate then dir = {0, -1} end
  if g.input.down then dir = {0, 1} end

  -- blink food
  if math.fmod(time, 3)==0 then g.display.main.toggle(food) end

  -- do the rest only each 10th tick
  time = time+1
  if time<10-g.speed then return end
  time = 0

  -- update state
  local head = {snake[1][1]+dir[1], snake[1][2]+dir[2]}
  if head[1]<0 or head[1]>=g.display.main.w or head[2]<0 or head[2]>=g.display.main.h then g.gameover = true; return end
  table.insert(snake, 1, head)

  if head[1]==food[1] and head[2]==food[2] then
    food = {math.random(10)-1, math.random(20)-1}
    g.score = g.score +5
    if g.score > g.speed*10 then g.speed = g.speed +1 end
  else
    table.remove(snake)
  end

  -- redraw
  g.display.main.clear()
  for _, pix in ipairs(snake) do
    g.display.main.on(pix)
  end

end
