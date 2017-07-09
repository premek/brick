local numPos = {2,6}
local brickscript = require "app.brickscript"
local font = brickscript.load('lib/font')
local draw = require "app.lib.draw"

local selected = 1

-- sys apps get os access
return function(os)
 return function(m)

  -- redraw
  m.display.main.clear()
  draw.drawBitmap(m.display.main, font[selected+1], numPos)

  -- FIXME input
  if m.input.down then selected = selected+1; if selected > 9 then selected = 1 end end
  if m.input.rotate then
    m.display.main.clear()
    os.app=brickscript.load(selected)
  end

 end
end
