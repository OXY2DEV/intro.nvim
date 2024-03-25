local U = {};

--local f = require("intro.filetypes")
local icons = require("nvim-web-devicons");
icons.setup();

-- Table containing all the lines  and their highlights
U.preparedLines = {};
U.anchors = {};
U.withinAnimation = false;

-- Helper
U.getHighlight = function(dat, v)
  if type(dat) == "string" then
    return dat;
  elseif type(dat) == "table" then
    if dat[v] ~= nil then
      return dat[v];
    else
      return dat[v % #dat == 0 and #dat or v % #dat];
    end
  else
    return "Normal";
  end
end

-- Helper function for banners
U.bannerFormatter = function(opts)
  local _o = {
    type = "banner",
    align = "center",

    lines = {
      "line 1"
    },
    highlights = {
      hl1 = { fg = "#2e2e2f" }
    },
    color = {
      default = "hl1",
      override = {}
    },
  };
  local _out = {};

  _o = vim.tbl_extend("force", _o, opts);

  for lIndex, line in ipairs(_o.lines) do
    local currentAlign = "center";
    local lineLength = vim.fn.strchars(line);

    local nT = "";
    local left = 0;

    -- Find the alignment of the text(default is "center")
    if type(_o.align) == "string" then
      currentAlign = _o.align;
    else
      currentAlign = _o.align[lIndex];
    end

    top = U.skip + lIndex + #U.preparedLines;

    -- Left offset
    if currentAlign == "left" then
      nT = line;
      left = 0;
    elseif currentAlign == "center" then
      nT = string.rep(" ", math.floor((U.width - lineLength) / 2)) .. line;
      left = math.floor((U.width - lineLength) / 2);
    else
      nT = string.rep(" ", U.width - lineLength) .. line;
      left = U.width - lineLength
    end



    -- Add line to the table
    table.insert(_out, {
      top = top,
      left = left,
      len = #line,

      index = lIndex,

      text = nT,
      color = {
        default = _o.color.default,
        override = _o.color["override"] ~= nil and _o.color.override[lIndex] or {}
      }
    })
  end

  return _out;
end

-- Helper function for recents
U.recentsFormatter = function(opts)
  local _o = {
    type = "recents",
    length = 1,

    width = 0.75,
    border = { "|", "" },

    color = {
      name = "Normal",
      number = "",

      borderLeft = "",
      borderRight = { "", "" }
    }
  };
  local _out = {};

  vim.cmd("rshada")
  local old = vim.v.oldfiles;
  
  _o = vim.tbl_extend("force", _o, opts);

  for i = 1, _o.length, 1 do
    local top;
    local left;
    local len;
    local nT;

    local spaces;

    local fullpath = old[i];
    local path = string.gsub(vim.fs.dirname(fullpath), "/data/data/com.termux/files/home", "~");
    local file = vim.fs.basename(fullpath);

    local ext = vim.filetype.match({ filename = file });
    local icon, hl = icons.get_icon(file, ext, { default = true });

    local BLstart, BLend = 0, 0;
    local DIstart, DIend = 0, 0;
    local FNstart, FNend = 0, 0;
    local FCstart, FCend = 0, 0;
    local BRstart, BRend = 0, 0;

    local override = {};


    -- line position from top
    top = U.skip + i + #U.preparedLines;
    U.anchors[i] = path .. file;

    -- Percantage value support
    if _o.width < 1 then
      _o.width = U.width * _o.width;
    end

    if _o.width ~= nil then
      left = math.floor((U.width - _o.width) / 2);
    else
      left = 4
    end

    len = left;
    nT = string.rep(" ", left);

    -- theres equal amount of padding on both sides
    spaces = U.width - (left * 2);
    
    -- Render the left  border 
    if _o.border ~= nil and _o.border[1] ~= nil then
      BLstart = 0;

      if type(_o.border[1]) == "string" then
        nT = nT .. _o.border[1] .. " ";
        spaces = spaces - vim.fn.strchars(_o.border[1] .. " ");
        
        BLend = vim.fn.strchars(_o.border[1] .. " ") - 1;
      elseif type(_o.border[1]) == "table" then
        nT = _o.border[1][i] ~= nil and nT .. _o.border[1][i] .. " " or nT .. _o.border[1][1] .. " ";
        spaces = spaces - vim.fn.strchars(_o.border[1][i] == nil and _o.border[1][1] .. " " or _o.border[1][i] .. " ")
        
        BLend = vim.fn.strchars(_o.border[1][i] == nil and _o.border[1][1] .. " " or _o.border[1][i] .. " ") - 1;
      end

      -- End of the left border( -1 is due to `col_end` being 0-indexed)
      table.insert(override, { BLstart, U.getHighlight(_o.color.borderLeft, i), BLend - 1 })
    end

    -- Add the icon
    DIstart = BLend == 0 and BLend or BLend + 1;
    nT = nT .. icon;
    DIend = DIstart + #icon - 1;
    
    table.insert(override, {DIstart, U.getHighlight(hl, i), DIend})

    nT = nT .. " ";

    -- Add the file name
    FNstart = DIend + 2;
    nT = nT .. file;
    FNend = FNstart + #file - 1;
    table.insert(override, {FNstart, U.getHighlight(_o.color.name, i), FNend})

    -- Add the soacws in between
    spaces = spaces - vim.fn.strchars(icon .. " " .. file) - #tostring(i);
    nT = nT .. string.rep(" ", spaces);

    -- Add the file count
    FCstart = FNend + spaces + 1;
    nT = nT .. tostring(i);
    FCend = FCstart + #tostring(i)
    table.insert(override, {FCstart, U.getHighlight(_o.color.number, i), FCend})
   
    -- Add the right border
    if _o.border ~= nil and _o.border[2] ~= nil then
      BRstart = FCend + 1;
      if type(_o.border[2]) == "string" then
        spaces = spaces - vim.fn.strchars(" " .. _o.border[2]);
        nT = nT .. " " .. _o.border[2];
      
        BRend = BRstart + #_o.border[2];
      elseif type(_o.border[2]) == "table" then
        spaces = spaces - vim.fn.strchars(_o.border[2][i] == nil and " " .. _o.border[2][1] or " " .. _o.border[2][i])
        nT = _o.border[2][i] ~= nil and nT .. " " .. _o.border[2][i] or nT .. " " .. _o.border[2][1];
        
        BRend = _o.border[2][i] ~= nil and BRstart + #_o.border[2][i] or BRstart + #_o.border[2][1];
      end
     
      table.insert(override, { BRstart, U.getHighlight(_o.color.borderRight, i), BRend })
    end


    -- Add a keymap for the current buffer
    vim.api.nvim_create_autocmd("CursorMoved", {
      pattern = { "<buffer>" },
      callback = function()
        local y = vim.api.nvim_win_get_cursor(0)[1];

        if U.anchors[y - (U.skip + 1)] ~= nil then
          vim.api.nvim_buf_set_lines(0, U.height - 1, U.height, false, { U.anchors[y - (U.skip + 1)] .. " " });
          --nvim_buf_add_highlight(0, 0, "Search" , U.height - 2, 0, 10 )
        else
          vim.api.nvim_buf_set_lines(0, U.height - 1, U.height, false, { "" });
        end
      end
    })



    table.insert(_out, {
      top = top,
      left = left,

      len = len,

      text = nT,
      color = {
        useRaw = true,
        override = override
        --[[
           [override = {
           [  {0, U.getHighlight(_o.color.borderLeft, i), BLend},
           [  {BLend + 2, hl, DIend},
           [  {DIend + 2, { "WLg1_bg", "WLg2_bg", "WLg3_bg" }, FNend},
           [  {FNend + spaces + 1, "Special", FCend },
           [  {FCend + #tostring(i), "TelescopeBorder", BRend},
           [}
           ]]
      }
    })
  end


  return _out;
end

-- Helper for keymaps
U.keymapsFormatter = function(opts)
end

-- Setup all the highlights
-- Global highlights get added first
U.setHighlights = function(opts)
  -- if the window size has changed change the values used by intro
  if U.width ~= vim.api.nvim_win_get_width(0) or U.height ~= vim.api.nvim_win_get_height(0) then
    U.width = vim.api.nvim_win_get_width(0);
    U.height = vim.api.nvim_win_get_height(0);
  end

  local gH = opts.globalHighlights;
  local cm = opts.components;

  -- Set global highlights
  for highlightName, highlightValue in pairs(gH) do
    vim.api.nvim_set_hl(0, "Intro_" .. highlightName, highlightValue);
  end

  -- Set component specific highlights
  for _, component in ipairs(cm) do
    if component.highlights ~= nil then
      for highlightName, highlightValue in pairs(component.highlights) do
        vim.api.nvim_set_hl(0, "Intro_" .. highlightName, highlightValue);
      end
    end
  end
end

-- Create a temporary scratch buffer for the start screen
U.createBuffer = function(opts)
  local cm = opts.components;
  U.lineCount = 0;

  U.width = vim.api.nvim_win_get_width(0);
  U.height = vim.api.nvim_win_get_height(0);

  -- Count the total number of lines
  for _, component in ipairs(cm) do
    if component.type == "banner" or component.type == "keymaps" then
      U.lineCount = U.lineCount + #component.lines;
    elseif component.type == "recents" then
      U.lineCount = U.lineCount + component.length;
    end
  end

  --vim.print(U.lineCount)

  U.drawDtart = math.floor((vim.api.nvim_win_get_height(0) - U.lineCount) / 2);


  U.introBuffer = vim.api.nvim_create_buf(false, true);
  vim.cmd("buf " .. U.introBuffer);
  vim.bo.filetype = "intro";

  -- Disabling various columns
  vim.cmd("setlocal nonumber norelativenumber signcolumn=no foldcolumn=0");
end

-- Format and highlight the texta
U.formatText = function(opts)
  U.preparedLines = {};

  local cm = opts.components;
  U.skip = math.floor((vim.api.nvim_win_get_height(0) - U.lineCount) / 2);

  local lines;

  for _, component in ipairs(cm) do
    if component.type == "banner" then
      lines = U.bannerFormatter(component);
    elseif component.type == "recents" then
      lines = U.recentsFormatter(component);
    elseif component.type == "keymaps" then
      lines = U.keymapsFormatter(component);
    end

    for _, item in ipairs(lines) do
      table.insert(U.preparedLines, item);
    end
  end
end

-- Render everything
U.render = function()
  vim.api.nvim_buf_set_lines(0, 0, U.height * 2, false, { "" });

  -- 1 for ths statusline, 1 so that the screen doesb't move up
  for l = 2, U.height, 1 do
    vim.api.nvim_buf_set_lines(0, l, l + 1, false, { string.rep(" ", U.width) })
  end

  -- Render every line
  for _, line in ipairs(U.preparedLines) do
    -- Add the line to the buffer
    vim.api.nvim_buf_set_lines(0, line.top, line.top + 1, false, { line.text })

    local _d;

    if line.color.default ~= nil then
      _d = (type(line.color.default[line.index]) == "table" or type(line.color.default[1] == "table")) and line.color.default[line.index] or line.color.default;
    else
      _d = nil;
    end

    local _o = line.color.override;
    local _s = line.color.shift;


    -- Add the default color
    if type(_d) == "string" then
      vim.api.nvim_buf_add_highlight(0, 0, vim.fn.hlexists(_d) == 0 and "Intro_" .. _d or _d, line.top, line.left, U.width);
    elseif type(_d) == "table" then
      local c = 1;

      -- If a gradient is used only iterate through the text and not through all the empty spaces
      for n = 0, line.len, 1 do
        vim.api.nvim_buf_add_highlight(0, 0, vim.fn.hlexists(_d[c]) == 0 and "Intro_" .. _d[c] or _d[c], line.top, line.left + n, line.left + n + 1);

        if c + 1 > #_d then
          c =  1;
        else
          c = c + 1;
        end
      end
    end


    -- Set the overwritten colors
    if type(_o) ~= "table" then
      goto next;
    end

    for _, ovr in ipairs(_o) do
      local n = ovr[1];
      local hl = ovr[2];

      local e = ovr[3] or nil;

      local start, finish;

      start = line.left + n;
      finish = e ~= nil and line.left + e + 1 or line.left + n + 1;

      -- use 1 based index or 0 based index
      if type(hl) == "string" then
        if vim.fn.hlexists(hl) == 1 then
           vim.api.nvim_buf_add_highlight(0, 0, hl, line.top, start, finish);
        else
          vim.api.nvim_buf_add_highlight(0, 0, "Intro_" .. hl, line.top, start, finish);
        end
      elseif type(hl) == "table" then
        local cN = 1;

        for i = start, finish do
          if vim.fn.hlexists(hl[cN]) == 1 then
             vim.api.nvim_buf_add_highlight(0, 0, hl[cN], line.top, i, i + 1);
          else
            vim.api.nvim_buf_add_highlight(0, 0, "Intro_" .. hl[cN], line.top, i, i + 1);
          end

          if cN + 1 > #hl then
            cN = 1;
          else
            cN = cN + 1;
          end
        end
      end
    end

    ::next::
  end
end

-- Start animation
U.animate = function(tbl)
  if U.withinAnimation == true or tbl == nil then
    return
  end

  U.withinAnimation = true;
end

return U;
