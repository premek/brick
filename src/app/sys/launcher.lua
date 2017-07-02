local font = require "app.lib.font"
local numPos = {2,6}
local brickapp = require "app.brickapp"

-- TODO lib
local drawBitmap = function (d, map, pos)
  for cy, line in ipairs(map) do
    for cx, val in ipairs(line) do
      if val then d.on(cx-1+pos[1], cy-1+pos[2]) end
    end
  end
end

local selected = 1
local frame = 0

-- sys apps get os access
return function(os)
 return function(m)
  frame = frame + 1

  -- redraw
  m.display.main.clear()
  drawBitmap(m.display.main, font[selected], numPos)

  -- FIXME input
  if m.input.down then selected = selected+1; if selected > 9 then selected = 1 end end
  if m.input.rotate then
    m.display.main.clear()
    os.app=brickapp.load(selected)
  end

 end
end
