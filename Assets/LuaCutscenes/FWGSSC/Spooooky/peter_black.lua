function onBegin()
    disableMovement()
    say("FWGSSC_Spooooky_PeterBlack")
    say("FWGSSC_Spooooky_PeterBlack2")
    say("FWGSSC_Spooooky_PeterBlack3")
    say("FWGSSC_Spooooky_PeterBlack4")
    say("FWGSSC_Spooooky_PeterBlack5")
    setFlag("decal_flag_Peter6", true)
    wait(1.5)
    say("FWGSSC_Spooooky_PeterBlack6")
    enableMovement()
end

function onEnd(room, wasSkipped)
    setFlag("decal_flag_Peter6", true)
	enableMovement()
end