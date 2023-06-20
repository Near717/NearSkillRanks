local addon = NEAR_SR
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

addon.selectedChar_charId = GetCurrentCharacterId()
addon.selectedChar_classId = GetUnitClassId('player')

addon.char_dropdown = {
	choices = {},
	choicesValues = {},
}
local char_dropdown = addon.char_dropdown

local function UpdateLam_char()
	local sv = addon.ASV.settings

	for i, value in ipairs(sv.charInfo) do
		table.insert(char_dropdown.choices, i, value.charName)
		table.insert(char_dropdown.choicesValues, i, value.charId)
	end
end

local function UpdateLam_selectedChar_classId()
	local sv	= addon.ASV.settings
	local dbg	= addon.utils.dbg

	for i, value in ipairs(sv.charInfo) do
		if value.charId == addon.selectedChar_charId then
			addon.selectedChar_classId = value.classId
		end
	end

	--[[ Debug ]] if sv.debug then d(dbg.lightGrey .. 'Selected character classId: ' .. addon.selectedChar_classId) end
end

-----------------------------------------------------------------
local selected_skillType = SKILL_TYPE_CLASS

addon.skillType_dropdown = {
	choices = {},
	choicesValues = {},
}
local skillType_dropdown = addon.skillType_dropdown

local function CreateLam_skillType()
	local t_skillType = {
		[SKILL_TYPE_CLASS] = GetString(SI_SKILLTYPE1),
		[SKILL_TYPE_WEAPON] = GetString(SI_SKILLTYPE2),
		[SKILL_TYPE_ARMOR] = GetString(SI_SKILLTYPE3),
		[SKILL_TYPE_WORLD] = GetString(SI_SKILLTYPE4),
		[SKILL_TYPE_GUILD] = GetString(SI_SKILLTYPE5),
		[SKILL_TYPE_AVA] = GetString(SI_SKILLTYPE6),
		-- [SKILL_TYPE_RACIAL] = GetString(SI_SKILLTYPE7),
		[SKILL_TYPE_TRADESKILL] = GetString(SI_SKILLTYPE8),
	}

	for i, value in ipairs(t_skillType) do
		table.insert(skillType_dropdown.choices, i, value)
		table.insert(skillType_dropdown.choicesValues, i, i)
	end
end

-----------------------------------------------------------------
local selected_skillLine = 1

addon.skillLine_dropdown = {
	choices = {},
	choicesValues = {},
}
local skillLine_dropdown = addon.skillLine_dropdown

local function CreateLam_skillLine()
	local sv = addon.ASV.settings

	local t_skillLineMax = {
		[SKILL_TYPE_CLASS] = 3,
		[SKILL_TYPE_WEAPON] = 6,
		[SKILL_TYPE_ARMOR] = 3,
		[SKILL_TYPE_WORLD] = 6,
		[SKILL_TYPE_GUILD] = 6,
		[SKILL_TYPE_AVA] = 3,
		-- [SKILL_TYPE_RACIAL] = 10,
		[SKILL_TYPE_TRADESKILL] = 7,
	}

	for i = 1, t_skillLineMax[selected_skillType], 1 do

		local selectedChar_charId = addon.selectedChar_charId
		local selectedChar_classId = addon.selectedChar_classId

		if selected_skillType ~= SKILL_TYPE_CLASS then
			local sv_skillLine = addon.ASV.char[selectedChar_charId][selected_skillType][i]

			local skillLineName = GetSkillLineNameById(GetSkillLineId(selected_skillType, i))
			local skillLineRank = sv_skillLine.rank

			local skillLineData = skillLineRank ..' '.. skillLineName

			table.insert(skillLine_dropdown.choices, selected_skillType, skillLineData)
			table.insert(skillLine_dropdown.choicesValues, selected_skillType, i)
		elseif selected_skillType == SKILL_TYPE_CLASS then
			local sv_skillLine = addon.ASV.char[selectedChar_charId][selected_skillType][selectedChar_classId][i]

			local skillLineName = addon.skilldata[selected_skillType][addon.selectedChar_classId][i].name
			local skillLineRank = sv_skillLine.rank

			local skillLineData = skillLineRank ..' '.. skillLineName

			table.insert(skillLine_dropdown.choices, selected_skillType, skillLineData)
			table.insert(skillLine_dropdown.choicesValues, selected_skillType, i)
		else
			--[[ Debug ]] if sv.debug then d('error at CreateLam_skillLine()') end
		end

	end
end


local function UpdateLam_skillLine()
	local sv_char = addon.ASV.char[addon.selectedChar_charId]

	local t_skillLine = {
		[SKILL_TYPE_CLASS] = {
			[1] = sv_char[SKILL_TYPE_CLASS][addon.selectedChar_classId][1].rank ..' '.. addon.skilldata[SKILL_TYPE_CLASS][addon.selectedChar_classId][1].name,
			[2] = sv_char[SKILL_TYPE_CLASS][addon.selectedChar_classId][2].rank ..' '.. addon.skilldata[SKILL_TYPE_CLASS][addon.selectedChar_classId][2].name,
			[3] = sv_char[SKILL_TYPE_CLASS][addon.selectedChar_classId][3].rank ..' '.. addon.skilldata[SKILL_TYPE_CLASS][addon.selectedChar_classId][3].name,
		},
		[SKILL_TYPE_WEAPON] = {
			[1] = sv_char[SKILL_TYPE_WEAPON][1].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WEAPON, 1)),
			[2] = sv_char[SKILL_TYPE_WEAPON][2].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WEAPON, 2)),
			[3] = sv_char[SKILL_TYPE_WEAPON][3].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WEAPON, 3)),
			[4] = sv_char[SKILL_TYPE_WEAPON][4].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WEAPON, 4)),
			[5] = sv_char[SKILL_TYPE_WEAPON][5].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WEAPON, 5)),
			[6] = sv_char[SKILL_TYPE_WEAPON][6].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WEAPON, 6)),
		},
		[SKILL_TYPE_ARMOR] = {
			[1] = sv_char[SKILL_TYPE_ARMOR][1].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_ARMOR, 1)),
			[2] = sv_char[SKILL_TYPE_ARMOR][2].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_ARMOR, 2)),
			[3] = sv_char[SKILL_TYPE_ARMOR][3].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_ARMOR, 3)),
		},
		[SKILL_TYPE_WORLD] = {
			[1] = sv_char[SKILL_TYPE_WORLD][1].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WORLD, 1)),
			[2] = sv_char[SKILL_TYPE_WORLD][2].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WORLD, 2)),
			[3] = sv_char[SKILL_TYPE_WORLD][3].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WORLD, 3)),
			[4] = sv_char[SKILL_TYPE_WORLD][4].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WORLD, 4)),
			[5] = sv_char[SKILL_TYPE_WORLD][5].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WORLD, 5)),
			[6] = sv_char[SKILL_TYPE_WORLD][6].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WORLD, 6)),
		},
		[SKILL_TYPE_GUILD] = {
			[1] = sv_char[SKILL_TYPE_GUILD][1].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_GUILD, 1)),
			[2] = sv_char[SKILL_TYPE_GUILD][2].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_GUILD, 2)),
			[3] = sv_char[SKILL_TYPE_GUILD][3].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_GUILD, 3)),
			[4] = sv_char[SKILL_TYPE_GUILD][4].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_GUILD, 4)),
			[5] = sv_char[SKILL_TYPE_GUILD][5].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_GUILD, 5)),
			[6] = sv_char[SKILL_TYPE_GUILD][6].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_GUILD, 6)),
		},
		[SKILL_TYPE_AVA] = {
			[1] = sv_char[SKILL_TYPE_AVA][1].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_AVA, 1)),
			[2] = sv_char[SKILL_TYPE_AVA][2].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_AVA, 2)),
			[3] = sv_char[SKILL_TYPE_AVA][3].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_AVA, 3)),
		},
		-- [SKILL_TYPE_RACIAL] = {},
		[SKILL_TYPE_TRADESKILL] = {
			[1] = sv_char[SKILL_TYPE_TRADESKILL][1].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 1)),
			[2] = sv_char[SKILL_TYPE_TRADESKILL][2].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 2)),
			[3] = sv_char[SKILL_TYPE_TRADESKILL][3].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 3)),
			[4] = sv_char[SKILL_TYPE_TRADESKILL][4].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 4)),
			[5] = sv_char[SKILL_TYPE_TRADESKILL][5].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 5)),
			[6] = sv_char[SKILL_TYPE_TRADESKILL][6].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 6)),
			[7] = sv_char[SKILL_TYPE_TRADESKILL][7].rank ..' '.. GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 7)),
		},
	}

	for index, value in ipairs(t_skillLine) do

		if index == selected_skillType then
			skillLine_dropdown.choices = value

			-- purge previous data
			for k in pairs(skillLine_dropdown.choicesValues) do
				skillLine_dropdown.choicesValues[k] = nil
			end

			-- insert new data
			for k in pairs(t_skillLine[selected_skillType]) do
				table.insert(skillLine_dropdown.choicesValues, k)
			end
		end

	end

	NEARSR_lam_dropdown_SkillLine:UpdateChoices(skillLine_dropdown.choices, skillLine_dropdown.choicesValues)
end

-----------------------------------------------------------------

local function UpdateLam_abilities()
	local utils = addon.utils

	local selectedChar_charId = addon.selectedChar_charId
	local selectedChar_classId = addon.selectedChar_classId

	-- check if there is data for that character, if not clear shown data and send warning message
	if addon.ASV.char[selectedChar_charId] == nil then
		d(utils.dbg.default .. GetString(NEARSR_nodata))

		addon.selectedSkillLine_abilities_name = utils.color.red .. GetString(NEARSR_nodata) .. "|r"
		addon.selectedSkillLine_abilities_rank = ''
		return
	end

	if selected_skillType == SKILL_TYPE_CLASS then
		local sv_skillLine = addon.ASV.char[selectedChar_charId][selected_skillType][selectedChar_classId][selected_skillLine]
		local sd_skillLine = addon.skilldata[selected_skillType][selectedChar_classId][selected_skillLine]

		addon.selectedSkillLine_abilities_name =
		sd_skillLine.name .. '\n' ..

		'Name: ' .. sd_skillLine[1][0].name .. '\n' ..
		'Name: ' .. sd_skillLine[1][1].name .. '\n' ..
		'Name: ' .. sd_skillLine[1][2].name .. '\n' ..

		'Name: ' .. sd_skillLine[2][0].name .. '\n' ..
		'Name: ' .. sd_skillLine[2][1].name .. '\n' ..
		'Name: ' .. sd_skillLine[2][2].name .. '\n' ..

		'Name: ' .. sd_skillLine[3][0].name .. '\n' ..
		'Name: ' .. sd_skillLine[3][1].name .. '\n' ..
		'Name: ' .. sd_skillLine[3][2].name .. '\n' ..

		'Name: ' .. sd_skillLine[4][0].name .. '\n' ..
		'Name: ' .. sd_skillLine[4][1].name .. '\n' ..
		'Name: ' .. sd_skillLine[4][2].name .. '\n' ..

		'Name: ' .. sd_skillLine[5][0].name .. '\n' ..
		'Name: ' .. sd_skillLine[5][1].name .. '\n' ..
		'Name: ' .. sd_skillLine[5][2].name .. '\n' ..

		'Name: ' .. sd_skillLine[6][0].name .. '\n' ..
		'Name: ' .. sd_skillLine[6][1].name .. '\n' ..
		'Name: ' .. sd_skillLine[6][2].name

		addon.selectedSkillLine_abilities_rank =
		'Lv: ' .. sv_skillLine.rank .. '\n' ..

		'Rank: ' .. sv_skillLine[1][0] .. '\n' ..
		'Rank: ' .. sv_skillLine[1][1] .. '\n' ..
		'Rank: ' .. sv_skillLine[1][2] .. '\n' ..

		'Rank: ' .. sv_skillLine[2][0] .. '\n' ..
		'Rank: ' .. sv_skillLine[2][1] .. '\n' ..
		'Rank: ' .. sv_skillLine[2][2] .. '\n' ..

		'Rank: ' .. sv_skillLine[3][0] .. '\n' ..
		'Rank: ' .. sv_skillLine[3][1] .. '\n' ..
		'Rank: ' .. sv_skillLine[3][2] .. '\n' ..

		'Rank: ' .. sv_skillLine[4][0] .. '\n' ..
		'Rank: ' .. sv_skillLine[4][1] .. '\n' ..
		'Rank: ' .. sv_skillLine[4][2] .. '\n' ..

		'Rank: ' .. sv_skillLine[5][0] .. '\n' ..
		'Rank: ' .. sv_skillLine[5][1] .. '\n' ..
		'Rank: ' .. sv_skillLine[5][2] .. '\n' ..

		'Rank: ' .. sv_skillLine[6][0] .. '\n' ..
		'Rank: ' .. sv_skillLine[6][1] .. '\n' ..
		'Rank: ' .. sv_skillLine[6][2]

	else
		local sv_skillLine = addon.ASV.char[selectedChar_charId][selected_skillType][selected_skillLine]
		local sd_skillLine = addon.skilldata[selected_skillType][selected_skillLine]

		--------------------------------------------------------------------------------
		-- 0 skills
		--------------------------------------------------------------------------------
		if selected_skillType == SKILL_TYPE_TRADESKILL or
			(selected_skillType == SKILL_TYPE_WORLD and (selected_skillLine == 1 or selected_skillLine == 2 or selected_skillLine == 3)) or
			(selected_skillType == SKILL_TYPE_GUILD and (selected_skillLine == 1 or selected_skillLine == 5)) or
			(selected_skillType == SKILL_TYPE_AVA and selected_skillLine == 2) then

			addon.selectedSkillLine_abilities_name =
			sd_skillLine.name

			--------------------------------------------------

			addon.selectedSkillLine_abilities_rank =
			'Lv: ' .. sv_skillLine.rank

		--------------------------------------------------------------------------------
		-- 1 skills
		--------------------------------------------------------------------------------
		elseif selected_skillType == SKILL_TYPE_ARMOR then

			addon.selectedSkillLine_abilities_name =
			sd_skillLine.name.. '\n' ..

			'Name: ' .. sd_skillLine[1][0].name .. '\n' ..
			'Name: ' .. sd_skillLine[1][1].name .. '\n' ..
			'Name: ' .. sd_skillLine[1][2].name

			--------------------------------------------------

			addon.selectedSkillLine_abilities_rank =
			'Lv: ' .. sv_skillLine.rank .. '\n' ..

			'Rank: ' .. sv_skillLine[1][0].. '\n' ..
			'Rank: ' .. sv_skillLine[1][1].. '\n' ..
			'Rank: ' .. sv_skillLine[1][2]

		--------------------------------------------------------------------------------
		-- 2 skills
		--------------------------------------------------------------------------------
		elseif selected_skillType == SKILL_TYPE_WORLD and selected_skillLine == 4 then

				addon.selectedSkillLine_abilities_name =
				sd_skillLine.name .. '\n' ..

				'Name: ' .. sd_skillLine[1][0].name .. '\n' ..
				'Name: ' .. sd_skillLine[1][1].name .. '\n' ..
				'Name: ' .. sd_skillLine[1][2].name .. '\n' ..

				'Name: ' .. sd_skillLine[2][0].name .. '\n' ..
				'Name: ' .. sd_skillLine[2][1].name .. '\n' ..
				'Name: ' .. sd_skillLine[2][2].name

				--------------------------------------------------

				addon.selectedSkillLine_abilities_rank =
				'Lv: ' .. sv_skillLine.rank .. '\n' ..

				'Rank: ' .. sv_skillLine[1][0]'\n' ..
				'Rank: ' .. sv_skillLine[1][1]'\n' ..
				'Rank: ' .. sv_skillLine[1][2]'\n' ..

				'Rank: ' .. sv_skillLine[2][0]'\n' ..
				'Rank: ' .. sv_skillLine[2][1]'\n' ..
				'Rank: ' .. sv_skillLine[2][2]

		--------------------------------------------------------------------------------
		-- 5 skills
		--------------------------------------------------------------------------------
		elseif (selected_skillType == SKILL_TYPE_GUILD and (selected_skillLine == 2 or selected_skillLine == 3 or selected_skillLine == 6)) or
			(selected_skillType == SKILL_TYPE_AVA and (selected_skillLine == 1 or selected_skillLine == 3)) then

			addon.selectedSkillLine_abilities_name =
			sd_skillLine.name .. '\n' ..

			'Name: ' .. sd_skillLine[1][0].name .. '\n' ..
			'Name: ' .. sd_skillLine[1][1].name .. '\n' ..
			'Name: ' .. sd_skillLine[1][2].name .. '\n' ..

			'Name: ' .. sd_skillLine[2][0].name .. '\n' ..
			'Name: ' .. sd_skillLine[2][1].name .. '\n' ..
			'Name: ' .. sd_skillLine[2][2].name .. '\n' ..

			'Name: ' .. sd_skillLine[3][0].name .. '\n' ..
			'Name: ' .. sd_skillLine[3][1].name .. '\n' ..
			'Name: ' .. sd_skillLine[3][2].name .. '\n' ..

			'Name: ' .. sd_skillLine[4][0].name .. '\n' ..
			'Name: ' .. sd_skillLine[4][1].name .. '\n' ..
			'Name: ' .. sd_skillLine[4][2].name .. '\n' ..

			'Name: ' .. sd_skillLine[5][0].name .. '\n' ..
			'Name: ' .. sd_skillLine[5][1].name .. '\n' ..
			'Name: ' .. sd_skillLine[5][2].name

			--------------------------------------------------

			addon.selectedSkillLine_abilities_rank =
			'Lv: ' .. sv_skillLine.rank .. '\n' ..

			'Rank: ' .. sv_skillLine[1][0].. '\n' ..
			'Rank: ' .. sv_skillLine[1][1].. '\n' ..
			'Rank: ' .. sv_skillLine[1][2].. '\n' ..

			'Rank: ' .. sv_skillLine[2][0].. '\n' ..
			'Rank: ' .. sv_skillLine[2][1].. '\n' ..
			'Rank: ' .. sv_skillLine[2][2].. '\n' ..

			'Rank: ' .. sv_skillLine[3][0].. '\n' ..
			'Rank: ' .. sv_skillLine[3][1].. '\n' ..
			'Rank: ' .. sv_skillLine[3][2].. '\n' ..

			'Rank: ' .. sv_skillLine[4][0].. '\n' ..
			'Rank: ' .. sv_skillLine[4][1].. '\n' ..
			'Rank: ' .. sv_skillLine[4][2].. '\n' ..

			'Rank: ' .. sv_skillLine[5][0].. '\n' ..
			'Rank: ' .. sv_skillLine[5][1].. '\n' ..
			'Rank: ' .. sv_skillLine[5][2]

		--------------------------------------------------------------------------------
		-- 6 skills
		--------------------------------------------------------------------------------
		elseif selected_skillType == SKILL_TYPE_WEAPON or
			(selected_skillType == SKILL_TYPE_WORLD and (selected_skillLine == 5 or selected_skillLine == 6)) or
			(selected_skillType == SKILL_TYPE_GUILD and selected_skillLine == 4) then

			addon.selectedSkillLine_abilities_name =
			sd_skillLine.name .. '\n' ..

			'Name: ' .. sd_skillLine[1][0].name .. '\n' ..
			'Name: ' .. sd_skillLine[1][1].name .. '\n' ..
			'Name: ' .. sd_skillLine[1][2].name .. '\n' ..

			'Name: ' .. sd_skillLine[2][0].name .. '\n' ..
			'Name: ' .. sd_skillLine[2][1].name .. '\n' ..
			'Name: ' .. sd_skillLine[2][2].name .. '\n' ..

			'Name: ' .. sd_skillLine[3][0].name .. '\n' ..
			'Name: ' .. sd_skillLine[3][1].name .. '\n' ..
			'Name: ' .. sd_skillLine[3][2].name .. '\n' ..

			'Name: ' .. sd_skillLine[4][0].name .. '\n' ..
			'Name: ' .. sd_skillLine[4][1].name .. '\n' ..
			'Name: ' .. sd_skillLine[4][2].name .. '\n' ..

			'Name: ' .. sd_skillLine[5][0].name .. '\n' ..
			'Name: ' .. sd_skillLine[5][1].name .. '\n' ..
			'Name: ' .. sd_skillLine[5][2].name .. '\n' ..

			'Name: ' .. sd_skillLine[6][0].name .. '\n' ..
			'Name: ' .. sd_skillLine[6][1].name .. '\n' ..
			'Name: ' .. sd_skillLine[6][2].name

			--------------------------------------------------

			addon.selectedSkillLine_abilities_rank =
			'Lv: ' .. sv_skillLine.rank .. '\n' ..

			'Rank: ' .. sv_skillLine[1][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[1][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[1][2] .. '\n' ..

			'Rank: ' .. sv_skillLine[2][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[2][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[2][2] .. '\n' ..

			'Rank: ' .. sv_skillLine[3][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[3][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[3][2] .. '\n' ..

			'Rank: ' .. sv_skillLine[4][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[4][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[4][2] .. '\n' ..

			'Rank: ' .. sv_skillLine[5][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[5][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[5][2] .. '\n' ..

			'Rank: ' .. sv_skillLine[6][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[6][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[6][2]
		end

	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Addon settings panel
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
function NEAR_SR.SetupSettings()
	local LAM2	= LibAddonMenu2
	local sv	= addon.ASV.settings
	local dbg	= addon.utils.dbg
	local color	= addon.utils.color

	local panelData = {
		type                = "panel",
		name                = addon.title,
		displayName         = addon.title,
		author              = addon.author,
		version             = addon.version,
		slashCommand        = "/sr",
		registerForRefresh  = true,
		registerForDefaults = true,
	}
	LAM2:RegisterAddonPanel(addon.name, panelData)

	UpdateLam_char()
	CreateLam_skillType()
	CreateLam_skillLine()
	UpdateLam_abilities()

	local optionsTable = {
		---------------------------------------------------------------------------------
		-- Char
		---------------------------------------------------------------------------------
		{
			type = 'dropdown',
			name = 'Character',
			choices = char_dropdown.choices,
			choicesValues = char_dropdown.choicesValues,
			getFunc = function() return addon.selectedChar_charId end,
			setFunc = function(v)
				--[[ Debug ]] if sv.debug then d(dbg.lightGrey .. 'Selected character charId: ' .. v) end
				addon.selectedChar_charId = v
				UpdateLam_selectedChar_classId()
				UpdateLam_skillLine()
				UpdateLam_abilities()
			end
		},
		---------------------------------------------------------------------------------
		-- Skilltype
		---------------------------------------------------------------------------------
		{
			type = 'dropdown',
			name = 'Skill Type',
			choices = skillType_dropdown.choices,
			choicesValues = skillType_dropdown.choicesValues,
			getFunc = function() return selected_skillType end,
			setFunc = function(v)
				selected_skillType = v
				selected_skillLine = 1
				UpdateLam_skillLine()
				UpdateLam_abilities()
			end
		},
		---------------------------------------------------------------------------------
		-- Skillline
		---------------------------------------------------------------------------------
		{
			type = 'dropdown',
			name = 'Skill Line',
			reference = 'NEARSR_lam_dropdown_SkillLine',
			choices = skillLine_dropdown.choices,
			choicesValues = skillLine_dropdown.choicesValues,
			getFunc = function() return selected_skillLine end,
			setFunc = function(v)
				selected_skillLine = v
				UpdateLam_abilities()
			end
		},
		{
			type = 'description',
			reference = 'NEARSR_lam_abilities_name',
			width = 'half',
			text = function() return addon.selectedSkillLine_abilities_name end,
		},
		{
			type = 'description',
			reference = 'NEARSR_lam_abilities_rank',
			width = 'half',
			text = function() return addon.selectedSkillLine_abilities_rank end,
		},
		{
			type = 'header',
			name = 'Debug',
		},
		{
			type = 'checkbox',
			name = 'Debug',
			getFunc = function() return sv.debug end,
			setFunc = function(v) sv.debug = v end,
			default = addon.defaults.debug,
		},
	}
	LAM2:RegisterOptionControls(addon.name, optionsTable)
end
