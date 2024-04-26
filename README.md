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

To see a more detailed explanation of what each property does I suggest you check the `intro.nvim-setup` help file(`:h intro.nvim-setup).

Additionally there is also a quick list for easily glancing over all the properties and their sub properties in the same help file(`:h intro.nvim-opts-tldr).

>[!TIP]
>If you are new to the plugin I suggest you skip the next section as it can be *VERY* overwhelming especially if you are a beginner.
>I suggest you to start using `presets` first, then watching some examples and this section together. Or you can go read the `documentations` too if you would prefer that.

## Components
Components are the building blocks for making a plugin. You can use them to make your start screen as simple or complex as you would like.

These are the currently available `components`,
  1. Banner
  2. Recents
  3. Keymaps

Even though I will try to be as **short** and **on point** as I can this section will be quite **big**.
If you want to read more and a detailed version(with examples) of this section check the `intro.nvim-components` help file.


To be less of a *performance hog* all the `components` are turned into `lines`.
```lua
{ -- An example of how a line looks like
  text = "",
  color = "",
  secondaryColors = {}
}
```

Currently you can't directly use `lines` and instead use `components` but I will be adding custom components in a later update which will allow direct usage of `lines`.
>[!TIP]
>**Why does the plugin use** `lines`**?**
> 
>The reason for this is that all the Components need to do various things(e.g. read old-files, set keymaps, set default options, communicate with other parts of the plugin etc.) and doing this things every time the screen resizes will cause *A LOT* of lag and slow down everything.
>So, things that are only need to be done once aren't done over & over again and whem things are added to the screen, the plugin only needs to worry about a single line rather than the entire configuration table.
> 
>There used to be a `bug` that crashed the entire terminal in the older version of the `plugin`(when the window was resized) for this exact reason.

### Banner
Originally created for easy coloring and aligning `text arts`. This component allows setting various options(e.g. colors, alignment, gradient behaviour etc.) to 1 or more lines.

```lua
{
  type = "banner", -- optional
  lines = {}, -- lines to show
  width = "auto", -- a custom width for the lines
  align = {}, -- alignment of lines
  colors = {}, -- the main highlight group to add to the lines
  secondaryColors = {}, -- colors to add to specific parts of the lines
  gradientRepeat = {}, -- control how gradient colors behave
  functions = {} -- functions that can be used inside lines for specific scenarios
}
```

These are all the values this component provides. It may seem like a lot but most of the time you will only use 3 properties. So, your table will most likely look something like this.

```lua
{
  lines = { "Hello World" },
  colors = "Special"
}
```

This will add "Hello World" to the start screen with the `Special` highlight group applied to the text.

>**Why does this component have 2 color properties?**
>
>**Answer:** The answer is very simple. A lot of the times you would need specific parts of the text to be of a different color. With just **color** you apply a highlight group(or a bunch of them if it's a gradient) to the entire text. With **secondaryColors** you can choose where to apply what color.
>
>**Shouldn't just having one be enough?**
>
>**Answer:** It would have been if it weren't for the fact that in that case you would need to set a color for every single letter manually. You wouldn't be able to set a default color without using a different property.
>Plus, now you can choose which property to use depending on your usage.

#### How colors are applied
Even though it is explained as part of this component(as it was originally exclusive to this component) the method used for coloring and how they are defined are the same everywhere else in the plugin.

There are 2 types of colors in this plugin,
  1. Solid colors
  2. Gradient colors 

Solid colors are basically a single highlight group. They are defined like this.
```lua
{
  lines = "Colored text",
  colors = "Special"
}
```
But the proper way is to define them using a `table` like this.
```lua
{
  colors = { "Special" }
}
```

Colors are applied based on line index(on `banner` type components) and entry number(on `recents` type components). So, how do we color 10 or more lines without making *ugly* nested tables? It's simple, by default the plugin will first look into `colors` and see if a value on the lines index is `nil` or not. If it's not then that color will be applied. However, if a lines colors value is `nil` it will default to the last `non-nil` value in the `colors` table(this process is completely skipped if `colors` nil).

>[!TIP]
>**I don't want to color a specific line. What do I do?**
>
>**Answer:** You set the `colors` tables value for that line to "". This will skip that line.

This is how you can skip a line and not color it.

```lua
{
  lines = { "I am colored", "I am not", "I am colored" },
  colors = { "Special", "", "Special" }
}
```


Gradients are also supported(as it was the main feature of this plugin). So, you can use them to color the entire text or parts of it.

>[!IMPORTANT]
>To make `gradient colored` text the plugin adds highlights to every character(s). This is not the best way since it does use `loops` which can slow the plugin. However, after searching the documentation and looking at others example, I couldn't find `any better solution`.
>However, in practice you won't even notice the difference in time.

This is how you can apply a gradient to lines
```lua
{
  lines = { "A line of text" },
  colors = {
    { "Special", "Normal", "Special" }
  }
}
```

This will add `Special` group to "A", `Normal` group to " " and `Special` to the rest of the text.

You can also make a gradient repeat itself using  the `gradientRepeat` property.

```lua
{
  lines = { "A line of text" },
  colors = {
    { "Special", "Normal", "Special" }
  },
  gradientRepeat = true
}
```

This will repeat the gradient from the start after all the the color in the `table` is applied.

You can also change the color of various parts of the text.
```lua
{
  lines = { 
    { "Current path", vim.fn.getcwd() }
  },
  colors = {
    "Special"
  },
  secondaryColors = {
    { nil, "Comment" }
  }
}
```
This will make the path appear the same color as `comments`. It also supports Gradient colors.
```lua
{
  lines = {
    { "Current path: ", "~/.config/nvim/" },
  },

  gradientRepeat = true,
  secondaryColors = {
    {
      { "Normal", "Special", "Conditional" },
      "Comment"
    }
  }
}
```
#### Gradient Repeat
When I first started working on the `Gradient color` support I was having trouble with wether a gradient should repeat or not.
Let me explain, when you want to apply a pattern of color it makes sense that the gradient would repeat. However, if the gradient only needs to be present at the start of the text then it would be better if the gradient didn't repeat.

>[!NOTE]
>**But can't you just use** `secondaryColors` **to do that?**
> 
>**Answer:** Yes, you can. But to do that you would need to change the text into a table, apply color using `secondaryColors`. This makes the configuration table more confusing than necessary.
>Plus it limits the customisability of the plugin which is one of it's key features. So, I decided it would be better to have an `option` for it. Now, you won't have to write, delete and write every time you want to change how the gradient is applied.

`gradientRepeat` can be **true**, **false** or a **table**.
```lua
{
  gradientRepeat = true, -- boolean value

  gradientRepeat = { -- table value
    colors = true,
    secondaryColors = true
  }
}
```
When its set to **true** or **false** the behaviour is applied to both `colors` & `secondaryColors`.
When its a table you can choose what behaviour `colors` or `secondaryColors` should take(useful in tricky coloring situations such as when gradients are used for both).

Not only that you can also use it as a `list` in which case the value is applied based on the lines index. So, you can add different rules to different lines without having to create a new component. If a value is `nil` the last value from the table is used.

You can use something like this in your component.
```lua
{
  gradientRepeat = {
    true, false,
    {
      colors = true,
      secondaryColors = false
    }
  }
}
```

Even though there are(and will be) more `components` the `banner` component was the only component when the plugin was first made. So, all the other components are just variation of it. As such many of the properties are also available in other `components`.


