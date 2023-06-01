NEAR_SR = {
	name 		= "NearSkillRanks",
	title 		= "Near's Skill Ranks",
	shortTitle 	= "Skill Ranks",
	version 	= "0.1.0",
	author 		= "|cCC99FFnotnear|r",
}
local addon = NEAR_SR

local function Initialize()
	local funcName = 'Initialize'
	local dbg = addon.utils.dbg
	local sv = addon.ASV

	--[[ Debug ]] if sv.debug then d(dbg.open) d(dbg.lightGrey..'start of '..funcName) end

	EVENT_MANAGER:UnregisterForEvent(addon.name .. '_Initialize_OnPlayerActivated', EVENT_PLAYER_ACTIVATED)

	--[[ Debug ]] if sv.debug then d(dbg.grey..'end of '..funcName) d(dbg.close) end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Slash commands
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

local LSC = LibSlashCommander

function addon.RegisterSlashCommands()

	-- LSC:Register("/rl",			function() addon.toggleKeyboard() ReloadUI() end,		"Reload UI on keyboard mode")

end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Addon loading
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function OnAddonLoaded(event, name)
	if name ~= addon.name then return end
	EVENT_MANAGER:UnregisterForEvent(addon.name, EVENT_ADD_ON_LOADED)

	addon.ASV = ZO_SavedVars:NewAccountWide(addon.name .. "_Data", 1, nil, addon.defaults)


	-- addon.RegisterSlashCommands()
	-- addon.SetupSettings()


	EVENT_MANAGER:RegisterForEvent(addon.name..'_Initialize_OnPlayerActivated', EVENT_PLAYER_ACTIVATED, Initialize)

end

EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
