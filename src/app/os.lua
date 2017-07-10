return function(machine)
    local os = {
      paused = false,
      muted = false,
    }

    local launcher = require('app.launcher')(os, machine)

    os.reset = function()
      os.app=launcher
      machine.score=0
      machine.speed=0
      machine.level=0
      machine.display.next.clear()
      machine.display.main.clear()
      -- etc.. TODO where to put this
    end
    os.reset()
    return os

end
