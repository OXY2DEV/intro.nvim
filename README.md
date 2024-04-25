<video src="./previews/plugin_showcase.mp4" loop></video>
Highly customisable `start screen` plugin for **Neovim**.

Key features,
  1. Quick & easy setup.
  2. Automatic alignment of texts with various alignment options.
  3. Gradient text support.
  4. Animation support.
  5. Presets for easy setup etc.


> [! IMPORTANT]
> This plugin is still in it's **early stages** so various parts of the plugin may go through changes.
> 
> This is a **hobby project** and I am not a **professional developer**. So, my approach to various features in the plugin may not be the most optimal solution. Thus, if someone can provide better solution I am more than happy to implement it.

>[! BUG]
>If you are installing the plugin I suggest first using the example in the `installation` section and check if the plugin works.
>
>This plugin was completely written inside **Termux**(as in, on my phone) and tested inside **Termux** & **xfce4-terminal**. So, I can't help you fix a bug unless **sufficient information** is provided when the plugin doesn't work. Especially, when the bug may occurs due to your **terminal** or **another plugin** that you use.

## Installation
### 💤 lazy.nvim
```lua
{ -- plugins.lua
  "OXY2DEV/intro.nvim",
  config = function()
    require("intro").setup();
  end
},
```

```lua
return { -- plugins/intro.lua
  "OXY2DEV/intro.nvim",
  config = function()
    require("intro").setup();
  end
}
```

