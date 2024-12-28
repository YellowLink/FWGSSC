buffy = nil

time_init = 0

function onBegin()
  if (getFlag("buffy-chat")) then
    return
  end
  while not getFlag("buffy-chat") do
    wait()
  end
  disableRetry()
  disableMovement()
  setFlag("buffy-disabled", true)

  player.DummyAutoAnimate = false
  playSound("event:/AnEnormousSmileyFace/Pet", player.Position)
  player.Sprite:play("pet")
  buffy.Sprite:play("pet")
  wait(1.8)
  player.DummyAutoAnimate = true

  playSound("event:/AnEnormousSmileyFace/OneBark", player.Position)
  say("DOG_BARK")

  player.Facing = getEnum("Celeste.Facings", "Left")
  walk(-10)
  player.Facing = getEnum("Celeste.Facings", "Right")

  if (not getFlag("buffy-chat-done")) then
    setFlag("buffy-chat-done")
    say("BUFFY_THANKS")
  end
end

function onEnd(wasSkipped)
  enableRetry()
  enableMovement()
  player.DummyAutoAnimate = true
end

function onEnter()
  if (not buffy and getFlag("secret-dog-once") and not getFlag("buffy-chat")) then
    setFlag("buffy-disabled", false)
    spawnBuffy()
    time_init = Monocle.Engine.Scene.TimeActive
  end
end

function spawnBuffy()
  if (buffy) then
    buffy:RemoveSelf()
    buffy = nil
  end
  -- create and add a new badeline dummy entity
  buffy = celeste.BadelineDummy(vector2(1830, -2654))
  scale = -1
  if (1840 < player.Position.X) then
    scale = 1
  end
  buffy.Sprite.Scale = vector2(scale, 1.0)
  getRoom():Add(buffy)
  buffy.Sprite:Play("duck")
  --buffy.Sprite:Play("pet")
  buffy.Floatness = 0
  wait(2)
  player.DummyAutoAnimate = true
end
