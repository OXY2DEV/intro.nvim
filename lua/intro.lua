--- *intro.nvim* intro.nvim ☄️

--- A niche `intro` or `start_screen` plugin for Neovim
--- # Features ~

--- *intro.setup* Setup

local intro = {};
local renderer = require("intro.renderer");
local utils;

local V = vim;

intro.default = {
  --preset = "nvimN"
}

intro.setup = function(table)
  if V.fn.argc() ~= 0 then
    return
  end

  local _o = V.tbl_extend("force", intro.default, table);
  renderer.handleConfig(_o)
end;

return intro;
