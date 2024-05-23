local data = {};
local AR = require("intro.arts");
local V = vim;
data.oldfiles = {};

data.introBuffer = 0;
data.whiteSpaces = 0;

data.cachedConfig = {};
data.cachedLines = {};

data.anchors = {};

data.height = V.api.nvim_win_get_height(0);
data.width = V.api.nvim_win_get_width(0);
data.availableHeight = data.height;

data.lastStatus = 0;

data.paths = {};

data.getNumber = function(config)
  return AR[config.style][config.line][config.number + 1];
end


data.toRelative = function(path)
  local p = path ~= nil and path or V.loop.cwd();

  return V.fn.fnamemodify(p, ":~");
end

data.pathModifiers = function (option)
  if option ~= nil then
    data.paths = option;
  end
end

data.pathForamtter = function (path)
  local formattedPath = V.fn.fnamemodify(path, ":~");

  for _, tuple in ipairs(data.paths) do
    formattedPath = string.gsub(formattedPath, tuple[1], tuple[2]);
  end

  return formattedPath;
end

data.recentFilesLog = function (isDir)
  if isDir == false or isDir == nil then
    return data.oldfiles;
  elseif isDir == true then
    local _t = {};

    for _, entry in ipairs(data.oldfiles) do
      if string.match(entry, V.loop.cwd()) ~= nil then
        table.insert(_t, entry);
      end
    end

    return _t;
  elseif type(isDir) == "string" then
    local _t = {};

    for _, entry in ipairs(data.oldfiles) do
      if string.match(V.fn.fnamemodify(entry, ":~"), isDir) ~= nil then
        table.insert(_t, entry);
      end
    end

    return _t;
  end
end

data.highlights = function(anchors)
  if anchors ~= nil and type(anchors.textStyle) == "table" then
    V.api.nvim_set_hl(0, "Intro_anchor_body", anchors.textStyle);
  else
    V.api.nvim_set_hl(0, "Intro_anchor_body", { bg = "#BAC2DE", fg = "#181825" });
  end

  if anchors ~= nil and type(anchors.cornerStyle) == "table" then
    V.api.nvim_set_hl(0, "Intro_anchor_corner", anchors.cornerStyle);
  else
    V.api.nvim_set_hl(0, "Intro_anchor_corner", { bg = "#BAC2DE", fg = "#181825" });
  end
end

data.movements = function(configMain)
  local config = configMain.anchors or {};

  data.highlights(config);
  data.height = V.api.nvim_win_get_height(0);
  data.width = V.api.nvim_win_get_width(0);

  if #data.anchors < 1 then
    return;
  end

  local keymap = config ~= nil and config.openFileUnderCursor or "<leader><leader>"

  V.api.nvim_buf_set_keymap(data.introBuffer, "n",
    keymap,
    "",
    {
      noremap = true, silent = true,
      callback = function ()
        local y = V.api.nvim_win_get_cursor(0)[1] - 1;
        data.height = V.api.nvim_win_get_height(0);

        for _, v in ipairs(data.anchors) do
          local pos = v[1];
          local lnk = v[2]["path"];

          if (y - data.whiteSpaces) == pos then
            V.api.nvim_buf_delete(0, { force = true });
            V.cmd("e" .. lnk);
            V.cmd("set laststatus=" .. data.lastStatus)
          end
        end
      end
    }
  )

  -- Autocmd for cursor
  V.api.nvim_create_autocmd({ "CursorMoved" }, {
    pattern = { "<buffer>" },
    callback = function ()
      local cr = type(config.corner) == "string" and config.corner or "▒";

      local y = V.api.nvim_win_get_cursor(0)[1] - 1;
      data.height = V.api.nvim_win_get_height(0);
      data.width = V.api.nvim_win_get_width(0);

      for _, v in ipairs(data.anchors) do
        local position = v[1];
        local link = data.pathForamtter(v[2]["path"]);

        local anchorPos = v[2]["position"] ~= nil and v[2]["position"] or config.position;
        local corner = type(v[2]["corner"]) == "string" and v[2]["corner"] or cr;
        local bodyHl = type(v[2]["textStyle"]) == "string" and v[2]["textStyle"] or "Intro_anchor_body";
        local cornerHl = type(v[2]["cornerStyle"]) == "string" and v[2]["cornerStyle"] or "Intro_anchor_corner";

        if (y - data.whiteSpaces) == position then
          if anchorPos == nil or anchorPos == "bottom" then
            V.api.nvim_buf_set_extmark(data.introBuffer, 1, data.availableHeight - 1, 0, {
              id = 10,
              strict = false,
              virt_text = {
                { " " .. link .. " ", bodyHl }
              },
              virt_text_pos = "overlay"
            });
            V.api.nvim_buf_set_extmark(data.introBuffer, 1, data.availableHeight - 1, 0, {
              id = 11,
              strict = false,
              virt_text = {
                { corner, cornerHl }
              },
              virt_text_win_col = V.fn.strchars(" " .. link .. " "),
              virt_text_pos = "overlay"
            })
          else
            V.api.nvim_buf_set_extmark(data.introBuffer, 1, 0, 0, {
              id = 10,
              strict = false,
              virt_text = {
                { " " .. link .. " ", bodyHl }
              },
              virt_text_pos = "overlay"
            });
            V.api.nvim_buf_set_extmark(data.introBuffer, 1, 0, 0, {
              id = 11,
              strict = false,
              virt_text = {
                { corner, cornerHl }
              },
              virt_text_win_col = V.fn.strchars(" " .. link .. " "),
              virt_text_pos = "overlay"
            })
          end

          return;
        else
          V.api.nvim_buf_del_extmark(data.introBuffer, 1, 10)
          V.api.nvim_buf_del_extmark(data.introBuffer, 1, 11)
        end
      end
    end
  })
end


return data;
