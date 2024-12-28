function onEnter()
  setFlag("hultra", false)
end
  
function onStay()
  if (player.Position.Y >= -2590 and (getFlag("hultra") or getFlag("silver"))) then
    teleportTo(0, 0, "Special-Terminal")
  end
end
