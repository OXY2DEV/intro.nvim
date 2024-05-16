https://github.com/OXY2DEV/intro.nvim/assets/122956967/b2ffb4ca-d543-46f6-8d7c-c4dbd42caa56

<h1 align="center">Intro.nvim</h1>
<p align="center">Animated <code>:intro</code> for Neovim</p>

<p align="center">
  <a href="#install">Installation</a> | <a href="DOC.md">Documentation</a> | <a href="#presets">Presets</a> | <a href="#showcase">Showcase</a>
</p>

<h2>🏝️ Introduction</h2>

>[!NOTE]
> This plugin was made **entirely** inside termux. So, I may or may *not* be able to reproduce your issue due to *hardware limitations*. So, It would really help me debug the issues if you add **extra details** to your issues(e.g. **explaining what happens** instead of the plugin starting, **attaching a video** of the bug, what machine you are using etc.).

>[!WARNING]
> This plugin was meant to be used inside **termux** so some things may be a *little bit* off when used somewhere else.

In my experience, after installing a new `start screen` plugin I will most likely end up writing helper functions for myself to better customise the plugin. This was a problem as I would have to change the helper functions every time I eventually needed to switch to a different plugin(either due to lack of features or not providing more customisation).

Some of the plugins are easy to set up but comes at the cost of you can't really change it much. Other have more customisation but don't have an easy way to set up.

I also couldn't find any plugin which provided a way to add `gradients` to the texts which I really wanted.

Key features of this plugin.
- Easily show recently opened files, add keymaps, text arts etc. without having to write everything from scratch.
- Gradient colors! If you have experience with something like `lolcat` or wanted gradients in your text then you are going to like this plugin. Plus unlike other plugins this one also has helper functions to make the entire process easier.
- Minimal config. If you aren't crazy about customisation and just want something simple and easy to set up then you can use one of the `presets`. But they are not like your normal presets as they do provide customisation of the presets in case you want it.
- Simple `animations`. The plugin provides a way to make simple color based animations(along with some text based ones, this is a work in progress though).
- Complete `timing control` over animations. This plugin not only provides options to control when the animations start but it also allows you to control them for individual animations too if you want.


<h2 id="install">💻 Installation</h2>
<h3>💤 Lazy</h3>

>[!WARNING]
> Do not lazy load the plugin. 
> 
> The plugin should run before other plugins so by setting `lazy = false` the plugin won't get the chance to load.

```lua
-- plugins.lua
{
  "OXY2DEV/intro.nvim",
  -- For file icons
  dependencies= {
    "nvim-tree/nvim-web-devicons"
  },
  config = function ()
    require("intro").setup();
  end
}
```

```lua
-- plugins/intro.lua
return {
  "OXY2DEV/intro.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function ()
    require("intro").setup();
  end
}
```

<h3>🧰 Mini.deps</h3>

```lua
-- depe.lua
require("mini.deps").add({
  source = "OXY2DEV/intro.nvim",
  depends = {
    "nvim-tree/nvim-web-devicons"
  }
})

require("intro").setup();
```

<h2 id="presets">🧩 Presets</h2>

If you want to `quickly set up` the plugin and don't want any of the hassle of customisation then this section is for you.

Presets are applied like this.
```lua
require("intro").setup({
  preset = {
    name = "",  -- Name of the preset
    opts = {}   -- Options of the preset to use
  }
})

-- If you don't want customisation you can use this
require("intro").setup({
  preset = ""   -- Name of the preset
})
```

The presets are available in the `/lua/intro/presets.lua` file in the plugin.

>[!TIP]
>Items that have a • in front of them are the preset name and the items that are numbered are the options for that preset.

>[!NOTE]
> The order in the `opts` matters. Some options have the ability to overwrite the values set by other options. This becomes more apparent in case there are options that add components to the screen. In this case, the option that came first in the list will have it components added first.
> 
> As such it is recommended you follow the order of options when using them. So, an option whose list number is less should be added first.

Currently available `presets` are,
- nvim
  1. animated
- nvim_mini
  1. animated
  1. dark_alt
  2. dark_alt_animated
- startify(based on `vim-strtify`)
  1. green
  2. red
  3. pink
  4. flamingo
  5. gradient_blue_green
  6. gradient_endless_river(taken from `uiGradients`)
  7. gradient_friday(taken from `uiGradients`)
  8. recent_files
  9. recent_files_current_dir
  10. list_shade
- cats(they are in `rows x columns` structure)
  1. c1x1
  2. c1x2
  3. c1x3
  4. c1x4
  5. c2x2
  6. c3x3
  7. c3x1
  8. rosewater
  9. rosewater_alt
  10. mauve
  11. mauve_alt
  12. yellow
  13. yellow_alt
  14. green
  15. green_alt
  16. blue
  17. blue_alt
  18. all_the_colors 
  19. all_the_colors_alt

More `presets` are going to be added in the future. If you want a specific type of preset you can open an `issue` for it.

<h2 id="showcase">🌌 Plugin showcase</h2>
<h3>Images</h3>

>[!NOTE]
> The images were taken on my phone so they can be a bit blurry.

![Screenshot_1](https://github.com/OXY2DEV/intro.nvim/blob/assets/images/plugin_img_1.jpg)

![Screenshot_1_L](https://github.com/OXY2DEV/intro.nvim/blob/assets/images/plugin_img_1_large.jpg)

![Screenshot_2_L](https://github.com/OXY2DEV/intro.nvim/blob/assets/images/plugin_img_2_large.jpg)

![Screenshot_3_L](https://github.com/OXY2DEV/intro.nvim/blob/assets/images/plugin_img_3_large.jpg)

![Screenshot_4_L](https://github.com/OXY2DEV/intro.nvim/blob/assets/images/plugin_img_4_large.jpg)

![Screenshot_5_L](https://github.com/OXY2DEV/intro.nvim/blob/assets/images/plugin_img_5_large.jpg)


<h3>Videos</h3>

https://github.com/OXY2DEV/intro.nvim/assets/122956967/2d4b230a-328a-4b80-90c4-55f9b6d26dab

https://github.com/OXY2DEV/intro.nvim/assets/122956967/b415931b-aa95-48e6-9133-847af7d222e2

https://github.com/OXY2DEV/intro.nvim/assets/122956967/9e9ed7b7-86b1-4412-8328-82b9071e8c65

