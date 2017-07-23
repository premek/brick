return function(pixelsX, pixelsY)

  local d = {
    w = pixelsX,
    h = pixelsY,
    layers = {},
  }

  d.clear = function (layer)
    if layer then d.layers[layer] = {} else d.layers = {} end
  end

  d.shift = function (x, y, layer)
    local layers = layer and {d.layers[layer]} or d.layers
    for _, l in pairs(layers) do
      -- TODO move up and left
      for xx=1, x do
        table.insert(l, 0, {})
          l[pixelsX*2] = nil -- keep some pixels outside the visible area to be able to shift them back
      end
      for yy=1, y do
        for _, col in pairs(l) do
          table.insert(col, 0, false)
          col[pixelsY*2] = nil -- keep some pixels outside the visible area to be able to shift them back
        end
      end
    end
  end

  d.bitmap = function (map, pos, layer)
    pos = pos or {0,0}
    for cy, line in ipairs(map) do
      for cx, val in ipairs(line) do
        if val>0 then d.on(cx-1+pos[1], cy-1+pos[2], layer) end
      end
    end
  end

  d.line = function (from, to, layer)
    if from[1]==to[1] then
      for y=from[2], to[2] do d.on(from[1], y, layer) end
    elseif from[2]==to[2] then
      for x=from[1], to[1] do d.on(x, from[2], layer) end
    end
  end


  local xy = function(x, y)
    if y == nil and type(x) == 'table' then return x[1], x[2] end
    return x, y
  end


  d.set = function(x,y, val, layer)
    x,y=xy(x,y);
    layer = layer or 'default'
    if not d.layers[layer] then d.layers[layer] = {} end
    if not d.layers[layer][x] then d.layers[layer][x] = {} end
    d.layers[layer][x][y] = val
  end

  d.get  = function(x,y, layer)
    x,y = xy(x,y)
    local layers = layer and {d.layers[layer]} or d.layers
    for _, l in pairs(layers) do
      if l[x] and l[x][y] then return true end
    end
  end
  d.isOn = d.get

  d.on = function(x,y, layer) d.set(x, y, true, layer) end
  d.off = function(x,y, layer) d.set(x, y, false, layer) end
  d.toggle = function(x,y, layer) d.set(x,y, not d.get(x,y, layer), layer) end

  return d
end
