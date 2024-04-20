local data = {};
local V = vim;
data.oldfiles = {};

data.introBuffer = 0;
data.whiteSpaces = 0;

data.anchors = {};
data.anchorTexts = {};
data.anchorStatus = {};

data.paths = {
  { "~/.config/nvim/lua/plugins/", " plugins/" },
  { "~/.config/nvim/lua/", "󰢱 nvim/lua/" },
  { "~/.config/nvim/", " nvim/" },

  { "~/.config/gh/", "  gh/" },

  { "~/.config/lazygit/", "  lazygit/" },

  { "~/.config/tmux/", " tmux/" },

  { "~/.config/", " config/" },
  { "~/", " ~/" }
};

data.toRelative = function(path)
  local p = path ~= nil and path or V.loop.cwd();

  return V.fn.fnamemodify(p, ":~");
end

data.pathForamtter = function (path)
  local formattedPath = V.fn.fnamemodify(path, ":~");

  for _, tuple in ipairs(data.paths) do
    formattedPath = string.gsub(formattedPath, tuple[1], tuple[2]);
  end

  return formattedPath;
end

data.recents = function (isDir)
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
      if string.match(entry, isDir) ~= nil then
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

  if #data.anchors < 1 then
    return;
  end

  local keymap = config ~= nil and config.keymap or "<leader><leader>"

  V.api.nvim_buf_set_keymap(data.introBuffer, "n",
    keymap,
    ":lua print('Opening File')<CR>",
    {
      noremap = true, silent = true,
      callback = function ()
        local y = V.api.nvim_win_get_cursor(0)[1] - 1;
        data.height = V.api.nvim_win_get_height(0);

        for _, v in ipairs(data.anchors) do
          local pos = v[1];
          local lnk = v[2];

          if (y - data.whiteSpaces) == pos then
            V.cmd("e" .. lnk)
          end
        end
      end
    }
  )

  -- Autocmd for cursor
  V.api.nvim_create_autocmd({ "CursorMoved" }, {
    pattern = { "<buffer>" },
    callback = function ()
      local corner = type(config.corner) == "string" and config.corner or " ";
      local y = V.api.nvim_win_get_cursor(0)[1] - 1;
      data.height = V.api.nvim_win_get_height(0);

      for aI, v in ipairs(data.anchorTexts) do
        local position = v[1];
        local link = v[2];

        if (y - data.whiteSpaces) == position and data.anchorStatus[aI] ~= false then
          if config.position == nil or config.position == "bottom" then
            V.api.nvim_buf_set_extmark(data.introBuffer, 1, (configMain.hasStatusline == nil or configMain.hasStatusline) == true and data.height - 1 or data.height, 0, {
              id = 10,
              strict = false,
              virt_text = { { " " .. link, "Intro_anchor_body" } },
             virt_text_pos = "overlay"
            })

            V.api.nvim_buf_set_extmark(data.introBuffer, 1, data.height - 1, 0, {
              id = 11,
              strict = false,
              virt_text = {
                { corner, "Intro_anchor_corner" }
              },
              virt_text_win_col = V.fn.strchars(link) + 1,
              virt_text_pos = "overlay"
            })
          elseif config.position == "top" then
            V.api.nvim_buf_set_extmark(data.introBuffer, 1, 0, 0, {
              id = 10,
              strict = false,
              virt_text = { { ' ' .. link, "Intro_anchor_body" } },
             virt_text_pos = "overlay"
            })

            V.api.nvim_buf_set_extmark(data.introBuffer, 1, 0, 0, {
              id = 11,
              strict = false,
              virt_text = { { corner, "Intro_anchor_corner" } },
              virt_text_win_col = V.fn.strchars(link) + 1,
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
