local A = {};
local uv = vim.loop or vim.uv;
local timer = uv.new_timer();

A.frameCount = 0;

A.setDefaults = function(element)
  if element.startDelay == nil then
    element.startDelay = 0;
  end

  if element.frameDelay == nil then
    element.frameDelay = 0;
  end

  if element.loopDelay == nil then
    element.loopDelay = 1;
  end

  element.__thisFrameIndex = 1;
  element.__delayPassed = 1;
  element.__render = true;
end

A.hlExists = function(name, value)
  if name == nil or value == nil then
    return;
  end

  if vim.fn.hlexists(name) == 1 then
    vim.api.nvim_set_hl(0, name, value)
  else
    vim.api.nvim_set_hl(0, "Intro_" .. name, value)
  end
end

A.animationWorker = function (animations)
  if animations == nil then
    return;
  end

  local delay = 0;
  local updateDelay = 200;

  if animations.delay ~= nil then
    delay = animations.delay;
  end

  if animations.updateDelay ~= nil then
    updateDelay = animations.repeatDelay;
  end

  for _, v in ipairs(animations.highlightBased) do
    A.setDefaults(v);
  end

  timer:start(delay, updateDelay, vim.schedule_wrap(
    function()
      -- if there is no animations then exit
      if animations.highlightBased == nil then
        timer:stop();
        return;
      end

      for _, tbl in ipairs(animations.highlightBased) do
        -- Skip if within delay
        if A.frameCount < tbl.startDelay then
          goto skip;
        end

        -- Skip if last element has been rendered
        if tbl.__thisFrameIndex > #tbl.values then
          -- Restart in case loop == true
          if tbl.loop == true then
            tbl.__thisFrameIndex = 1;
          else
            goto skip;
          end
        end

        -- Should this be rendered?
        if tbl.__render == true then
          -- Set the value
          A.hlExists(tbl.groupName, tbl.values[tbl.__thisFrameIndex]);
          -- nee Value
          tbl.__thisFrameIndex = tbl.__thisFrameIndex + 1;

          -- if there is no delay just render the next line
          if tbl.frameDelay ~= 0 then
            tbl.__render = false;
          else
            tbl.__render = true;
          end
        else
          -- if the correct amount of time hasn't been reached than skip
          if tbl.__delayPassed < tbl.frameDelay then
            tbl.__render = false;
            tbl.__delayPassed = tbl.__delayPassed + 1;
          else
            tbl.__render = true;
            tbl.__delayPassed = 1;
          end
        end

        ::skip::
      end

      -- Don't run infintely
      A.frameCount = A.frameCount + 1;
      if A.frameCount == 50 then
        print("\nLoop end")
        timer:stop();
      end
    end
  ))
end

return A;
