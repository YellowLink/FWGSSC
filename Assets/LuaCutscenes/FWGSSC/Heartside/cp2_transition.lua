local vector2 = require("#microsoft.xna.framework.vector2")
local level = getLevel()

playerX = player.Position.X
playerY = player.Position.Y

function onBegin()
    makeUnskippable()
    waitUntilBreaker()
    setFlag("slowdown", true)
    coroutine.yield(level:ZoomTo(vector2(160, 120), 2, 0.3))
    instantTeleportTo(4165, -2858, "b-00")
end

function onEnd()
    ResetZoom()
end

function waitUntilBreaker()
    while (not getFlag("disable_lightning")) do
        setFlag("slowdown", false)
        wait()
    end
end
