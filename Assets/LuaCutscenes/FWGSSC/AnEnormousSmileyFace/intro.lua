--[[
TODO: 
      Maybe: Improve panic walk
      Indicate panic better
         + screen shake?
        override music? temple and/or white noise
         + make it get darker?      
--]]
local lua_helper = celeste.Mod.LuaCutscenes.LuaHelper
local monocle = require("#monocle")
local vector2 = require("#microsoft.xna.framework.vector2")

local function makeCoroutine(func)
  return monocle.Coroutine(lua_helper.LuaCoroutineToIEnumerator(coroutine.create(func)))
end

function onBegin()
  if getFlag("introWatched") then
    return
  end
  setup()
  move_coroutine = makeCoroutine(moveController)
  cutsceneEntity:Add(move_coroutine)
  camera_coroutine = makeCoroutine(cameraController)
  cutsceneEntity:Add(camera_coroutine)
  talkController()
end

function setup()
  disableMovement()
  waitUntilOnGround()
  player.ForceCameraUpdate = true
  player.DummyAutoAnimate = true
end

function onEnd(wasSkipped)
  enableMovement()
  if move_coroutine then
    move_coroutine:Cancel()
    cutsceneEntity:Remove(move_coroutine)
  end
  if camera_coroutine then
    camera_coroutine:Cancel()
    cutsceneEntity:Remove(camera_coroutine)
  end
  if music_coroutine then
    music_coroutine:Cancel()
    cutsceneEntity:Remove(music_coroutine)
  end
  setCameraOffset(0, 0)
  engine.Scene:ResetZoom()
  player.DummyAutoAnimate = true
  if (wasSkipped and not getFlag("introWatched")) then
    teleportTo(744, 176)
  end
  setFlag("introWatched", true)
end

-- END MAIN CALLS

-- BEGIN CONTROLLER CALLS

local current_activity = 1  -- 1 = search, 2 = decide to climb, 3 = climb, 4 = look around, 5 = look up, 6 = panic, 7 = dog
local move_processing = false

-- say the search pattern dialog/search walk (1)
-- once done talking, move towards the base of the tree (2)
-- once moveing towards tree, talk about climb (2)
-- once done talking, climb tree (3)
-- once done climbing, look around (4)
-- once done talking about looking, stop looking (5)
-- once done looking, look up (5)
-- once done talking about up, talk about panic (6)
-- once done talking about panic, dog (7)

function moveController()
  -- say the search pattern dialog/search walk (1)
  move_processing = true
  while (current_activity < 2) do
    searchMove()
    wait(0.3)
  end
  -- once done talking, move towards the base of the tree (2)
  move_processing = false
  wait()
  move_processing = true
  goToSetpoint(5)
  walkTo(366)
  player.DummyAutoAnimate = false
  player.Sprite:Play("lookUp")
  move_processing = false
  -- once moving towards tree, talk about climb (2)
  while (current_activity < 3) do
    wait()
  end
  player.DummyAutoAnimate = true
  -- once done talking, climb tree (3)
  move_processing = true
  climbTree()
  move_processing = false
  while (current_activity < 4) do
    wait()
  end
  -- once done climbing, look around (4)
  move_processing = true
  while (current_activity < 5) do
    time_delay = math.floor(math.random(60, 120))
    while (current_activity < 5 and time_delay > 1) do
      wait()
      time_delay = time_delay - 1
    end
    swapDir()
  end
  move_processing = false
  -- once done talking about looking, look up (5)
  player.DummyAutoAnimate = false
  player.Sprite:Play("lookUp")
  player.Facing = getEnum("Celeste.Facings", "Right")
  while (current_activity < 6) do
    wait()
  end
  -- once done talking about up, talk about panic (6)
  -- once done talking about panic, see dog (7)
  player.Sprite:Play("tired")
  while (current_activity < 8) do
    wait()
  end
  player.DummyAutoAnimate = true
  -- once done talking about dog, walk to dog (8)
  move_processing = true
  walkTo(648)
  move_processing = false
  -- once done moving to dog, talk to dog, calm (9)
  while (current_activity < 9.1) do
    wait()
  end
  -- once asked who dog is, check collar
  player.DummyAutoAnimate = false
  player.Sprite:Play("duck")
  wait(1.5)
  player.DummyAutoAnimate = true
  while (current_activity < 10) do
    wait()
  end
  -- once calmed, walk offscreen (10)
  move_processing = true
  walkTo(722)
  move_processing = false
end

function cameraController()
  -- zoom is x-centered, then y bottom - half zoomed screen height - 1 tile
  zoom_time = 0
  zoom = 1
  wait(1)
  -- say the search pattern dialog/search walk (1)
  while (current_activity < 1.1) do
    zoom = 2 - 1200/(zoom_time + 1200)
    engine.Scene:ZoomSnap(vector2(160, 180 - 90/zoom), zoom)
    zoom_time = zoom_time + 1
    wait()
  end
  -- once partway done talking calm zoom (1.1)
  zoom = 1.2
  coroutine.yield(engine.Scene:ZoomAcross(vector2(160, 180 - 90/zoom), zoom, 3))
  -- once done talking, move towards the base of the tree (2)
  while (current_activity < 3) do
    wait()
  end
  -- once moveing towards tree, talk about climb (2)
  -- once done talking/moving, climb tree (3)
  coroutine.yield(engine.Scene:ZoomAcross(vector2(160, 160 - 90/zoom), zoom, 2))
  while (current_activity < 5.1) do
    wait()
  end
  -- once done climbing, look around (4)
  -- once done talking about looking, look up (5)
  -- look up camera (5.1)
  move_time = 0
  engine.Scene:ZoomAcross(vector2(160, 90), 1, 2)
  while (current_activity < 6) do
    move_time = move_time + 1
    setCameraOffset(0.075 * move_time, -0.3 * move_time)
    wait()
  end
  -- once done talking about up, talk about panic (6)
  setCameraOffset(0, 0)
  wait(0.1)
  while (current_activity < 7) do
    zoom = 3 - 1000/(zoom_time + 500)
    engine.Scene:ZoomSnap(vector2(160, 80), zoom)
    zoom_time = zoom_time + 1
    wait()
  end
  -- once done talking about panic, see dog (7)
  spawnBuffy()
  setCameraOffset(100, 100)
  coroutine.yield(engine.Scene:ZoomAcross(vector2(240, 125), 2, 1))
  -- once done talking about dog, go to dog (8)
  while (current_activity < 9) do
    wait()
  end
  -- once done going to dog, talk to dog, calm(9)
  coroutine.yield(engine.Scene:ZoomAcross(vector2(160, 90), 1, 5))
  setCameraOffset(0)
  while (current_activity < 11) do
    wait()
  end
end

function talkController()
  -- say the search pattern dialog/search walk (1)
  say("START_SEARCHING")  -- START_SEARCHING
  -- once partway through talking, calm down (1.1)
  current_activity = 1.1
  say("CALM_SEARCHING")
  -- once done talking, move towards the base of the tree (2)
  setpoint_index = 5 -- override current target, go to base of tree
  current_activity = 2
  -- once moving towards tree, talk about climb (2)
  repeat
    wait()
  until (move_processing ~= true)
  say("CONSIDER_CLIMBING")  -- CONSIDER_CLIMBING
  -- once done talking, climb tree (3)
  current_activity = 3
  repeat
    wait()
  until (move_processing ~= true)
  -- once done climbing, look around (4)
  current_activity = 4
  say("DONT_SEE_ANYTHING")  -- DONT_SEE_ANYTHING
  -- once done talking about looking, look up (5)
  current_activity = 5
  say("WHAT_IS_THAT_UP")  -- WHAT_IS_THAT_UP
  current_activity = 5.1
  say("THAT_IS_IT_UP")  -- THAT_IS_IT_UP
  -- once done talking about up, talk about panic (6)
  current_activity = 6
  say("TREE_TOP_PANIC")  -- TREE_TOP_PANIC
  -- once done talking about panic, see dog (7)
  current_activity = 7
  playSound("event:/AnEnormousSmileyFace/OneBark", player.Position)
  say("DOG_BARK")  -- DOG_BARK
  -- once done talking about seeing dog, go to dog (8)
  current_activity = 8
  say("HELLO_DOG")  -- HELLO_DOG
  repeat
    wait()
  until (move_processing ~= true)
  -- once at dog, talk to dog, calm down (9)
  current_activity = 9
  say("DOG_GREETING")
  -- once asked for name, check collar
  current_activity = 9.1
  say("DOG_CAN_HELP")  -- DOG_CAN_HELP
  playSound("event:/AnEnormousSmileyFace/TwoBark", player.Position)
  say("DOG_CAN_HELP_2")
  -- once calmed, walk offscreen
  current_activity = 10
  repeat
    wait()
  until (move_processing ~= true)
  current_activity = 11
end

-- END CONTROLLER CALLS

-- BEGIN PANIC WALK CYCLE

local x_setpoint = {115, 185, 256, 310, 350, 400, 450, 500, 550, 600}
local y_setpoint = {0, 1, 0, 1, 2, 1, 0, 0, 0, 0}

local setpoint_index = 0

function searchMove()
  goToSetpoint(math.floor(math.random(2,10)))
  wait()
end

function traverseSetpoint(right)
  dir = -1
  if right then
    dir = 1
  end
  --if it is at the initial setpoint index, it won't have to jump.
  --otherwise, if the next y_setpoint is higher than this one, jump and move
  --and if it isn't higher just move
  if (setpoint_index > 0 and y_setpoint[setpoint_index] < y_setpoint[setpoint_index + dir]) then
    jump(0.2)
  end
  setpoint_index = setpoint_index + dir
  walkTo(x_setpoint[setpoint_index])
  waitUntilOnGround()
end

function goToSetpoint(target)
  if (target < 1) then
    target = 1
  elseif (target > 10) then
    target = 10
  end
  while (target ~= setpoint_index) do
    if (target > setpoint_index) then
      traverseSetpoint(true)
    else
      traverseSetpoint(false)
    end
  end
end

-- END PANIC WALK CYCLE

-- BEGIN TREE CLIMB

function climbTree()
  -- Climb the tree
  runTo(376)
  jump(1)
  runTo(412)
  wait(0.5)
  waitUntilOnGround()
  jump(1)
  runTo(426)
  wait(0.5)
  waitUntilOnGround()
  jump(1)
  runTo(435)
  wait(0.5)
  waitUntilOnGround()
  jump(1)
  runTo(444)
  wait(0.5)
  waitUntilOnGround()
  jump(1)
  runTo(451)
end

-- END TREE CLIMB

-- START TREETOP LOOKAROUND

local right = false

function swapDir()
  if (right) then
    player.Facing = getEnum("Celeste.Facings", "Left")
    right = false
  else
    player.Facing = getEnum("Celeste.Facings", "Right")
    right = true
  end
end

-- END TREETOP LOOKAROUND

-- START BUFFY CODE

function spawnBuffy()
  -- create and add a new badeline dummy entity
  buffy = celeste.BadelineDummy(vector2(665, 178))
  buffy.Sprite.Scale = vector2(-1, 1.0)
  getRoom():Add(buffy)
  buffy.Sprite:Play("duck")
  buffy.Floatness = 0
end

-- END BUFFY CODE
