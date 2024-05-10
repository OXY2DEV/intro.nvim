-- INFO renderer for `intro.nvim`
local R = {};

local data = require("intro.data");
local txt = require("intro.text");
local hls = require("intro.highlights");
local V = vim;

R.lineCount = 0;
R.preparedLines = {};

R.rendering = false;

R.width = V.api.nvim_win_get_width(0);
R.height = V.api.nvim_win_get_height(0)

R.setBuffer = function(showStatusline)
  R.width = V.api.nvim_win_get_width(0);
  R.height = V.api.nvim_win_get_height(0);

  if showStatusline == true then
    R.availableHeight = R.height;
  else
    R.availableHeight = R.height + 1;
  end

  data.availableHeight = R.availableHeight;

  data.introBuffer = V.api.nvim_create_buf(false, true);

  V.cmd("buf " .. data.introBuffer);
  V.bo.filetype = "intro";

  -- Disabling various columns
  V.cmd("setlocal nonumber norelativenumber signcolumn=no foldcolumn=0 nospell");

  if showStatusline ~= true then
    data.lastStatus = vim.o.laststatus;
    V.cmd("set laststatus=0");
  end
end

R.handleConfig = function (config, isResizing)
  R.availableHeight = 0;

  if isResizing == true then
    -- Set new Width and Height
    R.width = V.api.nvim_win_get_width(0);
    R.height = V.api.nvim_win_get_height(0);

    data.width = R.width;
    data.height = R.height;

    R.availableHeight = R.height;

    data.availableHeight = R.availableHeight;

    -- Clear the screen
    V.bo.modifiable = true;
    V.api.nvim_buf_set_lines(data.introBuffer, R.height, R.height * 2, false, { "" });

    vim.api.nvim_win_set_cursor(0, { 1, 1 })
    V.api.nvim_buf_set_lines(0, 0, -1, false, {});

    -- Start adding things
    vim.bo.modifiable = true;

    local paddingTop = (#R.preparedLines <= R.availableHeight) and math.ceil((R.availableHeight - #R.preparedLines) / 2) or 0;
    local paddingBottom = (#R.preparedLines <= R.availableHeight) and math.floor((R.availableHeight - #R.preparedLines) / 2) or 0;

    data.whiteSpaces = paddingTop;

    for sp = 1, paddingTop do
      vim.api.nvim_buf_set_lines(data.introBuffer, sp - 1, sp - 1, false, { string.rep(" ", R.width) } )
    end

    for l, line in ipairs(R.preparedLines) do
      -- Buffer index is 0 based
      local indexOnBuffer = l - 1;

      if line.anchor ~= nil then
        table.insert(data.anchors, { indexOnBuffer, line.anchor });

        -- Should I use anchors?
        if line.useAnchors ~= nil then
          table.insert(data.anchorStatus,  line.useAnchors)
        end
      end

      -- Add the line to the buffer and apply the highlights
      txt.textRenderer(line, indexOnBuffer);
      hls.newHlApplier(line, indexOnBuffer)
    end


    for spE = 1, paddingBottom do
      local actualIndex = paddingTop + #R.preparedLines + spE;

      vim.api.nvim_buf_set_lines(data.introBuffer, actualIndex - 1, actualIndex -1, false, { string.rep(" ", R.width) } )
    end

    -- BUG: Incorrect number of empty lines are added when statusline is present
    -- cause: Unknown
    if config.showStatusline == true then
      vim.api.nvim_buf_set_lines(data.introBuffer, paddingTop + #R.preparedLines + paddingBottom, paddingTop + #R.preparedLines + paddingBottom, false, { string.rep(" ", R.width) } )
    end

    -- Don't let the user modify the buffer
    V.bo.modifiable = false;
    vim.api.nvim_win_set_cursor(0, { 1, 1 })
  else
    -- Set the buffer and store it's information
    R.setBuffer(config.showStatusline);

    -- Set all the highlight groups defined by the user
    if config.globalHighlights ~= nil then
      hls.setHL(config.globalHighlights)
    end

    -- Turn all the component into lines
    for _, component in ipairs(config.components) do
      local _s = txt.simplifyComponents(component);
      V.list_extend(R.preparedLines, _s);
    end

    -- Start adding things
    vim.bo.modifiable = true;

    local paddingTop = (#R.preparedLines <= R.availableHeight) and math.ceil((R.availableHeight - #R.preparedLines) / 2) or 0;
    local paddingBottom = (#R.preparedLines <= R.availableHeight) and math.floor((R.availableHeight - #R.preparedLines) / 2) or 0;

    data.whiteSpaces = paddingTop;

    for sp = 1, paddingTop do
      vim.api.nvim_buf_set_lines(data.introBuffer, sp - 1, sp - 1, false, { string.rep(" ", R.width) } )
    end

    for l, line in ipairs(R.preparedLines) do
      -- Buffer index is 0 based
      local indexOnBuffer = l - 1;

      if line.anchor ~= nil then
        table.insert(data.anchors, { indexOnBuffer, line.anchor });

        -- Should I use anchors?
        if line.useAnchors ~= nil then
          table.insert(data.anchorStatus,  line.useAnchors)
        end
      end

      -- Add the line to the buffer and apply the highlights
      txt.textRenderer(line, indexOnBuffer);
      hls.newHlApplier(line, indexOnBuffer)
    end


    for spE = 1, paddingBottom do
      local actualIndex = paddingTop + #R.preparedLines + spE;

      vim.api.nvim_buf_set_lines(data.introBuffer, actualIndex - 1, actualIndex -1, false, { string.rep(" ", R.width) } )
    end

    -- Don't let the user modify the buffer
    V.bo.modifiable = false;
    vim.api.nvim_win_set_cursor(0, { 1, 1 })


    -- Set resize autocommand
    V.api.nvim_create_autocmd("VimResized", {
      pattern = { "<buffer>" },
      callback = function()
        R.handleConfig(data.cachedConfig, true)
      end
    })

    V.api.nvim_buf_create_user_command(data.introBuffer, "Refresh",
      function()
        R.handleConfig(data.cachedConfig, true);
      end,
      {}
    );

    if config.showStatusline == true then
      return;
    end

    V.api.nvim_create_autocmd("BufLeave", {
      pattern = { "<buffer>" },
      callback = function()
        vim.cmd("set laststatus=" .. data.lastStatus)
      end
    })
  end
end


return R;
