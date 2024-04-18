```text
██████▒▒░░      ⠛⣿⠛ ⣿⣄  ⣿ ⠛⠛⣿⠛⠛ ⣾⠛⠛⣷ ⣾⠛⠛⣷
██░░▒▒██▒▒░░     ⣿  ⣿ ⣿ ⣿   ⣿   ⣿⠶⠶⠟ ⣿  ⣿
██░░▒▒████▒▒░░   ⣿  ⣿ ⣿ ⣿   ⣿   ⣿⠷   ⣿  ⣿
██▒▒▒▒░░▒▒▒▒░░  ⣤⣿⣤ ⣿  ⠙⣿   ⣿   ⣿ ⢷  ⢿⣤⣤⡿ .nvim
██████▒▒▒▒░░    
▒▒▒▒▒▒▒▒░░      Yet another start screen plugin
```

My attempt at making a startscreen plugin for **Neovim**.

>[!WARNING]
>
>This plugin is going through **breaking changes**. So there will be a lot of bugs.
>And I mean a LOT of them.

>[!NOTE]
>
>If you are here to test the plugin then check the **pinned issue**.
>Updates are posted there, at least until the plugin becomes stable enough.


## Installation
The Installation process is similar regardless of your preferred plugin manager.

For `lazy.nvim`
```lua
{
    "OXY2DEV/intro.nvim",
    name = "intro",

    -- Optional dependency if you want file icons
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },

    config = function()
        require("intro").setup();
    end
}
```

