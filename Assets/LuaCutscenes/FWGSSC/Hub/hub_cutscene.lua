function onBegin()
    makeUnskippable()
    if (arguments == "Hub_Intro") then
        hubIntro()
    end
    while (not getFlag("tp_ready")) do
        wait()
    end
    setFlag("tp_ready", false)
    instantTeleport(arguments)
end

function hubIntro()
    while (not getFlag("disable_lightning")) do
        wait()
    end
    setFlag("disable_lightning", false)
    teleportTo(1376,1688,"lobby1")
end