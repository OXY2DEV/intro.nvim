-- INFO text processor for `intro.nvim`
local T = {};
local V = vim;

T.rawTextHandler = function(txt)
  return {
    {
      align = "center",
      text = txt,
      color = "Special",
    }
  }
end

T.bannerHandler = function(component)
  local _l = {};

  for l, line in ipairs(component.lines) do
    local align, color, overwrite, gradientRepeat;

    if component.align == nil then
      align = "center";
    elseif type(component.align) == "string" then
      align = component.align;
    elseif type(component.align) == "table" and component.align[l] ~= nil then
      align = component.align[l]
    elseif type(component.align) == "table" and component.align[l] == nil then
      align = component.align[#component.align]
    end

    if type(component.colors) == "string" then
      color = component.colors;
    elseif type(component.colors) == "table" then
      if component.colors[l] ~= nil then
        color = component.colors[l];
      else
        color = component.colors[#component.colors]
      end
    else
      color = component.colors;
    end

    if component.overwrite ~= nil then
      if component.overwrite.from ~= nil then
        overwrite = component.overwrite;
      else
        overwrite = component.overwrite[l];
      end
    end

    if component.gradientRepeat == true then
      gradientRepeat = true;
    else
      gradientRepeat = false;
    end

    table.insert(_l, {
      align = align,
      text = line,

      color = color,
      overwrite = overwrite,
      gradientRepeat = gradientRepeat
    })
  end

  return _l;
end

T.recentsHandler = function(component)
  local length = component.length or 5;
  local _r, _p = {}, {};

  vim.cmd("rshada");
  local OFS = vim.v.oldfiles;

  for r = 1, length do
    local line = {
      anchor = r,
      align = "center",
      width = 0.6 * vim.api.nvim_win_get_width(0),

      gradientRepeat = true,
      functions = {}
    };

    if type(component.gradientRepeat) == "boolean" then
      if component.gradientRepeat == true then
        line.gradientRepeat = true;
      else
        line.gradientRepeat = false;
      end
    elseif type(component.gradientRepeat) == "table" then
      if component.gradientRepeat[l] ~= nil then
        line.gradientRepeat = component.gradientRepeat[l];
      else
        line.gradientRepeat = component.gradientRepeat[1];
      end
    end

    if component.width ~= nil then
      if component.width < 1 then
        line.width = math.floor(component.width * vim.api.nvim_win_get_width(0));
      else
        line.width = component.width;
      end
    end

    local entry = OFS[r];
    local path, filename, extension = string.gsub(vim.fs.dirname(entry), "/data/data/com.termux/files/home", "~"), vim.fs.basename(entry), vim.filetype.match({ filename = entry });
    table.insert(_p, { r, path });

    local devIcons = require("nvim-web-devicons");
    local icon, hl = devIcons.get_icon(filename, extension, { default = true });

    local fHl;
    local nHl;

    if type(component.colors.name) == "table" and component.colors.name[r] ~= nil then
      fHl = component.colors.name[r];
    else
      fHl = component.colors.name[1];
    end

    if type(component.colors.number) == "table" and component.colors.number[r] ~= nil then
      nHl = component.colors.number[r];
    else
      nHl = component.colors.number[1];
    end

    line.text = { icon, " ", filename, "SP", tostring(r)};
    line.overwrite = { hl, "Normal", fHl, "Normal", nHl }

    line.functions.SP = function()
      local amount = line.width - vim.fn.strchars(icon .. " " .. filename .. r);
      return string.rep(" ", amount);
    end

    table.insert(_r, line);
  end

  return _r, _p;
end

T.simplifyComponents = function(component)
  local _c;

  if type(component) == "string" then
    _c = T.rawTextHandler(component);
    goto finish;
  end

  if component.type == nil or component.type == "banner" then
    _c = T.bannerHandler(component);
  elseif component.type == "recents" then
    _c = T.recentsHandler(component)
  end

  ::finish::
  return _c;
end

T.textRenderer = function(line, lineIndex, whitespaces)
  local width = vim.api.nvim_win_get_width(0);

  local txt = line.text;

  if type(txt) == "string" then
    local _s = "";

    if line.align == "center" then
      _s = string.rep(" ", math.floor((width - vim.fn.strchars(txt)) / 2));
    elseif line.align == "right" then
      _s = string.rep(" ", width - vim.fn.strchars(txt))
    end

    V.api.nvim_buf_set_lines(0, whitespaces + lineIndex, whitespaces + lineIndex + 1, false, { _s .. line.text })
  else
    local _s = "";

    for _, part in ipairs(line.text) do
      if line.functions == nil or line.functions[part] == nil then
        _s = _s .. part
      else
        _s = _s .. line.functions[part]();
      end
    end

    if line.align == "center" then
      _s = string.rep(" ", math.floor((width - vim.fn.strchars(_s)) / 2)) .. _s;
    elseif line.align == "right" then
      _s = string.rep(" ", width - vim.fn.strchars(_s)) .. _s;
    end

    V.api.nvim_buf_set_lines(0, whitespaces + lineIndex, whitespaces + lineIndex + 1, false, { _s });
  end
end

return T;
