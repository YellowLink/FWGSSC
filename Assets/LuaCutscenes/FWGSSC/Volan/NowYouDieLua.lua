function onBegin()
    setFlag("NotDieFlag", false)
    disableMovement()
    say("NowYouDie")
end

function onEnd()
    setFlag("NotDieFlag", true)
    enableMovement()
end