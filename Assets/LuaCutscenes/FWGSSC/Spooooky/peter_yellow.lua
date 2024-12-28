function onBegin()
    disableMovement()
    say("FWGSSC_Spooooky_PeterYellow")
    say("FWGSSC_Spooooky_PeterYellow2")
    say("FWGSSC_Spooooky_PeterYellow3")
    say("FWGSSC_Spooooky_PeterYellow4")
    say("FWGSSC_Spooooky_PeterYellow5")
    say("FWGSSC_Spooooky_PeterYellow6")
    say("FWGSSC_Spooooky_PeterYellow7")
    setFlag("decal_flag_Peter4", true)
    wait(1.5)
    say("FWGSSC_Spooooky_PeterYellow8")
    enableMovement()
end

function onEnd(room, wasSkipped)
    setFlag("decal_flag_Peter4", true)
	enableMovement()
end