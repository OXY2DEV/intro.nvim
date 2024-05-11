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
> You can check the `messages` to look for *error logs*.
> To open the `messages` tab run `:messages`. If it doesn't open anything, it means there was no error log.
> This means the plugin either *failed to load* or an *exception* occured.

- Colors aren't applied.
> This can be caused due to a `colorscheme` plugin being loaded after `intro.nvim`.
> To solve it you just have to load the `colorscheme` plugin first. Because setting the `colorscheme` clears all the `highlight groups`.

- Animation not playing(Jumps to final value).
> This is caused due to the animations starting too quickly. This can happen when other plugins do something after neovim starts that prevents the buffer from updating.
> You can fix this by adding a large value to the `delay` in the `animations` table.

```lua
require("intro").setup({
   animations = {
        delay = 500
   }
})
```
- Animation not playing smoothly
> This is caused when a small `updateDelay` is set. A small value is usually used for a *smoother* animation but it comes at the cost of *performance*.
> It can also happen if your terminal has some type of **settings** related to how quickly the termimal can **refresh**.
> You can either increase the `updateDelay` or change your terminal settings.

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
> Sets one of the presets in the `presets.lua` file using the **name**.
> When set to a `string` it uses the preset matching the name with the **default** options.
> When it is a `table` the `name` is used to find the *preset* and the options in the `opts` is used to configure it.

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
> Shows/Hides the `statusline`.
>
> It uses `laststatus` to hide the `statusline`. When you leave the `Intro` buffer(more specifically when the `BufDelete` event is emitted) the value of `laststatus` is set back to the original value.
> The default value is `false`.

>[!WARNING]
> Originally the event used was `BufLeave`. However, due to `BufLeave` being fired when `virtual windows` open it was changed to `BufDelete`.

```lua
require("intro").setup({
    showStatusline = false
})
```

- shadaValidate `boolean or nil`
> Enable/Disable the filtering of `oldfiles`.
> When set to `true` the plugin will **not** show files that don't exist. 

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
> Changes the position of the `anchors`. Currently available values are `top` and `bottom`.
> Default value is `bottom`.

2. corner `string or nil`
> Changes the character(s) used as the corner of the `anchor`.
> Default is ▒.

3. textStyle `table or nil`
> Sets the option(s) for the `Intro_anchor_body` highlight group.
>
> You can check all the valid options with `:h nvim_set_hl()`.

4. cornerStyle `table or nil`
> Sets the option(s) for the `Intro_anchor_corner` highlight group.
>
> You can check all the valid options with `:h nvim_set_hl()`.


- pathModifiers `table or nil`
> Modify how specific `file paths` are shown. All the items should be `tuples`. The first item of it will be the `pattern` and the second will be the `replacemant`.

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
> A list containing all the components you will use.
> More information on `components` are available in the [components](#components) section.

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
> table containing animation settings and all the animations.

It has the following sub-properties.
1. delay `number or nil`
2. updateDelay `number or nil`
3. highlightBased `table or nil`
4. textBased `table or nil`

Here's what all of them do.

1. delay `number or nil`
> Time(in *miliseconds*) to wait before starting all the animations. The default value is 0.

```lua
require("intro").setup({
    animations = {
        delay = 500
    }
});
```

>[!TIP]
> If you can't see the *animations* play then using a higher `delay` may solve the issue.

2. updateDelay `number or nil`
> Time(in *miliseconds*) between each animation frames. The default value is 200.

```lua
require("intro").setup({
    animations = {
        updateDelay = 100
    }
})
```

>[!TIP]
> You can use a *small* `updateDelay` for smoother animations. However, it can sometimes slow down `Neovim`(especially when you have a lot of animations).

3. highlightBased `table or nil`
> Table containing animations related to `highlight groups`. More information is in the [animations](#animations) section.

3. textBased `table or nil`
> Table containing animations related to `virtual texts`. More information is in the [animations](#animations) section.








