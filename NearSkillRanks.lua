--[[
TODO:

DONE // make it so if discoreved == false skill line will be grayed out and show no info

THESE ARE DONE BUT STILL NEED TESTING:
Create UpdateCharData(skilltype, skillline, ability, morph) where it'll check what rank was updated and overwrite only that on sv

EVENT_ABILITY_PROGRESSION_RANK_UPDATE (eventCode, progressionIndex, rank, maxRank, morph) 
--- @param progressionIndex luaindex
--- @return skillType [SkillType|#SkillType], skillLineIndex luaindex, skillIndex luaindex
function GetSkillAbilityIndicesFromProgressionIndex(progressionIndex) end

EVENT_SKILL_RANK_UPDATE (eventCode, skillType, skillLineIndex, skillLineRank)

EVENT_SKILL_LINE_ADDED (eventCode, skillType, skillLineIndex, advised) 
this can be used with GetSkillLineDynamicInfo(skillType, skillLineIndex) to update "discovered" state, then update lam
]]

NEAR_SR = {
	name 		= "NearSkillRanks",
	title 		= "Near's Skill Ranks",
	shortTitle 	= "Skill Ranks",
	version 	= "0.1.5",
	author 		= "|cCC99FFnotnear|r",
}
local addon = NEAR_SR

addon.SKILL_TYPE_TRADESKILL = 7

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
	addon.SetupSettings()

	-- Events
    EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ABILITY_PROGRESSION_RANK_UPDATE,   NEAR_SR.func.OnMorphRankUpdate)
    EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_SKILL_RANK_UPDATE,                 NEAR_SR.func.OnSkillRankUpdate)
    EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_SKILL_LINE_ADDED,                  NEAR_SR.func.OnSkillLineAdded)

end

EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
