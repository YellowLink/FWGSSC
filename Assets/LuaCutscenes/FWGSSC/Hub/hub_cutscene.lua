function onBegin()
    makeUnskippable()
    waitUntilBreaker()
    hubTP()
end

function waitUntilBreaker()
    while (not getFlag("disable_lightning")) do
        wait()
    end
    setFlag("disable_lightning", false)
end

function hubTP()
    instantTeleport("hub-main")
end