local data = require("intro.data");

local A = {};
local V = vim;
local uv = V.loop or V.uv;
local timer = uv.new_timer();

A.frameCount = 0;
A.renderComplete = {};

A.setDefaults = function(element)
  if element.startDelay == nil then
    element.startDelay = 0;
  end

  if element.frameDelay == nil then
    element.frameDelay = 0;
  end

  element.__state = (element.startDelay == 0) and "play" or "start_delay";
  element.__loopFinished = 0;
  element.__thisFrameIndex = 1;
  element.__delayPassed = 1;
end

A.renderHandler = function (animationElement, elementType)
  if animationElement.__state == "start_delay" then
    if animationElement.__delayPassed < animationElement.startDelay then
      animationElement.__delayPassed = animationElement.__delayPassed + 1;

      animationElement.__state = "start_delay";
      return;
    else
      animationElement.__delayPassed = 1;
      animationElement.__startDelayPassed = true;

      animationElement.__state = "play";
    end
  elseif animationElement.__state == "play" then
    if elementType == "hl" then
      A.hlExists(animationElement.groupName, animationElement.values[animationElement.__thisFrameIndex]);
    elseif elementType == "txt" then
      A.textChanger(animationElement);
    end

    -- Play handler
    if animationElement.__thisFrameIndex < #animationElement.values then
      animationElement.__thisFrameIndex = animationElement.__thisFrameIndex + 1;

      if type(animationElement.frameDelay) == "number" then
        animationElement.__state = "frame_delay";
      end
    else
      animationElement.__thisFrameIndex = 1;

      if type(animationElement.loop) == "nil" or animationElement.loop == false then
        animationElement.__state = "over";
        table.insert(A.renderComplete, animationElement)
      elseif type(animationElement.loop) == "number" and animationElement.__loopFinished < animationElement.loop then
        animationElement.__loopFinished = animationElement.__loopFinished + 1;

        if type(animationElement.loopDelay) == "number" then
          animationElement.__state = "loop_delay";
        else
          animationElement.__state = "play";
        end
      elseif type(animationElement.loop) == "number" and animationElement.__loopFinished == animationElement.loop then
        animationElement.__state = "over";
        table.insert(A.renderComplete, animationElement)
      elseif animationElement.loop == true then
        if type(animationElement.loopDelay) == "number" then
          animationElement.__state = "loop_delay";
        else
          animationElement.__state = "play";
        end
      end
    end
  elseif animationElement.__state == "frame_delay" then
    if animationElement.__delayPassed < animationElement.frameDelay then
      animationElement.__delayPassed = animationElement.__delayPassed + 1;

      animationElement.__state = "frame_delay";
    else
      animationElement.__delayPassed = 1;

      animationElement.__state = "play";
    end
    -- Frame delay
  elseif animationElement.__state == "loop_delay" then
    if animationElement.__delayPassed < animationElement.loopDelay then
      animationElement.__delayPassed = animationElement.__delayPassed + 1;

      animationElement.__state = "loop_delay";
    else
      animationElement.__delayPassed = 1;

      animationElement.__state = "play";
    end
  end
end

A.hlExists = function(name, value)
  if name == nil or value == nil then
    return;
  end

  if V.fn.hlexists(name) == 1 then
    V.api.nvim_set_hl(0, name, value)
  else
    V.api.nvim_set_hl(0, "Intro_" .. name, value)
  end
end

A.textChanger = function(element)
  if element.mode == "line" then
    local ln = element.line == nil and data.whiteSpaces + 1 or data.whiteSpaces + element.line;
    local texts;
    local lnEnd = ln;

    if type(element.values[element.__thisFrameIndex]) == "string" then
      texts = { element.values[element.__thisFrameIndex] };

      lnEnd = lnEnd + 1
    elseif type(element.values[element.__thisFrameIndex]) == "table" then
      texts = {};

      for _, line in ipairs(element.values[element.__thisFrameIndex]) do
        table.insert(texts, line);
        lnEnd = lnEnd + 1;
      end
    end

    V.bo.modifiable = true;
    V.api.nvim_buf_set_lines(data.introBuffer, ln, lnEnd, false, texts)
    V.bo.modifiable = false;
  elseif element.mode == "virt_text" then
    local X = element.x ~= nil and element.x or 0;
    local Y = element.y ~= nil and element.y or 0;

    local text;

    if type(element.values[element.__thisFrameIndex]) == "table" then
      text = element.values[element.__thisFrameIndex];
    else
      text = {
        { element.values[element.__thisFrameIndex], "Normal" }
      };
    end

    local v_opts = {
      end_line = Y + #element.values[element.__thisFrameIndex];
      id = 1,

      virt_text = text,
      virt_text_pos = "overlay"
    }

    V.api.nvim_buf_set_extmark(data.introBuffer, 1, Y, X, v_opts)
  end
end

A.calculateMaxFrames = function (animations)
  local maxFrames = 0;

  if animations.highlightBased == nil then
    goto cantFindHLs;
  end

  for _, v in ipairs(animations.highlightBased) do
    local frameCount = 0;

    if v.loop == true then
      maxFrames = 99;
      break
    end

    for f = 1, #v.values do
      frameCount = frameCount + 1;

      if f == 1 then
        goto firstValHasNoFrameDelay_hl;
      end

      if type(v.frameDelay) == "number" then
        frameCount = frameCount + v.frameDelay
      end

      ::firstValHasNoFrameDelay_hl::
    end

    if type(v.loop) == "number" then
      frameCount = frameCount + (frameCount * (v.loop - 1));
    end

    if type(v.loopDelay) == "number" and type(v.loop) == "number" then
      frameCount = frameCount + (v.loopDelay * (v.loop - 1));
    end

    if type(v.startDelay) == "number" then
      frameCount = frameCount + v.startDelay;
    end

    if frameCount > maxFrames then
      maxFrames = frameCount;
    end
  end


  ::cantFindHLs::

  if animations.textBased == nil then
    goto cantFindTXTs
  end

  for _, v in ipairs(animations.textBased) do
    if v.loop == true then
      maxFrames = 99;
      break
    end
  end

  ::cantFindTXTs::

  return maxFrames;
end

A.animationWorker = function (animations)
  if animations == nil then
    return;
  end

  local delay = 0;
  local updateDelay = 200;

  local totalAnimationLength = 0;
  local maxFrames = 100;

  if animations.delay ~= nil then
    delay = animations.delay;
  end

  if animations.updateDelay ~= nil then
    updateDelay = animations.updateDelay;
  end

  if animations.highlightBased == nil then
    goto noHlAnim;
  end

  for _, v in ipairs(animations.highlightBased) do
    A.setDefaults(v);

    if type(v.startDelay) == "number" and v.startDelay > maxFrames then
      maxFrames = v.startDelay;
    end

    totalAnimationLength = totalAnimationLength + 1;
  end

  ::noHlAnim::

  if animations.textBased == nil then
    goto noTxAnim;
  end

  for _, v in ipairs(animations.textBased) do
    A.setDefaults(v);

    if type(v.startDelay) == "number" and v.startDelay > maxFrames then
      maxFrames = v.startDelay;
    end

    totalAnimationLength = totalAnimationLength + 1;
  end

  ::noTxAnim::

  timer:start(delay, updateDelay, V.schedule_wrap(
    function()
      -- if there is no animations then exit
      if animations.highlightBased == nil and animations.highlightBased == nil then
        timer:stop();
        return;
      end

      if #A.renderComplete >= totalAnimationLength then
        timer:stop();
        return;
      end

      for _, tbl in ipairs(animations.highlightBased) do
        A.renderHandler(tbl, "hl");
      end

      if animations.textBased == nil then
        goto noTextAnim;
      end

      for _, tbl in ipairs(animations.textBased) do
        A.renderHandler(tbl, "txt");
      end

      ::noTextAnim::
      if A.frameCount < maxFrames then
        A.frameCount = A.frameCount + 1;
      end
    end
  ))

  V.api.nvim_create_autocmd({ "BufDelete" }, {
    pattern = { "<buffer>" },
    callback = function()
      timer:stop();
    end
  })
end

return A;
