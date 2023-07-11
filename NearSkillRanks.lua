--[[
TODO:

	remove UpdateLam_skillLine()
	CreateLam_skillLine():
	add the unknown check
	add purge of previous data before the loop
	add param "update"
		if update then NEARSR_lam_dropdown_SkillLine:UpdateChoices(skillLine_dropdown.choices, skillLine_dropdown.choicesValues) end
]]

NEAR_SR = {
	name 		= "NearSkillRanks",
	title 		= "Near's Skill Ranks",
	shortTitle 	= "Skill Ranks",
	version 	= "0.1.9",
	author 		= "|cCC99FFnotnear|r",
}
local addon = NEAR_SR

NEAR_SR.SKILL_TYPE_TRADESKILL = 7

function NEAR_SR.RegisterSlashCommands()
	-- toggle window
	SLASH_COMMANDS["/sr"] = function() NEAR_SR.gui.ToggleWindow() end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Addon loading
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function OnAddonLoaded(event, name)
	if name ~= addon.name then return end
	EVENT_MANAGER:UnregisterForEvent(addon.name, EVENT_ADD_ON_LOADED)

	local asv_version = 1
	addon.ASV = {}
	addon.ASV.settings	= ZO_SavedVars:NewAccountWide(addon.name .. "_Data", asv_version, 'settings', addon.defaults.settings, GetWorldName())
	addon.ASV.char		= ZO_SavedVars:NewAccountWide(addon.name .. "_Data", asv_version, 'char_data', addon.defaults.char, GetWorldName())

	addon.func.Init()
	addon.gui.Init()
	addon.SetupSettings()
	addon.RegisterSlashCommands()

	-- Events
    EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ABILITY_PROGRESSION_RANK_UPDATE,   NEAR_SR.func.OnMorphRankUpdate)
    EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_SKILL_RANK_UPDATE,                 NEAR_SR.func.OnSkillRankUpdate)
    EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_SKILL_LINE_ADDED,                  NEAR_SR.func.OnSkillLineAdded)

end

EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
