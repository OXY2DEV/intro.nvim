<img src="/previews/plugin_showcase.gif"/>

Highly customisable `start screen` plugin for **Neovim**.

Key features,
  1. Quick & easy setup.
  2. Automatic alignment of texts with various alignment options.
  3. Gradient text support.
  4. Animation support.
  5. Presets for easy setup etc.


> [!IMPORTANT]
> This plugin is still in it's **early stages** so various parts of the plugin may go through changes.
> 
> This is a **hobby project** and I am not a **professional developer**. So, my approach to various features in the plugin may not be the most optimal solution. Thus, if someone can provide better solution I am more than happy to implement it.

> [!NOTE]
> If you are installing the plugin I suggest first using the example in the `installation` section and check if the plugin works.
>
> This plugin was completely written inside **Termux**(as in, on my phone) and tested inside **Termux** & **xfce4-terminal**. So, I can't help you fix a bug unless **sufficient information** is provided when the plugin doesn't work. Especially, when the bug may occurs due to your **terminal** or **another plugin** that you use.

# Installation
## 💤 lazy.nvim
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
# Setup
The setup function has these properties,
```lua
require("intro").setup({
  showStatusline = false, -- hide the Statusline
  shadaValidate = true, -- ignore files that don't exist when reading the oldfiles
  
  preset = {}, -- preset configuration
  
  anchors = {}, -- file path preview options
  components = {}, -- components to render
  globalHighlights = {}, -- highlight group names and their properties that will be used in the atart screen
  
  animations = {} -- animations and their settings
})
```

To see a more detailed explanation of what each property does I suggest you check the `intro.nvim-setup` help file(`:h intro.nvim-setup`).

Additionally there is also a quick list for easily glancing over all the properties and their sub properties in the same help file(`:h intro.nvim-opts-tldr).

>[!TIP]
>If you are new to the plugin I suggest you skip the next section as it can be *VERY* overwhelming especially if you are a beginner.
>I suggest you to start using `presets` first, then watching some examples and this section together. Or you can go read the `documentations` too if you would prefer that.
