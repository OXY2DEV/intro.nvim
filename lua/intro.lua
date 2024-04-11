--- *intro.nvim* intro.nvim ☄️

--- A niche `intro` or `start_screen` plugin for Neovim
--- # Features ~

--- *intro.setup* Setup

local intro = {};
local renderer = require("intro.renderer");
local animations = require("intro.animation");
local data = require("intro.data");

local presets = require("intro.presets");

local V = vim;

intro.default = {
  preset = "nvim_color_animated",
}

intro.setup = function(table)
  local tbl;

  if V.fn.argc() ~= 0 then
    return
  end

  if type(table) ~= "table" then
    tbl = intro.default;
  else
    tbl = table;
  end

  if type(tbl.preset) == "string" and presets[tbl.preset] ~= nil then
    tbl = presets[tbl.preset];
  end

  renderer.handleConfig(tbl);
  data.movements(tbl.anchors);

  animations.animationWorker(tbl.animations)
end;

return intro;
