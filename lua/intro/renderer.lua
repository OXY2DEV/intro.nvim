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

R.setBuffer = function()
  R.width = V.api.nvim_win_get_width(0);
  R.height = V.api.nvim_win_get_height(0);

  data.introBuffer = V.api.nvim_create_buf(false, true);

  V.cmd("buf " .. data.introBuffer);
  V.bo.filetype = "intro";

  -- Disabling various columns
  V.cmd("setlocal nonumber norelativenumber signcolumn=no foldcolumn=0 nospell");
end

R.handleConfig = function (config, isResizing)
  if isResizing == true then
    -- Set new Width and Height
    R.width = V.api.nvim_win_get_width(0);
    R.height = V.api.nvim_win_get_height(0);

    -- Clear the screen
    V.bo.modifiable = true;
    V.api.nvim_buf_set_lines(data.introBuffer, R.height, R.height * 2, false, { "" });

    for cl = 3, R.height do
      V.api.nvim_buf_set_lines(0, cl, cl + 1, false, { "" });
    end
    V.bo.modifiable = false;

    -- Re render the lines
    local whSpaces = (#R.preparedLines < R.height) and math.floor((R.height - #R.preparedLines) / 2) or 0;
    data.whiteSpaces = whSpaces;

    -- Modify the buffer
    V.bo.modifiable = true

    -- Add spaces before the components
    for w = 0, whSpaces do
      V.api.nvim_buf_set_lines(data.introBuffer, w, w + 1, false, { string.rep(" ", R.width) })
    end

    for l, line in ipairs(R.preparedLines) do
      if line.anchor ~= nil then
        table.insert(data.anchors, { l, line.anchor });

        -- Should I use anchors?
        if line.useAnchors ~= nil then
          table.insert(data.anchorStatus,  line.useAnchors)
        end
      end

      -- Add the line to the buffer and apply the highlights
      txt.textRenderer(line, l, whSpaces);
      hls.applier(line, l)
    end

    -- Where to start the spaces again
    local afterWhStart = whSpaces + #R.preparedLines;

    -- Add spaces after the components
    for w = 2, whSpaces do
      V.api.nvim_buf_set_lines(0, afterWhStart + w, afterWhStart + w + 1, false, { string.rep(" ", R.width) })
    end

    -- Don't let the user modify the buffer
    V.bo.modifiable = false;
  else
    -- Set the buffer and store it's information
    R.setBuffer();

    -- Set all the highlight groups defined by the user
    if config.globalHighlights ~= nil then
      hls.setHL(config.globalHighlights)
    end

    -- Turn all the component into lines
    for _, component in ipairs(config.components) do
      local _s = txt.simplifyComponents(component);
      V.list_extend(R.preparedLines, _s);
    end

    local whSpaces = (#R.preparedLines < R.height) and math.floor((R.height - #R.preparedLines) / 2) or 0;
    data.whiteSpaces = whSpaces;

    -- Modify the buffer
    V.bo.modifiable = true

    -- Add spaces before the components
    for w = 0, whSpaces do
      V.api.nvim_buf_set_lines(data.introBuffer, w, w + 1, false, { string.rep(" ", R.width) })
    end

    for l, line in ipairs(R.preparedLines) do
      if line.anchor ~= nil then
        table.insert(data.anchors, { l, line.anchor });

        -- Should I use anchors?
        if line.useAnchors ~= nil then
          table.insert(data.anchorStatus,  line.useAnchors)
        end
      end

      -- Add the line to the buffer and apply the highlights
      txt.textRenderer(line, l, whSpaces);
      hls.applier(line, l)
    end

    -- Where to start the spaces again
    local afterWhStart = whSpaces + #R.preparedLines;

    -- Add spaces after the components
    for w = 2, whSpaces do
      V.api.nvim_buf_set_lines(0, afterWhStart + w, afterWhStart + w + 1, false, { string.rep(" ", R.width) })
    end

    -- Don't let the user modify the buffer
    V.bo.modifiable = false;

    -- Set resize autocommand
    V.api.nvim_create_autocmd("VimResized", {
      pattern = { "<buffer>" },
      callback = function()
        R.handleConfig(tbl, true)
      end
    })
  end
end


return R;
