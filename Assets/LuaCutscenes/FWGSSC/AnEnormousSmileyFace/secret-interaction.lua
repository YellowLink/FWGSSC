function onBegin()
  player.DummyAutoAnimate = true
  player.ForceCameraUpdate = true
  makeUnskippable()
  disableRetry()
  if not (getFlag("secret-leave-once") or getFlag("silver-secret-entered")) then
    if (getFlag("silver")) then
      disableMovement()
      say("SECRET_SILVER")
      setFlag("silver-secret-entered", true)
      if (getFlag("hultra")) then
        die()
        wait(1)
      end
    elseif (getFlag("hultra")) then
      say("SECRET_WELCOME")
      setFlag("hultra", false)
      die()
      wait(1)
    end
  elseif (getFlag("hultra")) then
    say("SECRET_RETURN_DIE")
    setFlag("hultra", false)
    die()
    wait(1)
  end
  generalBehavior()
end

function onEnd(wasSkipped)
  enableMovement()
  enableRetry()
  if (getFlag("hultra")) then
    setFlag("hultra", false)
    endCutscene()
  end
end

function generalBehavior()
  dialog_options = {"SECRET_CHOICE_LEAVE", "SECRET_CHOICE_LOOP", "SECRET_CHOICE_ZIPPER", "SECRET_CHOICE_BOOSTER", "SECRET_CHOICE_DOG"}
  flag_checks = {"silver", "secret-loop-done", "secret-zipper-done", "secret-booster-done"}
  dialog_seen_flags = {"secret-leave-once", "secret-loop-once", "secret-zipper-once", "secret-booster-once", "secret-dog-once"}
  teleport_tags = {"Summit", "Special-Loop", "Special-Zipper", "Special-Booster", "Special-Dog"}
  options_actual = {}  -- dialog_options with invald choices removed
  options_refrence = {}  -- refrence to the original dialog_options index

  disableMovement()
  for i=1,4 do
    if (not getFlag(flag_checks[i])) then
      table.insert(options_actual, dialog_options[i]) -- if not triggered, add it to dialog_actual
      table.insert(options_refrence, i)
    else
      setFlag(dialog_seen_flags[i], false)  -- clean up any unused flags
    end
  end

  if ((#options_actual == 0) or (#options_actual == 1 and not getFlag("silver"))) then
    table.insert(options_actual, "SECRET_CHOICE_DOG")
    table.insert(options_refrence, 5)
  end

  if (getFlag("silver")) then
    say("SILVER_SECRET_QUESTION")
  else
    say("SECRET_QUESTION")
  end
  
  choice = options_refrence[choice(options_actual)]
  
  if (getFlag("silver")) then
    if (choice == 5) then
      say("SILVER_SECRET_DOG")
      setFlag("secret-dog-once")
    else
      say("SILVER_SECRET_TELEPORT")
    end
  else
    if (getFlag(dialog_seen_flags[choice])) then
      say(dialog_options[choice] .. "_RESPONSE_TWO")
    else
      say(dialog_options[choice] .. "_RESPONSE_ONE")
      setFlag(dialog_seen_flags[choice], true)
    end
  end

  enableMovement()
  enableRetry()
  teleportTo(0, 0, teleport_tags[choice], "respawn")
end

function onEnd(wasSkipped)
  if (wasSkipped) then
    die()
  end
end
