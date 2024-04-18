local intro = {};
local renderer = require("intro.renderer");
local animations = require("intro.animation");
local data = require("intro.data");

local presets = require("intro.presets");
local helpers = require("intro.helpers");

local V = vim;

intro.default = {
  preset = { name = "nvim", opts = { "animated" } },
}

intro.setup = function(setupTable)
  local tbl;

  if V.fn.argc() ~= 0 then
    return
  end

  V.cmd("rshada");
  local oldfiles = V.v.oldfiles;

  if type(setupTable) ~= "table" then
    tbl = intro.default;
  else
    tbl = setupTable;
  end

  if type(tbl.preset) == "table" then
    tbl = presets.presetToConfig(tbl.preset);
  elseif type(tbl.preset) == "string" then
    tbl = presets.presetToConfig({ name = tbl.preset });
  end

  if tbl.shadaRefresh == true then
    for _, v in ipairs(oldfiles) do
      if V.fn.filereadable(v) == 1 then
        table.insert(data.oldfiles, v)
      end
    end
  else
    data.oldfiles = oldfiles;
  end

  if tbl.anchors == nil then
    tbl.anchors = {}
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
    local mode = options.fargs[4] ~= nil and options.fargs[4] or "string"

    local colors = helpers.gradientSteps(
      {  r = r1, g = g1, b = b1 },
      {  r = r2, g = g2, b = b2 },
      steps
    );

    local output, text = {}, "";
    for _, v in ipairs(colors) do
      if mode == "fg" then
        table.insert(output, { fg = v });
      elseif mode == "bg" then
        table.insert(output, { bg = v });
      elseif mode == "string" then
        text = text .. '{ fg = "' .. tostring(v) .. '" }, ';
      end
    end

    if #output == 0 then
      V.print(text);
    else
      V.print(output);
    end
  end,
  {}
);

return intro;
