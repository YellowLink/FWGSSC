function onBegin()
    while (not getFlag("disable_lightning")) do
        wait()
    end
    setFlag("disable_lightning", false)
    teleportTo(1376,1688,"lobby1")
end