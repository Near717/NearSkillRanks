NEAR_SR = {
	name 		= "NearSkillRanks",
	title 		= "Near's Skill Ranks",
	shortTitle 	= "Skill Ranks",
	version 	= "0.1.1",
	author 		= "|cCC99FFnotnear|r",
}
local addon = NEAR_SR

local function Initialize()
	local funcName = 'Initialize'
	local dbg = addon.utils.dbg
	local sv = addon.ASV.settings

	--[[ Debug ]] if sv.debug then d(dbg.open) d(dbg.lightGrey..'start of '..funcName) end

	EVENT_MANAGER:UnregisterForEvent(addon.name .. '_Initialize_OnPlayerActivated', EVENT_PLAYER_ACTIVATED)

	addon.func.UpdateAllData()

	--[[ Debug ]] if sv.debug then d(dbg.grey..'end of '..funcName) d(dbg.close) end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Slash commands
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

local LSC = LibSlashCommander

function addon.RegisterSlashCommands()

	LSC:Register("/nsr", function() addon.gui.ToggleWindow() end, "Toggle 'Skill Ranks' window")

end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Addon loading
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function OnAddonLoaded(event, name)
	if name ~= addon.name then return end
	EVENT_MANAGER:UnregisterForEvent(addon.name, EVENT_ADD_ON_LOADED)

	local asv_version = 1
	addon.ASV = {}
	addon.ASV.settings	= ZO_SavedVars:NewAccountWide(addon.name .. "_Data", asv_version, 'settings', addon.defaults, GetWorldName())
	addon.ASV.char		= ZO_SavedVars:NewAccountWide(addon.name .. "_Data", asv_version, GetCurrentCharacterId(), addon.defaults_char, GetWorldName())


	addon.RegisterSlashCommands()
	addon.SetupSettings()


	EVENT_MANAGER:RegisterForEvent(addon.name..'_Initialize_OnPlayerActivated', EVENT_PLAYER_ACTIVATED, Initialize)

end

EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
