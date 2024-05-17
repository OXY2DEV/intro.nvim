-- INFO text processor for `intro.nvim`
local data = require("intro.data");
local hl = require("intro.highlights");

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
  elseif component.type == "recentFiles" then
    component = V.tbl_deep_extend("keep", component, {
      style = "list",

      entryCount = 5,
      width = 0.8,

      useIcons = false,
      useAnchors = true,
      dir = false,

      gap = " ",

      colors = {
        name = "",
        path = "",
        number = "",
        spaces = ""
      },
      anchorStyle = {
        textGroup = nil,
        cornerGroup = nil,
        corner = nil
      },

      keymapPrefix = "<leader>",
    })
  elseif component.type == "keymaps" then
    component = V.tbl_deep_extend("keep", component, {
      style = "list",

      columnSeparator = " ",
      separatorHl = "",
      maxColumns = 4,

      lineGaps = 0
    })

    if component.keymaps ~= nil then
      for index, keyTable in ipairs(component.keymaps) do
        component.keymaps[index] = V.tbl_extend("keep", keyTable, {
          text = "Keymap",
          colors = "Special",

          keyModes = "n",
          keyOptions = {
            silent = true
          }
        });
      end
    end
  elseif component.type == "clock" then
    component = V.tbl_deep_extend("keep", component, {
      colors = {
        spaces = "",
        colon = "",
        border = "",

        clock = "",

        hour = "",
        minute = "",
        second = "",
        dayNight = "",

        day = "",
        date = "",
        month = "",
        year = ""
      },
      style = {
        clockStyle = "basic",
        textStyle = "fill",

        clockParts = {
          "╭", "─", "╮",
          "│", " ", "│",
          "╰", "─", "╯"
        },
        colon = "•"
      }
    })
  end

  return component;
end

T.listBehaviour = function (list, index, exception)
  local exceptionString = exception or "skip";

  if list == nil then
    return;
  end

  if type(list) ~= "table" then
    return list;
  end

  if list[index] ~= nil then
    if list[index] == exceptionString then
      return;
    else
      return list[index];
    end
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
    text.align = T.listBehaviour(component.align, line)

    -- Line width
    text.width = T.listBehaviour(component.width, line);

    -- Main color
    text.color = T.listBehaviour(component.colors, line);

    -- Changes color
    text.secondaryColors = T.listBehaviour(component.secondaryColors, line, "skip");

    -- Gradient behaviour
    text.gradientRepeat = T.listBehaviour(component.gradientRepeat, line);

    table.insert(_t, text);
  end

  return _t;
end

T.newRecentsHandler = function (component)
  local _t = {};

  -- Set all the default values
  component = T.setDefaults(component);

  -- Import dependency
  local devIcons = component.useIcons == true and require("nvim-web-devicons") or nil;

  -- List of files to show
  local file_list = data.recentFilesLog(component.dir);

  for entry = 1, component.entryCount do
    local thisFile = file_list[entry] or "Empty";
    local fileName = V.fn.fnamemodify(thisFile, ":t");
    local fileExtension = V.filetype.match({ filename = fileName });
    local filePath = vim.fn.fnamemodify(thisFile, ":~:h") .. "/";
    local gap = T.listBehaviour(component.gap, entry)


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
    text.gradientRepeat = T.listBehaviour(component.gradientRepeat, entry);

    -- No file found
    if thisFile ~= "Empty" then
      vim.api.nvim_buf_set_keymap(data.introBuffer, "n", component.keymapPrefix .. entry, ":e" .. thisFile .. "<CR>", { silent = true })

      text.anchor = {
        path = "",

        corner = nil,
        cornerStyle = nil,
        textStyle = nil,
      };

      text.anchor.path = thisFile;
      vim.tbl_deep_extend("force", text.anchor, component.anchorStyle);
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

      text.text = { fileIcon, "gap", fileName, "fileSpaces", tostring(entry) };
      text.secondaryColors = {
        fileIconColor, nil, fileNameHl, fileSpcaesHl, fileNumberHl
      };
      text.functions = {
        fileSpaces = function ()
          local totalSize = component.width < 1 and math.floor(data.width * component.width) or math.floor(component.width);
          local spcSize = 0;
          local gapSize = vim.fn.strchars(gap);
          local addSpaces = 0;
          local reminder = 0;

          if totalSize <= data.width then
            if fileIcon ~= "" then
              spcSize = totalSize - V.fn.strchars(fileIcon .. fileName .. tostring(entry));
            else
              spcSize = totalSize - V.fn.strchars(fileIcon .. fileName .. tostring(entry)) + 1;
            end

            if spcSize % gapSize == 0 then
              addSpaces = spcSize / gapSize;
            else
              reminder = spcSize % gapSize
              addSpaces = math.floor(spcSize / gapSize);
            end
          end

          local str = "";

          if reminder == 0 then
            str =  string.rep(component.gap, addSpaces);
          else
            -- This needs more investigation
            str = string.rep(component.gap, addSpaces) .. vim.fn.strcharpart(gap, 0, reminder)
          end

          return str;
        end,

        gap = function ()
          return fileIcon ~= "" and " " or "";
        end
      };
    elseif component.style == "list_paths" then
      local fileNameHl = T.listBehaviour(component.colors.name, entry) or "";
      local filePathHl = T.listBehaviour(component.colors.path, entry) or "";
      local fileNumberHl = T.listBehaviour(component.colors.number, entry) or "";
      local fileSpcaesHl = T.listBehaviour(component.colors.spaces, entry) or "";

      text.text = { fileIcon, "gap", filePath, fileName, "fileSpaces", tostring(entry) };
      text.secondaryColors = {
        fileIconColor, fileSpcaesHl, filePathHl, fileNameHl, fileSpcaesHl, fileNumberHl
      };
      text.functions = {
        fileSpaces = function ()
          local totalSize = component.width < 1 and math.floor(data.width * component.width) or math.floor(component.width);

          local str =  string.rep(component.gap, fileIcon ~= "" and totalSize - V.fn.strchars(fileIcon .. filePath .. fileName .. tostring(entry)) or  totalSize - V.fn.strchars(fileIcon .. filePath .. fileName .. tostring(entry)) + 1);
          return str;
        end,

        gap = function ()
          return fileIcon ~= "" and " " or "";
        end
      };
    end

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
        V.list_extend(stacks.highlights, keyOpts.colors);
      else
        table.insert(stacks.texts, keyOpts.text);
        table.insert(stacks.highlights, keyOpts.colors);
      end

      columnsInThisLine = columnsInThisLine + 1;

      if columnsInThisLine < component.maxColumns and keyIndex ~= #component.keymaps then
        table.insert(stacks.texts, component.columnSeparator);
        table.insert(stacks.highlights, component.separatorHl);
      else
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

        color = type(keyOpts.text) == "string" and keyOpts.colors or nil,
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

T.newClockHandler = function (component)
  local _t = {};
  component = T.setDefaults(component);

  if component.style.clockStyle == "basic" then
    local lines = {
      { component.style.clockParts[1], "borderTop", component.style.clockParts[3] },
      { component.style.clockParts[4], "padding_ve", component.style.clockParts[6] },

      { component.style.clockParts[4], "padding_hr", "hr_1_1", component.style.clockParts[5], "hr_2_1", "colonGap", "mn_1_1", component.style.clockParts[5], "mn_2_1", "colonGap", "se_1_1", component.style.clockParts[5], "se_2_1", "colonGap", "mm_1", "padding_hr", component.style.clockParts[6] },
      { component.style.clockParts[4], "padding_hr", "hr_1_2", component.style.clockParts[5], "hr_2_2", "colon"   , "mn_1_2", component.style.clockParts[5], "mn_2_2", "colon"   , "se_1_2", component.style.clockParts[5], "se_2_2", "colonGap", "mm_2", "padding_hr", component.style.clockParts[6] },
      { component.style.clockParts[4], "padding_hr", "hr_1_3", component.style.clockParts[5], "hr_2_3", "colonGap", "mn_1_3", component.style.clockParts[5], "mn_2_3", "colonGap", "se_1_3", component.style.clockParts[5], "se_2_3", "colonGap", "mm_3", "padding_hr", component.style.clockParts[6] },

      { component.style.clockParts[4], "padding_ve", component.style.clockParts[6] },
      { component.style.clockParts[7], "borderBottom", component.style.clockParts[9] },
    };

    local colors = {
      { component.colors.border, component.colors.border, component.colors.border },
      { component.colors.border, component.colors.spaces, component.colors.border },

      { component.colors.border, component.colors.spaces, component.colors.hour, component.colors.spaces, component.colors.hour, component.colors.colon, component.colors.minute, component.colors.spaces, component.colors.minute, component.colors.colon,  component.colors.second, component.colors.spaces, component.colors.second, component.colors.spaces, component.colors.dayNight, component.colors.spaces, component.colors.border },
      { component.colors.border, component.colors.spaces, component.colors.hour, component.colors.spaces, component.colors.hour, component.colors.colon, component.colors.minute, component.colors.spaces, component.colors.minute, component.colors.colon,  component.colors.second, component.colors.spaces, component.colors.second, component.colors.spaces, component.colors.dayNight, component.colors.spaces, component.colors.border },
      { component.colors.border, component.colors.spaces, component.colors.hour, component.colors.spaces, component.colors.hour, component.colors.colon, component.colors.minute, component.colors.spaces, component.colors.minute, component.colors.colon,  component.colors.second, component.colors.spaces, component.colors.second, component.colors.spaces, component.colors.dayNight, component.colors.spaces, component.colors.border },

      { component.colors.border, component.colors.spaces, component.colors.border },
      { component.colors.border, component.colors.border, component.colors.border },
    };

    local funcs = {
      hr_1_1 = function()
        local hour = tostring(os.date("%I"));

        return data.getNumber({ line = 1, number = tonumber(string.sub(hour, 1, 1)), style = component.style.textStyle })
      end,
      hr_1_2 = function()
        local hour = tostring(os.date("%I"));

        return data.getNumber({ line = 2, number = tonumber(string.sub(hour, 1, 1)), style = component.style.textStyle })
      end,
      hr_1_3 = function()
        local hour = tostring(os.date("%I"));

        return data.getNumber({ line = 3, number = tonumber(string.sub(hour, 1, 1)), style = component.style.textStyle })
      end,

      hr_2_1 = function()
        local hour = tostring(os.date("%I"));

        return data.getNumber({ line = 1, number = tonumber(string.sub(hour, 2, 2)), style = component.style.textStyle })
      end,
      hr_2_2 = function()
        local hour = tostring(os.date("%I"));

        return data.getNumber({ line = 2, number = tonumber(string.sub(hour, 2, 2)), style = component.style.textStyle })
      end,
      hr_2_3 = function()
        local hour = tostring(os.date("%I"));

        return data.getNumber({ line = 3, number = tonumber(string.sub(hour, 2, 2)), style = component.style.textStyle })
      end,


      mn_1_1 = function()
        local minute = tostring(os.date("%M"));

        return data.getNumber({ line = 1, number = tonumber(string.sub(minute, 1, 1)), style = component.style.textStyle })
      end,
      mn_1_2 = function()
        local minute = tostring(os.date("%M"));

        return data.getNumber({ line = 2, number = tonumber(string.sub(minute, 1, 1)), style = component.style.textStyle })
      end,
      mn_1_3 = function()
        local minute = tostring(os.date("%M"));

        return data.getNumber({ line = 3, number = tonumber(string.sub(minute, 1, 1)), style = component.style.textStyle })
      end,

      mn_2_1 = function()
        local minute = tostring(os.date("%M"));

        return data.getNumber({ line = 1, number = tonumber(string.sub(minute, 2, 2)), style = component.style.textStyle })
      end,
      mn_2_2 = function()
        local minute = tostring(os.date("%M"));

        return data.getNumber({ line = 2, number = tonumber(string.sub(minute, 2, 2)), style = component.style.textStyle })
      end,
      mn_2_3 = function()
        local minute = tostring(os.date("%M"));

        return data.getNumber({ line = 3, number = tonumber(string.sub(minute, 2, 2)), style = component.style.textStyle })
      end,


      se_1_1 = function()
        local second = tostring(os.date("%S"));

        return data.getNumber({ line = 1, number = tonumber(string.sub(second, 1, 1)), style = component.style.textStyle })
      end,
      se_1_2 = function()
        local second = tostring(os.date("%S"));

        return data.getNumber({ line = 2, number = tonumber(string.sub(second, 1, 1)), style = component.style.textStyle })
      end,
      se_1_3 = function()
        local second = tostring(os.date("%S"));

        return data.getNumber({ line = 3, number = tonumber(string.sub(second, 1, 1)), style = component.style.textStyle })
      end,

      se_2_1 = function()
        local second = tostring(os.date("%S"));

        return data.getNumber({ line = 1, number = tonumber(string.sub(second, 2, 2)), style = component.style.textStyle })
      end,
      se_2_2 = function()
        local second = tostring(os.date("%S"));

        return data.getNumber({ line = 2, number = tonumber(string.sub(second, 2, 2)), style = component.style.textStyle })
      end,
      se_2_3 = function()
        local second = tostring(os.date("%S"));

        return data.getNumber({ line = 3, number = tonumber(string.sub(second, 2, 2)), style = component.style.textStyle })
      end,


      mm_1 = function()
        local dayOrNight = os.date("%p") == "AM" and 0 or 1;

        return data.getNumber({ line = 4, number = dayOrNight, style = component.style.textStyle })
      end,
      mm_2 = function()
        local dayOrNight = os.date("%p") == "AM" and 0 or 1;

        return data.getNumber({ line = 5, number = dayOrNight, style = component.style.textStyle })
      end,
      mm_3 = function()
        local dayOrNight = os.date("%p") == "AM" and 0 or 1;

        return data.getNumber({ line = 6, number = dayOrNight, style = component.style.textStyle })
      end,


      colonGap = function ()
        if component.style.colon == nil then
          return "";
        else
          return string.rep(component.style.clockParts[5], V.fn.strchars(component.style.colon))
        end
      end,
      colon = function ()
        if component.style.colon == nil then
          return "";
        else
          return component.style.colon;
        end
      end,

      padding_hr = function ()
        return string.rep(component.style.clockParts[5], 3)
      end,
      padding_ve = function ()
        return string.rep(component.style.clockParts[5], (8 * 3) + 4 + (V.fn.strchars(component.style.colon) * 3) + 6)
      end,

      borderTop = function ()
        return string.rep(component.style.clockParts[2], (8 * 3) + 4 + (V.fn.strchars(component.style.colon) * 3) + 6)
      end,
      borderBottom = function ()
        return string.rep(component.style.clockParts[8], (8 * 3) + 4 + (V.fn.strchars(component.style.colon) * 3) + 6)
      end
    }

    for index, line in ipairs(lines) do
      table.insert(_t, {
        align = "center",
        --width = 27,
        text = line,
        functions = funcs,

        secondaryColors = colors[index]
      })
    end
  elseif component.style.clockStyle == "compact" then
    local lines = {
      { component.style.clockParts[1], "borderTop", component.style.clockParts[3], "padding_right" },
      { component.style.clockParts[4], "padding_fill", component.style.clockParts[6], "padding_right" },

      { component.style.clockParts[4], "widget_padding", "hr_1_1", component.style.clockParts[5], "hr_2_1", "widget_padding", component.style.clockParts[6], component.style.clockParts[5], "mm_1", "padding_mm" },
      { component.style.clockParts[4], "widget_padding", "hr_1_2", component.style.clockParts[5], "hr_2_2", "widget_padding", component.style.clockParts[6], component.style.clockParts[5], "mm_2", "padding_mm" },
      { component.style.clockParts[4], "widget_padding", "hr_1_3", component.style.clockParts[5], "hr_2_3", "widget_padding", component.style.clockParts[6], component.style.clockParts[5], "mm_3", "padding_mm" },

      { component.style.clockParts[4], "padding_fill", component.style.clockParts[6], "padding_right" },

      { component.style.clockParts[4], "widget_padding", "mn_1_1", component.style.clockParts[5], "mn_2_1", "widget_padding", component.style.clockParts[6], component.style.clockParts[4], "day", "padding_day" },
      { component.style.clockParts[4], "widget_padding", "mn_1_2", component.style.clockParts[5], "mn_2_2", "widget_padding", component.style.clockParts[6], component.style.clockParts[4], "date", component.style.clockParts[5], "month", "padding_date" },
      { component.style.clockParts[4], "widget_padding", "mn_1_3", component.style.clockParts[5], "mn_2_3", "widget_padding", component.style.clockParts[6], component.style.clockParts[4], "year", "padding_year" },

      { component.style.clockParts[4], "padding_fill", component.style.clockParts[6], "padding_right" },
      { component.style.clockParts[7], "borderBottom", component.style.clockParts[9], "padding_right" }
    };

    local colors = {
      { component.colors.border, component.colors.border, component.colors.border, component.colors.spaces },
      { component.colors.border, component.colors.spaces, component.colors.border, component.colors.spaces },

      { component.colors.border, component.colors.spaces, component.colors.hour, component.colors.spaces, component.colors.hour, component.colors.spaces, component.colors.border, component.colors.spaces, component.colors.dayNight, component.colors.spaces },
      { component.colors.border, component.colors.spaces, component.colors.hour, component.colors.spaces, component.colors.hour, component.colors.spaces, component.colors.border, component.colors.spaces, component.colors.dayNight, component.colors.spaces },
      { component.colors.border, component.colors.spaces, component.colors.hour, component.colors.spaces, component.colors.hour, component.colors.spaces, component.colors.border, component.colors.spaces, component.colors.dayNight, component.colors.spaces },

      { component.colors.border, component.colors.spaces, component.colors.border, component.colors.spaces },

      { component.colors.border, component.colors.spaces, component.colors.minute, component.colors.spaces, component.colors.minute, component.colors.spaces, component.colors.border, component.colors.border, component.colors.day, component.colors.spaces },
      { component.colors.border, component.colors.spaces, component.colors.minute, component.colors.spaces, component.colors.minute, component.colors.spaces, component.colors.border, component.colors.border, component.colors.date, component.colors.spaces, component.colors.month, component.colors.spaces },
      { component.colors.border, component.colors.spaces, component.colors.minute, component.colors.spaces, component.colors.minute, component.colors.spaces, component.colors.border, component.colors.border, component.colors.year, component.colors.spaces },

      { component.colors.border, component.colors.spaces, component.colors.border, component.colors.spaces },
      { component.colors.border, component.colors.border, component.colors.border, component.colors.spaces }
    }

    local funcs = {
      borderTop = function ()
        return string.rep(component.style.clockParts[2], 6 + (V.fn.strchars(component.style.clockParts[5]) * 7))
      end,
      borderBottom = function ()
        return string.rep(component.style.clockParts[8], 6 + (V.fn.strchars(component.style.clockParts[5]) * 7))
      end,

      widget_padding = function ()
        return string.rep(component.style.clockParts[5], 3);
      end,

      padding_fill = function ()
        return string.rep(component.style.clockParts[5], 6 + (V.fn.strchars(component.style.clockParts[5]) * 7));
      end,

      padding_right = function ()
        return string.rep(component.style.clockParts[5], 15);
      end,

      padding_mm = function ()
        return string.rep(component.style.clockParts[5], 8 - V.fn.strchars(component.style.clockParts[5]));
      end,

      padding_day = function ()
        return string.rep(component.style.clockParts[5], 15 - V.fn.strchars(component.style.clockParts[4] .. os.date("%A")));
      end,

      padding_date = function ()
        return string.rep(component.style.clockParts[5], 15 - V.fn.strchars(component.style.clockParts[4] .. os.date("%d") .. component.style.clockParts[5] .. os.date("%B")));
      end,

      padding_year = function ()
        return string.rep(component.style.clockParts[5], 15 - V.fn.strchars(component.style.clockParts[4] .. os.date("%Y")));
      end,

      hr_1_1 = function()
        local hour = tostring(os.date("%I"));

        return data.getNumber({ line = 1, number = tonumber(string.sub(hour, 1, 1)), style = component.style.textStyle })
      end,
      hr_1_2 = function()
        local hour = tostring(os.date("%I"));

        return data.getNumber({ line = 2, number = tonumber(string.sub(hour, 1, 1)), style = component.style.textStyle })
      end,
      hr_1_3 = function()
        local hour = tostring(os.date("%I"));

        return data.getNumber({ line = 3, number = tonumber(string.sub(hour, 1, 1)), style = component.style.textStyle })
      end,

      hr_2_1 = function()
        local hour = tostring(os.date("%I"));

        return data.getNumber({ line = 1, number = tonumber(string.sub(hour, 2, 2)), style = component.style.textStyle })
      end,
      hr_2_2 = function()
        local hour = tostring(os.date("%I"));

        return data.getNumber({ line = 2, number = tonumber(string.sub(hour, 2, 2)), style = component.style.textStyle })
      end,
      hr_2_3 = function()
        local hour = tostring(os.date("%I"));

        return data.getNumber({ line = 3, number = tonumber(string.sub(hour, 2, 2)), style = component.style.textStyle })
      end,


      mn_1_1 = function()
        local minute = tostring(os.date("%M"));

        return data.getNumber({ line = 1, number = tonumber(string.sub(minute, 1, 1)), style = component.style.textStyle })
      end,
      mn_1_2 = function()
        local minute = tostring(os.date("%M"));

        return data.getNumber({ line = 2, number = tonumber(string.sub(minute, 1, 1)), style = component.style.textStyle })
      end,
      mn_1_3 = function()
        local minute = tostring(os.date("%M"));

        return data.getNumber({ line = 3, number = tonumber(string.sub(minute, 1, 1)), style = component.style.textStyle })
      end,

      mn_2_1 = function()
        local minute = tostring(os.date("%M"));

        return data.getNumber({ line = 1, number = tonumber(string.sub(minute, 2, 2)), style = component.style.textStyle })
      end,
      mn_2_2 = function()
        local minute = tostring(os.date("%M"));

        return data.getNumber({ line = 2, number = tonumber(string.sub(minute, 2, 2)), style = component.style.textStyle })
      end,
      mn_2_3 = function()
        local minute = tostring(os.date("%M"));

        return data.getNumber({ line = 3, number = tonumber(string.sub(minute, 2, 2)), style = component.style.textStyle })
      end,


      mm_1 = function()
        local dayOrNight = os.date("%p") == "AM" and 0 or 1;

        return data.getNumber({ line = 4, number = dayOrNight, style = component.style.textStyle })
      end,
      mm_2 = function()
        local dayOrNight = os.date("%p") == "AM" and 0 or 1;

        return data.getNumber({ line = 5, number = dayOrNight, style = component.style.textStyle })
      end,
      mm_3 = function()
        local dayOrNight = os.date("%p") == "AM" and 0 or 1;

        return data.getNumber({ line = 6, number = dayOrNight, style = component.style.textStyle })
      end,

      day = function ()
        return os.date("%A");
      end,

      date = function ()
        return os.date("%d");
      end,
      month = function ()
        return os.date("%B");
      end,

      year = function ()
        return os.date("%Y");
      end,
    };

    for index, line in ipairs(lines) do
      table.insert(_t, {
        align = "center",
        width = 30,
        text = line,
        functions = funcs,

        secondaryColors = colors[index]
      })
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
  elseif component.type == "recentFiles" then
    _c = T.newRecentsHandler(component)
  elseif component.type == "time" then
    _c = T.timeHandler(component);
  elseif component.type == "keymaps" then
    _c = T.newKeymapsHandler(component);
  elseif component.type == "clock" then
    _c = T.newClockHandler(component);
  end

  ::finish::
  return _c;
end

T.textRenderer = function(line, lineIndex)
  local width;
  local whitespaces = data.whiteSpaces;

  local txt = line.text;

  if type(line.width) == "number" and line.width < 1 then
    width = line.width * data.width;
  elseif type(line.width) == "number" and line.width >= 1 then
    width = line.width;
  elseif line.width == "auto" then
    width = nil;
  end

  if type(txt) == "string" then
    local _s = "";
    local _s2 = "";

    if line.align == "center" then
      if width ~= nil then
        _s = string.rep(" ", width <= data.width and math.floor((data.width - width) / 2) or 0)
        _s2 = string.rep(" ", width <= data.width and math.ceil((data.width - width) / 2) or 0);
      else
        _s = string.rep(" ", V.fn.strchars(txt) <= data.width and math.floor((data.width - V.fn.strchars(txt)) / 2) or 0);
        _s2 = string.rep(" ", V.fn.strchars(txt) <= data.width and math.ceil((data.width - V.fn.strchars(txt)) / 2) or 0);
      end
    elseif line.align == "right" then
      if width ~= nil then
        _s = string.rep(" ", data.width - width);
      else
        _s = string.rep(" ", data.width - V.fn.strchars(txt));
      end
    end

    V.api.nvim_buf_set_lines(0, whitespaces + lineIndex, whitespaces + lineIndex, false, { _s .. line.text .. _s2 })
  else
    local _s = "";

    for _, part in ipairs(line.text) do
      if line.functions == nil or line.functions[part] == nil then
        _s = _s .. part
      else
        _s = _s .. line.functions[part]();
      end
    end

    local sp, spEnd;

    if line.align == "center" then
      if width ~= nil then
        sp = width <= data.width and math.floor((data.width - width) / 2) or 0;
        spEnd = width <= data.width and math.ceil((data.width - width) / 2) or 0;

        _s = string.rep(" ", sp) .. _s .. string.rep(" ", spEnd);
      else
        sp = V.fn.strchars(_s) <= data.width and math.floor((data.width - V.fn.strchars(_s)) / 2) or 0;
        spEnd = V.fn.strchars(_s) <= data.width and math.ceil((data.width - V.fn.strchars(_s)) / 2) or 0;

        _s = string.rep(" ", sp) .. _s .. string.rep(" ", spEnd);
      end
    elseif line.align == "right" then
      sp = V.fn.strchars(_s) <= data.width and data.width - V.fn.strchars(_s) or 0;

      if width ~= nil and width <= data.width then
        _s = width <= data.width and string.rep(" ", data.width - width) .. _s or _s;
      else
        _s = string.rep(" ", sp) .. _s;
      end
    end

    V.api.nvim_buf_set_lines(0, whitespaces + lineIndex, whitespaces + lineIndex, false, { _s });
  end
end

T.lineUpdater = function (animationElement)
  local textWidth, textParts = 0, {};
  local padLeft, padRight, padSize = "", "", 0;

  -- set some default options
  animationElement = vim.tbl_deep_extend("keep", animationElement, {
    y = 0,

    align = "center",

    values = {},
    functions = {},

    gradientRepeat = false,

    position = "fixed",
    updateCache = false
  });

  local textNow = animationElement.values[animationElement.__thisFrameIndex];
  local addedText = "";
  local colNow = T.listBehaviour(animationElement.colors, animationElement.__thisFrameIndex);
  local secNow = T.listBehaviour(animationElement.secondaryColors, animationElement.__thisFrameIndex);

  if type(textNow) == "string" then
    textWidth = V.fn.strchars(textNow);
    addedText = textNow;
  elseif V.tbl_islist(textNow) == true then
    local charsPassed = 0;

    for _, part in ipairs(textNow) do
      if animationElement.functions[part] ~= nil then
        addedText = addedText .. animationElement.functions[part]();
        textWidth = textWidth + V.fn.strchars(animationElement.functions[part]());
        table.insert(textParts, { start = charsPassed, finish = charsPassed + V.fn.strchars(functions[part]()) });

        charsPassed = charsPassed + V.fn.strchars(animationElement.functions[part]());
      else
        addedText = addedText .. part;
        textWidth = textWidth + V.fn.strchars(part);
        table.insert(textParts, { start = charsPassed, finish = charsPassed + V.fn.strchars(part) });

        charsPassed = charsPassed + V.fn.strchars(part);
      end
    end
  end


  if animationElement.align == "center" then
    padLeft = string.rep(" ", textWidth <= data.width and math.floor((data.width - textWidth) / 2) or 0);
    padRight = string.rep(" ", textWidth <= data.width and math.ceil((data.width - textWidth) / 2) or 0);

    padSize = textWidth <= data.width and math.floor((data.width - textWidth) / 2) or 0;
  elseif animationElement.align == "right" then
    padLeft = string.rep(" ", textWidth <= data.width and data.width - textWidth or 0);

    padSize = textWidth <= data.width and data.width - textWidth or 0;
  end

  local linePosition = animationElement.y;

  if animationElement.position == "relative" then
    linePosition = data.whiteSpaces + animationElement.y;
  end

  -- BUG: setting lines using Lua doesn't work properly
  vim.fn.setbufline(data.introBuffer, linePosition + 1, padLeft .. addedText .. padRight)

  -- coloring the line
  if colNow == nil then
    goto noMainColor;
  end

  if type(colNow) == "string" then
    hl.checkHl(colNow, linePosition, padSize, padSize + #addedText)
  elseif type(colNow) == "table" then
    local colorIndex = 1;

    for char = 0, textWidth do
      local start = V.fn.strcharpart(addedText, 0, char);
      local finish = V.fn.strcharpart(addedText, 0, char + 1);

      hl.checkHl(colNow[colorIndex], linePosition, padSize + #start, padSize + #finish)
      colorIndex = hl.gradientIndexHandler(animationElement.gradientRepeat, colNow, colorIndex);
    end
  end

  ::noMainColor::

  if secNow == nil then
    goto noSecondColor;
  end

  for secondIndex = 1, #textParts do
    local colors = secNow[secondIndex];

    if type(colors) == "string" then
      local part = textParts[secondIndex];

      local start = V.fn.strcharpart(addedText, 0, part.start);
      local finish = V.fn.strcharpart(addedText, 0, part.finish);

      hl.checkHl(colors, linePosition, padSize + #start, padSize + #finish)
    elseif type(colors) == "table" then
      local part = textParts[secondIndex];
      local colorIndex = 1;

      -- Bug fix: gradients bleeding out of their parts
      for char = 0, (part.finish - part.start) - 1 do
        local start = V.fn.strcharpart(addedText, 0, part.start + char);
        local finish = V.fn.strcharpart(addedText, 0, part.start + char + 1);

        hl.checkHl(colors[colorIndex], linePosition, padSize + #start, padSize + #finish)
        colorIndex = hl.gradientIndexHandler(animationElement.gradientRepeat, colors, colorIndex);
      end
    end
  end

  ::noSecondColor::

  if animationElement.updateCache == true and animationElement.position == "relative" then
    data.cachedLines[animationElement.y + 1] = {
      align = animationElement.align,

      text = textNow,
      color = colNow,
      secondaryColors = secNow,

      gradientRepeat = animationElement.gradientRepeat
    }
  end
end

T.virtualTextRenderer = function (animationElement)
  animationElement = V.tbl_deep_extend("keep", animationElement, {
    x = 0, y = 0,

    colors = {},
  });

  local X;
  local Y;
  local textNow = T.listBehaviour(animationElement.values, animationElement.__thisFrameIndex);
  local colNow = T.listBehaviour(animationElement.colors, animationElement.__thisFrameIndex);

  if type(T.listBehaviour(animationElement.x, animationElement.__thisFrameIndex)) == "number" then
    X = T.listBehaviour(animationElement.x, animationElement.__thisFrameIndex);

    if X < 1 then
      X = math.floor(X * data.width);
    end
  end

  if type(T.listBehaviour(animationElement.y, animationElement.__thisFrameIndex)) == "number" then
    Y = T.listBehaviour(animationElement.y, animationElement.__thisFrameIndex);

    if Y < 1 then
      Y = math.floor(Y * data.height);
    end
  end

  if type(textNow) == "string" then
    textNow = {
      { textNow, colNow }
    };
  elseif V.tbl_islist(textNow) == true then
    local tmp = {};

    for index, line in ipairs(textNow) do
      table.insert(tmp, { line, T.listBehaviour(colNow, index) });
    end

    --vim.print(tmp)
    textNow = tmp;
  end

  V.api.nvim_buf_set_extmark(data.introBuffer, 1, Y, X, {
    id = 99,

    virt_text = textNow,
    virt_text_pos = "overlay"
  })
end


return T;
