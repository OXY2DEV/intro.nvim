<h2>🗒️ Overview</h2>

If you don't like one of the presets, you can always make your own plugin.

As such, this plugin provides `components` to make the entire process of creating a start screen easier. It also provides a way to change or add your own `highlight groups` which you can use in the `intro` buffer.
You can also create simple animations using the highlight groups. And also some text animations(this is still a work in progress).

These are the topics that are explained in this page,
0. [Configuration table](#config)
1. [Components](#components)
    - [Banner](#c_banner)
    - [Recents](#c_recents)
    - [Keymaps](#c_keymaps)
    -  [Clock](#c_clock)
1. [Coloring](#coloring)
    - [How colors are applied](#clr_how)
    - [Gradients](#clr_gradients)
    - [Helper function](#clr_helper)
2. [Animations](#animations)
    - [How the animation loop works](#anim_how)
    - [How to create animations](#anim_create)
    - [Highlight group based animation](#anim_hl)
    - [Text based animations](#anim_txt)

<h2 id="config">⚙️ Configuration table</h2>

This section talks about the various configuration options in the `setup()` function and what they do.

The configuration table with all the properties(and their **default** values),
```lua
require("intro").setup({
  showStatusline = false,
  shadaValidate = false,

  openFileUnderCursor = "<leader><leader>",

  anchors = {
    position = "bottom",
    corner = "▒",
    conerStyle = {},
    textStyle = {}
  },
  pathModifiers = {},

  components = {},
  globalHighlights = {},
  animations = {
    delay = 0,
    updateDelay = 100,
    highlightBased = {},
    textBased = {}
  }
})
```

Here's what all the properties do,
- showStatusline `true, false or nil`
  > Enable or disable the status(using `laststatus`). Originally, I thought statusline plugins would be handling that. Unfortunately, they some of them don't or can't. So, you can control it from the plugin.
  > The value of `laststatus` is stored an reapplied on the `BufLeave` event(when you leave the `Intro` buffer).
- shadaValidate `true, false or nil`
  > When set to **true**, files that don't exist are not added to the list created by the `recents` component.

  >[!WARNING]
  > May impact performance if the `shada` file is too long. But it shouldn't be something you notice.

- openFileUnderCursor `string or nil`
  > The keymap for opening files under the cursor. Only takes effect when a `recents` component is used.

- Anchors `table or nil`
  >[!NOTE]
  > As the plugin was made on a phone, it is impractical to show the entire file path. However you can change this behaviour in the `recents` components properties.
  
  > Change how the file path previews are shown. They are sent to a function which uses the patterns in the `pathModifiers` and replaces them with their texts. This can be used for extra customisation.
  > More details about these are in the [anchors](#anchors) section.
  
- pathModifiers `table or nil`
  > A list containing tuples(`{ pattern, replacement }`) whose values are sent to a `string.gsub()` that changes the file paths. 
  > *This only affects their appearance and don't change the actual files path.*
  > More information on it is in the [anchors](#anchors) section.

- components `table`
  > The core part of the configuration table. Define all your components as a list in it. 
  > More information about it is in the [components](#components) section.
  
- globalHighlights `table or nil`
  > Define `highlight group` names and their values. They are directly passed into `nvim_set_hl()`. An `Intro_` prefix is added to a highlight group.
  
  >[!WARNING]
  > You can use it to change other highlight groups too(if it is already defined). This is intended.

- Animations `table or nil`
  > A table containing all the animations and animation related options.
  > More information  about it is in the [animations](#animations) section.

<h2 id="components">📦 Components</h2>

Components are the `building blocks` of this plugin. They are meant to show things such as `setting keymaps` and `showing them`, showing recently `opened files`, showing `colored text arts` etc.

These are the currently available components.
1. Banner 
    > Originally created for handling `text arts`, this component allows the coloring and alignment of a lot of lines without having to set them for every line individually.
    > You can also use it to make any other type of component(even your own custom ones) too if you want.
2. Recents
    > Originally called `recent_files`, this component allows listing of recently opened files in neovim.
    > You can also set up `file path` preview, `icons`, quickly opening file under cursor with `keymap`. Optionally, you can specify patterns for listing the files and ignoring files that don't exist.
    
3. Keymaps
    > Easily set keymaps for the `intro` buffer and show as columns or rows.
4. Clock 
    > A simple clock that can show the current time & date. Only updates on `WindowResize` to prevent negativity impacting performance.

<h3 id="#banner">🎋 Banner</h3>

Handle complex text arts and color them however you like with this component.

Supports `custom width` of text, `alignment options`, `gradient colors` and even `functions` within texts.

```lua
{
  type = "banner", -- optional
  width = "auto",
  align ° "center",

  lines = {},
  functions = {},
  
  colors = {},
  secondaryColors = {},
  gradientRepeat = false
}
```

>[!TIP]
> This component allows certain values to be *tables*. It is especially useful if you want to add an option to a specific line but don't want it on other lines.
> 
> When these values are tables they are applied to the line whose index matches theirs.
  > ```lua
  > {
  >   align = { "left", "right", "center" },
  >   lines = { "ln 1", "ln 2", "ln 3" }
  > }
  > -- The first line will be on the left side of the buffer
  > -- The second one will be on the right and the third one will be on the center
  > ```
  > The table **must** be continuous(as in they can't have `nil` values between other values).
  > 
  >  Because if a `nil` value is found then the last `non-nil` value *before it* will be used for the other lines(this is how `lua` works so I can't do much about it).
  >  
  > ```lua
  > {
  >   align = { "left", nil, "right" },
  >   -- this will just add "left" to all the lines
  > }
  > ```
  > 
  > These are the values that have this behaviour:
  > - align
  > - color
  > - secondaryColors
  > - gradientRepeat
  >
  > `secondaryColors` will skip over nil values unlike the other properties and can have `nil` in it's table.


<h4 align="center">Properties</h4>

- type `string or nil`
  > Name of the component. By default, it is set to `banner`.
  > ```lua
  > {
  >   type = "banner"
  > }
  > ```
  
- width `number or nil`
  > Width of the `lines`. Useful when you have characters whose width is bigger than a single character(e.g. some arabic characters). You can also set it to `auto`(or `nil`) to disable it.
  
  >[!TIP]
  > If you are using nerd font characters, you don't have to add a `width`. It will still work just fine, just make sure they don't overlap(in which case the output will also have character overlaps).
  
  > ```lua
  > {
  >   width = 5,
  >   -- this makes the line behave like it has 5 characters in it
  > }
  > ```
  
- align `string or table or nil`
  > Changes the alignment of the text. It can be `left`, `right` or `center`. By default, it is `center`.
  > ```lua
  > {
  >   align = "center" -- centers the text.
  > }
  > ```
  
- lines `table`
  > List containing all the lines to add. Lines can be either a `string` or a `table`.
   
   >[!TIP]
   > If the line only uses a single color(or a single gradient) then it is best to use a `string`. If the line has more complex coloring(or has [function names](#functions) in them) it is best to use a `table` as this provides more control.
   > ```lua
   > {
   >   lines = {
   >     { "A", " line ", "as a", " tae" },
   >     "A line as a string"
   >   }
   > }
   > ```
   
- colors `string or table or nil`
   > Contains the highlight groups that will be used for coloring the text. Can be a `table` of colors(for individual lines) or a `string`.
   > ```lua
   > {
   >   colors = "Special",
   >   -- adds the "Special" highlight group to all the lines
   >   
   >   colors = { "Comment", "Special", "Conditional" },
   >   -- 1st line gets the "Comment" highlight group, the 2nd one "Special" and everything after gets the "Conditional" highlight group
   >   
   >   colors = {
   >     { "Constant", "Function", "Special" }
   >   }
   >   -- adds a 3 color gradient to all the lines
   > }
   > ```
   
- secondaryColors `table or nil`
   > Coloring with finer control. Useful when you have something like a table(or any type of structured data as text) or code that you may have on your start screen.
   
   >[!WARNING]
   > This only takes effect *when* the lines are `table`.
   
   > ```lua
   > {
   >   lines = {
   >     { "Red", " | ", "Blue" }
   >   },
   >   secondaryColors = {
   >     { "Error", nil, "Function" }
   >     -- highlight group color may be different due to the colorscheme
   >   }
   > }
   > ```
   
- gradientRepeat `boolean or table or nil`
   > Controls wether `gradients` should repeat or not. By default, it is set to `false`.
   > This property can be set for each line individually.
   > ```lua
   > {
   >   gradientRepeat = false,
   >   -- gradients will no longer repeat
   >   
   >   gradientRepeat = { true, false },
   >   -- only the gradients in the first line will repeat
   > }
   > ```

<h3 id="recents">📜 Recents</h3>

Show your recently opened files *with style* 😎. Allows customisation of how the items are shown. You can even specify patterns(uses `string.match()`) to filter the list. Allows the setup of keymap(with the pattern `<prefix>n`) to easily open files. 

Additionally shows the file path with using `anchors` and supports operating files under the cursor with the `openFileUnderCursor` keymap.
```lua
{
  style = "list",

  entryCount = 5,
  width = 0.8,
  
  useAnchors = true,
  useIcons = false,
  dir = false,

  gap = " ",
  colors = {
    name = "",
    path = "",
    number = "",
    spaces = ""
  },
  anchorStyle = {
    corner = "//",
    cornerGroup = nil,
    textGroup = nil
  },

  keymapPrefix = "<leader>"
}
```
>[!TIP]
> Just like `banner` component all the properties in the `colors` table can be lists which allows you to set colors to each entry. You can add `shading` or `reveal animations`.
> The behaviour is the same too.
> ```lua
> {
>   colors = {
>     name = { "hl_1", "hl_2", "hl_3" }
>     -- the first 2 entry's file name will have "hl_1", "hl_2" respectively and all the other entries will have "hl_3" applied to them
>   }
> }
> ```

<h4 align="center">Properties</h4>

- style `string`
 > Determines what component a table is.
 
 >[!NOTE] 
 > Currently available styles are,
 > - list
 > - list_2
 
- entryCount `number or nil`
 > Number of entries to add. Default is `5`.
 
- width `number or nil`
  > Change how wide lists are supposed to be.
  
  >[!TIP]
  > This can be an `integer` or a `float`. When a float is used it is considered that % of the window width.
  > By default, it is set to 0.6.
  > ```lua
  > {
  >   width = 50, -- the list will be 50 characters wide
  >   width = 0.6, -- the list will be 60% of total window width
  > }
  > ```
  
- useAnchors `boolean or nil`
  > Toggle the usage of [anchors](#anchors).

- useIcons `boolean or nil`
  > Toggle the use of `nerd-font` icons for file icons.
  
  >[!NOTE]
  > This requires `nvim-web-devicons`. So, you have to install it as a dependency.
  
 - dir `boolean or string or nil`
  > Used to filter through the files. When set to `true` it will only show the files in the `current working directory`. When the value is a `string` it is used to match(using `string.match()`) match the file paths.
  > By default, it is set to `false` which disables it.
  > ```lua
  > {
  >   dir = true, -- show files in the current directory
  >   
  >   dir = "~/.config/nvim/"
  >   -- only show files that have `~/.config/nvim/` in their path
  > }
  > ```
  
- gap `string or nil`
  > Character used for filling up empty spaces. It should be a single character long.
  > By default, it is set to " ".
  
- colors `table or nil`
  > Set the coloring for various parts of the text.
  > - name (changes the color for showing file names)
  > - path (changes the color for the path before the file names)
  > - number (changes the color for the entry number)
  > - spaces (changes the color of the spaces separating various parts of the lines)
  
- anchorStyle `table or nil`
  > Allows customisation of the [anchors](#anchors).
  > - corner (changes the text that is used as the corner)
  > - cornerGroup (changes the highlight group used to color the corner)
  > - textGroup (changes the highlight group used to color the text)
  
  >[!WARNING]
  > As the plugin uses `virtual text` for anchors. Gradients are not supposed, *yet*.
  
- keymapPrefix `string or nil`
  > Change the prefix key for quickly accessing files. It can be used by typing the entry number after the prefix.
  > The default is `<leader>`.
  
  >[!WARNING]
  > Keymaps are set for each `recents` component individually. So, another `recents` component can override the keymap.
