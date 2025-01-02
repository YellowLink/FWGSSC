--[[
function onBegin()
    makeUnskippable()
    waitUntilBreaker()
    hubTP()
end
--]]

function hubTP()
    instantTeleport("hub-main")
end

function waitUntilBreaker()
    while (not getFlag("disable_lightning")) do
        wait()
    end
end

local lua_helper = celeste.Mod.LuaCutscenes.LuaHelper
local monocle = require("#monocle")
local vector2 = require("#microsoft.xna.framework.vector2")

local function makeCoroutine(func)
  return monocle.Coroutine(lua_helper.LuaCoroutineToIEnumerator(coroutine.create(func)))
end

target_x = 12936
target_y = -2992
target = vector2(target_x, target_y)
duration = 10 --seconds

-- move controller
time_to_center = 5 --seconds
tangent_speed = 200

-- camera controller
max_zoom = 4
zoom_duration = 900 --bigger = slower
target_y = 70 --from top of screen

function onBegin()
    makeUnskippable()
    waitUntilBreaker()
    disableMovement()
    disableRetry()
    player.Collidable = false
    player.DummyAutoAnimate = false
    player.TreatNaive = true
	player.Sprite:Play("spin")
    move_coroutine = makeCoroutine(moveController)
    cutsceneEntity:Add(move_coroutine)
    camera_coroutine = makeCoroutine(cameraController)
    cutsceneEntity:Add(camera_coroutine)
    wait(duration)
end

function onEnd()
    enableMovement()
    enableRetry()
    player.Collidable = true
    player.TreatNaive = false
    if move_coroutine then
        move_coroutine:Cancel()
        cutsceneEntity:Remove(move_coroutine)
    end
    if camera_coroutine then
        camera_coroutine:Cancel()
        cutsceneEntity:Remove(camera_coroutine)
    end
    setFlag("disable_lightning", false)
    engine.Scene:ResetZoom()
    hubTP()
end

function magnitude(x1,y1,x2,y2)
    return ((x1 - x2) ^ 2 + (y1 - y2) ^ 2) ^ 0.5
end

function moveController()
    --distance_tolerance = 0 -- this doesn't seem to work and I'm not sure why
    initial_distance = magnitude(player.Position.X, player.Position.Y, target.X, target.Y)
    m = initial_distance
    prev_loc = player.Position
    wait()  --why does it need to wait 1 frame? I don't know!
            --but if I don't do this madeline teleports off into the distance!
    --while m > distance_tolerance do --might revisit this later
    while true do
        m = magnitude(player.Position.X, player.Position.Y, target_x, target_y)
        inwards = (target - player.Position) / m
        tangent = vector2(inwards.Y, -inwards.X)
        speed = tangent * tangent_speed + inwards * initial_distance / time_to_center * 5
        --why 5? I don't know! It just sorta works good
        player.Position = prev_loc + speed
        prev_loc = prev_loc + speed
        wait()
    end
    --[[
    final_loc = player.Position
    while true do
        player.Speed = vector2(0, 0)
        player.Position = final_loc
        wait()
    end--]]
end

function cameraController()
    zoom_time = 0
    while true do
        --max_zoom - zoom_duration / v = 1
        --(max_zoom - 1) * v = zoom_duration
        --v = zoom_duration / (max_zoom - 1)
        --equation I wrote in desmos: 4 - 900/(300 + x)
        zoom = max_zoom - zoom_duration/(zoom_time + (zoom_duration / (max_zoom - 1)))
        --ZoomSnap(vector2(x_position, y_position), zoom_amount)
        --y position = 90 -> target y
        -- zoom = max: y = target y
        -- zoom = 1: y = 90
        -- y = 90 + v1 - v2 / zoom
        -- 90 + v1 - v2 / 1 = 90
        -- v1 = v2
        -- v2 - v2 / max + 90 = target_y
        -- v2 * (max-1)/max = target_y - 90
        -- v2 = v1 = max/(max-1) * (target_y - 90)
        -- y = 90 + (target_y - 90) * (max/max-1) - ((target_y - 90) * (max/max-1)) / zoom
        y_target = 90 + (target_y - 90) * (max_zoom / (max_zoom - 1)) * ((zoom - 1) / zoom)
        engine.Scene:ZoomSnap(vector2(160, y_target), zoom)
        zoom_time = zoom_time + 1
        wait() --very important. Wait's one frame. Without this the game freezes
    end
end

--[[
player.CameraAnchor = Target;
player.CameraAnchorLerp = Vector2.One * MathHelper.Clamp(LerpStrength *
                          GetPositionLerp(player, PositionMode), 0f, 1f);
(1, 1) * LerpStrength 
    (LerpStrength is on [0.5, 1] and GetPositionLerp returns 1 for our use case)
--]]
-- In case of another attempt to control camera target (failed the first one)
