local os = {
  paused = false,
  muted = false,
}

local launcher = require('app.sys.launcher')(os)
os.reset = function() os.app=launcher end
os.reset()
return os
