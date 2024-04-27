-- INFO text processor for `intro.nvim`
local data = require("intro.data");
local arts = require("intro.arts");

local T = {};
local V = vim;

T.setDefaults = function (component)
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
  elseif component.type == "keymaps" then
    if component.style == "list" or component.style == nil then
      component = V.tbl_extend("keep", component, {
        style = "silent",
        spaceBetween = 1,
        width = "auto"
      })
    elseif component.style == "columns" then
      component = V.tbl_extend("keep", component, {
        columnSeparator = " ",
        separatorHl = "",

        maxColumns = 4,
        lineGaps = 0,
      })
    end
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

  component = T.setDefaults(component);

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
  component = T.setDefaults(component);

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

T.newKeymapsHandler = function (component)
  local _t = {};
  component = T.setDefaults(component);

  if component.style == "silent" then
    -- Silently add the keymaps
    for _, keyOpts in ipairs(component.keymaps) do
      V.api.nvim_buf_set_keymap(data.introBuffer, keyOpts.keyModes, keyOpts.keyCombination, keyOpts.keyAction, keyOpts.keyOptions)
    end
  elseif component.style == "columns" then
    local stacks = {
      texts = {},
      highlights = {},
    };
    local columnsInThisLine = 0;

    for keyIndex, keyOpts in ipairs(component.keymaps) do
      V.api.nvim_buf_set_keymap(data.introBuffer, keyOpts.keyModes, keyOpts.keyCombination, keyOpts.keyAction, keyOpts.keyOptions)

      if V.tbl_islist(keyOpts.text) == true then
        V.list_extend(stacks.texts, keyOpts.text);
        V.list_extend(stacks.highlights, keyOpts.color);
      else
        table.insert(stacks.texts, keyOpts.text);
        table.insert(stacks.highlights, keyOpts.color);
      end

      columnsInThisLine = columnsInThisLine + 1;

      if columnsInThisLine < component.maxColumns and keyIndex ~= #component.keymaps then
        table.insert(stacks.texts, component.columnSeparator);
        table.insert(stacks.highlights, component.separatorHl);
      else
        V.print(stacks.highlights)
        table.insert(_t, {
          align = "center",

          text = stacks.texts,
          secondaryColors = stacks.highlights,

          gradientRepeat = keyOpts.gradientRepeat ~= nil and keyOpts.gradientRepeat or component.gradientRepeat
        });

        stacks.texts = {};
        stacks.highlights = {};

        columnsInThisLine = 0;
      end
    end
  elseif component.style == "list" then
    for keyIndex, keyOpts in ipairs(component.keymaps) do
      V.api.nvim_buf_set_keymap(data.introBuffer, keyOpts.keyModes, keyOpts.keyCombination, keyOpts.keyAction, keyOpts.keyOptions)

      table.insert(_t, {
        align = "center",
        text = keyOpts.text,

        colors = type(keyOpts.text) == "string" and keyOpts.colors or nil,
        secondaryColors = V.tbl_islist(keyOpts.text) == true and keyOpts.colors or nil
      })

      if keyIndex < #component.keymaps and component.lineGaps ~= nil and component.lineGaps ~= 0 then
        for _ = 1, component.lineGaps do
          table.insert(_t, { text = "" });
        end
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
    _c = T.newKeymapsHandler(component);
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
