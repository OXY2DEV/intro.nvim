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
  if V.fn.hlexists(hl) == 1 then
    V.api.nvim_buf_add_highlight(0, 0, hl, line, clStart, clEnd);
  else
    V.api.nvim_buf_add_highlight(0, 0, "Intro_" .. hl, line, clStart, clEnd);
  end
end

H.applier = function (lineConfig, lineIndex)
  local width = V.api.nvim_win_get_width(0);

  local align = lineConfig.align;

  local color = lineConfig.color;
  local secondary = lineConfig.secondaryColors;

  local text = lineConfig.text;
  local functions = lineConfig.functions;

  local gradientRepeat = lineConfig.gradientRepeat;

  local partSizes = {};
  local characterLength = 0;
  local byteLength = 0;

  local cachedText = "";

  local whiteSpaces = data.whiteSpaces;
  local spaces = 0;

  -- Get the width of the text
  if type(text) == "string" then
    byteLength = #text;
    characterLength = V.fn.strchars(text);
     
    cachedText = text;
  elseif type(text) == "table" then
    local sizeStart = 0;

    for _, part in ipairs(text) do
      if functions ~= nil and functions[part] ~= nil then
        local str = functions[part]();

        byteLength = byteLength + #str;
        characterLength = characterLength + V.fn.strchars(str);

        table.insert(partSizes, { sizeStart, sizeStart + #str });
        cachedText = cachedText .. str;

        sizeStart = sizeStart + #str;
      else
        byteLength = byteLength + #part;
        characterLength = characterLength + V.fn.strchars(part);

        table.insert(partSizes, { sizeStart, sizeStart + #part });
        cachedText = cachedText .. part;

        sizeStart = sizeStart + #part;
      end
    end
  end

  -- Calculate the number of spaces before the text
  if align == "center" or align == nil then
    if characterLength < width then
      spaces = math.floor((width - characterLength) / 2);
    else
      spaces = 0;
    end
  elseif align == "right" then
    if characterLength < width then
      spaces = width - characterLength;
    else
      spaces = 0;
    end
  else
    spaces = 0;
  end

  -- Apply the main color
  if type(color) == "string" then
    H.checkHl(color, whiteSpaces + lineIndex, spaces, spaces + byteLength)
  elseif type(color) == "table" then
    local colorIndex = 1;

    for c = 0, characterLength do
      local characterStart = spaces + #string.sub(cachedText, 0, c);
      local characterEnd = spaces + #string.sub(cachedText, 0, c + 1);

      H.checkHl(color[colorIndex], whiteSpaces + lineIndex, characterStart, characterEnd);

      if (colorIndex + 1) > #color then
        if type(gradientRepeat) == "boolean" and gradientRepeat == true then
          colorIndex = 1;
        elseif type(gradientRepeat) == "table" and gradientRepeat.colors == true then
          colorIndex = 1;
        end
      else
        colorIndex = colorIndex + 1;
      end
    end
  end

  -- Up until here everything works
  if secondary == nil then
    return;
  end

  for index, seClr in ipairs(secondary) do
    if type(seClr) == "string" and seClr ~= "" then
      local Y1 = partSizes[index][1];
      local Y2 = partSizes[index][2];

      H.checkHl(seClr, whiteSpaces + lineIndex, spaces + Y1, spaces + Y2)
    elseif type(seClr) == "table" and V.tbl_islist(seClr) == true then
      local Y1 = partSizes[index][1];
      local Y2 = partSizes[index][2] - #string.sub(cachedText, -1);

      local colorIndex = 1;

      for y = Y1, Y2 do
        H.checkHl(seClr[colorIndex], whiteSpaces + lineIndex, spaces + y, spaces + y + 1);

        if (colorIndex + 1) > #seClr then
          if type(gradientRepeat) == "boolean" and gradientRepeat == true then
            colorIndex = 1;
          elseif type(gradientRepeat) == "table" and gradientRepeat.secondaryColors == true then
            colorIndex = 1;
          end
        else
          colorIndex = colorIndex + 1;
        end
      end
    elseif type(seClr) == "table" and V.tbl_islist(seClr) == false then
      if seClr.from == nil then
        seClr.from = 0;
      end

      if seClr.to == nil then
        seClr.to = 1;
      end

      if type(seClr.highlight) == "string" then
        local from = #string.sub(cachedText, 0, seClr.from);
        local to = #string.sub(cachedText, 0, seClr.to + 1);

        H.checkHl(seClr.highlight, whiteSpaces + lineIndex, spaces + from, spaces + to);
      elseif type(seClr.highlight) == "table" then
        local colorIndex = 1;

        for y = seClr.from, seClr.to - 1 do
          local from = #string.sub(cachedText, 0, y);
          local to = from + #string.sub(cachedText, y, y + 1);

          H.checkHl(seClr.highlight[colorIndex], whiteSpaces + lineIndex, spaces + from, spaces + to);

          if (colorIndex + 1) > #seClr.highlight then
            if type(gradientRepeat) == "boolean" and gradientRepeat == true then
              colorIndex = 1;
            elseif type(gradientRepeat) == "table" and gradientRepeat.secondaryColors == true then
              colorIndex = 1;
            end
          else
            colorIndex = colorIndex + 1;
          end
        end
      end
    end
  end
end

return H;
