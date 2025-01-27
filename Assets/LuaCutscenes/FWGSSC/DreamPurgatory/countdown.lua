function onBegin()
    setFlag("pass", false)
    makeUnskippable()
    miniTextbox("FWGSSC_DreamPurgatory_three")
    wait(1)
    miniTextbox("FWGSSC_DreamPurgatory_two")
    wait(1)
    miniTextbox("FWGSSC_DreamPurgatory_one")
    wait(1)
    if (getFlag("pass")) then
        miniTextbox("FWGSSC_DreamPurgatory_yay")
    else
        miniTextbox("FWGSSC_DreamPurgatory_too_slow")
    end
end