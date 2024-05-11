<h1 align="center">Intro.nvim</h1>
<p align="center">Animated <code>:intro</code> for Neovim</p>

If you don't like what the `presets` provide or just want to make your own start screen from scratch, then this is for you.

The documentation here is written like a tutorial. However, there are useful links provided here so that you can easily jump to whichever topic you may need. You can still find the normal documentation by checking the `intro.nvim` help file.

>[!NOTE]
> The documentation was written inside `Neovim` & viewed using `Glow`. As such some things may not render properly.
> They will be patched out through later commits.

<h2>Table of contents</h2>

- [Starting with some basics](#basics)
  - [Fixing issues](#issues)
- [Basics](#basics)

<h2 id="basics">Starting with some basics</h2>

Even though you may have followed the `installation` instruction in some cases the plugin may not load properly. So, it is better to test if the plugin works or not.
For this example I am using `Lazy.nvim`. But the process should be similar for other **plugin managers**.

>[!NOTE]
> To remove *unnecessary codes & complexities* I have put the configuration for the plugin in a seperate folder.

```lua
require("intro").setup();
```

To test the plugin just using the `setup()` function is enough. Now, if you open `Neovim` you should see this,

<!-- Video -->

<h3 id="basics">Fixing issues</h3>

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

<h2 id="basics">Basics</h2>

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

