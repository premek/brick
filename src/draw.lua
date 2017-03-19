local lg = love.graphics
local res = require 'resources'
local pixS = 8

local display = function(display, offX, offY, args)
    if args and args.border then
      lg.setColor(res.palette.on)
      lg.rectangle('line', offX-1.5, offY-1.5, pixS*display.w+2, pixS*display.h+2)
    end

    for x=0, display.w-1 do
      for y=0,display.h-1 do
        lg.setColor(display.isOn(x,y) and res.palette.on or res.palette.off)
        lg.rectangle('fill', 2+pixS*x+offX, 2+y*pixS+offY, pixS-5, pixS-5)
        lg.rectangle('line', .5+pixS*x+offX, .5+y*pixS+offY, pixS-2, pixS-2)
      end
    end
end

local lcd = function (val, x, y, len)
    lg.setFont(res.font.lcd)
    lg.setColor(res.palette.off)
    lg.print(string.rep("8", len), x, y)
    lg.setColor(res.palette.on)
    lg.print(string.rep(" ", len-tostring(val):len())..val, x, y)
end


return function(machine)
  lg.setColor(res.palette.bg)
  lg.rectangle('fill', 0, 0, lg:getWidth(), lg:getHeight())

  lg.setFont(res.font.sans)

  lg.setColor(machine.gameover and res.palette.on or res.palette.off)
  lg.print('GAME\nOVER', 350,100)

  lg.setColor(res.palette.on)

  lg.print('SCORE', 220,60) -- TODO 'HI-'
  lg.print('NEXT', 300,115)
  lg.print('SPEED', 300,230)
  lg.print('LEVEL', 300,280)
  lg.print('ROTATE', 300, 350)
  lg.print('<', 330,370)
  -- TODO fruits on the right side, note symbol, LINES instead of score

  lcd(machine.score, 300,55, 6)
  lcd(machine.speed, 370,230, 2)
  lcd(machine.level, 370,280, 2)

  lg.scale(2)
  display(machine.display.main, 60,65, {border=true})
  display(machine.display.next, 150, 70)
end
