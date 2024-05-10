-- INFO highlight handler for `intro.nvim`
local H = {};
local V = vim;

local data = require("intro.data");

H.setHL = function (hls)
  for hlN, hlV in pairs(hls) do
    if V.fn.hlexists(hl) == 0 then
      V.api.nvim_set_hl(0, "Intro_" .. hlN, hlV);
    end
  end
end

H.checkHl = function(hl, line, clStart, clEnd)
  if hl == nil or hl == "" then
    return;
  end

  if V.fn.hlexists(hl) == 1 then
    V.api.nvim_buf_add_highlight(0, 0, hl, line, clStart, clEnd);
  else
    V.api.nvim_buf_add_highlight(0, 0, "Intro_" .. hl, line, clStart, clEnd);
  end
end

H.setDefaults = function (lineConfig)
  lineConfig = V.tbl_deep_extend("keep", lineConfig, {
    align = "left",

    text = {},
    functions = {},

    color = {},
    secondaryColors = {},
    gradientRepeat = false
  })

  return lineConfig;
end

H.gradientIndexHandler = function (gradientRepeat, colors, var)
  if (var + 1) <= #colors then
    return var + 1;
  elseif (var + 1) > #colors and gradientRepeat == true then
    return 1;
  else
    return #colors;
  end
end

H.newHlApplier = function (lineConfig, lineIndex)
  lineConfig = H.setDefaults(lineConfig);

  local totalByteLength = 0;
  local partPositions = {};
  local cachedText = "";
  local textWidth = lineConfig.width;

  local padding = 0;

  if lineConfig.width == "auto" or lineConfig.width == nil then
    textWidth = nil;
  elseif lineConfig.width < 1 then
    textWidth = lineConfig.width * data.width;
  else
    textWidth = lineConfig.width;
  end

  if type(lineConfig.text) == "string" then
    cachedText = lineConfig.text;
  elseif type(lineConfig.text) == "table" then
    local charsPassed = 0;

    for _, part in ipairs(lineConfig.text) do
      part = lineConfig.functions[part] ~= nil and lineConfig.functions[part]() or part;

      table.insert(partPositions, { start = charsPassed, finish = charsPassed + V.fn.strchars(part) });

      cachedText = cachedText .. part;
      charsPassed = charsPassed + V.fn.strchars(part);
    end
  end

  if textWidth == nil then
    textWidth = V.fn.strchars(cachedText);
    totalByteLength = #cachedText;
  else
    totalByteLength = #string.sub(cachedText, 0, width)
  end

  if lineConfig.align == "center" and textWidth < data.width then
    padding = math.floor((data.width - textWidth) / 2);
  elseif lineConfig.align == "right" and textWidth < data.width then
    padding = data.width - textWidth;
  end

  if lineConfig.color == nil then
    goto noMainColor;
  end

  if type(lineConfig.color) == "string" then
    H.checkHl(lineConfig.color, data.whiteSpaces + lineIndex, padding, padding + totalByteLength)
  elseif type(lineConfig.color) == "table" then
    local colorIndex = 1;

    for char = 0, textWidth do
      local start = V.fn.strcharpart(cachedText, 0, char);
      local finish = V.fn.strcharpart(cachedText, 0, char + 1);

      H.checkHl(lineConfig.color[colorIndex], data.whiteSpaces + lineIndex, padding + #start, padding + #finish)
      colorIndex = H.gradientIndexHandler(lineConfig.gradientRepeat, lineConfig.color, colorIndex);
    end
  end

  ::noMainColor::

  if lineConfig.secondaryColors == nil then
    goto noSecondColor;
  end

  for secondIndex = 1, #partPositions do
    local colors = lineConfig.secondaryColors[secondIndex];

    if type(colors) == "string" then
      local part = partPositions[secondIndex];

      local start = V.fn.strcharpart(cachedText, 0, part.start);
      local finish = V.fn.strcharpart(cachedText, 0, part.finish);

      H.checkHl(colors, data.whiteSpaces + lineIndex, padding + #start, padding + #finish)
    elseif type(colors) == "table" then
      local part = partPositions[secondIndex];
      local colorIndex = 1;

      for char = 0, part.finish - part.start do
        local start = V.fn.strcharpart(cachedText, 0, part.start + char);
        local finish = V.fn.strcharpart(cachedText, 0, part.start + char + 1);

        H.checkHl(colors[colorIndex], data.whiteSpaces + lineIndex, padding + #start, padding + #finish)
        colorIndex = H.gradientIndexHandler(lineConfig.gradientRepeat, colors, colorIndex);
      end
    end
  end

  ::noSecondColor::
end


return H;
