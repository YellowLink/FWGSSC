function onBegin()
    makeUnskippable()
    disableRetry()
    start = os.time()
    playSound("event:/char/dialogue/secret_character", player.Position)
    say("STUCK")
    while (os.time() - start < 17) do
        wait(1)
    end
    die()
end

function onEnd()
    enableRetry()
end