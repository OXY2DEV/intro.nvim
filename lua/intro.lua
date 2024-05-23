local intro = {};
local renderer = require("intro.renderer");
local animations = require("intro.animation");
local data = require("intro.data");

local presets = require("intro.presets");

local V = vim;

intro.default = {
  preset = { name = "nvim", opts = { "animated" } }
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
  else
    tbl = setupTable;
  end

  if setupTable ~= nil and setupTable.merge == true then
    for setupKey, setupValue in pairs(setupTable) do
      if setupKey == "preset" or setupKey == "merge" then
        goto doNotMerge;
      end

      if tbl[setupKey] == nil or type(tbl[setupKey]) == "string" then
        tbl[setupKey] = setupValue;
      elseif vim.tbl_islist(tbl[setupKey]) == true then
        tbl[setupKey] = vim.list_extend( tbl[setupKey], setupValue);
      elseif type(tbl[setupKey]) == "table" then
        tbl[setupKey] = vim.tbl_deep_extend("force",tbl[setupKey], setupValue);
      end

      ::doNotMerge::
    end
  end

  if setupTable ~= nil and setupTable.showStatusline ~= nil then
    tbl.showStatusline = setupTable.showStatusline;
  end

  if tbl.shadaValidate == true then
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

  data.pathModifiers(tbl.pathModifiers)
  data.cachedConfig = tbl;
  renderer.handleConfig(tbl);
  data.movements(tbl);

  animations.animationWorker(tbl.animations)
end;

return intro;
