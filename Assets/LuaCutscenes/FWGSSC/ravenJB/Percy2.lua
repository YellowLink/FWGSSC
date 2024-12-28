local lua_helper = celeste.Mod.LuaCutscenes.LuaHelper
local monocle = require("#monocle")

local function makeCoroutine(func)
    return monocle.Coroutine(lua_helper.LuaCoroutineToIEnumerator(coroutine.create(func)))
end

local function approachNPC()
    player.ForceCameraUpdate = true
    walkTo(10542)
    player.Facing = getEnum("Celeste.Facings", "Right")
    setCameraOffset(0,0)
end

local approachNPCCoroutine

function onTalk()
    disableMovement()
    approachNPCCoroutine = makeCoroutine(approachNPC)
    talker:Add(approachNPCCoroutine)
	if not getFlag("talked_to_percy") then
		setFlag("talked_to_percy", true)
		setFlag("talked_in_2", true)
		say("FWGSSC_ravenJB_Percy2_intro")
	else
		if not getFlag("talked_in_2") then
			setFlag("talked_in_2", true)
			say("FWGSSC_ravenJB_Percy2_dialog")
		else
			say("FWGSSC_ravenJB_Percy2_repeat")
		end
	end
    enableMovement()
end

function onEnd(room, wasSkipped)
    if approachNPCCoroutine then
        approachNPCCoroutine:Cancel()
        talker:Remove(approachNPCCoroutine)
    end
    enableMovement()
end