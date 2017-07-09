local font = require("app.brickscript").load('lib/font')
local numPos = {2,6}
local brickscript = require "app.brickscript"

-- TODO lib
local drawBitmap = function (d, map, pos)
  for cy, line in ipairs(map) do
    for cx, val in ipairs(line) do
      if val>0 then d.on(cx-1+pos[1], cy-1+pos[2]) end
    end
  end
end

local selected = 1

-- sys apps get os access
return function(os)
 return function(m)

  -- redraw
  m.display.main.clear()
  drawBitmap(m.display.main, font[selected], numPos)

  -- FIXME input
  if m.input.down then selected = selected+1; if selected > 9 then selected = 1 end end
  if m.input.rotate then
    m.display.main.clear()
    os.app=brickscript.load(selected)
  end

 end
end
