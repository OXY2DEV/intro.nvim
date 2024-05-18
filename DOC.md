https://github.com/OXY2DEV/intro.nvim/assets/122956967/b2ffb4ca-d543-46f6-8d7c-c4dbd42caa56

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
    - [🌌 How lists behave](#imp_list)
    - [⚓ Anchors](#imp_anchors)
  - [🎋 Banner](#banner)
  - [📜 Recent files](#recent_files)
  - [🗝️ Keymaps](#keymaps)
  - [⏰ Clock](#clock)
- [📼 Animations](#animations)

<h2 id="basics">🧭 Starting with some basics</h2>

Even though you may have followed the `installation` instruction, in some cases the plugin may not load properly. So, it is better to test if the plugin works or not.
For this example I am using `Lazy.nvim`. But the process should be similar for other **plugin managers**.

>[!NOTE]
> To remove *unnecessary codes & complexities* I have put the configuration for the plugin in a separate file.

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
    merge = false,

    showStatusline = false,
    shadaValidate = false,

    anchors = {
        position = "bottom",
        corner = "▒",

        textStyle = { bg = "#BAC2DE", fg = "#181825" },
        cornerStyle = { bg = "#BAC2DE", fg = "#181825" },
    },
    pathModifiers = {},
    openFileUnderCursor = "<leader><leader>",

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

- merge `boolean or nil`

  Used in case you want to merge your own configuration table with a `presets` configuration table. By default, it is set to `false`.

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

- openFileUnderCursor `string or nil`

  `Keymap` to open filw under the cursor. Only works when a `recentFiles` component is used.

  Default value is `<leader><leader>`.

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

  A `table` containing animation settings and all the animations. It has the following sub-properties.
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

<h4 id="imp_anchors">⚓ Anchors</h4>

If you ever used browsers on your PC, you may have noticed that when you **hover** over some **link** you get to see the **entire url** at the bottom left corner of the window.

`Anchors` in this plugin do the same thing but for file names.

>**Why not show the entire path?**
>
> Because, phones don't have enough spaces to show the entire **file path** and the plugin is made on a phone.
>
> Plus, there's no point in adding the **file path** since most of the time you would recognise the file with just it's name.


https://github.com/OXY2DEV/intro.nvim/assets/122956967/a507fc9a-cecb-4ea6-993d-6c593775d704


>[!TIP]
> The path shown by the `anchors` can be customised. So, if you have a long path(e.g. "~/.local/share/nvim/lazy/intro.nvim/lua/intro/") you can replace it with something easy to remember such as "📂 Lazy/intro/lua".
>
>>[!NOTE]
>> If you plan on using this you should add **longer paths** first in the `pathModifiers` table.

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

~~This is explained in more detail in the [coloring](#coloring) section.~~

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
>
> You can also skip over a line by using "skip".

```lua
require("intro").setup({
  components = {
    {
      lines = {
        { "Gradient", " | ", "solid" },
        { "Gradient", " | ", "solid" },
      },

      secondaryColors = {
        { "Red", nil, "Green" },
        "skip" -- remove this line to see the difference
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

A simple fading effect done using `gradientRepeat`.

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

<h3 id="recent_files">📜 Recent files</h3>

Show your recently opened files with *style*. It also supports `icons`, `keymap` for opening one of the files listed, ability to open a file of the list when it is under the cursor & much more.

It has the following sub-properties.

```lua
{
    type = "recentFiles",       -- Determines the components type
    style = "list",             -- Optional, changes how the items are shown

    entryCount = 5,             -- Optional, number of items to show
    width = 0.8,                -- Optional, width of the items

    useIcons = false,           -- Optional, enables/disables file icons
    useAnchors = true,          -- Optional, enables/disables file path preview
    dir = false,                -- Optional, directory whose files are shown

    gap = " ",                  -- Optional, the character used as spaces

    colors = {
        name = {},              -- Optional, color for file names
        path = {},              -- Optional, color for file paths(without the filename)

        number = {},            -- Optional, color for the item number

        spaces = {}             -- Optional, color for the spaces
    },

    anchorStyle = {
        corner = nil,           -- Optional, character to use as the anchor's corner

        textStyle = nil,        -- Optional, highlight group for the anchor text
        cornerStyle = nil       -- Optioanl, highlight group for the corner
    },

    keymapPrefix = "<leader>"   -- Optional, the prefix key for opening files on the list
}
```
- type `string or nil`

  Required for defining a `component`'s type.

- style `string or nil`

  Changes how the items are shown. By default, it is set to `list`.

  It's possible values are `list` & `list_path`.

> List
> ![list showcase](https://private-user-images.githubusercontent.com/122956967/329949462-1d62a7e5-a02a-4b57-877c-47cbeb25bdef.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MTU1ODMxNDIsIm5iZiI6MTcxNTU4Mjg0MiwicGF0aCI6Ii8xMjI5NTY5NjcvMzI5OTQ5NDYyLTFkNjJhN2U1LWEwMmEtNGI1Ny04NzdjLTQ3Y2JlYjI1YmRlZi5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDUxM1QwNjQ3MjJaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0zYWM0ODA1ODFjMjQwYjdhNzk1MTY5YTNlNmU2Njk4YmVkODAzZDRkODA2ZmZmYzBjZDJkYTZkODQ4NjQzNDFkJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.n-tW8q207YoJ7RsO_FLk-k1RMbvH82ABgoIlCZJ_vRg)

```lua
require("intro").setup({
  components = {
    {
      type = "recentFiles",
      style = "list",

      width = 0.6,
      useIcons = true
    }
  }
})
```

>list_paths
> ![list_path showcase](https://private-user-images.githubusercontent.com/122956967/329949478-f89ed3bb-f7cb-423f-8872-75ab0980f76a.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MTU1ODMxNDIsIm5iZiI6MTcxNTU4Mjg0MiwicGF0aCI6Ii8xMjI5NTY5NjcvMzI5OTQ5NDc4LWY4OWVkM2JiLWY3Y2ItNDIzZi04ODcyLTc1YWIwOTgwZjc2YS5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDUxM1QwNjQ3MjJaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1kM2I0YjUzMmFjYTBhNDhlMzQ0OWRmYjI1NGM2ZGMxYjRiZjVlYjdmNmQwZGYwMjU4OTYzMDc4MjBkZjAyNmFjJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.aBC5wepA4CxWrqzhgFUrkiX-Y6IwYVR2rZ4c6WhkCCY)

```lua
require("intro").setup({
  components = {
    {
      type = "recentFiles",
      style = "list_paths",

      width = 0.6,
      useIcons = true,

      -- just for styling purposes
      colors = {
        path = { "fade_3" }
      }
    }
  },

  globalHighlights = {
    fade_3 = { fg = "#878ca4" },
  }
})
```

- entryCount `number or nil`

  Number of items to show in the list. By default, it is `5`.

- width `number or nil`

  Changes how wide the lists should be. If the value is smaller than 1 it is used as % value.

  By default, it is set to `0.8`(80% of window width).

>[!IMPORTANT]
> Having a `width` smaller than the actual text results in the entire thing being centered.
> ![awkward_width]()


- useIcons `boolean or nil`

  Enable/Disable file icons. Requires `nvim-web-devIcons`. This also adds colors to the icons.

```lua
-- plugins.lua
{
    "OXY2DEV/intro.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },

    config = function ()
        require("intro").setup({
            components = {
                {
                    type = "recentFiles",
                    useIcons = true
                }
            }
        });
    end
}

-- plugins/intro.lua
return {
    "OXY2DEV/intro.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },

    config = function ()
        require("intro").setup({
            components = {
                {
                    type = "recentFiles",
                    useIcons = true
                }
            }
        });
    end
}
```

- useAnchors `boolean or nil`

  Enable/Disable the **file path preview**. By default, it is set to `true`. Check the [anchors](#imp_anchors) section to see what `anchors` are.

- dir `boolean or string or nil`

  Changes which files are listed. When set to `true`, only the files in the **current working directory** are shown. When set to a `string`, `string.match()` is used to find files to list.

  If set to `false` or `nil`, all the files are listed. By default, it is set to `false`.

>[!TIP]
> You can set `shadaValidate` to `true`, if you want to only show files that **exist**.

For example, you can tell the plugin to only show files that **exist** and files that are **in your current directory**.

```lua
require("intro").setup({
    shadaValidate = true,

    components = {
        {
            type = "recentFiles",
            dir = true,

            -- Optional
            useIcons = true,
        }
    }
});
```

- gap `string or nil`

  Character(s) to use as **empty spaces** between the `file name` & the `entry number`. Default is " "

```lua
require("intro").setup({
    components = {
        {
            type = "recentFiles",
            gap = "•",

            -- Optional
            useIcons = true,
        }
    }
});
```

>[!TIP]
> You can use `gap` along with `colors` to further customise your `recentFiles` component.

Example usage of both.

```lua
require("intro").setup({
    components = {
        {
            type = "recentFiles",
            gap = "•",

            colors = {
              spaces = {
                { "fade_1", "fade_2", "fade_3", "fade_4", "fade_5", "fade_4", "fade_3", "fade_2", "fade_1", "fade_0" }
              }
            },

            -- Optional
            useIcons = true,
            gradientRepeat = true
        }
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

- colors `table or nil`

  Define `highlight group(s)` to color the various parts of the list. It has the following sub-properties.
    - name
    - path
    - number
    - spaces

```lua
{
    name = nil,     -- Changes the color of file names
    path = nil,     -- Changes the color of file paths(without the file name)
    number = nil,   -- Changes the color of the list number
    spaces = nil    -- Changes the color of the spaces between the file name
                    -- and the list number
}
```
All of them support `gradient` colors. You can also skip items by using "skip" as their value.

Just like all the other properties who support `lists`, the last `non-nil` value is used if an item has `nil` value for it.

- keymapPrefix `string or nil`

  The **key** to use for easily opening files. Even though you can open files under the cursror using `openFileUnderCursor`, sometimes you need to quickly open a file.

  So, by using the `keymapPrefix` followed by the **item number** you can easily open a file without needing to move the **cursor**.

<h3 id="keymaps">🗝️ Keymaps</h3>

A **fancy** way of setting keymaps. Supports silently setting them up to in case you don't like the style options.

It has the following sub-properties.

```lua
{
    style = "list",         -- Optional, changes how keymaps are shown

    columnSeparator = " ",  -- Optional, characters added between columns
    separatorHl = "",       -- Optional, color for the characters between columns
    maxcolumns = 4,         -- Optional, max number of columns per line

    lineGaps = 0            -- Optional, number of gaps between each items
}
```

- style `string or nil`

  Changes how items are shown in the buffer. Can be either `silent`, `columns` or `list`

  By default, it is set to "list".

Here's a demonstration of the `columns` style.

```lua
require("intro").setup({
    components = {
        {
            type = "keymaps",

            style = "columns",
            lineGaps = 1,

            -- Optional
            columnSeparator = " ║ ",
            separatorHl = "Comment",

            keymaps = {
                {
                    text = { "  ", "M", "inimap" },
                    colors = { "sky", "sky_1", "sky" },

                    keyCombination = "M",
                    keyAction = ":lua require('mini.map').toggle()<CR>",
                },
                {
                    text = { "  ", "T", "elescope" },
                    colors = { "comp", "comp_1", "comp" },

                    keyCombination = "T",
                    keyAction = ":Telescope<CR>",
                }
            }
        }
    },

    globalHighlights = {
        sky = { fg = "#89B4FA" },
        sky_1 = { fg = "#89B4FA", underline = true },
        comp = { fg = "#F9E2AF" },
        comp_1 = { fg = "#F9E2AF", underline = true }
    }
});
```

- columnSeparator `string or nil`

  The Character(s) to use as **separator** between the columns. Only works when `style = "column"`.

  By default, it is " ".

- separatorHl `string or table or nil`

  The highlight group(s) to use for the `columnSeparator`. Also supports gradients.

- maxColumns `number or nil`

  The maximum number of columns on a single line. Can be used for styling purposes. Only works when `style = "column"`.

  By default, it is set to 4.

- lineGaps `number or nil`

  Number of empty lines between each item in the list. Only works when `style = "list"`. Default value is 0.


<h3 id="clock">⏰ Clock</h3>

Fancy way of showing the current time.

This component has the following sub-properties.


```lua
{
    style = {
        clockStyle = "basic",       -- Optional, style for the component
        textStyle = "filled",       -- Optional, style for the texts in the component

        clockParts = {              -- Optioanl, parts for the borders
            "╭", "─", "╮",
            "│", " ", "│",
            "╰", "─", "╯"
        },
        colon = " • "               -- Optioanl, character used as : in the clock
    }

    colors = {
        spaces = "",                -- Optional, color for the empty spaces
        colon = "",                 -- Optional, color for the colon
        border = "",                -- Optional, color for the borders
                                    
        hour = "",                  -- Optional, color for the hour part
        minute = "",                -- Optional, color for the minute part
        second = "",                -- Optioanl, color for the second part
        dayNight = "",              -- Optional, color for "am" or "pm" text
                                    
        day = "",                   -- Optioanl, color for the day of the week
        date = "",                  -- Optioanl, color for the date
        month = "",                 -- Optioanl, color for the month name
        year = ""                   -- Optioanl, color for the year
    }
}
```

- style `table or nil`

  Changes the appearance of the component. It has the following sub-properties.
    - clockStyle `string or nil`

      Changes how the clock is shown. Currently available options are `basic` & `compact`. Default is `basic`.

    - textStyle `string or nil`

      Chnages how the Numbers/digits are shown. Currently available values are `rounded`, `blocky`, `dotted` & `filled`.

      The default is `filled`.

    - clockParts `table or nil`

      A table containing various parts of the borders. You can see the code block above to check which value representa what border part.

    - colon `string or nil`

      Character(s) to use as colons between parts of the clock. Only works when `clockStyle = "basic"`.

Example usage of `style`.

```lua
require("intro").setup({
    components = {
        {
            type = "clock",

            style = {
                colon = " • ",
            },

            colors = {
                border = "comp",

                hour = "sky",
                minute = "sky",
                second = "sky",

                dayNight = "comp"
            }
        }
    },

    globalHighlights = {
        sky = { fg = "#89B4FA" },
        comp = { fg = "#F9E2AF" },
    }
});
```

- colors `table or nil`

  Changes the colors for various parts of the component. Supports `gradients`. By default, no color is applied.
  
  Check the table with all the properties to see what all of the sub-properties do.

```lua
require("intro").setup({
    components = {
        {
            type = "clock",

            -- Optional
            style = {
                colon = " • ",
            },

            colors = {
                border = "comp",

                hour = "sky",
                minute = "sky",
                second = "sky",

                dayNight = "comp"
            }
        }
    },

    globalHighlights = {
        sky = { fg = "#89B4FA" },
        comp = { fg = "#F9E2AF" },
    }
});
```

---

As you may have noticed, the last 2 components provides less options then the 1st component. This is because you adding more configuration option wouldn't really add anything since you can get the exact thing done by using `banner` component(most of the time).

Also, I ran out of idea on what customisation options to add 😶. So, if you have an idea feel free to open an issue describing it.

---

<h2 id="animations">📼 Animations</h2>

Now, that you have successfully added things to the screen, it is about time you learned how to animate things.

There are 2 types of animations available in this plugin.
  1. highlightBased
  2. textBased

---

Before learning to make your own animations, you should at least learn a bit about how the plugin animates things.
This **might help** you better fine tune your animations and time them properly.

> **ISSUE 1: Creating the illusion of animations**
>
> Neovim runs in a `terminal` and as such has no way to actually do animations. So, the plugin uses `nvim_set_hl()` for the color related animations and `nvim_buf_set_text()` & `nvim_buf_set_extmarl()` for the text related animations.
>
> These functions are called at a specific `interval` which fakes an animation(idea was taken from `windline.nvim`). So, to create an animation that doesn't feel like a `slideshow` you need to have a large number of `values`. More values(especially in the case transitioning of `colors`) can make the animations feel much smoother then they really are.

> **ISSUE 2: The timer problem**
>
> To run something in a loop you need to either **A.** use some type of `sleep()` function along with a loop statement or **B.** use a `timer`.
>
> In this plugin I use `vim.loop.new_timer()`(`vim.uv.new_timer()` in 0.10) as this gives me more control over the animation(s).
>
> However, this also comes with it's own issues. Depending on your **hardware**, calling too many `new_timer()` can cause neovim to **crash**. So, instead of having a new timer for every animation the plugin uses 1 timer for the `animation loop` which handles all the animations.
>
> As such, to provide ways to individually control the animations this plugin has something called `frames`.

>[!NOTE]
> **What are frames?**
>
> Every iteration of the `animation loop` is considered a frame(as they render a single frame of all the animations). Frames are used as a way to mimic the options provided by animation libraries. You can change the delay between each frame by changing the `updateDelay`. All the animations have `startDelay`, `frameDelay` & `loopDelay` for controlling various parts of the animation.
>
> `startDelay` controls the number of frames to wait before starting an animation, `frameDelay` does the same thing but the delay is used when switching from one value to another in the animation. And finally, `loopDelay` is used to wait between every loop of an animation.


>[!IMPORTANT]
> Color related animation values are applied first. So, this can change how texts are colored in the animations(if you use that highlight for coloring).

---

The `animations` property has the following options
```lua
animations = {
    delay = 0,
    updateDelay = 200,

    highlightBased = {},

    textBased = {}
}
```

`delay` is used for controlling **when** all the animations start, `updateDelay` is used for controlling the `speed` of all the animations.

On the other hand, `highlightBased` & `textBased` are containers for the different types of `animations`. Animations have a few common properties.

```lua
{
    loop = false,               -- Controls the looping of an animation

    startDelay = 0,             -- Number of frames to wait before starting
                                -- the animation
    frameDelay = 0,             -- Number of frames to wait before an animation
                                -- switches to the next value
    loopDelay = 0,              -- Number of frames to wait between loops

    -- internally set values

    __state = "play",           -- State of the animation during a frame
    __loopFinished = 0,         -- Number of loop finished
    __thisFrameIndex = 0,       -- Current value's index
    __delayPassed = 1           -- Number of idle frames passed
}
```

- loop `number or boolean or nil`

  Controls the looping of a specific `animation`. When set to `true`, the animation will repeat forever. When it is set to a `number`, it will repeat that number of times.

>[!NOTE]
> The first time an animation is completed it is not counted as a `loop`. 
>
> So, `loop = 1` will result in the animation happening **twice**(once from the main animation & once for the `loop = 1`).

- startDelay `numbet or nil`

  Number of frames to wait before starting an animation.

- frameDelay `number or nil`

  Number of frames to wait before changing the current value of an animation. It is useful for controlling a specific animations **speed**.

For example,
```lua
{
    frameDelay = 5,
    values = {
        "A         ",
        "An        ",
        "An        ",
        "An e      ",
        "An ex     ",
        "An exa    ",
        "An exam   ",
        "An examp  ",
        "An exampl ",
        "An example"
    }
}
```
This will result in the animation loop waiting 5 frames of time before changing the applied value. In this case, the applied value will be "A         " first and it will not change in the next **5** frames. Afterwards, it will change to "An        " and it will be repeating the same thing for all the other values too.

- loopDelay `number or nil`

  Number of frames to wait before starting a loop.

---

- \_\_state `string` 
  <sub>internally set</sub>

  A string defining what an animation will do in the current `frame`. The posibble `states` are `play`, `start_delay`, `frame_delay`, `loop_delay`, `over`.

  When an animation is completed it's `\_\_state` becomes `over`.

- \_\_loopFinished `number`
  <sub>internally set</sub>

  The number `loops` an animation has completed. The value is increased by 1 when the value of `\_\_thisFrameIndex` becomes larger then the number of values in an animation and `loops` isn't **false** or **nil** for that animation.

- \_\_thisFrameIndex `number`
  <sub>internally set</sub>

  The index of the current `value` of an animation.

- \_\_delayPassed `number`
  <sub>internally set</sub>

  The number of frames passed in a delay.

<h3 id="anim_hl">🪩 Color related animations</h3>

Also called `highlightBased`. This table contains highlight group related animations.

Highlight group related animations have the following structure.

```lua
{
    groupName = "",
    values = {},

    loop = false,
    startDelay = 0,
    frameDelay = 0,
    loopDelay = 0
}
```

- groupName `string`

  Name of the `highlight group`. The plugin will first check if a highlight group with the `string` is present or not. If its not present then a prefix("Intro_") is added before the `string`.

- values `table`

  A list containing all the values for an animation. Check the `{opts}` section of `nvim_set_hl()` in the help files for all the valid options.


Example usage.

```lua
require("intro").setup({
    components = {},    -- components needs to be something for the plugin
                        -- to work
    animations = {
        delay = 500,        -- Large delay to prevent being suppressed by other plugins
        updateDelay = 25,   -- Small update delay for smoither transitioning

        highlightBased = {
            {
                groupName = "Normal",
                values = {
                    { bg = "#1e1e2e" }, { bg = "#272738" }, { bg = "#303142" }, { bg = "#393b4d" }, { bg = "#424457" }, { bg = "#4c4e62" }, { bg = "#55586c" }, { bg = "#5e6176" }, { bg = "#676b81" }, { bg = "#70758b" }, { bg = "#7a7e96" }, { bg = "#8388a0" }, { bg = "#8c92ab" }, { bg = "#959bb5" }, { bg = "#9ea5bf" }, { bg = "#a8afca" }, { bg = "#b1b8d4" }, { bg = "#bac2df" }, { bg = "#c3cce9" }, { bg = "#cdd6f4" }
                }
            }
        }
});
```

Now, you can *flashbang* yourself every time you open Neovim. 🙂

<h3 id="anim_tx">📃 Text related animations</h3>

>[!WARNING]
> New feature, so things may be a bit buggy sometimes.

Also called `textBased`. Holds text related animations as `tables`.

Text related animations have the following structure.

```lua
{
    mode = "",
    position = "",
    updateCache = false,

    x = 0,
    y = 0,

    values = {},
    colors = {},
    secondaryColors = {},

    gradientRepeat = {}
}
```

- mode `string`

  Changes how the text animation will be applied. Available options are `line`, `virt_text`.

>[!NOTE]
>
> Changes made by `virt_text` are not permanent as it uses virtual text for it.

- position `string`

  Allows to switch between either changing a line in the buffer by it's index or changing the lines made by the components. Possible values are `fixed`, `relative`.

  When set to `fixed`, the value of `y` is used as the line number in the buffer. On he other hand, if it is set to `relative` the value of `y` is set relative to where the components started to render the text.

- updateCache `boolean or nil`

  You can use this to make the changes permanent. ONLY works when `position = "relative"`.

- x `number`

  The position of the text in the X-axis. Only works when `mode = "virt_text"`.

- y `number`

  The position of the text in the Y-axis.

- values `table`

  Holds all the text values that will be looped through. Texts can be `strings` or `tables`.

- colors, secondaryColors, gradientRepeat

  Works exactly like in [banners](#banners)






