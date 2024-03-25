-- INFO highlight handler for `intro.nvim`
local H = {};
local V = vim;

H.setHL = function (hls)
  for hlN, hlV in pairs(hls) do
    if vim.fn.hlexists(hl) == 0 then
      V.api.nvim_set_hl(0, "Intro_" .. hlN, hlV);
    end
  end
end

H.checkHl = function(hl, line, clStart, clEnd)
  if V.fn.hlexists(hl) == 1 then
    V.api.nvim_buf_add_highlight(0, 0, hl, line, clStart, clEnd);
  else
    V.api.nvim_buf_add_highlight(0, 0, "Intro_" .. hl, line, clStart, clEnd);
  end
end

H.applyHighlight = function(line, lineIndex, whitespaces)
  local clr = line.color;
  local ovr = line.overwrite;

  local grd = line.gradientRepeat;

  local txt = line.text;
  local func = line.functions or {};

  local spaces = 0;
  local size, totalSize = {}, 0;

  if type(txt) == "string" then
    totalSize = #txt;
  elseif type(txt) == "table" then
    local pS = 0;

    for _, part in ipairs(txt) do
      if func[part] ~= nil then
        totalSize = totalSize + V.fn.strchars(func[part]());
        table.insert(size, { pS, pS + #func[part]() });

        pS = pS + #func[part]();
      else
        totalSize = totalSize + V.fn.strchars(part);
        table.insert(size, { pS, pS + #part });

        pS = pS + #part;
      end
    end
  end

  if line.align == "center" then
    spaces = math.floor((V.api.nvim_win_get_width(0) - totalSize) / 2);
  elseif line.align == "right" then
    spaces = (V.api.nvim_win_get_width(0) - totalSize);
  end

  if type(clr) == "string" then
    H.checkHl(clr, whitespaces + lineIndex, spaces, spaces + totalSize)
  elseif type(clr) == "table" then
    local c = 1;

    for s = 1, totalSize do
      H.checkHl(clr[c], whitespaces + lineIndex, spaces + s - 1, spaces + s);

      if (c + 1) <= #clr then
        c = c + 1;
      else
        if type(grd) == "boolean" then
          if grd == true then
            c = 1;
          else
            c = #clr;
          end
        elseif type(grd) == "table" then
          if grd.default == true then
            c = 1;
          else
            c = #clr;
          end
        end
      end
    end
  end

  if ovr == nil then
    return;
  end

  for oI,o in ipairs(ovr) do
    local coords = size[oI];

    if type(o) == "string" and o.from == nil then
      H.checkHl(o, whitespaces + lineIndex, spaces + coords[1], spaces + coords[2]);
    elseif type(o) == "table" and o.from == nil then
      local oc = 1;

      for s = coords[1], coords[2] do
        H.checkHl(o[oc], whitespaces + lineIndex, spaces + s, spaces + s + 1);

        if (oc + 1) <= #o then
          oc = oc + 1;
        else
          oc = 1;
          if type(grd) == "boolean" then
            if grd == true then
              oc = 1;
            else
              oc = #o;
            end
          elseif type(grd) == "table" then
            if grd.overwrite == true then
              oc = 1;
            else
              oc = #o;
            end
          end
        end
      end
    elseif type(o) == "table" and o.from ~= nil then
      local from, to, hl = o.from, o.to, o.highlight;

      if o.to == nil then
        to = from + 1;
      end

      -- BUG highlight priorities becoming incorrect
      for l = from, to do
        if type(hl) == "string" then
          H.checkHl(hl, whitespaces + lineIndex, spaces + l, spaces + l + 1)
        end
      end
    end
  end
end

return H;
