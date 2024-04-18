local HP = {};

HP.toFg = function(colorList)
  local Fg = {};

  for _, v in ipairs(colorList) do
    table.insert(Fg, { fg = v })
  end

  return Fg;
end

HP.transition = function (groupName, color1, color2, animationSteps, animationOptions)
  local opts = {
    groupName = "nogroup",
    values = {}
  };

  local R1 = type(color1[1]) == "string" and tonumber(color1[1], 16) or color1[1];
  local G1 = type(color1[2]) == "string" and tonumber(color1[2], 16) or color1[2];
  local B1 = type(color1[3]) == "string" and tonumber(color1[3], 16) or color1[3];

  local R2 = type(color1[1]) == "string" and tonumber(color2[1], 16) or color2[1];
  local G2 = type(color2[2]) == "string" and tonumber(color2[2], 16) or color2[2];
  local B2 = type(color2[3]) == "string" and tonumber(color2[3], 16) or color2[3];

  if type(groupName) == "string" then
    opts.groupName = groupName;
  end

  if type(animationOptions) == "table" then
    vim.tbl_extend("force", opts, animationOptions);
  end

  local colors = HP.gradientSteps(
    { r = R1, g = G1, b = B1 },
    { r = R2, g = G2, b = B2 },
    animationSteps
  )

  for _, clr in ipairs(colors) do
    table.insert(opts.values, { fg = clr })
  end

  return opts;
end

HP.gradientSteps = function(from, to, steps)
  local gradient = {};

  table.insert(gradient, "#" .. string.format("%x", from.r) .. string.format("%x", from.g) .. string.format("%x", from.b))

  for g = 1, steps - 1 do
    local alpha = g / (steps - 1);

    local R = (from.r > to.r) and (from.r * ( 1 - alpha)) + (to.r * alpha) or (to.r * alpha) + (from.r * (1 - alpha));
    local G = (from.g > to.g) and (from.g * ( 1 - alpha)) + (to.g * alpha) or (to.g * alpha) + (from.g * (1 - alpha));
    local B = (from.b > to.b) and (from.b * ( 1 - alpha)) + (to.b * alpha) or (to.b * alpha) + (from.b * (1 - alpha));

    table.insert(gradient, "#" .. string.format("%x", R) .. string.format("%x", G) .. string.format("%x", B))
  end

  return gradient;
end

return HP;
