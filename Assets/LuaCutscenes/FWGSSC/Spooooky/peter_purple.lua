function onBegin()
    disableMovement()
    say("FWGSSC_Spooooky_PeterPurple")
    say("FWGSSC_Spooooky_PeterPurple2")
    say("FWGSSC_Spooooky_PeterPurple3")
    say("FWGSSC_Spooooky_PeterPurple4")
    say("FWGSSC_Spooooky_PeterPurple5")
    setFlag("decal_flag_Peter5", true)
    wait(1.5)
    say("FWGSSC_Spooooky_PeterPurple6")
    enableMovement()
end

function onEnd(room, wasSkipped)
    setFlag("decal_flag_Peter5", true)
	enableMovement()
end