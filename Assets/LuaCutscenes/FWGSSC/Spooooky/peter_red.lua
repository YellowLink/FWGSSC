function onBegin()
    disableMovement()
    say("FWGSSC_Spooooky_PeterRed")
    setFlag("decal_flag_Peter1", true)
    wait(1.5)
    say("FWGSSC_Spooooky_PeterRed2")
    enableMovement()
end

function onEnd(room, wasSkipped)
    setFlag("decal_flag_Peter1", true)
	enableMovement()
end