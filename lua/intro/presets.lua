local P = {};

local V = vim;
local A = require("intro.arts");
local H = require("intro.helpers");

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
      colors = { A.nvim_color_names_simple }
    }
  },

  globalHighlights = A.nvim_color_groups_black,

  animations = {
    updateDelay = 15,
    highlightBased = {
      {
        groupName = "c_1",
        values = {
          { fg = "#282d42" }, { fg = "#333c56" }, { fg = "#3e4b6b" }, { fg = "#485a7f" }, { fg = "#536994" }, { fg = "#5e78a8" }, { fg = "#6887bc" }, { fg = "#7396d1" }, { fg = "#7ea5e5" }, { fg = "#89b5fa" }
        },

        startDelay = 0
      },
      {
        groupName = "c_2",
        values = {
          { fg = "#262e42" }, { fg = "#2f3e57" }, { fg = "#374e6b" }, { fg = "#405e80" }, { fg = "#486e94" }, { fg = "#517ea9" }, { fg = "#598ebd" }, { fg = "#629ed2" }, { fg = "#6aaee6" }, { fg = "#73befb" }
        },

        startDelay = 1
      },
      {
        groupName = "c_3",
        values = {
          { fg = "#242e42" }, { fg = "#2b3f56" }, { fg = "#31506a" }, { fg = "#38617e" }, { fg = "#3e7292" }, { fg = "#4582a6" }, { fg = "#4b93ba" }, { fg = "#52a4ce" }, { fg = "#58b5e2" }, { fg = "#5fc6f7" }
        },

        startDelay = 2
      },
      {
        groupName = "c_4",
        values = {
          { fg = "#232f41" }, { fg = "#284154" }, { fg = "#2d5267" }, { fg = "#32647b" }, { fg = "#37758e" }, { fg = "#3c87a1" }, { fg = "#4198b5" }, { fg = "#46aac8" }, { fg = "#4bbbdb" }, { fg = "#50cdef" }
        },

        startDelay = 3
      },
      {
        groupName = "c_5",
        values = {
          { fg = "#223040" }, { fg = "#274252" }, { fg = "#2b5464" }, { fg = "#306677" }, { fg = "#357889" }, { fg = "#398a9b" }, { fg = "#3e9cae" }, { fg = "#42aec0" }, { fg = "#47c0d2" }, { fg = "#4cd3e5" }
        },

        startDelay = 4
      },
      {
        groupName = "c_6",
        values = {
          { fg = "#23303f" }, { fg = "#284350" }, { fg = "#2d5661" }, { fg = "#336872" }, { fg = "#387b83" }, { fg = "#3d8e94" }, { fg = "#43a0a5" }, { fg = "#48b3b6" }, { fg = "#4dc6c7" }, { fg = "#53d9d8" }
        },

        startDelay = 5
      },
      {
        groupName = "c_7",
        values = {
          { fg = "#24313d" }, { fg = "#2b444d" }, { fg = "#32575c" }, { fg = "#396a6c" }, { fg = "#407d7b" }, { fg = "#47908b" }, { fg = "#4ea39a" }, { fg = "#55b6aa" }, { fg = "#5cc9b9" }, { fg = "#63ddc9" }
        },

        startDelay = 6
      },
      {
        groupName = "c_8",
        values = {
          { fg = "#27313c" }, { fg = "#30444a" }, { fg = "#395858" }, { fg = "#426b66" }, { fg = "#4b7f74" }, { fg = "#549282" }, { fg = "#5da590" }, { fg = "#66b99e" }, { fg = "#6fccac" }, { fg = "#78e0ba" }
        },

        startDelay = 7
      },
      {
        groupName = "c_9",
        values = {
          { fg = "#29313a" }, { fg = "#344547" }, { fg = "#3f5854" }, { fg = "#4a6c60" }, { fg = "#56806d" }, { fg = "#61937a" }, { fg = "#6ca786" }, { fg = "#77ba93" }, { fg = "#82cea0" }, { fg = "#8ee2ad" }
        },

        startDelay = 8
      },
      {
        groupName = "c_0",
        values = {
          { fg = "#2b3139" }, { fg = "#394545" }, { fg = "#465950" }, { fg = "#546c5c" }, { fg = "#628067" }, { fg = "#6f9473" }, { fg = "#7da77e" }, { fg = "#8abb8a" }, { fg = "#98cf95" }, { fg = "#a6e3a1" }
        },

        startDelay = 9
      },
    }
  }
};


P.cat = {
  components = {
    {
      width = 14,
      lines = A.cat,
    }
  }
}

P.cat_green = {
  components = {
    {
      width = 14,
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
      width = 14,
      lines = A.cat,
      colors = "cat_1"
    }
  },

  globalHighlights = {
    cat_1 = { fg = "#89b5fa" },
  }
}

P.blue_green_cats = {
  components = {
    {
      width = 24,
      lines = A.cat_2,
      secondaryColors = {
        { "cat_1", "cat_2" },
        { "cat_1", "cat_2" },
        { "cat_1", "cat_2" },
        { "cat_1", "cat_2" },
      }
    }
  },

  globalHighlights = {
    cat_1 = { fg = "#89b5fa" },
    cat_2 = { fg = "#a6e3a1" },
  }
}

P.four_cats = {
  components = {
    {
      width = 24,
      lines = A.cat_4,
      secondaryColors = {
        { "cat_1", "cat_2" },
        { "cat_1", "cat_2" },
        { "cat_1", "cat_2" },
        { "cat_1", "cat_2" },
        nil,
        { "cat_3", "cat_4" },
        { "cat_3", "cat_4" },
        { "cat_3", "cat_4" },
        { "cat_3", "cat_4" },
      }
    }
  },

  globalHighlights = {
    cat_1 = { fg = "#89b5fa" },
    cat_2 = { fg = "#a6e3a1" },
    cat_3 = { fg = "#f5c2e7" },
    cat_4 = { fg = "#cba6f7" },
  }
}

local bgToBlue = V.list_extend(
  H.gradientSteps(
    { r = 30, g = 30, b = 46 }, { r = 137, g = 181, b = 250 }, 10
  ),

  H.gradientSteps(
    { r = 137, g = 181, b = 250 }, { r = 30, g = 30 , b = 46 }, 10
  )
);

local bgToGreen = V.list_extend(
  H.gradientSteps(
    { r = 30, g = 30, b = 46 }, { r = 166, g = 227, b = 161 }, 10
  ),

  H.gradientSteps(
    { r = 166, g = 227, b = 161 }, { r = 30, g = 30 , b = 46 }, 10
  )
);

local bgToPink = V.list_extend(
  H.gradientSteps(
    { r = 30, g = 30, b = 46 }, { r = 245, g = 194, b = 231 }, 10
  ),

  H.gradientSteps(
    { r = 245, g = 194, b = 231 }, { r = 30, g = 30 , b = 46 }, 10
  )
);

local bgToViolet = V.list_extend(
  H.gradientSteps(
    { r = 30, g = 30, b = 46 }, { r = 203, g = 166, b = 247 }, 10
  ),

  H.gradientSteps(
    { r = 203, g = 166, b = 247 }, { r = 30, g = 30 , b = 46 }, 10
  )
);

P.four_cats_animated = {
  components = {
    {
      width = 24,
      lines = A.cat_4,
      secondaryColors = {
        { "cat_1", "cat_2" },
        { "cat_1", "cat_2" },
        { "cat_1", "cat_2" },
        { "cat_1", "cat_2" },
        nil,
        { "cat_3", "cat_4" },
        { "cat_3", "cat_4" },
        { "cat_3", "cat_4" },
        { "cat_3", "cat_4" },
      }
    }
  },

  globalHighlights = {
    cat_1 = { fg = "#1e1e2e" },
    cat_2 = { fg = "#1e1e2e" },
    cat_3 = { fg = "#1e1e2e" },
    cat_4 = { fg = "#1e1e2e" },
  },

  animations = {
    updateDelay = 50,
    highlightBased = {
      {
        groupName = "cat_1",
        loop = true,
        values = H.toFg(bgToBlue)
      },
      {
        groupName = "cat_2",
        loop = true,

        loopDelay = 10,
        values = H.toFg(bgToGreen)
      },
      {
        groupName = "cat_3",
        loop = true,

        loopDelay = 40,
        values = H.toFg(bgToPink)
      },
      {
        groupName = "cat_4",
        loop = true,
        loopDelay = 20,
        values = H.toFg(bgToViolet)
      },
    }
  }
}

return P;
