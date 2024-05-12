<img align="center" src="https://github.com/OXY2DEV/intro.nvim/assets/122956967/fa61c4b0-bff3-4cc8-815b-820c6f887194">

<h1 align="center">Intro.nvim</h1>
<p align="center">Animated <code>:intro</code> for Neovim</p>

If you don't like what the `presets` provide or just want to make your own start screen from scratch, then this is for you.

The documentation here is written like a tutorial. However, there are useful links provided here so that you can easily jump to whichever topic you may need. You can still find the normal documentation by checking the `intro.nvim` help file.

>[!NOTE]
> The documentation was written inside `Neovim` & viewed using `Glow`. As such some things may not render properly.
> They will be patched out through later commits.

<h2>📖 Table of contents</h2>

- [🧭 Starting with some basics](#basics)
  - [🔩 Fixing issues](#issues)
- [🚀 Configuration table](#config)
- [📦 Components](#components)
  - [🧰 Important information you should know](#imp_info)
  - [🎋 Banner](#banner)

<h2 id="basics">🧭 Starting with some basics</h2>

Even though you may have followed the `installation` instruction, in some cases the plugin may not load properly. So, it is better to test if the plugin works or not.
For this example I am using `Lazy.nvim`. But the process should be similar for other **plugin managers**.

>[!NOTE]
> To remove *unnecessary codes & complexities* I have put the configuration for the plugin in a seperate file.

To test the plugin, just using the `setup()` function is enough. 

```lua
require("intro").setup();
```

Now, if you open `Neovim` you should see this,

https://github.com/OXY2DEV/intro.nvim/assets/122956967/fe6c12ec-db6d-45f4-9208-fa8712d00c4a

<h3 id="basics">🔩 Fixing issues</h3>

If the start screen doesn't behave like its supposed to. You may see one of the following behavior.

- Neovim opens into an empty buffer, but nothing shows up.

  You can check the `messages` to look for *error logs*.
  To open the `messages` tab run `:messages`. If it doesn't open anything, it means there was no error log.
  This means the plugin either *failed to load* or an *exception* occured.

- Colors aren't applied.

  This can be caused due to a `colorscheme` plugin being loaded after `intro.nvim`.
  To solve it you just have to load the `colorscheme` plugin first. Because setting the `colorscheme` clears all the `highlight groups`.

- Animation not playing(Jumps to final value).

  This is caused due to the animations starting too quickly. This can happen when other plugins do something after neovim starts that prevents the buffer from updating.
  You can fix this by adding a large value to the `delay` in the `animations` table.

```lua
require("intro").setup({
   animations = {
        delay = 500
   }
})
```
- Animation not playing smoothly

  This is caused when a small `updateDelay` is set. A small value is usually used for a *smoother* animation but it comes at the cost of *performance*.
  It can also happen if your terminal has some type of **settings** related to how quickly the termimal can **refresh**.
  You can either increase the `updateDelay` or change your terminal settings.

```lua
require("intro").setup({
    animations = {
        updateDelay = 100
    }
});
```

If none of them happen and the plugin still *doesn't load*, then you should open a new *issue*. Check the **README** to see how to open a *proper issue*.

<h2 id="config">🚀 Configuration table</h2>

First things first, if you want to get the most out of this plugin you should knkw how to use all the options

These are all the options the plugin provides.

```lua
require("intro").setup({
    preset = {
        name = "nvim",
        opts = { "animated" }
    },

    showStatusline = false,
    shadaValidate = false,

    anchors = {
        position = "bottom",
        corner = "▒",

        textStyle = { bg = "#BAC2DE", fg = "#181825" },
        cornerStyle = { bg = "#BAC2DE", fg = "#181825" },
    },
    pathModifiers = {},

    components = {},
    globalHighlights = {},

    animations = {
        delay = 0,
        updateDelay = 200,

        highlightBased = {},
        textBased = {}
    }
})
```

Here's what all the options do, their value type and other *useful* informations.

- preset `string or table or nil`

  Sets one of the presets in the `presets.lua` file using the **name**.
  When set to a `string` it uses the preset matching the name with the **default** options.
  When it is a `table` the `name` is used to find the *preset* and the options in the `opts` is used to configure it.

```lua
require("intro").setup({
    preset = "nvim",
    -- Uses the "nvim" preset

    preset = {
        name = "nvim",
        opts = { "animated" }
    }
    -- uses the "nvim" preset with the "animated" option for it
})
```

>[!TIP]
> The **order** in the `opts` list **matters**. Due to how presets work some presets may override settings set by other presets.
> As such, it is recommended to use `component` presets first followed vy the `color` presets and then the `animation` presets.

- showStatusline `boolean or nil`

  Shows/Hides the `statusline`.
 
  It uses `laststatus` to hide the `statusline`. When you leave the `Intro` buffer(more specifically when the `BufDelete` event is emitted) the value of `laststatus` is set back to the original value.
  The default value is `false`.

>[!WARNING]
> Originally the event used was `BufLeave`. However, due to `BufLeave` being fired when `virtual windows` open it was changed to `BufDelete`.

```lua
require("intro").setup({
    showStatusline = false
})
```

- shadaValidate `boolean or nil`

  Enable/Disable the filtering of `oldfiles`.
  When set to `true` the plugin will **not** show files that don't exist. 

```lua
require("intro").setup({
    shadaValidate = false
});
```
>[!IMPORTANT]
> As this feature uses a `for` loop, it may sometimes impact Neovim's performance. However, I couldn't find any significant change in load time of the plugin, so I can't really tell to what extent this happens.


- anchors `table or nil`
>[!NOTE]
> If you are curious about what `anchors` are, they show the `path` of the file under cursor. It is **only** used when `recents` component is present in your configuration table.
> You can also **disable** it if you like.

Changes how anchors behave. Has the following sub-properties,
   1. position `string or nil`
   2. corner `string or nil`
   3. textStyle `table or nil`
   4. cornerStyle `table or nil`

```lua
require("intro").setup({
    anchors = {
        position = "bottom",
        corner = "",

        textStyle = { fg = "#ffffff" },

    }
})
```
The sub-properties have the following purposes.

1. position `string or nil`

  Changes the position of the `anchors`. Currently available values are `top` and `bottom`.
  Default value is `bottom`.

2. corner `string or nil`

  Changes the character(s) used as the corner of the `anchor`.
  Default is ▒.

3. textStyle `table or nil`

  Sets the option(s) for the `Intro_anchor_body` highlight group.
 
  You can check all the valid options with `:h nvim_set_hl()`.

4. cornerStyle `table or nil`

  Sets the option(s) for the `Intro_anchor_corner` highlight group.
 
  You can check all the valid options with `:h nvim_set_hl()`.


- pathModifiers `table or nil`

  Modify how specific `file paths` are shown. All the items should be `tuples`. The first item of it will be the `pattern` and the second will be the `replacemant`.

```lua
require("intro").setup({
    pathModifiers = {
        { "~/.config/nvim/lua/plugins/", "🔌 Plugins/" },
        { "~/.config/nvim/lua/", "📓 Lua/" },
        { "~/.config/nvim/", "💻 Neovim/" }
    }
})
```

>[!NOTE]
> This only affects `anchora` and doesn't impact how files are shown in the `recents` component.

>[!TIP]
> As the plugin loops through the list, it is recommended that you add longer files first to prevent some of them from not working.

For example,

```lua
require("intro").setup({
    pathModifiers = {
        { "~/.config/", "🔩 Config/" },
        { "~/.config/nvim/", "💻 Neovim" }
    }
});
```
This will result in `~/.config/nvim` showing up as `🔩 Config/nvim/` instead of `💻 Neovim`. So, **longer** paths should go first in the list.

- components `table`

  A list containing all the components you will use.
  More information on `components` are available in the [components](#components) section.

>[!TIP]
> If you don't want to clutter your `setup()` you can assign each property to a variable and then use them. This improves readability and prevents too many `nested tables` from appearing.

```lua
local intro_c = {
    "Hello World"
};

local intro_hl = {
    test = { fg = "red" }
};


require("intro").setup({
    components = intro_c,
    globalHighlights = intro_hl
});
```

- animations `table or nil`

  table containing animation settings and all the animations.

It has the following sub-properties.
1. delay `number or nil`
2. updateDelay `number or nil`
3. highlightBased `table or nil`
4. textBased `table or nil`

Here's what all of them do.

- delay `number or nil`

  Time(in *miliseconds*) to wait before starting all the animations. The default value is 0.

```lua
require("intro").setup({
    animations = {
        delay = 500
    }
});
```

>[!TIP]
> If you can't see the *animations* play then using a higher `delay` may solve the issue.

- updateDelay `number or nil`

  Time(in *miliseconds*) between each animation frames. The default value is 200.

```lua
require("intro").setup({
    animations = {
        updateDelay = 100
    }
})
```

>[!TIP]
> You can use a *small* `updateDelay` for smoother animations. However, it can sometimes slow down `Neovim`(especially when you have a lot of animations).

- highlightBased `table or nil`

  Table containing animations related to `highlight groups`. More information is in the [animations](#animations) section.

- textBased `table or nil`

  Table containing animations related to `virtual texts`. More information is in the [animations](#animations) section.


<h2 id="components">📦 Components</h2>

Now that you have a *general idea* of the various options the plugin provides. We can get to the fun part.

First thing first, let's add a simple text to the **Buffer**.

```lua
require("intro").setup({
    components = {
        "Hello world"
    }
});
```

Now, if you open `Neovim`, you should see "Hello World" being added to the screen. It's not `centered` like some may expect, this is intended.

This is called a *Raw* component and it is used when there is a `string` in the `components` table.

>[!NOTE]
> I will be adding a way to change how *Raw* components behave in a later commit so keep an eye out for that.

---

<h3 id="imp_info">🧰 Important information you should know</h3>

Here are some things that you may need to know before using the `components`.

<h4 id="imp_list">🌌 How lists behave</h4>

In some of the properties & sub-properties, you may notice that they also accept `table` version of their actual values.

For example, You can set the **alignment** of `lines` like this.
```lua
require("intro").setup({
    components = {
        {
            align = "center"
        }
    }
});
```

But, you can also do this.
```lua
require("intro").setup({
    components = {
        {
            align = { "left", "center" }
        }
    }
});
```
This will result in the first `line`/`entry` to be aligned `left` and the rest of the `lines`/`entries` to be aligned `right`.

>[!IMPORTANT]
> When used as a `table`, the `table` can't have `nil` inside of it. As it uses a `for` loop and `nil` values will stop the loop. Thus, the values after that will **not** be used.

If the `table` is shorter than the number of `lines`/`entries` then the last `non-nil` value will be used for the lines that have no value.

---

Now, we will go over the first(& probably the most customisable) `component`.

<h3 id="banner">🎋 Banner</h3>

Originally created to handle `text arts`, this `component` provides an easy way to apply colors, styles etc. to a group of texts.

It has the following sub-properties.

```lua
{
    type = "banner",        -- Optional, determines the type of component a table is
    width = "auto",         -- Optional, defines a custom width for the lines
    align = "center",       -- Optional, defines the alignment of lines

    lines = {},             -- The lines to add to the buffer
    functions = {},         -- Optional, functions whoose values replaces the
                            -- function names in lines

    colors = {},            -- Optional, main color for the lines
    secondaryColors = {},   -- Optional, changed colors in specific parts of the
                            -- lines
    gradientRepeat = false  -- Optional, changes how gradients are applied
}
```

- type `string or nil`

  Determines what `component` a table is considered. By default, it is set to `banner`.

>[!IMPORTANT]
> `type` is used in all the `components`. So, if a `component` doesn't work, it may be due to not defining a `type`.

- width `number or nil`

  Adds a custom `width` to the lines. By default, it is set to `auto`.

  When the value is larger than or equal to 1, it is directly used. However, if it is smaller than 1, it will be used as a % value. For example, 0.5 will be **50%** of **window width**.

>[!TIP]
> Percentage(%) values are updated on `window resize` so they can be used for headers.

```lua
require("intro").setup({
    components = {
        {
            type = "banner",
            width = 0.8,

            lines = {
                "A line"
            }
            -- This will lead to "A line" behaving like it takes 80% of the total screen width
        }
    }
});
```

>[!TIP]
> You can set a custom width to fix `alignment` on `text arts` who have characters that take up more spaces than a normal character.
> `Nerd font` characters **DO NOT** take more than a single character's space. So, you don't have to worry about **setting a width** in this scenario.


- align `string or nil`

  Changes the **alignment** of the `lines`. By default, it is set to `center`.

  Texts can have an **alignment** of either `left`, `right` or `center`.

>[!IMPORTANT]
> `align` is one of the sub-properties who can also be a `table`. When it's a table it uses the `line` index to find the value of that line.

You can use this *special* property to customise even more. For example,

```lua
require("intro").setup({
    components = {
        {
            type = "banner",
            lines = {
                "A line",
                { "A", " line ", "as a", " table" },
                "Another line"
            },

            align = {
                "left",
                "right",
                "center"
            }
        }
    }
});
```

This will result in "A line" being put on the `left side` of the screen, "A line as a table" on the `center` and "Another line" on the `right side` of the screen.

- lines `table`

  A **list** containing `lines` to show. Lines can be either `string` or `table` depending on usage.

>[!NOTE]
> **String or a table?** 🤔
>
> `Strings` are used for general usage. However, when you have texts in that line thay needs to be **dynamically** changed or if you want a **different coloring** on a specific part of the lines, then you may use a `table`.
>
> A `table` can have **texts** that can be the name of a property in `functions`. In this case, the result of that function is going to be added to th `line` instead of the original text.

For example,

```lua
require("intro").setup({
    components = {
        {
            type = "banner",

            lines = {
                { "Hello", "name" }
            },
            functions = {
                name = function()
                    return "User"
                end
            }
        }
    }
});
```

This will result in "Hello User", instead of "Hello name".

>[!TIP]
> **Using tables for complex coloring:** 🎨
>
> You can also use a `table` to add complex colors to your `lines`.

For example,

```lua
require("intro").setup({
    components = {
        {
            type = "banner",

            lines = {
                { "Red", "Blue" }
            },

            -- These are custom highlight group names
            secondaryColors = {
                { "rd", "bl" }
            }
        }
    },

    -- Custom highlight groups are defined here
    globalHighlights = {
        rd = { fg = "red" },
        bl = { fg = "blue" }
    }
});
```
This will result in "Red" having a **red** color and "Blue" having a **blue** color.

This is explained in more detail in the [coloring](#coloring) section.

- functions `table or nil`

  Allows you to define `functions` to use in the `lines`. Function values replace the function names in a line(this only happens if the line is a `table`).

>[!NOTE]
> `functions` value only update when either `:Refresh` is called or when the `window resize` event is fired. As I didn't want to update the buffer all the time for no reason(due to the risk of **performance reasons**, especially on older hardware).

You can use it to do something like this.

```lua
require("intro").setup({
  components = {
    {
      lines = {
        { "Current time is: ", "time" }
      },

      -- This part is just for styling purposes
      secondaryColors = {
        { "Comment", "Special" }
      },

      functions = {
        time = function ()
          return os.date("%X");
        end
      }
    }
  }
})
```

This will show your **current time** in place of "time".

- colors `table or nil`

  A `table` defining the coloring of the `lines`. It also supports `gradients`.

>[!NOTE]
> Coloring is based on `highlight groups`, so you can't just directly add the color codes themselves. This increases the flexibility of the plugin.
>
> This also allows the usage of things like **bold**, *italics*, ~~strikethrough~~ etc.

For example,

```lua
require("intro").setup({
  components = {
    {
      -- underscores used for better visibility
      lines = {
        "A_line",
        { "A_line", "_as_", "a_table" }
      },

      colors = {
        { "Special", "Comment", "Function", "Conditional" }
      },

      -- Optional, if you want to see a repeating gradient
      gradientRepeat = true
    }
  }
});
```
This will result in a simple `4 color` gradient to be used in coloring the text.

>[!IMPORTANT]
> **Why not make the gradient happen automatically by using the start & stop values?**
>
> The reason the plugin doesn't provide that option is simple. It is just **not worth** it. For it to work with just the **start** & **stop** values, the plugin will need to calculate it every time a new `gradient` appears. This is not good, at least performance-wise. There's no point in having a feature if you can't even use it.
>
> Plus you can do the exact same thing by running `:Gradient <from> <to> <steps>`(uses the `hex` colorcodes without the `#`).
>
> And you can't even add a *multi-stop* `gradient` with it. Ans it will lead to *unnecessary complexities* on specific cases(especially on longer lines).


- secondaryColors `table or nil`
  Coloring option for when you need to color a certain part of a `line` differently.
  This also works with `gradients` too.

>[!IMPORTANT]
> For `secondaryColors` to work, the `line` **must be** a table. If it's not obvious, without knowing where to change the color the plugin won't be able to add the color.

```lua
require("intro").setup({
  components = {
    {
      lines = {
        { "Red", " | ", "Green" },
        { "Gradient", " | ", "solid" }
      },

      secondaryColors = {
        { "Red", nil, "Green" },
        { { "Red", "Green" }, nil, "Special" },
      },

      -- Optional, For better visibility
      gradientRepeat = true
    },

  },

  globalHighlights = {
    red = { fg = "#F38BA8" },
    green = { fg = "#A6E3A1" }
  }
});
```

>[!TIP]
> You can add a `nil` for a specific part of the `line` if you want to skip over it.

- gradientRepeat `boolean or table or nil`

  Enable/Disable the repeating of `gradients`. By default, it is set to `false`.


You can use it like this.

```lua
require("intro").setup({
  components = {
    {
      lines = {
        "A gradient text"
      },

      colors = {
        { "red", "green", "blue" }
      },

      gradientRepeat = true
    },

  },

  globalHighlights = {
    red = { fg = "#F38BA8" },
    green = { fg = "#A6E3A1" },
    blue = { fg = "#89B4FA" }
  }
});
```

This will make the gradient repeat itself.

However, the `gradientRepeat` can also have sub-properties.

```lua
{
    gradientRepeat = {
        colors = false,         -- controls the gradients in "colors"
        secondaryColors = false -- controls the gradients in "secondaryColors"
    }
}
```

This allows you to control the gradients in `colors` & `secondaryColors` individually.

>[!TIP]
> `gradientRepeat = false` can be used to make cool fading effects.

A simple fading effet done using `gradientRepeat`.

```lua
require("intro").setup({
  components = {
    {
      lines = {
        "A fading text"
      },

      colors = {
        { "fade_5", "fade_4", "fade_3", "fade_2", "fade_1" }
      },

      gradientRepeat = false
    },

  },

  globalHighlights = {
    fade_5 = { fg = "#cdd6f4" },
    fade_4 = { fg = "#aab1cc" },
    fade_3 = { fg = "#878ca4" },
    fade_2 = { fg = "#64677d" },
    fade_1 = { fg = "#414255" },
    fade_0 = { fg = "#1e1e2e" },
  }
});
```



