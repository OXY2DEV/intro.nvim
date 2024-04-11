local P = {};
local A = require("intro.arts");
local U = require("intro.utils");

A.nvim_color_names = {
  "c_1",  "c_2",  "c_3",  "c_4",  "c_5",
  "c_6",  "c_7",  "c_8",  "c_9",  "c_10",
  "c_11", "c_12", "c_13", "c_14", "c_15",
  "c_16", "c_17", "c_18", "c_19", "c_20",
  "c_21", "c_22", "c_23", "c_24", "c_25",
  "c_26", "c_27", "c_28", "c_29", "c_30",
};

A.nvim_color_names_simple = {
  "c_1", "c_1", "c_1", "c_2", "c_2", "c_2",
  "c_3", "c_3", "c_3", "c_4", "c_4", "c_2",
  "c_5", "c_5", "c_5", "c_6", "c_6", "c_6",
  "c_7", "c_7", "c_7", "c_8", "c_8", "c_8",
  "c_9", "c_9", "c_9", "c_0", "c_0", "c_0",
}

A.nvim_color_groups = {
  c_1  = { fg = "#89b5fa" },
  c_2  = { fg = "#82b8fb" },
  c_3  = { fg = "#7cbbfb" },
  c_4  = { fg = "#75bdfb" },
  c_5  = { fg = "#6ec0fa" },
  c_6  = { fg = "#68c3f9" },
  c_7  = { fg = "#62c5f8" },
  c_8  = { fg = "#5cc7f6" },
  c_9  = { fg = "#57caf4" },
  c_10 = { fg = "#53ccf1" },
  c_11 = { fg = "#4fceee" },
  c_12 = { fg = "#4dd0eb" },
  c_13 = { fg = "#4cd2e8" },
  c_14 = { fg = "#4cd4e4" },
  c_15 = { fg = "#4dd5e0" },
  c_16 = { fg = "#4fd7dc" },
  c_17 = { fg = "#52d8d8" },
  c_18 = { fg = "#57dad4" },
  c_19 = { fg = "#5bdbcf" },
  c_20 = { fg = "#61dccb" },
  c_21 = { fg = "#67ddc6" },
  c_22 = { fg = "#6ddec1" },
  c_23 = { fg = "#74dfbd" },
  c_24 = { fg = "#7be0b8" },
  c_25 = { fg = "#82e1b4" },
  c_26 = { fg = "#89e2b0" },
  c_27 = { fg = "#90e2ac" },
  c_28 = { fg = "#97e2a8" },
  c_29 = { fg = "#9fe3a4" },
  c_30 = { fg = "#a6e3a1" },
}

A.nvim_color_groups_black = {
  c_1 = { fg = "#1E1E2E" },
  c_2 = { fg = "#1E1E2E" },
  c_3 = { fg = "#1E1E2E" },
  c_4 = { fg = "#1E1E2E" },
  c_5 = { fg = "#1E1E2E" },
  c_6 = { fg = "#1E1E2E" },
  c_7 = { fg = "#1E1E2E" },
  c_8 = { fg = "#1E1E2E" },
  c_9 = { fg = "#1E1E2E" },
  c_0 = { fg = "#1E1E2E" },
}

P.nvim_color = {
  components = {
    {
      lines = A.N,
      colors = {
        A.nvim_color_names
      }
    }
  },

  globalHighlights = A.nvim_color_groups
};

P.nvim_color_animated = {
  components = {
    {
      lines = A.N,
      colors = {
        A.nvim_color_names_simple
      }
    }
  },

  globalHighlights = A.nvim_color_groups_black,

  animations = {
    updateDelay = 15,
    highlightBased = {
      U.transition("c_1", { "1E", "1E", "1E" }, { "89", "b5", "fa" }, 10),
      U.transition("c_2", { "1E", "1E", "1E" }, { "73", "be", "fb" }, 10),
      U.transition("c_3", { "1E", "1E", "1E" }, { "5f", "c6", "f7" }, 10),
      U.transition("c_4", { "1E", "1E", "1E" }, { "50", "cd", "ef" }, 10),
      U.transition("c_5", { "1E", "1E", "1E" }, { "4c", "d3", "e5" }, 10),
      U.transition("c_6", { "1E", "1E", "1E" }, { "53", "d9", "d8" }, 10),
      U.transition("c_7", { "1E", "1E", "1E" }, { "63", "dd", "c9" }, 10),
      U.transition("c_8", { "1E", "1E", "1E" }, { "78", "e0", "ba" }, 10),
      U.transition("c_9", { "1E", "1E", "1E" }, { "8e", "e2", "ad" }, 10),
      U.transition("c_0", { "1E", "1E", "1E" }, { "a6", "e3", "a1" }, 10)
    }
  }
};


P.cat = {
  components = {
    {
      width = { 8, 11, 8, 11 },
      lines = A.cat,
    }
  }
}

P.cat_green = {
  components = {
    {
      width = { 8, 11, 8, 11 },
      lines = A.cat,
      colors = "cat_1"
    }
  },

  globalHighlights = {
    cat_1 = { fg = "#a6e3a1" },
  }
}

P.cat_blue = {
  components = {
    {
      width = { 8, 11, 8, 11 },
      lines = A.cat,
      colors = "cat_1"
    }
  },

  globalHighlights = {
    cat_1 = { fg = "#89b5fa" },
  }
}

return P;
