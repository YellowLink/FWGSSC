function onBegin()
    disableMovement()
    say("FWGSSC_Spooooky_PeterGreen")
    say("FWGSSC_Spooooky_PeterGreen2")
    say("FWGSSC_Spooooky_PeterGreen3")
    setFlag("decal_flag_Peter2", true)
    wait(1.5)
    say("FWGSSC_Spooooky_PeterGreen4")
    enableMovement()
end

function onEnd(room, wasSkipped)
    setFlag("decal_flag_Peter2", true)
	enableMovement()
end