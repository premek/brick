return function(pixelsX, pixelsY)

  local d = {
    w = pixelsX,
    h = pixelsY,
    display = {},
  }

  d.clear = function ()
   for x=0, d.w-1 do
    d.display[x] = {}
    for y=0,d.h-1 do
      d.display[x][y]=false
    end
   end
  end

  local xy = function(x, y)
    if y == nil and type(x) == 'table' then return x[1], x[2] end
    return x, y
  end


  d.set = function(x,y, val)
    x,y=xy(x,y);
    if not d.display[x] then d.display[x] = {} end
    d.display[x][y] = val
  end
  -- FIXME which one?
  d.isOn = function(x,y) x,y=xy(x,y); return d.display[x] and d.display[x][y] end
  d.get  = function(x,y) x,y=xy(x,y); return d.display[x] and d.display[x][y] end

  d.on = function(x,y) d.set(x, y, true) end
  d.off = function(x,y) d.set(x, y, false) end
  d.toggle = function(x,y) d.set(x,y, not d.get(x,y)) end

  d.clear()

  return d
end
