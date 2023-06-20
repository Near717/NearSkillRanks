NEAR_SR = {
	name 		= "NearSkillRanks",
	title 		= "Near's Skill Ranks",
	shortTitle 	= "Skill Ranks",
	version 	= "0.1.4",
	author 		= "|cCC99FFnotnear|r",
}
local addon = NEAR_SR

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Addon loading
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function OnAddonLoaded(event, name)
	if name ~= addon.name then return end
	EVENT_MANAGER:UnregisterForEvent(addon.name, EVENT_ADD_ON_LOADED)

	local asv_version = 2
	addon.ASV = {}
	addon.ASV.settings	= ZO_SavedVars:NewAccountWide(addon.name .. "_Data", asv_version, 'settings', addon.defaults.settings, GetWorldName())
	addon.ASV.char		= ZO_SavedVars:NewAccountWide(addon.name .. "_Data", asv_version, 'char_data', addon.defaults.char, GetWorldName())

	addon.func.UpdateAllData()
	addon.SetupSettings()

end

EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
