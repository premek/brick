local numPos = {2,6}
local brickscript = require "app.brickscript"
local font = brickscript.load('lib/font')

local selected = 2

-- sys apps get os access
return function(os, machine)
 return function()

  -- redraw
  machine.display.main.clear()
  machine.display.main.bitmap(font[selected+1], numPos)

  -- FIXME input
  if machine.input.down then selected = selected+1; if selected > 9 then selected = 1 end end
  if machine.input.rotate then

    local bindings = {
      machine=machine,
      display=machine.display.main,
      displayNext=machine.display.next,
      score=machine.score,
      print=print,
      --draw = require "app.lib.draw",
      ['<'] = function(callback) if machine.input.left then callback() end end,
      ['>'] = function(callback) if machine.input.right then callback() end end,
      ['every'] = function(times)
        local counter = 0
        return function (callback)
          counter = counter + 1
          if counter >= times then
            counter = 0
            callback()
          end
        end
      end,
    }


    machine.display.main.clear()
    os.app=brickscript.load(selected, bindings)
  end

 end
end
