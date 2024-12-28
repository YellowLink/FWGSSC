function onBegin()
    disableMovement()
    say("FWGSSC_Spooooky_PeterBlue")
    say("FWGSSC_Spooooky_PeterBlue2")
    say("FWGSSC_Spooooky_PeterBlue3")
    setFlag("decal_flag_Peter3", true)
    wait(1.5)
    say("FWGSSC_Spooooky_PeterBlue4")
    enableMovement()
end

function onEnd(room, wasSkipped)
    setFlag("decal_flag_Peter3", true)
	enableMovement()
end