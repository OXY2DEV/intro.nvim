local HP = {};

HP.colorTable = function (color)
  local _out = {
    r = 0, g = 0, b = 0
  };

  local r, g, b;

  if string.match(color, "rgb") ~= nil then
    -- returns strings
    r, g, b = string.match(color, "rgb%((%d+), *(%d+), *(%d+)%)");

    -- return the lab colors
    _out.r = tonumber(r) / 255;
    _out.g = tonumber(g) / 255;
    _out.b = tonumber(b) / 255;
  elseif string.match(color, "#") ~= nil then
    color = string.sub(color, 2, #color);

    if vim.fn.strchars(color) == 3 then
      r = tonumber(string.sub(color, 1, 1), 16);
      g = tonumber(string.sub(color, 2, 2), 16);
      b = tonumber(string.sub(color, 3, 3), 16);
    else
      r = tonumber(string.sub(color, 1, 2), 16);
      g = tonumber(string.sub(color, 3, 4), 16);
      b = tonumber(string.sub(color, 5, 6), 16);
    end

    _out.r = r / 255;
    _out.g = g / 255;
    _out.b = b / 255;
  elseif tonumber(color, 16) ~= nil then
    if vim.fn.strchars(color) == 3 then
      r = tonumber(string.sub(color, 1, 1), 16);
      g = tonumber(string.sub(color, 2, 2), 16);
      b = tonumber(string.sub(color, 3, 3), 16);
    else
      r = tonumber(string.sub(color, 1, 2), 16);
      g = tonumber(string.sub(color, 3, 4), 16);
      b = tonumber(string.sub(color, 5, 6), 16);
    end

    _out.r = r / 255;
    _out.g = g / 255;
    _out.b = b / 255;
  end

  return _out;
end

HP.returnEaseValue = function (ease, x1, x2, y)
  local easeVal = 0;

  if ease == "linear" or ease == nil then
    easeVal = y;
  elseif ease == "ease-in-sine" then
    easeVal = 1 - math.cos((y * math.pi) / 2);
  elseif ease == "ease-out-sine" then
    easeVal = math.sin((y * math.pi) / 2);
  elseif ease == "ease-in-out-sine" then
    easeVal = -(math.cos(math.pi * y) - 1) / 2;
  elseif ease == "ease-in-quad" then
    easeVal = y ^ 2;
  elseif ease == "ease-out-quad" then
    easeVal = 1 - ((1 - y) ^ 2);
  elseif ease == "ease-in-out-quad" then
    easeVal = y < 0.5 and 2 * (y ^ 2) or 1 - (((-2 * y + 2) ^ 2) / 2);
  elseif ease == "ease-in-cubic" then
    easeVal = y ^ 3;
  elseif ease == "ease-out-cubic" then
    easeVal = 1 - ((1 - y) ^ 3);
  elseif ease == "ease-in-out-cubic" then
    easeVal = y < 0.5 and 2 * (y ^ 2) or 1 - ((- 2 * y + 2) ^ 2) / 2;
  elseif ease == "ease-in-quart" then
    easeVal = y ^ 4;
  elseif ease == "ease-out-quart" then
    easeVal = 1 - ((1 - y) ^ 4);
  elseif ease == "ease-in-out-quart" then
    easeVal = y < 0.5 and 8 * (y ^ 4) or 1 - ((-2 * y + 2) ^ 4) / 2;
  elseif ease == "ease-in-quint" then
    easeVal = y ^ 5;
  elseif ease == "ease-out-qint" then
    easeVal = 1 - ((1 - y) ^ 5);
  elseif ease == "ease-in-out-qint" then
    easeVal = y < 0.5 and 16 * (y ^ 5) or 1 - ((-2 * y + 2) ^ 5) / 2;
  elseif ease == "ease-in-circ" then
    easeVal = 1 - math.sqrt(1 - (y ^ 2));
  elseif ease == "ease-out-circ" then
    easeVal = math.sqrt(1 - ((y - 1) ^ 2));
  elseif ease == "ease-in-out-circ" then
    easeVal = y < 0.5 and (1 - math.sqrt(1 - ((2 * y) ^ 2))) / 2 or (math.sqrt(1 - ((-2 * y + 2) ^ 2)) + 1) / 2;
  end

  return x1 + ((x2 - x1) * easeVal);
end

HP.toHex = function (value)
  local tmp = string.format("%x", value);

  if vim.fn.strchars(tmp) == 1 then
    return "0" .. tmp;
  else
    return tmp;
  end
end

HP.colorSteps = function (from, to, steps, options)
  local fromColor = HP.colorTable(from);
  local toColor = HP.colorTable(to);

  local currentStep = 0;
  local stepProgress = steps ~= nil and math.abs(1 / (steps - 1)) or 0.1;

  if options == nil then
    options = {
      ease = "linear",
      outputAs = "groupMame_fg",

      outputMethod = "normal",
      namePrefix = "grad_"
    };
  else
    options = vim.tbl_extend("keep", options, {
      ease = "linear",
      outputAs = "animation_fg",

      outputMethod = "normal",

      namePrefix = "grad_"
    });
  end

  local values = {};
  local output = {};

  for _ = 1, steps do
    table.insert(values, {
      r = HP.returnEaseValue(options.ease, fromColor.r, toColor.r, currentStep),
      g = HP.returnEaseValue(options.ease, fromColor.g, toColor.b, currentStep),
      b = HP.returnEaseValue(options.ease, fromColor.b, toColor.b, currentStep)
    });

    currentStep = currentStep + stepProgress;
  end


  for index, v in ipairs(values) do
    local R = HP.toHex(v.r * 255);
    local G = HP.toHex(v.g * 255);
    local B = HP.toHex(v.b * 255);

    if options.outputAs == "animation_fg" then
      table.insert(output, { fg = "#" .. R .. G .. B });
    elseif options.outputAs == "animation_bg" then
      table.insert(output, { bg = "#" .. R .. G .. B });
    elseif options.outputAs == "color" then
      table.insert(output, "#" .. R .. G .. B);
    elseif options.outputAs == "highlightGroups_fg" then
      if index < 10 then
        output[options.namePrefix .. "0" .. index] = { fg = "#" .. R .. G .. B };
      else
        output[options.namePrefix .. index] = { fg = "#" .. R .. G .. B };
      end
    elseif options.outputAs == "highlightGroups_bg" then
      if index < 10 then
        output[options.namePrefix .. "0" .. index] = { bg = "#" .. R .. G .. B };
      else
        output[options.namePrefix .. index] = { bg = "#" .. R .. G .. B };
      end
    elseif options.outputAs == "highlightGroups" then
      if index < 10 then
        output[options.namePrefix .. "0" .. index] = {
          fg = "#" .. R .. G .. B,
          bg = "#" .. R .. G .. B
        };
      else
        output[options.namePrefix .. index] = {
          fg = "#" .. R .. G .. B,
          bg = "#" .. R .. G .. B
        };
      end
    end
  end

  if options.outputMethod == "normal" then
    return output;
  else
    vim.print(output);
  end
end

return HP;
