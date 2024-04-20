local P = {};
local A = require("intro.arts");
local D = require("intro.data");
local V = vim;

P.presetToConfig = function(presetConfig)
  local config = {
    shadaRefresh = false,
    components = {},
    globalHighlights = {},
    animations = {}
  };
  local preset = nil;

  if presetConfig.name == nil or P[presetConfig.name] == nil then
    goto noPresetName;
  else
    preset = P[presetConfig.name];
  end

  if preset.default ~= nil then
    if preset.default.shadaRefresh ~= nil then
      config.shadaRefresh = preset.default.shadaRefresh;
    end

    if preset.default.anchors ~= nil then
      config.anchors = preset.anchors;
    end

    if preset.default.components ~= nil then
      config.components = preset.default.components;
    end

    if preset.default.globalHighlights ~= nil then
      config.globalHighlights = preset.default.globalHighlights;
    end

    if preset.default.animations ~= nil then
      config.animations = preset.default.animations;
    end
  end

  if presetConfig.opts == nil then
    goto noPresetName;
  end

  for _, keyValue in ipairs(presetConfig.opts) do
    if preset[keyValue] == nil then
      goto notOptName;
    end

    for keyName, keyTable in pairs(preset[keyValue]) do
      if keyTable.action == "overwrite" then
        config[keyName] = keyTable.value;
      elseif keyTable.action == "append" then
        if V.tbl_islist(keyTable.value) == true then
          V.list_extend(config[keyName], keyTable.value);
        else
          config[keyName] = V.tbl_extend("force", config[keyName], keyTable.value);
        end
      end
    end

    ::notOptName::
  end

  ::noPresetName::
  return config;
end

P.nvim = {
  default = {
    components = {
      {
        lines = A.N,
        colors = {
          {
            "c_1",  "c_2",  "c_3",  "c_4",  "c_5",
            "c_6",  "c_7",  "c_8",  "c_9",  "c_10",
            "c_11", "c_12", "c_13", "c_14", "c_15",
            "c_16", "c_17", "c_18", "c_19", "c_20",
            "c_21", "c_22", "c_23", "c_24", "c_25",
            "c_26", "c_27", "c_28", "c_29", "c_30",
          }
        }
      }
    },

    globalHighlights = {
      c_1  = { fg = "#89b5fa" }, c_2  = { fg = "#82b8fb" }, c_3  = { fg = "#7cbbfb" }, c_4  = { fg = "#75bdfb" }, c_5  = { fg = "#6ec0fa" },
      c_6  = { fg = "#68c3f9" }, c_7  = { fg = "#62c5f8" }, c_8  = { fg = "#5cc7f6" }, c_9  = { fg = "#57caf4" }, c_10 = { fg = "#53ccf1" },
      c_11 = { fg = "#4fceee" }, c_12 = { fg = "#4dd0eb" }, c_13 = { fg = "#4cd2e8" }, c_14 = { fg = "#4cd4e4" }, c_15 = { fg = "#4dd5e0" },
      c_16 = { fg = "#4fd7dc" }, c_17 = { fg = "#52d8d8" }, c_18 = { fg = "#57dad4" }, c_19 = { fg = "#5bdbcf" }, c_20 = { fg = "#61dccb" },
      c_21 = { fg = "#67ddc6" }, c_22 = { fg = "#6ddec1" }, c_23 = { fg = "#74dfbd" }, c_24 = { fg = "#7be0b8" }, c_25 = { fg = "#82e1b4" },
      c_26 = { fg = "#89e2b0" }, c_27 = { fg = "#90e2ac" }, c_28 = { fg = "#97e2a8" }, c_29 = { fg = "#9fe3a4" }, c_30 = { fg = "#a6e3a1" },
    }
  },

  animated = {
    components = {
      action = "overwrite",
      value = {
        {
          lines = A.N,
          colors = {
            {
              "c_1", "c_1", "c_1", "c_2", "c_2", "c_2",
              "c_3", "c_3", "c_3", "c_4", "c_4", "c_2",
              "c_5", "c_5", "c_5", "c_6", "c_6", "c_6",
              "c_7", "c_7", "c_7", "c_8", "c_8", "c_8",
              "c_9", "c_9", "c_9", "c_0", "c_0", "c_0",
            }
          }
        }
      }
    },

    globalHighlights = {
      action = "overwrite",
      value = {
        c_1 = { fg = "#1E1E2E" }, c_2 = { fg = "#1E1E2E" }, c_3 = { fg = "#1E1E2E" }, c_4 = { fg = "#1E1E2E" }, c_5 = { fg = "#1E1E2E" },
        c_6 = { fg = "#1E1E2E" }, c_7 = { fg = "#1E1E2E" }, c_8 = { fg = "#1E1E2E" }, c_9 = { fg = "#1E1E2E" }, c_0 = { fg = "#1E1E2E" },
      }
    },

    animations = {
      action = "overwrite",
      value = {
        delay = 15,
        updateDelay = 15,
        highlightBased = {
          {
            groupName = "c_1",
            startDelay = 0,
            values = {
              { fg = "#282d42" }, { fg = "#333c56" }, { fg = "#3e4b6b" }, { fg = "#485a7f" }, { fg = "#536994" }, { fg = "#5e78a8" }, { fg = "#6887bc" }, { fg = "#7396d1" }, { fg = "#7ea5e5" }, { fg = "#89b5fa" }
            },
          },
          {
            groupName = "c_2",
            startDelay = 1,
            values = {
              { fg = "#262e42" }, { fg = "#2f3e57" }, { fg = "#374e6b" }, { fg = "#405e80" }, { fg = "#486e94" }, { fg = "#517ea9" }, { fg = "#598ebd" }, { fg = "#629ed2" }, { fg = "#6aaee6" }, { fg = "#73befb" }
            },
          },
          {
            groupName = "c_3",
            startDelay = 2,
            values = {
              { fg = "#242e42" }, { fg = "#2b3f56" }, { fg = "#31506a" }, { fg = "#38617e" }, { fg = "#3e7292" }, { fg = "#4582a6" }, { fg = "#4b93ba" }, { fg = "#52a4ce" }, { fg = "#58b5e2" }, { fg = "#5fc6f7" }
            },
          },
          {
            groupName = "c_4",
            startDelay = 3,
            values = {
              { fg = "#232f41" }, { fg = "#284154" }, { fg = "#2d5267" }, { fg = "#32647b" }, { fg = "#37758e" }, { fg = "#3c87a1" }, { fg = "#4198b5" }, { fg = "#46aac8" }, { fg = "#4bbbdb" }, { fg = "#50cdef" }
            },
          },
          {
            groupName = "c_5",
            startDelay = 4,
            values = {
              { fg = "#223040" }, { fg = "#274252" }, { fg = "#2b5464" }, { fg = "#306677" }, { fg = "#357889" }, { fg = "#398a9b" }, { fg = "#3e9cae" }, { fg = "#42aec0" }, { fg = "#47c0d2" }, { fg = "#4cd3e5" }
            },
          },
          {
            groupName = "c_6",
            startDelay = 5,
            values = {
              { fg = "#23303f" }, { fg = "#284350" }, { fg = "#2d5661" }, { fg = "#336872" }, { fg = "#387b83" }, { fg = "#3d8e94" }, { fg = "#43a0a5" }, { fg = "#48b3b6" }, { fg = "#4dc6c7" }, { fg = "#53d9d8" }
            },
          },
          {
            groupName = "c_7",
            startDelay = 6,
            values = {
              { fg = "#24313d" }, { fg = "#2b444d" }, { fg = "#32575c" }, { fg = "#396a6c" }, { fg = "#407d7b" }, { fg = "#47908b" }, { fg = "#4ea39a" }, { fg = "#55b6aa" }, { fg = "#5cc9b9" }, { fg = "#63ddc9" }
            },
          },
          {
            groupName = "c_8",
            startDelay = 7,
            values = {
              { fg = "#27313c" }, { fg = "#30444a" }, { fg = "#395858" }, { fg = "#426b66" }, { fg = "#4b7f74" }, { fg = "#549282" }, { fg = "#5da590" }, { fg = "#66b99e" }, { fg = "#6fccac" }, { fg = "#78e0ba" }
            },
          },
          {
            groupName = "c_9",
            startDelay = 8,
            values = {
              { fg = "#29313a" }, { fg = "#344547" }, { fg = "#3f5854" }, { fg = "#4a6c60" }, { fg = "#56806d" }, { fg = "#61937a" }, { fg = "#6ca786" }, { fg = "#77ba93" }, { fg = "#82cea0" }, { fg = "#8ee2ad" }
            },
          },
          {
            groupName = "c_0",
            startDelay = 9,
            values = {
              { fg = "#2b3139" }, { fg = "#394545" }, { fg = "#465950" }, { fg = "#546c5c" }, { fg = "#628067" }, { fg = "#6f9473" }, { fg = "#7da77e" }, { fg = "#8abb8a" }, { fg = "#98cf95" }, { fg = "#a6e3a1" }
            },
          },
        }
      }
    }
  }
};

P.nvim_alt_1 = {
  default = {
    shadaRefresh = true,

    components = {
      {
        lines = A.nvim_outline,
        colors = {
          { "c_1", "c_1", "c_1", "c_1", "c_1", "c_2", "c_2", "c_2", "c_2", "c_2", "c_3", "c_3", "c_3", "c_3", "c_3", "c_4", "c_4", "c_4", "c_4", "c_4", "c_5", "c_5", "c_5", "c_5", "c_5", "c_4", "c_4", "c_4", "c_4", "c_4", "c_3", "c_3", "c_3", "c_3", "c_3", "c_2", "c_2", "c_2", "c_2", "c_2", "c_1", "c_1", "c_1", "c_1", "c_1" },
          { "c_2", "c_2", "c_2", "c_2", "c_2", "c_3", "c_3", "c_3", "c_3", "c_3", "c_4", "c_4", "c_4", "c_4", "c_4", "c_5", "c_5", "c_5", "c_5", "c_5", "c_4", "c_4", "c_4", "c_4", "c_4", "c_3", "c_3", "c_3", "c_3", "c_3", "c_2", "c_2", "c_2", "c_2", "c_2", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1" },
          { "c_3", "c_3", "c_3", "c_3", "c_3", "c_4", "c_4", "c_4", "c_4", "c_4", "c_5", "c_5", "c_5", "c_5", "c_5", "c_4", "c_4", "c_4", "c_4", "c_4", "c_3", "c_3", "c_3", "c_3", "c_3", "c_2", "c_2", "c_2", "c_2", "c_2", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_2", "c_2", "c_2", "c_2", "c_2" },
          { "c_4", "c_4", "c_4", "c_4", "c_4", "c_5", "c_5", "c_5", "c_5", "c_5", "c_4", "c_4", "c_4", "c_4", "c_4", "c_3", "c_3", "c_3", "c_3", "c_3", "c_2", "c_2", "c_2", "c_2", "c_2", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_2", "c_2", "c_2", "c_2", "c_2", "c_3", "c_3", "c_3", "c_3", "c_3" },
          { "c_5", "c_5", "c_5", "c_5", "c_5", "c_4", "c_4", "c_4", "c_4", "c_4", "c_3", "c_3", "c_3", "c_3", "c_3", "c_2", "c_2", "c_2", "c_2", "c_2", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_1", "c_2", "c_2", "c_2", "c_2", "c_2", "c_3", "c_3", "c_3", "c_3", "c_3", "c_4", "c_4", "c_4", "c_4", "c_4" },
        },
        gradientRepeat = true
      }
    },
  },

  dark = {
    anchors = {
      action = "overwrite",
      value = {
        position = "bottom",
        textStyle = { bg = "#a6e3a1", fg = "#384361" },
        cornerStyle = { bg = "#a6e3a1", fg = "#1E1E2E" },
        corner = " "
      },
    },
    globalHighlights = {
      action = "overwrite",
      value = {
        c_1 = { fg = "#89b5fa" }, c_2 = { fg = "#90c0e3" }, c_3 = { fg = "#97cccd" }, c_4 = { fg = "#9ed7b7" }, c_5 = { fg = "#a6e3a1" },
      }
    }
  },

  dark_alt = {
    globalHighlights = {
      action = "overwrite",
      value = {
        c_1 = { fg = "#6dd5fa" }, c_2 = { fg = "#5cbfe9" }, c_3 = { fg = "#4baad9" }, c_4 = { fg = "#3a95c9" }, c_5 = { fg = "#2980b9" }
      }
    },
    anchors = {
      action = "overwrite",
      value = {
        position = "bottom",
        textStyle = { bg = "#6dd5fa", fg = "#384361" },
        cornerStyle = { bg = "#6dd5fa", fg = "#1E1E2E" },
        corner = " "
      },
    },
  },

  dark_animated = {
    anchors = {
      action = "overwrite",
      value = {
        position = "bottom",
        textStyle = { bg = "#a6e3a1", fg = "#384361" },
        cornerStyle = { bg = "#a6e3a1", fg = "#1E1E2E" },
        corner = " "
      },
    },
    globalHighlights = {
      action = "overwrite",
      value = {
        c_1 = { fg = "#384361" }, c_2 = { fg = "#384361" }, c_3 = { fg = "#384361" }, c_4 = { fg = "#384361" }, c_5 = { fg = "#384361" },
      }
    },
    animations = {
      action = "overwrite",
      value = {
        updateDelay = 50,
        highlightBased = {
          {
            groupName = "c_1",
            loop = 1,
            values = {
              { fg = "#384361" }, { fg = "#445468" }, { fg = "#50666f" }, { fg = "#5c7876" }, { fg = "#688a7d" }, { fg = "#759b84" }, { fg = "#81ad8b" }, { fg = "#8dbf92" }, { fg = "#99d199" },
              { fg = "#a6e3a1" },
              { fg = "#99d199" }, { fg = "#8dbf92" }, { fg = "#81ad8b" }, { fg = "#759b84" }, { fg = "#688a7d" }, { fg = "#5c7876" }, { fg = "#50666f" }, { fg = "#445468" }, { fg = "#384361" },
            }
          },
          {
            groupName = "c_2",
            startDelay = 2,
            loop = 1,
            values = {
              { fg = "#384361" }, { fg = "#445468" }, { fg = "#50666f" }, { fg = "#5c7876" }, { fg = "#688a7d" }, { fg = "#759b84" }, { fg = "#81ad8b" }, { fg = "#8dbf92" }, { fg = "#99d199" },
              { fg = "#a6e3a1" },
              { fg = "#99d199" }, { fg = "#8dbf92" }, { fg = "#81ad8b" }, { fg = "#759b84" }, { fg = "#688a7d" }, { fg = "#5c7876" }, { fg = "#50666f" }, { fg = "#445468" }, { fg = "#384361" },
            }
          },
          {
            groupName = "c_3",
            startDelay = 4,
            loop = 1,
            values = {
              { fg = "#384361" }, { fg = "#445468" }, { fg = "#50666f" }, { fg = "#5c7876" }, { fg = "#688a7d" }, { fg = "#759b84" }, { fg = "#81ad8b" }, { fg = "#8dbf92" }, { fg = "#99d199" },
              { fg = "#a6e3a1" },
              { fg = "#99d199" }, { fg = "#8dbf92" }, { fg = "#81ad8b" }, { fg = "#759b84" }, { fg = "#688a7d" }, { fg = "#5c7876" }, { fg = "#50666f" }, { fg = "#445468" }, { fg = "#384361" },
            }
          },
          {
            groupName = "c_4",
            startDelay = 6,
            loop = 1,
            values = {
              { fg = "#384361" }, { fg = "#445468" }, { fg = "#50666f" }, { fg = "#5c7876" }, { fg = "#688a7d" }, { fg = "#759b84" }, { fg = "#81ad8b" }, { fg = "#8dbf92" }, { fg = "#99d199" },
              { fg = "#a6e3a1" },
              { fg = "#99d199" }, { fg = "#8dbf92" }, { fg = "#81ad8b" }, { fg = "#759b84" }, { fg = "#688a7d" }, { fg = "#5c7876" }, { fg = "#50666f" }, { fg = "#445468" }, { fg = "#384361" },
            }
          },
          {
            groupName = "c_5",
            startDelay = 8,
            loop = 1,
            values = {
              { fg = "#384361" }, { fg = "#445468" }, { fg = "#50666f" }, { fg = "#5c7876" }, { fg = "#688a7d" }, { fg = "#759b84" }, { fg = "#81ad8b" }, { fg = "#8dbf92" }, { fg = "#99d199" },
              { fg = "#a6e3a1" },
              { fg = "#99d199" }, { fg = "#8dbf92" }, { fg = "#81ad8b" }, { fg = "#759b84" }, { fg = "#688a7d" }, { fg = "#5c7876" }, { fg = "#50666f" }, { fg = "#445468" }, { fg = "#384361" },
            }
          },
        }
      }
    }
  },

  dark_alt_animated = {
    globalHighlights = {
      action = "overwrite",
      value = {
        c_1 = { fg = "#6dd5fa" }, c_2 = { fg = "#5cbfe9" }, c_3 = { fg = "#4baad9" }, c_4 = { fg = "#3a95c9" }, c_5 = { fg = "#2980b9" }
      }
    },
    animations = {
      action = "overwrite",
      value = {
        delay = 750,
        updateDelay = 50,
        highlightBased = {
          {
            groupName = "c_2",
            loop = 1, loopDelay = 25,
            values = {
              { fg = "#5cbfe9" }, { fg = "#5dc1ea" }, { fg = "#5fc3ec" }, { fg = "#61c6ee" }, { fg = "#63c8f0" }, { fg = "#65cbf2" }, { fg = "#67cdf4" }, { fg = "#69d0f6" }, { fg = "#6bd2f8" }, { fg = "#6dd5fa" }, 
              { fg = "#6dd5fa" }, { fg = "#6bd2f8" }, { fg = "#69d0f6" }, { fg = "#67cdf4" }, { fg = "#65cbf2" }, { fg = "#63c8f0" }, { fg = "#61c6ee" }, { fg = "#5fc3ec" }, { fg = "#5dc1ea" }, { fg = "#5cbfe9" }, 
            }
          },
          {
            groupName = "c_3",
            loop = 1, loopDelay = 25,
            values = {
              { fg = "#4baad9" }, { fg = "#4eaedc" }, { fg = "#52b3e0" }, { fg = "#56b8e4" }, { fg = "#5abde7" }, { fg = "#5dc1eb" }, { fg = "#61c6ef" }, { fg = "#65cbf2" }, { fg = "#69d0f6" }, { fg = "#6dd5fa" }, 
              { fg = "#6dd5fa" }, { fg = "#69d0f6" }, { fg = "#65cbf2" }, { fg = "#61c6ef" }, { fg = "#5dc1eb" }, { fg = "#5abde7" }, { fg = "#56b8e4" }, { fg = "#52b3e0" }, { fg = "#4eaedc" }, { fg = "#4baad9" }, 
            }
          },
          {
            groupName = "c_4",
            loop = 1, loopDelay = 25,
            values = {
              { fg = "#3a95c9" }, { fg = "#3f9cce" }, { fg = "#45a3d3" }, { fg = "#4baad9" }, { fg = "#50b1de" }, { fg = "#56b8e4" }, { fg = "#5cbfe9" }, { fg = "#61c6ef" }, { fg = "#67cdf4" }, { fg = "#6dd5fa" }, 
              { fg = "#6dd5fa" }, { fg = "#67cdf4" }, { fg = "#61c6ef" }, { fg = "#5cbfe9" }, { fg = "#56b8e4" }, { fg = "#50b1de" }, { fg = "#4baad9" }, { fg = "#45a3d3" }, { fg = "#3f9cce" }, { fg = "#3a95c9" }, 
            }
          },
          {
            groupName = "c_5",
            loop = 1, loopDelay = 25,
            values = {
              { fg = "#2980b9" }, { fg = "#3089c0" }, { fg = "#3892c7" }, { fg = "#3f9cce" }, { fg = "#47a5d5" }, { fg = "#4eafdd" }, { fg = "#56b8e4" }, { fg = "#5dc2eb" }, { fg = "#65cbf2" }, { fg = "#6dd5fa" }, 
              { fg = "#6dd5fa" }, { fg = "#65cbf2" }, { fg = "#5dc2eb" }, { fg = "#56b8e4" }, { fg = "#4eafdd" }, { fg = "#47a5d5" }, { fg = "#3f9cce" }, { fg = "#3892c7" }, { fg = "#3089c0" }, { fg = "#2980b9" }, 
            }
          },
        }
      }
    }
  },

  recents = {
    components = {
      action = "append",
      value = {
        "",
        {
          type = "banner",
          width = 0.8,
          lines = { { " ▒▒ ", "Recently opened files:" } },
          secondaryColors = { { "icon_bg", "Normal" } }
        },
        "",
        {
          type = "recents",
          width = 0.8,
          useIcons = true,
          useAnchors = true,
          entryCount = 5,

          colors = {
            name = { "name" },
            number = { "number" }
          },
        },
      }
    },

    globalHighlights = {
      action = "append",
      value = {
        icon_bg = { fg = "#74C7EC", bg = "#1E1E2E" }
      }
    }
  }
}

P.startify = {
  default = {
    components = {
      {
        lines = A.nvim_lean,
        colors = {
          {
            "col_1",  "col_1",  "col_1",  "col_1",  "col_1",
            "col_2",  "col_2",  "col_2",  "col_2",  "col_2",
            "col_3",  "col_3",  "col_3",  "col_3",  "col_3",
            "col_4",  "col_4",  "col_4",  "col_4",  "col_4",
            "col_5",  "col_5",  "col_5",  "col_5",  "col_5",
            "col_6",  "col_6",  "col_6",  "col_6",  "col_6",
            "col_7",  "col_7",  "col_7",  "col_7",  "col_7",
            "col_8",  "col_8",  "col_8",  "col_8",  "col_8",
            "col_9",  "col_9",  "col_9",  "col_9",  "col_9",
            "col_10", "col_10", "col_10", "col_10", "col_10",
            "col_11", "col_11", "col_11", "col_11", "col_11",
            "col_12", "col_12", "col_12", "col_12", "col_12",
            "col_13", "col_13", "col_13", "col_13", "col_13",
          }
        }
      }
    }
  },

  blue = {
    anchors = {
      action = "overwrite",
      value = {
        position = "bottom",
        textStyle = { bg = "#89b4fa", fg = "#384361" },
        cornerStyle = { bg = "#89b4fa", fg = "#1E1E2E" },
        corner = " "
      },
    },
    globalHighlights = {
      action = "overwrite",
      value = {
        col_1 = { fg = "#89b4fa" }, col_2 = { fg = "#89b4fa" }, col_3 = { fg = "#89b4fa" }, col_4 = { fg = "#89b4fa" }, col_5 = { fg = "#89b4fa" }, col_6 = { fg = "#89b4fa" }, col_7 = { fg = "#89b4fa" }, col_8 = { fg = "#89b4fa" }, col_9 = { fg = "#89b4fa" }, col_10 = { fg = "#89b4fa" }, col_11 = { fg = "#89b4fa" }, col_12 = { fg = "#89b4fa" }, col_13 = { fg = "#89b4fa" },
        label_1 = { fg = "#89b4fa" }
      }
    }
  },
  green = {
    anchors = {
      action = "overwrite",
      value = {
        position = "bottom",
        textStyle = { bg = "#a6e3a1", fg = "#384361" },
        cornerStyle = { bg = "#a6e3a1", fg = "#1E1E2E" },
        corner = " "
      },
    },
    globalHighlights = {
      action = "overwrite",
      value = {
        col_1 = { fg = "#a6e3a1" }, col_2 = { fg = "#a6e3a1" }, col_3 = { fg = "#a6e3a1" }, col_4 = { fg = "#a6e3a1" }, col_5 = { fg = "#a6e3a1" }, col_6 = { fg = "#a6e3a1" }, col_7 = { fg = "#a6e3a1" }, col_8 = { fg = "#a6e3a1" }, col_9 = { fg = "#a6e3a1" }, col_10 = { fg = "#a6e3a1" }, col_11 = { fg = "#a6e3a1" }, col_12 = { fg = "#a6e3a1" }, col_13 = { fg = "#a6e3a1" },
        label_1 = { fg = "#a6e3a1" }
      }
    }
  },
  red = {
    anchors = {
      action = "overwrite",
      value = {
        position = "bottom",
        textStyle = { bg = "#f38ba8", fg = "#384361" },
        cornerStyle = { bg = "#f38ba8", fg = "#1E1E2E" },
        corner = " "
      },
    },
    globalHighlights = {
      action = "overwrite",
      value = {
        col_1 = { fg = "#f38ba8" }, col_2 = { fg = "#f38ba8" }, col_3 = { fg = "#f38ba8" }, col_4 = { fg = "#f38ba8" }, col_5 = { fg = "#f38ba8" }, col_6 = { fg = "#f38ba8" }, col_7 = { fg = "#f38ba8" }, col_8 = { fg = "#f38ba8" }, col_9 = { fg = "#f38ba8" }, col_10 = { fg = "#f38ba8" }, col_11 = { fg = "#f38ba8" }, col_12 = { fg = "#f38ba8" }, col_13 = { fg = "#f38ba8" },
        label_1 = { fg = "#f38ba8" }
      }
    }
  },
  pink = {
    anchors = {
      action = "overwrite",
      value = {
        position = "bottom",
        textStyle = { bg = "#f5c2e7", fg = "#384361" },
        cornerStyle = { bg = "#f5c2e7", fg = "#1E1E2E" },
        corner = " "
      },
    },
    globalHighlights = {
      action = "overwrite",
      value = {
        col_1 = { fg = "#f5c2e7" }, col_2 = { fg = "#f5c2e7" }, col_3 = { fg = "#f5c2e7" }, col_4 = { fg = "#f5c2e7" }, col_5 = { fg = "#f5c2e7" }, col_6 = { fg = "#f5c2e7" }, col_7 = { fg = "#f5c2e7" }, col_8 = { fg = "#f5c2e7" }, col_9 = { fg = "#f5c2e7" }, col_10 = { fg = "#f5c2e7" }, col_11 = { fg = "#f5c2e7" }, col_12 = { fg = "#f5c2e7" }, col_13 = { fg = "#f5c2e7" },
        label_1 = { fg = "#f5c2e7" }
      }
    }
  },
  flamingo = {
    anchors = {
      action = "overwrite",
      value = {
        position = "bottom",
        textStyle = { bg = "#f2cdcd", fg = "#384361" },
        cornerStyle = { bg = "#f2cdcd", fg = "#1E1E2E" },
        corner = " "
      },
    },
    globalHighlights = {
      action = "overwrite",
      value = {
        col_1 = { fg = "#f2cdcd" }, col_2 = { fg = "#f2cdcd" }, col_3 = { fg = "#f2cdcd" }, col_4 = { fg = "#f2cdcd" }, col_5 = { fg = "#f2cdcd" }, col_6 = { fg = "#f2cdcd" }, col_7 = { fg = "#f2cdcd" }, col_8 = { fg = "#f2cdcd" }, col_9 = { fg = "#f2cdcd" }, col_10 = { fg = "#f2cdcd" }, col_11 = { fg = "#f2cdcd" }, col_12 = { fg = "#f2cdcd" }, col_13 = { fg = "#f2cdcd" },
        label_1 = { fg = "#f2cdcd" }
      }
    }
  },

  gradient_blue_green = {
    anchors = {
      action = "overwrite",
      value = {
        textStyle = { bg = "#89b5fa", fg = "#1E1E2E" },
        cornerStyle = { bg = "#89b5fa", fg = "#1E1E2E" }
      }
    },
    globalHighlights = {
      action = "overwrite",
      value = {
        col_1 = { fg = "#89b4fa" }, col_2 = { fg = "#8bb7f2" }, col_3 = { fg = "#8dbbeb" }, col_4 = { fg = "#90bfe3" }, col_5 = { fg = "#92c3dc" }, col_6 = { fg = "#95c7d4" }, col_7 = { fg = "#97cbcd" }, col_8 = { fg = "#99cfc6" }, col_9 = { fg = "#9cd3be" }, col_10 = { fg = "#9ed7b7" }, col_11 = { fg = "#a1dbaf" }, col_12 = { fg = "#a3dfa8" }, col_13 = { fg = "#a6e3a1" },
        label_1 = { fg = "#89b4fa" }
      }
    }
  },
  -- Taken from uiGrafients.com
  gradient_endless_river = {
    anchors = {
      action = "overwrite",
      value = {
        textStyle = { bg = "#43cea2", fg = "#1E1E2E" },
        cornerStyle = { bg = "#43cea2", fg = "#1E1E2E" }
      }
    },
    globalHighlights = {
      action = "overwrite",
      value = {
        col_1 = { fg = "#43cea2" }, col_2 = { fg = "#3fc4a1" }, col_3 = { fg = "#3bbaa1" }, col_4 = { fg = "#38b1a0" }, col_5 = { fg = "#34a7a0" }, col_6 = { fg = "#319d9f" }, col_7 = { fg = "#2d949f" }, col_8 = { fg = "#298a9f" }, col_9 = { fg = "#26809e" }, col_10 = { fg = "#22779e" }, col_11 = { fg = "#1f6d9d" }, col_12 = { fg = "#1b639d" }, col_13 = { fg = "#185a9d" },
        label_1 = { fg = "#43cea2" }
      }
    }
  },
  -- Taken from uiGrafients.com
  gradient_friday = {
    anchors = {
      action = "overwrite",
      value = {
        textStyle = { bg = "#83a4d4", fg = "#1E1E2E" },
        cornerStyle = { bg = "#83a4d4", fg = "#1E1E2E" }
      }
    },
    globalHighlights = {
      action = "overwrite",
      value = {
        col_1 = { fg = "#83a4d4" }, col_2 = { fg = "#87abd7" }, col_3 = { fg = "#8bb2db" }, col_4 = { fg = "#8fb9de" }, col_5 = { fg = "#94c1e2" }, col_6 = { fg = "#98c8e5" }, col_7 = { fg = "#9ccfe9" }, col_8 = { fg = "#a0d6ed" }, col_9 = { fg = "#a5def0" }, col_10 = { fg = "#a9e5f4" }, col_11 = { fg = "#adecf7" }, col_12 = { fg = "#b1f3fb" }, col_13 = { fg = "#b6fbff" },
        label_1 = { fg = "#83a4d4" }
      }
    }
  },

  recents = {
    components = {
      action = "append",
      value = {
        "",
        "",
        {
          type = "banner",
          width = 0.8,
          lines = { { " ▒▒ ", "Recently opened files:" } },
          secondaryColors = { { "label_1", "" } }
        },
        "",
        {
          type = "recents",
          width = 0.8,
          useIcons = true,
          useAnchors = true,
          entryCount = 5,

          colors = {
            name = { "name_1", "name_2", "name_3", "name_4", "name_5" },
            number = { "name_1", "name_2", "name_3", "name_4", "name_5" }
          },
        },
      }
    },
  },

  recents_in_current_dir = {
    components = {
      action = "append",
      value = {
        "",
        "",
        {
          type = "banner",
          width = 0.8,
          lines = { { " ▒▒ ", "Recently opened files in ", "current", " directory:" } },
          secondaryColors = { { "label_1", "", "Special", "" } }
        },
        {
          type = "banner",
          width = 0.8,
          lines = {
            { "      ", D.toRelative() }
          },
          secondaryColors = {
            { "", "Comment" }
          }
        },
        "",
        {
          type = "recents",
          width = 0.8,
          dir = true,
          useIcons = true,
          useAnchors = true,
          entryCount = 5,

          colors = {
            name = { "name_1", "name_2", "name_3", "name_4", "name_5" },
            number = { "name_1", "name_2", "name_3", "name_4", "name_5" }
          },
        },
      }
    },
  },

  list_shade = {
    globalHighlights = {
      action = "append",
      value = {
        name_1 = { fg = "#cdd6f4" }, name_2 = { fg = "#afb7d3" }, name_3 = { fg = "#9298b2" }, name_4 = { fg = "#757a91" }, name_5 = { fg = "#585b70" }
      }
    }
  }
};

P.cats = {
  default = {
    components = {
      {
        width = 12,
        lines = A.cat,
        colors = "cat_1"
      }
    }
  },

  c1x2 = {
    components = {
      action = "overwrite",
      value = {
        {
          width = 24,
          lines = A.cat_1x2,
          secondaryColors = {
            { "cat_1", "cat_2" },
            { "cat_1", "cat_2" },
            { "cat_1", "cat_2" },
            { "cat_1", "cat_2" },
          }
        }
      }
    }
  },

  c2x2 = {
    components = {
      action = "overwrite",
      value = {
        {
          width = 24,
          lines = A.cat_2x2,
          secondaryColors = {
            { "cat_1", "cat_2" },
            { "cat_1", "cat_2" },
            { "cat_1", "cat_2" },
            { "cat_1", "cat_2" },
            nil,
            { "cat_4", "cat_5" },
            { "cat_4", "cat_5" },
            { "cat_4", "cat_5" },
            { "cat_4", "cat_5" },
          }
        }
      }
    }
  },

  c1x3 = {
    components = {
      action = "overwrite",
      value = {
        {
          width = 36,
          lines = A.cat_1x3,
          secondaryColors = {
            { "cat_1", "cat_2", "cat_3" },
            { "cat_1", "cat_2", "cat_3" },
            { "cat_1", "cat_2", "cat_3" },
            { "cat_1", "cat_2", "cat_3" },
          }
        }
      }
    }
  },

  c1x4 = {
    components = {
      action = "overwrite",
      value = {
        {
          width = 48,
          lines = A.cat_1x4,
          secondaryColors = {
            { "cat_1", "cat_2", "cat_3", "cat_4" },
            { "cat_1", "cat_2", "cat_3", "cat_4" },
            { "cat_1", "cat_2", "cat_3", "cat_4" },
            { "cat_1", "cat_2", "cat_3", "cat_4" }
          }
        }
      }
    }
  },

  c3x3 = {
    components = {
      action = "overwrite",
      value = {
        {
          width = 36,
          lines = A.cat_3x3,
          secondaryColors = {
            { "cat_1", "cat_2", "cat_3" },
            { "cat_1", "cat_2", "cat_3" },
            { "cat_1", "cat_2", "cat_3" },
            { "cat_1", "cat_2", "cat_3" },
            nil,
            { "cat_4", "cat_5", "cat_6" },
            { "cat_4", "cat_5", "cat_6" },
            { "cat_4", "cat_5", "cat_6" },
            { "cat_4", "cat_5", "cat_6" },
            nil,
            { "cat_7", "cat_8", "cat_9" },
            { "cat_7", "cat_8", "cat_9" },
            { "cat_7", "cat_8", "cat_9" },
            { "cat_7", "cat_8", "cat_9" },
          }
        }
      }
    }
  },

  c3x1 = {
    components = {
      action = "overwrite",
      value = {
        {
          width = 12,
          lines = A.cat_3x1,
          colors = {
            "cat_1",
            "cat_1",
            "cat_1",
            "cat_1",
            "",
            "cat_4",
            "cat_4",
            "cat_4",
            "cat_4",
            "",
            "cat_7",
            "cat_7",
            "cat_7",
            "cat_7",
          }
        }
      }
    }
  },

  rosewater = {
    globalHighlights = {
      action = "overwrite",
      value = {
        cat_1 = { fg = "#F5E0DC" },
        cat_2 = { fg = "#F5E0DC" },
        cat_3 = { fg = "#F5E0DC" },
        cat_4 = { fg = "#F5E0DC" },
        cat_5 = { fg = "#F5E0DC" },
        cat_6 = { fg = "#F5E0DC" },
        cat_7 = { fg = "#F5E0DC" },
        cat_8 = { fg = "#F5E0DC" },
        cat_9 = { fg = "#F5E0DC" },
      }
    }
  },

  rosewater_alt = {
    globalHighlights = {
      action = "overwrite",
      value = {
        cat_1 = { fg = "#DC8A78" },
        cat_2 = { fg = "#DC8A78" },
        cat_3 = { fg = "#DC8A78" },
        cat_4 = { fg = "#DC8A78" },
        cat_5 = { fg = "#DC8A78" },
        cat_6 = { fg = "#DC8A78" },
        cat_7 = { fg = "#DC8A78" },
        cat_8 = { fg = "#DC8A78" },
        cat_9 = { fg = "#DC8A78" },
      }
    }
  },

  mauve = {
    globalHighlights = {
      action = "overwrite",
      value = {
        cat_1 = { fg = "#CBA6F7" },
        cat_2 = { fg = "#CBA6F7" },
        cat_3 = { fg = "#CBA6F7" },
        cat_4 = { fg = "#CBA6F7" },
        cat_5 = { fg = "#CBA6F7" },
        cat_6 = { fg = "#CBA6F7" },
        cat_7 = { fg = "#CBA6F7" },
        cat_8 = { fg = "#CBA6F7" },
        cat_9 = { fg = "#CBA6F7" },
      }
    }
  },

  mauve_alt = {
    globalHighlights = {
      action = "overwrite",
      value = {
        cat_1 = { fg = "#8839EF" },
        cat_2 = { fg = "#8839EF" },
        cat_3 = { fg = "#8839EF" },
        cat_4 = { fg = "#8839EF" },
        cat_5 = { fg = "#8839EF" },
        cat_6 = { fg = "#8839EF" },
        cat_7 = { fg = "#8839EF" },
        cat_8 = { fg = "#8839EF" },
        cat_9 = { fg = "#8839EF" },
      }
    }
  },

  yellow = {
    globalHighlights = {
      action = "overwrite",
      value = {
        cat_1 = { fg = "#F9E2AF" },
        cat_2 = { fg = "#F9E2AF" },
        cat_3 = { fg = "#F9E2AF" },
        cat_4 = { fg = "#F9E2AF" },
        cat_5 = { fg = "#F9E2AF" },
        cat_6 = { fg = "#F9E2AF" },
        cat_7 = { fg = "#F9E2AF" },
        cat_8 = { fg = "#F9E2AF" },
        cat_9 = { fg = "#F9E2AF" },
      }
    }
  },

  yellow_alt = {
    globalHighlights = {
      action = "overwrite",
      value = {
        cat_1 = { fg = "#DF8E1D" },
        cat_2 = { fg = "#DF8E1D" },
        cat_3 = { fg = "#DF8E1D" },
        cat_4 = { fg = "#DF8E1D" },
        cat_5 = { fg = "#DF8E1D" },
        cat_6 = { fg = "#DF8E1D" },
        cat_7 = { fg = "#DF8E1D" },
        cat_8 = { fg = "#DF8E1D" },
        cat_9 = { fg = "#DF8E1D" },
      }
    }
  },

  green = {
    globalHighlights = {
      action = "overwrite",
      value = {
        cat_1 = { fg = "#A6E3A1" },
        cat_2 = { fg = "#A6E3A1" },
        cat_3 = { fg = "#A6E3A1" },
        cat_4 = { fg = "#A6E3A1" },
        cat_5 = { fg = "#A6E3A1" },
        cat_6 = { fg = "#A6E3A1" },
        cat_7 = { fg = "#A6E3A1" },
        cat_8 = { fg = "#A6E3A1" },
        cat_9 = { fg = "#A6E3A1" },
      }
    }
  },

  green_alt = {
    globalHighlights = {
      action = "overwrite",
      value = {
        cat_1 = { fg = "#40A02B" },
        cat_2 = { fg = "#40A02B" },
        cat_3 = { fg = "#40A02B" },
        cat_4 = { fg = "#40A02B" },
        cat_5 = { fg = "#40A02B" },
        cat_6 = { fg = "#40A02B" },
        cat_7 = { fg = "#40A02B" },
        cat_8 = { fg = "#40A02B" },
        cat_9 = { fg = "#40A02B" },
      }
    }
  },

  blue = {
    globalHighlights = {
      action = "overwrite",
      value = {
        cat_1 = { fg = "#89B4FA" },
        cat_2 = { fg = "#89B4FA" },
        cat_3 = { fg = "#89B4FA" },
        cat_4 = { fg = "#89B4FA" },
        cat_5 = { fg = "#89B4FA" },
        cat_6 = { fg = "#89B4FA" },
        cat_7 = { fg = "#89B4FA" },
        cat_8 = { fg = "#89B4FA" },
        cat_9 = { fg = "#89B4FA" },
      }
    }
  },

  blue_alt = {
    globalHighlights = {
      action = "overwrite",
      value = {
        cat_1 = { fg = "#1E66F5" },
        cat_2 = { fg = "#1E66F5" },
        cat_3 = { fg = "#1E66F5" },
        cat_4 = { fg = "#1E66F5" },
        cat_5 = { fg = "#1E66F5" },
        cat_6 = { fg = "#1E66F5" },
        cat_7 = { fg = "#1E66F5" },
        cat_8 = { fg = "#1E66F5" },
        cat_9 = { fg = "#1E66F5" },
      }
    }
  },

  all_the_colors = {
    globalHighlights = {
      action = "overwrite",
      value = {
        cat_1 = { fg = "#F5E0DC" },
        cat_2 = { fg = "#F5C2E7" },
        cat_3 = { fg = "#CBA6F7" },
        cat_4 = { fg = "#EBA0AC" },
        cat_5 = { fg = "#FAB387" },
        cat_6 = { fg = "#F9E2AF" },
        cat_7 = { fg = "#A6E3A1" },
        cat_8 = { fg = "#89DCEB" },
        cat_9 = { fg = "#B4BEFE" },
      }
    }
  },

  all_the_colors_alt = {
    globalHighlights = {
      action = "overwrite",
      value = {
        cat_1 = { fg = "#DC8A78" },
        cat_2 = { fg = "#EA76CB" },
        cat_3 = { fg = "#8839EF" },
        cat_4 = { fg = "#E64553" },
        cat_5 = { fg = "#FE640B" },
        cat_6 = { fg = "#DF8E1D" },
        cat_7 = { fg = "#40A02B" },
        cat_8 = { fg = "#04A5E5" },
        cat_9 = { fg = "#7287FD" },
      }
    }
  },
}

return P;
