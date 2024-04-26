-- INFO text processor for `intro.nvim`
local data = require("intro.data");
local arts = require("intro.arts");

local T = {};
local V = vim;

T.rawTextHandler = function(txt)
  return {
    {
      align = "center",
      text = txt,
    }
  }
end

T.bannerHandler = function(component)
  local _l = {};

  for l, line in ipairs(component.lines) do
    local align, color, secondaryColors, gradientRepeat, width, func;

    if type(component.width) == "number" then
      width = component.width;
    elseif type(component.width) == "table" then
      if component.width[l] ~= nil then
        width = component.width[l];
      else
        width = component.width[#component.width];
      end
    end

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
    end

    if component.secondaryColors ~= nil then
      if component.secondaryColors.from ~= nil then
        secondaryColors = component.secondaryColors;
      else
        secondaryColors = component.secondaryColors[l];
      end
    end

    if type(component.gradientRepeat) == "boolean" then
      gradientRepeat = component.gradientRepeat;
    elseif type(component.gradientRepeat) == "table" then
      if V.tbl_islist(component.gradientRepeat) == true then
        if component.gradientRepeat[l] ~= nil then
          gradientRepeat = component.gradientRepeat[l];
        else
          gradientRepeat = component.gradientRepeat[#component.gradientRepeat];
        end
      else
        gradientRepeat = component.gradientRepeat;
      end
    end

    if component.functions ~= nil then
      func = component.functions;
    end

    table.insert(_l, {
      align = align,
      text = line,
      width = width,
      functions = func,

      color = color,
      secondaryColors = secondaryColors,
      gradientRepeat = gradientRepeat
    })
  end

  return _l;
end

T.recentsHandler = function(component)
  local entryCount = component.entryCount or 5;
  local _r = {};

  local OFS = data.recents(component.dir);

  for r = 1, entryCount do
    local line = {
      anchor = nil,
      align = "center",
      width = 0.6,

      gradientRepeat = true,
      functions = {}
    };

    if type(component.gradientRepeat) == "boolean" then
      line.gradientRepeat = component.gradientRepeat;
    elseif type(component.gradientRepeat) == "table" then
      if V.tbl_islist(component.gradientRepeat) == true then
        if component.gradientRepeat[r] ~= nil then
          line.gradientRepeat = component.gradientRepeat[r];
        else
          line.gradientRepeat = component.gradientRepeat[#component.gradientRepeat];
        end
      else
        line.gradientRepeat = component.gradientRepeat;
      end
    end

    if component.width ~= nil then
      if component.width < 1 then
        line.width = math.floor(component.width * data.width);
      else
        line.width = component.width;
      end
    end

    local entry = OFS[r] or "Empty";
    local path, filename, extension = string.gsub(V.fs.dirname(entry), V.fn.expand("$HOME"), "~"), V.fs.basename(entry), V.filetype.match({ filename = entry });
    if entry ~= "Empty" then
      line.anchor = path .. "/" .. filename;
    end

    if component.useAnchors == false then
      line.useAnchors = false;
    else
      line.useAnchors = true;
    end

    local icon, hl = "", nil;

    if component.useIcons == true then
      local devIcons = require("nvim-web-devicons");
      icon, hl = devIcons.get_icon(filename, extension, { default = true });
    end

    local fHl = "";
    local nHl = "";

    local sHl = "";

    if component.colors == nil then
      goto noColors;
    end

    if type(component.colors.name) == "table" and component.colors.name[r] ~= nil then
      fHl = component.colors.name[r];
    elseif type(component.colors.name) == "table" and component.colors.name[r] == nil then
      fHl = component.colors.name[#component.colors.name];
    end

    if type(component.colors.number) == "table" and component.colors.number[r] ~= nil then
      nHl = component.colors.number[r];
    elseif type(component.colors.number) == "table" and component.colors.number[r] == nil then
      nHl = component.colors.number[#component.colors.number];
    end

    if type(component.colors.whiteSpace) == "table" and component.colors.whiteSpace[r] ~= nil then
      sHl = component.colors.whiteSpace[r];
    elseif type(component.colors.whitespaces) == "table" and component.colors.whitespaces[r] == nil then
      sHl = component.colors.whitespaces[#component.colors.whitespaces]
    end

    ::noColors::

    if component.style == nil or component.style == "list" then
      if component.useIcons == true then
        line.text = { icon, " ", filename, "SP", tostring(r) };
        line.secondaryColors = { hl, sHl, fHl, sHl, nHl };
      else
        line.text = { filename, "SP", tostring(r) };
        line.secondaryColors = { fHl, sHl, nHl };
      end

    elseif component.style == "centered" then
      if component.useIcons == true then
        line.text = { icon, " ", filename };
        line.secondaryColors = { hl, sHl, fHl };
      else
        line.text = { filename };
        line.secondaryColors = { fHl };
      end
    end

    if component.style == nil or component.style == "list" then
      local amount = 0;

      line.functions.SP = function()
        if component.useIcons == true then
          amount = line.width - V.fn.strchars(icon .. " " .. filename .. r);
        else
          amount = line.width - V.fn.strchars(filename .. r);
        end

        return string.rep(" ", amount);
      end
    elseif component.style == "centered" then
      line.width = nil;
    end

    table.insert(_r, line);
  end

  return _r;
end

T.timeHandler = function(component)
  local _t = {};
  local theme = component.theme ~= nil and component.theme or "clock";

  local apply = function(i)
    table.insert(_t, {
      align = "center",
      color = "Special",
      text = { "tm" },
      functions = {
        tm = function()
          return arts.returnTime(nil,true)[i];
        end
      }
    })
  end

    for i = 1, 3 do
      apply(i);
    end

  return _t;
end

T.keymapsHandler = function(component)
  local _t = {};

  if component.style == nil or component.style == "compact" then
    local itemLimit = component.itemLimit ~= nil and component.itemLimit or 3;

    local textStack = {};
    local hlStack = {};
    local funcStack = {};
    local itemAdded = 0;

    for itemIndex = 1, #component.keys do
      if itemAdded >= itemLimit then
        table.insert(_t, {
          align = "center",
          text = textStack, secondaryColors = hlStack, functions = funcStack
        });

        textStack = {};
        hlStack = {};
        funcStack = {}
        itemAdded = 0;
      end

      itemAdded = itemAdded + 1;
      local thisItem = component.keys[itemIndex];
      local modes = thisItem.modes or "n";
      local options = thisItem.keyOptions or { silent = true };
      local gaps = thisItem.gaps ~= nil and thisItem.gaps or component.gaps ~= nil and component.gaps or "   ";
      local gapsHl = thisItem.gapsHl ~= nil and thisItem.gapsHl or component.gapsHl ~= nil and component.gapsHl or ""

      V.api.nvim_buf_set_keymap(data.introBuffer, modes, thisItem.keyCombination, thisItem.keyAction, options);

      if type(thisItem.text) == "string" then
        table.insert(textStack, thisItem.text);

        if thisItem.color ~= nil then
          table.insert(hlStack, thisItem.color)
        else
          table.insert(hlStack, "");
        end
      elseif V.tbl_islist(thisItem.text) then
        V.list_extend(textStack, thisItem.text);

        if V.tbl_islist(thisItem.color) == true then
          V.list_extend(hlStack, thisItem.color)
        else
          -- This looks so weird
          for _ = 1, #thisItem.text do
            table.insert(hlStack, "");
          end
        end
      end

      if thisItem.functions ~= nil then
        if #funcStack < 1 then
          funcStack = thisItem.functions
        else
          V.tbl_extend("force", funcStack, thisItem.functions);
        end

      end

      if itemAdded ~= itemLimit and itemIndex ~= #component.keys then
        table.insert(textStack, gaps);
        table.insert(hlStack, gapsHl);
        V.print(hlStack)
      end
    end

    local gradientRepeat = false;

    if type(component.gradientRepeat) == "boolean" then
      gradientRepeat = component.gradientRepeat
    end

    table.insert(_t, {
      align = "center", gradientRepeat = gradientRepeat,
      text = textStack, secondaryColors = hlStack, functions = funcStack
    });
  elseif component.style == "list" then
    for _, keys in ipairs(component.keys) do
      local width = component.width;
      local options = keys.keyOptions ~= nil and keys.keyOptions or { silent = true }
      V.api.nvim_buf_set_keymap(data.introBuffer, "n", keys.keyCombination, keys.keyAction, options);

      local gradientRepeat = false;

      if type(component.gradientRepeat) == "boolean" then
        gradientRepeat = component.gradientRepeat
      end

      if type(keys.text) == "string" then
        table.insert(_t, { align = "center", width = width, text = keys.text, color = keys.color, gradientRepeat = gradientRepeat });
      elseif type(keys.text) == "table" then
        table.insert(_t, { align = "center", width = width, text = keys.text, secondaryColors = keys.color, gradientRepeat = gradientRepeat, functions = keys.functions })
      end
    end
  end

  return _t;
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
  elseif component.type == "time" then
    _c = T.timeHandler(component);
  elseif component.type == "keymaps" then
    _c = T.keymapsHandler(component);
  end

  ::finish::
  return _c;
end

T.textRenderer = function(line, lineIndex, whitespaces)
  local width = V.api.nvim_win_get_width(0);

  local txt = line.text;

  if type(line.width) == "number" and line.width < 1 then
    line.width = line.width * width;
  elseif line.width == "auto" then
    line.width = nil;
  end

  if type(txt) == "string" then
    local _s = "";
    local _s2 = "";

    if line.align == "center" then
      if line.width ~= nil then
        _s = string.rep(" ", line.width <= width and math.floor((width - line.width) / 2) or 0)
        _s2 = _s;
      else
        _s = string.rep(" ", V.fn.strchars(txt) <= width and math.floor((width - V.fn.strchars(txt)) / 2) or 0);
        _s2 = _s;
      end
    elseif line.align == "right" then
      if line.width ~= nil then
        _s = string.rep(" ", width - line.width);
      else
        _s = string.rep(" ", width - V.fn.strchars(txt));
      end
    end

    V.api.nvim_buf_set_lines(0, whitespaces + lineIndex, whitespaces + lineIndex + 1, false, { _s .. line.text .. _s2 })
  else
    local _s = "";

    for _, part in ipairs(line.text) do
      if line.functions == nil or line.functions[part] == nil then
        _s = _s .. part
      else
        _s = _s .. line.functions[part]();
      end
    end

    local sp;

    if line.align == "center" then
      sp = V.fn.strchars(_s) <= width and math.floor((width - V.fn.strchars(_s)) / 2) or 0;

      if line.width ~= nil then
        _s = line.width <= width and string.rep(" ", math.floor((width - line.width) / 2)) .. _s .. string.rep(" ", math.floor((width - line.width) / 2) or _s)
      else
        _s = string.rep(" ", sp) .. _s .. string.rep(" ", sp);
      end
    elseif line.align == "right" then
      sp = V.fn.strchars(_s) <= width and width - V.fn.strchars(_s) or 0;

      if line.width ~= nil and line.width <= width then
        _s = line.width <= width and string.rep(" ", width - line.width) .. _s .. string.rep(" ", width - line.width) or _s;
      else
        _s = string.rep(" ", sp) .. _s .. string.rep(" ", sp);
      end
    end

    V.api.nvim_buf_set_lines(0, whitespaces + lineIndex, whitespaces + lineIndex + 1, false, { _s });
  end
end

return T;
