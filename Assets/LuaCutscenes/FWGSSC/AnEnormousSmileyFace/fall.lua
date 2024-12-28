function onBegin()
  if getFlag("fallWatched") then
    return
  end
  setPlayerState(20)
  waitUntilOnGround()
  wait(0.9)
  disableMovement()
  say("FALL_SAD")
end

function onEnd(wasSkipped)
  setInventory("farewell")
  enableMovement()
  setFlag("fallWatched", true)
end
