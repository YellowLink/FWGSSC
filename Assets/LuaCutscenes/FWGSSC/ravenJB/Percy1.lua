local lua_helper = celeste.Mod.LuaCutscenes.LuaHelper
local monocle = require("#monocle")

local function makeCoroutine(func)
    return monocle.Coroutine(lua_helper.LuaCoroutineToIEnumerator(coroutine.create(func)))
end

local function approachNPC()
    player.ForceCameraUpdate = true
    walkTo(410)
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
		say("FWGSSC_ravenJB_Percy1_intro")
	else
		say("FWGSSC_ravenJB_Percy1_repeat")
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