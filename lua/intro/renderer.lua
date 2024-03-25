-- INFO renderer for `intro.nvim`
local R = {};
local txt = require("intro.text");
local hls = require("intro.highlights");
local V = vim;

R.lineCount = 0;
R.preparedLines = {};

R.width = V.api.nvim_win_get_width(0);
R.height = V.api.nvim_win_get_height(0)

R.setBuffer = function()
  R.width = V.api.nvim_win_get_width(0);
  R.height = V.api.nvim_win_get_height(0);

  R.introBuffer = V.api.nvim_create_buf(false, true);

  V.cmd("buf " .. R.introBuffer);
  V.bo.filetype = "intro";

  -- Disabling various columns
  V.cmd("setlocal nonumber norelativenumber signcolumn=no foldcolumn=0 nospell");
end

R.handleConfig = function(tbl)
  if V.bo.filetype == "intro" then
    R.width = V.api.nvim_win_get_width(0);
    R.height = V.api.nvim_win_get_height(0);

    V.api.nvim_buf_set_lines(0, R.height, R.height * 2, false, { "" });

    for cl = 3, R.height do
      V.api.nvim_buf_set_lines(0, cl, cl + 1, false, { "" });
    end

    goto skipSetup;
  else
    R.setBuffer();
  end

  if tbl.globalHighlights ~= nil then
    hls.setHL(tbl.globalHighlights);
  end

  for _, component in ipairs(tbl.components) do
    local _c;
    _c = txt.simplifyComponents(component);
    V.list_extend(R.preparedLines, _c)
  end

  ::skipSetup::
  local whiteSpaces = math.floor((R.height - #R.preparedLines) / 2)

  for w = 1, whiteSpaces do
    V.api.nvim_buf_set_lines(0, w, w + 1, false, { "" })
  end

  for l, line in ipairs(R.preparedLines) do
    txt.textRenderer(line, l, whiteSpaces);
    hls.applyHighlight(line, l, whiteSpaces);
  end

  local afterWhiteStart = whiteSpaces + #R.preparedLines;

  for a = 1, whiteSpaces - 1 do
    V.api.nvim_buf_set_lines(0, afterWhiteStart + a, afterWhiteStart + a + 1, false, { "" })
  end

  V.api.nvim_create_autocmd("VimResized", {
    pattern = { "<buffer>" },
    callback = function()
      R.handleConfig(tbl)
    end
  })
end

return R;
