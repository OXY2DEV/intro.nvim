local AR = {};

AR.rounded = {
  { "╭─╮", " ╶╮", "╶─╮", "╶─╮", "╷ ╷", "╭─╴", "╭─╴", "╶─╮", "╭─╮", "╭─╮", },
  { "│ │", "  │", "╭─╯", "╶─┤", "╰─┤", "╰─╮", "├─╮", "  │", "├─┤", "╰─┤", },
  { "╰─╯", "  ╵", "╰─╴", "╶─╯", "  ╵", "╶─╯", "╰─╯", "  ╵", "╰─╯", "╶─╯", },

  { "╭─╮ ╭┬╮", "╭─╮ ╭┬╮" },
  { "├─┤ │╵│", "├─╯ │╵│" },
  { "╵ ╵ ╵ ╵", "╵   ╵ ╵" }
};

AR.cornered = {
  { "┌─┐", " ╶┐", "╶─┐", "╶─┐", "╷ ╷", "┌─╴", "┌─╴", "╶─┐", "┌─┐", "┌─┐" },
  { "│ │", "  │", "┌─┘", "╶─┤", "└─┤", "└─┐", "├─┐", "  │", "├─┤", "└─┤" },
  { "└─┘" ,"  ╵", "└─╴", "╶─┘", "  ╵", "╶─┘", "└─┘", "  ╵", "└─┘", "╶─┘" },

  { "┌─┐ ┌┬┐", "┌─┐ ┌┬┐" },
  { "├─┤ │ │", "├─┘ │╵│" },
  { "╵ ╵ ╵ ╵", "╵   ╵ ╵" }
}

AR.dotMatrix = {
  { "⣾⠛⣷", " ⣠⣿", "⠛⠛⣷", "⠛⠛⣷", "⣿ ⣿", "⣾⠛⠛", "⣾⠛⠛", "⠛⠛⣷", "⣾⠛⣷", "⣾⠛⣷", },
  { "⣿ ⣿", "  ⣿", "⣠⠶⠋", "⠶⠶⣿", "⠙⠛⣿", "⠙⠶⣄", "⣿⣤⣄", "  ⣿", "⣿⠶⣿", "⠻⠶⣿", },
  { "⢿⣤⡿", "  ⣿", "⢿⣤⣤", "⣤⣤⡿", "  ⣿", "⣤⣤⡿", "⢿⣤⡿", "  ⣿", "⢿⣤⡿", "⣤⣤⡿", },

  { "⣾⠛⣷ ⣷⣀⣾", "⣾⠛⣷ ⣷⣀⣾" },
  { "⣿⠶⣿ ⣿⠉⣿", "⣿⠶⠟ ⣿⠉⣿" },
  { "⣿⠶⣿ ⣿ ⣿", "⣿   ⣿ ⣿" }
}

AR.fill = {
  { "█▀█", " ▗█", "▀▀█", "▀▀█", "█ █", "█▀▀", "█▀▀", "▀▀█", "█▀█", "█▀█" },
  { "█ █", "  █", "▄■▀", "■■█", "▀▀█", "▀■▄", "█■▄", "  █", "█■█", "▀■█" },
  { "█▄█", "  █", "█▄▄", "▄▄█", "  █", "▄▄█", "█▄█", "  █", "█▄█", "▄▄█" },

  { "▟▀▙ ▙ ▟", "█▀▙ ▙ ▟" },
  { "█■█ █▀█", "█▄▛ █▀█" },
  { "█ █ █ █", "█   █ █" }
};


AR.N = {
  "      ,l;             c,      ",
  "   .:ooool'           loo:.   ",
  " .,oooooooo:.         looooc, ",
  "l:,loooooooool,       looooool",
  "llll,;ooooooooc.      looooooo",
  "lllllc,coooooooo;     looooooo",
  "lllllll;,loooooool'   looooooo",
  "lllllllc .:oooooooo:. looooooo",
  "lllllllc   'loooooool,:ooooooo",
  "lllllllc     ;ooooooooc,cooooo",
  "lllllllc      .coooooooo;;looo",
  "lllllllc        ,loooooool,:ol",
  " 'cllllc         .:oooooooo;. ",
  "   .;llc           .loooo:.   ",
  "      ,;             ;l;      ",
}

-- As this uses non-English characters
-- you need to set custom width for this kind of arts
--
-- I used a mix of fixed width line and spaces 
-- to make the wntire art fit properly
--
-- Used values are { 8, 11, 8, 11 }
-- These represent how many characters each line actually takes
AR.cat = {
  "  ／l、     ",
  "（ﾟ､ ｡ ７   ",
  "  l  ~ヽ    ",
  "  じしf_,)ノ",
};

AR.cat_1x2 = {
  { "  ／l、     ", "  ／l、     " },
  { "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   " },
  { "  l  ~ヽ    ", "  l  ~ヽ    " },
  { "  じしf_,)ノ", "  じしf_,)ノ" },
};

AR.cat_1x3 = {
  { "  ／l、     ", "  ／l、     ", "  ／l、     " },
  { "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   " },
  { "  l  ~ヽ    ", "  l  ~ヽ    ", "  l  ~ヽ    " },
  { "  じしf_,)ノ", "  じしf_,)ノ", "  じしf_,)ノ" },
};

AR.cat_1x4 = {
  { "  ／l、     ", "  ／l、     ", "  ／l、     ", "  ／l、     " },
  { "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   " },
  { "  l  ~ヽ    ", "  l  ~ヽ    ", "  l  ~ヽ    ", "  l  ~ヽ    " },
  { "  じしf_,)ノ", "  じしf_,)ノ", "  じしf_,)ノ", "  じしf_,)ノ" },
};

AR.cat_2x1 = {
  "  ／l、     ",
  "（ﾟ､ ｡ ７   ",
  "  l  ~ヽ    ",
  "  じしf_,)ノ",
  "",
  "  ／l、     ",
  "（ﾟ､ ｡ ７   ",
  "  l  ~ヽ    ",
  "  じしf_,)ノ",
};

AR.cat_2x2 = {
  { "  ／l、     ", "  ／l、     " },
  { "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   " },
  { "  l  ~ヽ    ", "  l  ~ヽ    " },
  { "  じしf_,)ノ", "  じしf_,)ノ" },
  "",
  { "  ／l、     ", "  ／l、     " },
  { "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   " },
  { "  l  ~ヽ    ", "  l  ~ヽ    " },
  { "  じしf_,)ノ", "  じしf_,)ノ" },
};

AR.cat_3x1 = {
  "  ／l、     ",
  "（ﾟ､ ｡ ７   ",
  "  l  ~ヽ    ",
  "  じしf_,)ノ",
  "",
  "  ／l、     ",
  "（ﾟ､ ｡ ７   ",
  "  l  ~ヽ    ",
  "  じしf_,)ノ",
  "",
  "  ／l、     ",
  "（ﾟ､ ｡ ７   ",
  "  l  ~ヽ    ",
  "  じしf_,)ノ",
};

AR.cat_3x3 = {
  { "  ／l、     ", "  ／l、     ", "  ／l、     " },
  { "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   " },
  { "  l  ~ヽ    ", "  l  ~ヽ    ", "  l  ~ヽ    " },
  { "  じしf_,)ノ", "  じしf_,)ノ", "  じしf_,)ノ" },
  "",
  { "  ／l、     ", "  ／l、     ", "  ／l、     " },
  { "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   " },
  { "  l  ~ヽ    ", "  l  ~ヽ    ", "  l  ~ヽ    " },
  { "  じしf_,)ノ", "  じしf_,)ノ", "  じしf_,)ノ" },
  "",
  { "  ／l、     ", "  ／l、     ", "  ／l、     " },
  { "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   ", "（ﾟ､ ｡ ７   " },
  { "  l  ~ヽ    ", "  l  ~ヽ    ", "  l  ~ヽ    " },
  { "  じしf_,)ノ", "  じしf_,)ノ", "  じしf_,)ノ" },
};

-- These text arts were taken from the `ascii.nvim` repo
-- They are NOT mine and credits go to their originl creators
AR.nvim_outline = {
	[[ _______             ____   ____.__         ]],
	[[ \      \   ____  ___\   \ /   /|__| _____  ]],
	[[ /   |   \_/ __ \/  _ \   Y   / |  |/     \ ]],
	[[/    |    \  ___(  <_> )     /  |  |  Y Y  \]],
	[[\____|__  /\___  >____/ \___/   |__|__|_|  /]],
	[[        \/     \/                        \/ ]],
};

AR.nvim_block = {
	[[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
	[[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
	[[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
	[[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
	[[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
	[[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
};

AR.nvim_lean = {
	[[    _/      _/                      _/      _/  _/              ]],
	[[   _/_/    _/    _/_/      _/_/    _/      _/      _/_/_/  _/_/ ]],
	[[  _/  _/  _/  _/_/_/_/  _/    _/  _/      _/  _/  _/    _/    _/]],
	[[ _/    _/_/  _/        _/    _/    _/  _/    _/  _/    _/    _/ ]],
	[[_/      _/    _/_/_/    _/_/        _/      _/  _/    _/    _/  ]],
}

return AR;
