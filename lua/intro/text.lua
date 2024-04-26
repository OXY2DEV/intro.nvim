-- INFO text processor for `intro.nvim`
local data = require("intro.data");
local arts = require("intro.arts");

local T = {};
local V = vim;

T.setDefs = function (component)
  if component.type == nil or component.type == "banner" then
    component = V.tbl_deep_extend("keep", component, {
      align = "center",
      width = "auto",

      lines = { "Placeholder" },
      functions = {},

      colors = {},
      secondaryColors = {},
      gradientRepeat = false
    })
  elseif component.type == "recents" then
    component = V.tbl_deep_extend("keep", component, {
      style = "list",

      entryCount = 5,
      width = 0.8,

      useIcons = false,
      useAnchors = true,
      dir = false,

      colors = {
        name = "",
        number = "",
        spaces = ""
      },
      anchorStyle = {
        textGroup = "Special",
        cornerGroup = nil,
        corner = "//"
      },

      gap = " ",
    })
  end

  return component;
end

T.listBehaviour = function (list, index)
  if list[index] ~= nil then
    return list[index];
  else
    return list[#list];
  end
end


T.rawTextHandler = function(txt)
  return {
    {
      align = "center",
      text = txt,
    }
  }
end

T.newBannerHandler = function (component)
  local _t = {};

  component = T.setDefs(component);

  for line = 1, #component.lines do
    local text = {
      align = "center",
      width = "auto",

      text = component.lines[line],
      functions = component.functions,

      color = {},
      secondaryColors = {},
      gradientRepeat = {}
    };

    -- Text alignment
    if V.tbl_islist(component.align) == true then
      text.align = T.listBehaviour(component.align, line);
    else
      text.align = component.align;
    end

    -- Line width
    if V.tbl_islist(component.width) == true then
      text.width = T.listBehaviour(component.width, line);
    else
      text.width = component.width;
    end

    -- Main color
    if V.tbl_islist(component.colors) == true then
      text.color = T.listBehaviour(component.colors, line);
    else
      text.color = component.color;
    end

    -- Changes color
    if V.tbl_islist(component.secondaryColors) == true and component.secondaryColors[line] ~= nil then
      text.secondaryColors = T.listBehaviour(component.secondaryColors, line);
    else
      text.secondaryColors = component.secondaryColors;
    end

    -- Gradient behaviour
    if V.tbl_islist(component.gradientRepeat) == true then
      text.gradientRepeat = T.listBehaviour(component.gradientRepeat, line);
    else
      text.gradientRepeat = component.gradientRepeat;
    end

    table.insert(_t, text);
  end

  return _t;
end

T.newRecentsHandler = function (component)
  local _t = {};
  local devIcons = nil;

  -- Set all the default values
  component = T.setDefs(component);

  -- Import dependency
  if component.useIcons == true then
    devIcons = require("nvim-web-devicons");
  end

  -- List of files to show
  local file_list = data.recents(component.dir);

  for entry = 1, component.entryCount do
    local thisFile = file_list[entry] or "Empty";
    local fileName = V.fn.fnamemodify(thisFile, ":t");
    local fileExtension = V.filetype.match({ filename = fileName });

    local text = {
      anchor = nil,
      anchorStyle = nil,

      gradientRepeat = nil,
      text = nil,
      --colors = component.colors,
      secondaryColors = {},
      functions = {},

      align = "center",
      --width = component.width,
    };

    -- Gradient repeat handler
    if type(component.gradientRepeat) == "boolean" or (type(component.gradientRepeat) == "table" and V.tbl_islist(component.gradientRepeat) == false) then
      text.gradientRepeat = component.gradientRepeat;
    elseif type(component.gradientRepeat) == "table" and V.tbl_islist(component.gradientRepeat) == true then
      text.gradientRepeat = T.listBehaviour(component.gradientRepeat, entry);
    end

    -- No file found
    if thisFile ~= "Empty" then
      text.anchor = thisFile;
      text.anchorStyle = component.anchorStyle;
    end

    -- File Icons
    local fileIcon = "";
    local fileIconColor = "";

    if component.useIcons == true then
      fileIcon, fileIconColor = devIcons.get_icon(fileName, fileExtension, { default = true });
    end

    -- Renders
    if component.style == "list" then
      local fileNameHl = T.listBehaviour(component.colors.name, entry) or "";
      local fileNumberHl = T.listBehaviour(component.colors.number, entry) or "";
      local fileSpcaesHl = T.listBehaviour(component.colors.spaces, entry) or "";

      text.text = { fileIcon, fileIcon ~= "" and " " or "", fileName, "fileSpaces", tostring(entry) };
      text.secondaryColors = {
        fileIconColor, fileSpcaesHl, fileNameHl, fileSpcaesHl, fileNumberHl
      };
      text.functions = {
        fileSpaces = function ()
          local totalSize = component.width < 1 and math.floor(data.width * component.width) or math.floor(component.width);

          local str =  string.rep(component.gap, fileIcon ~= "" and totalSize - V.fn.strchars(fileIcon .. fileName .. tostring(entry)) or  totalSize - V.fn.strchars(fileIcon .. fileName .. tostring(entry)) + 1);
          return str;
        end
      }
    end

    V.print(text.secondaryColors)
    table.insert(_t, text)
  end

  return _t;
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
    _c = T.newBannerHandler(component);
  elseif component.type == "recents" then
    _c = T.newRecentsHandler(component)
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
