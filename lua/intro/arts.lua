local AR = {};

AR.time = {
  t1 = {  "⣾⠛⣷", "⣾", "⠛⠛⣷", "⠛⠛⣷", "⣿ ⣿", "⣾⠛⠛", "⣾⠛⠛", "⠛⠛⣷", "⣾⠛⣷", "⣾⠛⣷", },
  t2 = {  "⣿ ⣿", "⣿", "⣠⠶⠋", "⠶⠶⣿", "⠙⠛⣿", "⠙⠶⣄", "⣿⣤⣄", "  ⣿", "⣿⠶⣿", "⠻⠶⣿", },
  t3 = {  "⢿⣤⡿", "⣿", "⢿⣤⣤", "⣤⣤⡿", "  ⣿", "⣤⣤⡿", "⢿⣤⡿", "  ⣿", "⢿⣤⡿", "⣤⣤⡿", },

  m1 = { "⣾⠛⣷ ⣷⣀⣾", "⣾⠛⣷ ⣷⣀⣾" },
  m2 = { "⣿⠶⣿ ⣿⠉⣿", "⣿⠶⠟ ⣿⠉⣿" },
  m3 = { "⣿⠶⣿ ⣿ ⣿", "⣿   ⣿ ⣿" }
}

AR.returnTime = function(time, use12)
  local tm = time ~= nil and time or os.date("*t");
  local hour = tm.hour or 1;
  local min = tm.min or 1;

  local l = {};
  local l1, l2, l3 = "1", "2", "3";

  if use12 ~= true then
    goto not12;
  end

  if hour == 0 then
    l1 = AR.time.t1[2] .. " " .. AR.time.t1[3];
    l2 = AR.time.t2[2] .. " " .. AR.time.t2[3];
    l3 = AR.time.t3[2] .. " " .. AR.time.t3[3];
  elseif hour <= 9 then
    l1 = AR.time.t1[1] .. " " .. AR.time.t1[hour + 1];
    l2 = AR.time.t2[1] .. " " .. AR.time.t2[hour + 1];
    l3 = AR.time.t3[1] .. " " .. AR.time.t3[hour + 1];
  elseif hour == 10 then
    l1 = AR.time.t1[2] .. " " .. AR.time.t1[1];
    l2 = AR.time.t2[2] .. " " .. AR.time.t2[1];
    l3 = AR.time.t3[2] .. " " .. AR.time.t3[1];
  elseif hour > 10 and hour < 22 then
    if hour <= 12 then
      l1 = AR.time.t1[2] .. " " .. AR.time.t1[hour - 9];
      l2 = AR.time.t2[2] .. " " .. AR.time.t2[hour - 9];
      l3 = AR.time.t3[2] .. " " .. AR.time.t3[hour - 9];
    else
      l1 = AR.time.t1[1] .. " " .. AR.time.t1[hour - 11];
      l2 = AR.time.t2[1] .. " " .. AR.time.t2[hour - 11];
      l3 = AR.time.t3[1] .. " " .. AR.time.t3[hour - 11];
    end
  else
    l1 = AR.time.t1[2] .. " " .. AR.time.t1[hour - 21];
    l2 = AR.time.t2[2] .. " " .. AR.time.t2[hour - 21];
    l3 = AR.time.t3[2] .. " " .. AR.time.t3[hour - 21];
  end

  goto mins;
  ::not12::

  if hour <= 9 then
    l1 = AR.time.t1[1] .. " " .. AR.time.t1[hour + 1];
    l2 = AR.time.t2[1] .. " " .. AR.time.t2[hour + 1];
    l3 = AR.time.t3[1] .. " " .. AR.time.t3[hour + 1];
  elseif hour == 10 then
    l1 = AR.time.t1[2] .. " " .. AR.time.t1[1];
    l2 = AR.time.t2[2] .. " " .. AR.time.t2[1];
    l3 = AR.time.t3[2] .. " " .. AR.time.t3[1];
  elseif hour > 10 and hour < 20 then
    l1 = AR.time.t1[2] .. " " .. AR.time.t1[hour - 9];
    l2 = AR.time.t2[2] .. " " .. AR.time.t2[hour - 9];
    l3 = AR.time.t3[2] .. " " .. AR.time.t3[hour - 9];
  elseif hour == 20 then
    l1 = AR.time.t1[3] .. " " .. AR.time.t1[1];
    l2 = AR.time.t2[3] .. " " .. AR.time.t2[1];
    l3 = AR.time.t3[3] .. " " .. AR.time.t3[1];
  else
    l1 = AR.time.t1[3] .. " " .. AR.time.t1[hour - 19];
    l2 = AR.time.t2[3] .. " " .. AR.time.t2[hour - 19];
    l3 = AR.time.t3[3] .. " " .. AR.time.t3[hour - 19];
  end

  ::mins::

  l1 = l1 .. "   ";
  l2 = l2 .. " : ";
  l3 = l3 .. "   ";

  if min < 10 then
    l1 = l1 .. AR.time.t1[1] .. " " .. AR.time.t1[min + 1];
    l2 = l2 .. AR.time.t2[1] .. " " .. AR.time.t2[min + 1];
    l3 = l3 .. AR.time.t3[1] .. " " .. AR.time.t3[min + 1];
  else
    l1 = l1 .. AR.time.t1[math.floor(min / 10) + 1] .. " " .. AR.time.t1[min % 10 + 1];
    l2 = l2 .. AR.time.t2[math.floor(min / 10) + 1] .. " " .. AR.time.t2[min % 10 + 1];
    l3 = l3 .. AR.time.t3[math.floor(min / 10) + 1] .. " " .. AR.time.t3[min % 10 + 1];
  end

  if use12 == true then
    if hour < 12 then
      l1 = l1 .. "   " .. AR.time.m1[1];
      l2 = l2 .. "   " .. AR.time.m2[1];
      l3 = l3 .. "   " .. AR.time.m3[1];
    else
      l1 = l1 .. "   " .. AR.time.m1[2];
      l2 = l2 .. "   " .. AR.time.m2[2];
      l3 = l3 .. "   " .. AR.time.m3[2];
    end
  end

  table.insert(l, l1);
  table.insert(l, l2);
  table.insert(l, l3);

  return l;
end

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
  "／l、   ",
  "（ﾟ､ ｡ ７   ",
  "l  ~ヽ  ",
  "  じしf_,)ノ",
}

return AR;
