-- This is the (only) interface the games should interact with

local Display = require('machine.display')
local machine = {
  pause = false,
  gameover = false,
  score = 0,
  speed = 0,
  level = 0,
  input = {
    left=false,
    right=false,
    down=false,
    rotate=false
  },
  display = {
    main = Display(10,20),
    next = Display(4,4),
  },
}

return machine
