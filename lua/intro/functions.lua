local F = {};
F.clone = function(tbl)
  return table.move(tbl, 1, #tbl, 1, {})
end

--- Simple array shifter
F.gradientShift = function(opts)
  --local t = {"1", "2", "3", "4", "5"}
  local arr = opts.color.default;
  local out = { arr };

  for i = 1, #opts.lines - 1 do
    local new = F.clone(arr);
  
    if opts.color.shift.direction == "left" then
      local tmp = table.remove(new, 1);
      table.insert(new, tmp);

      table.insert(out, new);
      arr = new;
    else
      local tmp = table.remove(new, #new);
      table.insert(new, 1, tmp);

      table.insert(out, new);
      arr = new;
    end
  end

  opts.color.default = out;
  return opts;
end

return F;
