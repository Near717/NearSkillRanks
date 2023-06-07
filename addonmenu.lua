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
	local sv = addon.ASV.settings

	for i, value in ipairs(sv.charInfo) do
		if value.charId == addon.selectedChar_charId then
			addon.selectedChar_classId = value.classId
		end
	end

	d(addon.selectedChar_classId)
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

local function CreateLam_skillLine()
	for i = 1, t_skillLineMax[selected_skillType], 1 do

		if selected_skillType ~= SKILL_TYPE_CLASS then
			local skillLineName = GetSkillLineNameById(GetSkillLineId(selected_skillType, i))
			table.insert(skillLine_dropdown.choices, selected_skillType, skillLineName)
			table.insert(skillLine_dropdown.choicesValues, selected_skillType, i)
		elseif selected_skillType == SKILL_TYPE_CLASS then
			local skillLineName = addon.skilldata[selected_skillType][addon.selectedChar_classId][i].name
			table.insert(skillLine_dropdown.choices, selected_skillType, skillLineName)
			table.insert(skillLine_dropdown.choicesValues, selected_skillType, i)
		else
			d('error')
		end

	end
end

local t_skillLine = {
	[SKILL_TYPE_CLASS] = {
		[1] = addon.skilldata[SKILL_TYPE_CLASS][addon.selectedChar_classId][1].name,
		[2] = addon.skilldata[SKILL_TYPE_CLASS][addon.selectedChar_classId][2].name,
		[3] = addon.skilldata[SKILL_TYPE_CLASS][addon.selectedChar_classId][3].name,
	},
	[SKILL_TYPE_WEAPON] = {
		[1] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WEAPON, 1)),
		[2] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WEAPON, 2)),
		[3] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WEAPON, 3)),
		[4] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WEAPON, 4)),
		[5] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WEAPON, 5)),
		[6] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WEAPON, 6)),
	},
	[SKILL_TYPE_ARMOR] = {
		[1] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_ARMOR, 1)),
		[2] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_ARMOR, 2)),
		[3] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_ARMOR, 3)),
	},
	[SKILL_TYPE_WORLD] = {
		[1] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WORLD, 1)),
		[2] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WORLD, 2)),
		[3] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WORLD, 3)),
		[4] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WORLD, 4)),
		[5] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WORLD, 5)),
		[6] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_WORLD, 6)),
	},
	[SKILL_TYPE_GUILD] = {
		[1] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_GUILD, 1)),
		[2] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_GUILD, 2)),
		[3] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_GUILD, 3)),
		[4] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_GUILD, 4)),
		[5] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_GUILD, 5)),
		[6] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_GUILD, 6)),
	},
	[SKILL_TYPE_AVA] = {
		[1] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_AVA, 1)),
		[2] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_AVA, 2)),
		[3] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_AVA, 3)),
	},
	-- [SKILL_TYPE_RACIAL] = {},
	[SKILL_TYPE_TRADESKILL] = {
		[1] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 1)),
		[2] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 2)),
		[3] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 3)),
		[4] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 4)),
		[5] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 5)),
		[6] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 6)),
		[7] = GetSkillLineNameById(GetSkillLineId(SKILL_TYPE_TRADESKILL, 7)),
	},
}

local function UpdateLam_skillLine()

	for index, value in ipairs(t_skillLine) do

		if index == selected_skillType then
			skillLine_dropdown.choices = value

			for k in pairs(skillLine_dropdown.choicesValues) do
				skillLine_dropdown.choicesValues[k] = nil
			end

			for k in pairs(t_skillLine[selected_skillType]) do
				table.insert(skillLine_dropdown.choicesValues, k)
			end
		end

	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Addon settings panel
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
function NEAR_SR.SetupSettings()
	local LAM2 = LibAddonMenu2
	local color = addon.utils.color
	local sv = addon.ASV.settings

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
				d(v)
				addon.selectedChar_charId = v

				-- UpdateLam_selectedChar_classId()

				-- UpdateLam_skillLine()
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
				NEARSR_lam_dropdown_SkillLine:UpdateChoices(skillLine_dropdown.choices, skillLine_dropdown.choicesValues)
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
			end
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
