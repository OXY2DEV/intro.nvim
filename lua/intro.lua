local intro = {};
local renderer = require("intro.renderer");
local animations = require("intro.animation");
local data = require("intro.data");

local presets = require("intro.presets");
local helpers = require("intro.helpers");

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

V.api.nvim_create_user_command("Gradient", function(options)
    local c1 = options.fargs[1];
    local c2 = options.fargs[2];

    local r1 = tonumber(string.sub(c1, 2, 3), 16);
    local g1 = tonumber(string.sub(c1, 4, 5), 16);
    local b1 = tonumber(string.sub(c1, 6, 7), 16);

    local r2 = tonumber(string.sub(c2, 2, 3), 16);
    local g2 = tonumber(string.sub(c2, 4, 5), 16);
    local b2 = tonumber(string.sub(c2, 6, 7), 16);

    local steps = options.fargs[3] ~= nil and options.fargs[3] or 10;
    local isBg = options.fargs[4] ~= nil and options.fargs or false;

    local colors = helpers.gradientSteps(
      {  r = r1, g = g1, b = b1 },
      {  r = r2, g = g2, b = b2 },
      steps
    );

    local output = {};
    for _, v in ipairs(colors) do
      if isBg == false then
        table.insert(output, { fg = v })
      else
        table.insert(output, { bg = v })
      end
    end

    --V.fn.setreg("+", output)
    V.print(output);
  end,
  {}
);

return intro;
