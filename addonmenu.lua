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
		[SKILL_TYPE_CLASS]		= GetString(SI_SKILLTYPE1),
		[SKILL_TYPE_WEAPON]		= GetString(SI_SKILLTYPE2),
		[SKILL_TYPE_ARMOR]		= GetString(SI_SKILLTYPE3),
		[SKILL_TYPE_WORLD]		= GetString(SI_SKILLTYPE4),
		[SKILL_TYPE_GUILD]		= GetString(SI_SKILLTYPE5),
		[SKILL_TYPE_AVA]		= GetString(SI_SKILLTYPE6),
		-- [SKILL_TYPE_RACIAL]		= GetString(SI_SKILLTYPE7),
		[addon.SKILL_TYPE_TRADESKILL]	= GetString(SI_SKILLTYPE8),
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
	local sv_char = addon.ASV.char[addon.selectedChar_charId]

	local selectedChar_classId = addon.selectedChar_classId

	local t_skillLineMax = {
		[SKILL_TYPE_CLASS]		= 3,
		[SKILL_TYPE_WEAPON]		= 6,
		[SKILL_TYPE_ARMOR]		= 3,
		[SKILL_TYPE_WORLD]		= 6,
		[SKILL_TYPE_GUILD]		= 6,
		[SKILL_TYPE_AVA]		= 3,
		-- [SKILL_TYPE_RACIAL]		= 10,
		[addon.SKILL_TYPE_TRADESKILL]	= 7,
	}

	local function color(skillType, skillLine)
		if skillType ~= SKILL_TYPE_CLASS then
			local discovered = sv_char[skillType][skillLine].discovered
			if discovered == false then return NEAR_SR.utils.color.grey
			else return '' end
		else
			local discovered = sv_char[skillType][selectedChar_classId][skillLine].discovered
			if discovered == false then return NEAR_SR.utils.color.grey
			else return '' end
		end
	end

	local prefix, mid = "Lv ", ' '

	for skillLineIndex = 1, t_skillLineMax[selected_skillType], 1 do

		if selected_skillType ~= SKILL_TYPE_CLASS then
			local sv_skillLine = sv_char[selected_skillType][skillLineIndex]

			local skillLineName = addon.skilldata[selected_skillType][skillLineIndex].name
			local skillLineRank = sv_skillLine.rank

			local skillLineData = color(selected_skillType, skillLineIndex) ..prefix.. skillLineRank ..mid.. skillLineName

			table.insert(skillLine_dropdown.choices, skillLineIndex, skillLineData)
			table.insert(skillLine_dropdown.choicesValues, skillLineIndex, skillLineIndex)

		elseif selected_skillType == SKILL_TYPE_CLASS then
			local sv_skillLine = sv_char[selected_skillType][selectedChar_classId][skillLineIndex]

			local skillLineName = addon.skilldata[selected_skillType][selectedChar_classId][skillLineIndex].name
			local skillLineRank = sv_skillLine.rank

			local skillLineData = color(selected_skillType, skillLineIndex) ..prefix.. skillLineRank ..mid.. skillLineName

			table.insert(skillLine_dropdown.choices, skillLineIndex, skillLineData)
			table.insert(skillLine_dropdown.choicesValues, skillLineIndex, skillLineIndex)

		else
			--[[ Debug ]] if sv.debug then d('error at CreateLam_skillLine()') end
		end

	end
end


local function UpdateLam_skillLine()
	local sv_char = addon.ASV.char[addon.selectedChar_charId]
	local skilldata = addon.skilldata

	local choices_skillLine = {}
	if sv_char == nil then

		local unknown = 'No data'

		choices_skillLine = {
			[SKILL_TYPE_CLASS] = {
				[1] = unknown,
			},
			[SKILL_TYPE_WEAPON] = {
				[1] = unknown,
			},
			[SKILL_TYPE_ARMOR] = {
				[1] = unknown,
			},
			[SKILL_TYPE_WORLD] = {
				[1] = unknown,
			},
			[SKILL_TYPE_GUILD] = {
				[1] = unknown,
			},
			[SKILL_TYPE_AVA] = {
				[1] = unknown,
			},
			-- [SKILL_TYPE_RACIAL] = {},
			[addon.SKILL_TYPE_TRADESKILL] = {
				[1] = unknown,
			},
		}

	else
		local classId = addon.selectedChar_classId

		local function color(skillType, skillLine)
			if skillType ~= SKILL_TYPE_CLASS then
				local discovered = sv_char[skillType][skillLine].discovered
				if discovered == false then return NEAR_SR.utils.color.grey
				else return '' end
			else
				local discovered = sv_char[skillType][classId][skillLine].discovered
				if discovered == false then return NEAR_SR.utils.color.grey
				else return '' end
			end
		end

		local prefix, mid = "Lv ", ' '

		local sType = SKILL_TYPE_CLASS
		choices_skillLine[SKILL_TYPE_CLASS] = {
			[1] = color(sType,1) ..prefix.. sv_char[sType][classId][1].rank ..mid.. skilldata[sType][classId][1].name,
			[2] = color(sType,2) ..prefix.. sv_char[sType][classId][2].rank ..mid.. skilldata[sType][classId][2].name,
			[3] = color(sType,3) ..prefix.. sv_char[sType][classId][3].rank ..mid.. skilldata[sType][classId][3].name,
		}
		sType = SKILL_TYPE_WEAPON
		choices_skillLine[SKILL_TYPE_WEAPON] = {
			[1] = color(sType,1) ..prefix.. sv_char[sType][1].rank ..mid.. skilldata[sType][1].name,
			[2] = color(sType,2) ..prefix.. sv_char[sType][2].rank ..mid.. skilldata[sType][2].name,
			[3] = color(sType,3) ..prefix.. sv_char[sType][3].rank ..mid.. skilldata[sType][3].name,
			[4] = color(sType,4) ..prefix.. sv_char[sType][4].rank ..mid.. skilldata[sType][4].name,
			[5] = color(sType,5) ..prefix.. sv_char[sType][5].rank ..mid.. skilldata[sType][5].name,
			[6] = color(sType,6) ..prefix.. sv_char[sType][6].rank ..mid.. skilldata[sType][6].name,
		}
		sType = SKILL_TYPE_ARMOR
		choices_skillLine[SKILL_TYPE_ARMOR] = {
			[1] = color(sType,1) ..prefix.. sv_char[sType][1].rank ..mid.. skilldata[sType][1].name,
			[2] = color(sType,2) ..prefix.. sv_char[sType][2].rank ..mid.. skilldata[sType][2].name,
			[3] = color(sType,3) ..prefix.. sv_char[sType][3].rank ..mid.. skilldata[sType][3].name,
		}
		sType = SKILL_TYPE_WORLD
		choices_skillLine[SKILL_TYPE_WORLD] = {
			[1] = color(sType,1) ..prefix.. sv_char[sType][1].rank ..mid.. skilldata[sType][1].name,
			[2] = color(sType,2) ..prefix.. sv_char[sType][2].rank ..mid.. skilldata[sType][2].name,
			[3] = color(sType,3) ..prefix.. sv_char[sType][3].rank ..mid.. skilldata[sType][3].name,
			[4] = color(sType,4) ..prefix.. sv_char[sType][4].rank ..mid.. skilldata[sType][4].name,
			[5] = color(sType,5) ..prefix.. sv_char[sType][5].rank ..mid.. skilldata[sType][5].name,
			[6] = color(sType,6) ..prefix.. sv_char[sType][6].rank ..mid.. skilldata[sType][6].name,
		}
		sType = SKILL_TYPE_GUILD
		choices_skillLine[SKILL_TYPE_GUILD] = {
			[1] = color(sType,1) ..prefix.. sv_char[sType][1].rank ..mid.. skilldata[sType][1].name,
			[2] = color(sType,2) ..prefix.. sv_char[sType][2].rank ..mid.. skilldata[sType][2].name,
			[3] = color(sType,3) ..prefix.. sv_char[sType][3].rank ..mid.. skilldata[sType][3].name,
			[4] = color(sType,4) ..prefix.. sv_char[sType][4].rank ..mid.. skilldata[sType][4].name,
			[5] = color(sType,5) ..prefix.. sv_char[sType][5].rank ..mid.. skilldata[sType][5].name,
			[6] = color(sType,6) ..prefix.. sv_char[sType][6].rank ..mid.. skilldata[sType][6].name,
		}
		sType = SKILL_TYPE_AVA
		choices_skillLine[SKILL_TYPE_AVA] = {
			[1] = color(sType,1) ..prefix.. sv_char[sType][1].rank ..mid.. skilldata[sType][1].name,
			[2] = color(sType,2) ..prefix.. sv_char[sType][2].rank ..mid.. skilldata[sType][2].name,
			[3] = color(sType,3) ..prefix.. sv_char[sType][3].rank ..mid.. skilldata[sType][3].name,
		}
		-- choices_skillLine[SKILL_TYPE_RACIAL] = {},
		sType = addon.SKILL_TYPE_TRADESKILL
		choices_skillLine[addon.SKILL_TYPE_TRADESKILL] = {
			[1] = color(sType,1) ..prefix.. sv_char[sType][1].rank ..mid.. skilldata[sType][1].name,
			[2] = color(sType,2) ..prefix.. sv_char[sType][2].rank ..mid.. skilldata[sType][2].name,
			[3] = color(sType,3) ..prefix.. sv_char[sType][3].rank ..mid.. skilldata[sType][3].name,
			[4] = color(sType,4) ..prefix.. sv_char[sType][4].rank ..mid.. skilldata[sType][4].name,
			[5] = color(sType,5) ..prefix.. sv_char[sType][5].rank ..mid.. skilldata[sType][5].name,
			[6] = color(sType,6) ..prefix.. sv_char[sType][6].rank ..mid.. skilldata[sType][6].name,
			[7] = color(sType,7) ..prefix.. sv_char[sType][7].rank ..mid.. skilldata[sType][7].name,
		}

	end

	for index, value in ipairs(choices_skillLine) do

		if index == selected_skillType then
			skillLine_dropdown.choices = value

			-- purge previous data
			for k in pairs(skillLine_dropdown.choicesValues) do
				skillLine_dropdown.choicesValues[k] = nil
			end

			-- insert new data
			for k in pairs(choices_skillLine[selected_skillType]) do
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

	-- check if there is data for that character, if not, clear shown data and send warning message
	if addon.ASV.char[selectedChar_charId] == nil then
		d(utils.dbg.default .. GetString(NEARSR_nodata))

		addon.selectedSkillLine_abilities_name = utils.color.red .. GetString(NEARSR_nodata) .. "|r"
		addon.selectedSkillLine_abilities_rank = ''
		return
	end

	local notDiscovered = GetString(NEARSR_notdiscovered) .. "|r"
	local tab = '		'

	if selected_skillType == SKILL_TYPE_CLASS then
		local sv_skillLine = addon.ASV.char[selectedChar_charId][selected_skillType][selectedChar_classId][selected_skillLine]
		local sd_skillLine = addon.skilldata[selected_skillType][selectedChar_classId][selected_skillLine]

		if sv_skillLine.discovered == true then
			addon.selectedSkillLine_abilities_name =
			sd_skillLine.name .. '\n' ..
			-- '\n' ..
			'Name: ' .. sd_skillLine[1][0].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[1][1].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[1][2].name .. '\n' ..
			-- '\n' ..
			'Name: ' .. sd_skillLine[2][0].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[2][1].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[2][2].name .. '\n' ..
			-- '\n' ..
			'Name: ' .. sd_skillLine[3][0].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[3][1].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[3][2].name .. '\n' ..
			-- '\n' ..
			'Name: ' .. sd_skillLine[4][0].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[4][1].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[4][2].name .. '\n' ..
			-- '\n' ..
			'Name: ' .. sd_skillLine[5][0].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[5][1].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[5][2].name .. '\n' ..
			-- '\n' ..
			'Name: ' .. sd_skillLine[6][0].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[6][1].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[6][2].name

			--------------------------------------------------

			addon.selectedSkillLine_abilities_rank =
			'Lv: ' .. sv_skillLine.rank .. '\n' ..
			-- '\n' ..
			'Rank: ' .. sv_skillLine[1][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[1][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[1][2] .. '\n' ..
			-- '\n' ..
			'Rank: ' .. sv_skillLine[2][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[2][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[2][2] .. '\n' ..
			-- '\n' ..
			'Rank: ' .. sv_skillLine[3][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[3][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[3][2] .. '\n' ..
			-- '\n' ..
			'Rank: ' .. sv_skillLine[4][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[4][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[4][2] .. '\n' ..
			-- '\n' ..
			'Rank: ' .. sv_skillLine[5][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[5][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[5][2] .. '\n' ..
			-- '\n' ..
			'Rank: ' .. sv_skillLine[6][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[6][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[6][2]
		else
			addon.selectedSkillLine_abilities_name = notDiscovered
			addon.selectedSkillLine_abilities_rank = ''
		end

	else
		local sv_skillLine = addon.ASV.char[selectedChar_charId][selected_skillType][selected_skillLine]
		local sd_skillLine = addon.skilldata[selected_skillType][selected_skillLine]

		--------------------------------------------------------------------------------
		-- 0 skills
		--------------------------------------------------------------------------------
		if selected_skillType == addon.SKILL_TYPE_TRADESKILL or
			(selected_skillType == SKILL_TYPE_WORLD and (selected_skillLine == 1 or selected_skillLine == 2 or selected_skillLine == 3)) or
			(selected_skillType == SKILL_TYPE_GUILD and (selected_skillLine == 1 or selected_skillLine == 5)) or
			(selected_skillType == SKILL_TYPE_AVA and selected_skillLine == 2) then

			if sv_skillLine.discovered == true then
				addon.selectedSkillLine_abilities_name =
				sd_skillLine.name

				--------------------------------------------------

				addon.selectedSkillLine_abilities_rank =
				'Lv: ' .. sv_skillLine.rank
			else
				addon.selectedSkillLine_abilities_name = notDiscovered
				addon.selectedSkillLine_abilities_rank = ''
			end

		--------------------------------------------------------------------------------
		-- 1 skills
		--------------------------------------------------------------------------------
		elseif selected_skillType == SKILL_TYPE_ARMOR then

			if sv_skillLine.discovered == true then
				addon.selectedSkillLine_abilities_name =
				sd_skillLine.name.. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[1][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][2].name

				--------------------------------------------------

				addon.selectedSkillLine_abilities_rank =
				'Lv: ' .. sv_skillLine.rank .. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[1][0].. '\n' ..
				'Rank: ' .. sv_skillLine[1][1].. '\n' ..
				'Rank: ' .. sv_skillLine[1][2]
			else
				addon.selectedSkillLine_abilities_name = notDiscovered
				addon.selectedSkillLine_abilities_rank = ''
			end

		--------------------------------------------------------------------------------
		-- 2 skills
		--------------------------------------------------------------------------------
		elseif selected_skillType == SKILL_TYPE_WORLD and selected_skillLine == 4 then

			if sv_skillLine.discovered == true then
				addon.selectedSkillLine_abilities_name =
				sd_skillLine.name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[1][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][2].name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[2][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[2][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[2][2].name

				--------------------------------------------------

				addon.selectedSkillLine_abilities_rank =
				'Lv: ' .. sv_skillLine.rank .. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[1][0].. '\n' ..
				'Rank: ' .. sv_skillLine[1][1].. '\n' ..
				'Rank: ' .. sv_skillLine[1][2].. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[2][0].. '\n' ..
				'Rank: ' .. sv_skillLine[2][1].. '\n' ..
				'Rank: ' .. sv_skillLine[2][2]
			else
				addon.selectedSkillLine_abilities_name = notDiscovered
				addon.selectedSkillLine_abilities_rank = ''
			end

		--------------------------------------------------------------------------------
		-- 5 skills
		--------------------------------------------------------------------------------
		elseif (selected_skillType == SKILL_TYPE_GUILD and (selected_skillLine == 2 or selected_skillLine == 3 or selected_skillLine == 6)) or
			(selected_skillType == SKILL_TYPE_AVA and (selected_skillLine == 1 or selected_skillLine == 3)) then

			if sv_skillLine.discovered == true then
				addon.selectedSkillLine_abilities_name =
				sd_skillLine.name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[1][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][2].name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[2][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[2][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[2][2].name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[3][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[3][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[3][2].name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[4][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[4][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[4][2].name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[5][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[5][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[5][2].name

				--------------------------------------------------

				addon.selectedSkillLine_abilities_rank =
				'Lv: ' .. sv_skillLine.rank .. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[1][0].. '\n' ..
				'Rank: ' .. sv_skillLine[1][1].. '\n' ..
				'Rank: ' .. sv_skillLine[1][2].. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[2][0].. '\n' ..
				'Rank: ' .. sv_skillLine[2][1].. '\n' ..
				'Rank: ' .. sv_skillLine[2][2].. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[3][0].. '\n' ..
				'Rank: ' .. sv_skillLine[3][1].. '\n' ..
				'Rank: ' .. sv_skillLine[3][2].. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[4][0].. '\n' ..
				'Rank: ' .. sv_skillLine[4][1].. '\n' ..
				'Rank: ' .. sv_skillLine[4][2].. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[5][0].. '\n' ..
				'Rank: ' .. sv_skillLine[5][1].. '\n' ..
				'Rank: ' .. sv_skillLine[5][2]
			else
				addon.selectedSkillLine_abilities_name = notDiscovered
				addon.selectedSkillLine_abilities_rank = ''
			end

		--------------------------------------------------------------------------------
		-- 6 skills
		--------------------------------------------------------------------------------
		elseif selected_skillType == SKILL_TYPE_WEAPON or
			(selected_skillType == SKILL_TYPE_WORLD and (selected_skillLine == 5 or selected_skillLine == 6)) or
			(selected_skillType == SKILL_TYPE_GUILD and selected_skillLine == 4) then

			if sv_skillLine.discovered == true then
				addon.selectedSkillLine_abilities_name =
				sd_skillLine.name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[1][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][2].name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[2][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[2][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[2][2].name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[3][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[3][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[3][2].name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[4][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[4][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[4][2].name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[5][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[5][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[5][2].name .. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[6][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[6][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[6][2].name

				--------------------------------------------------

				addon.selectedSkillLine_abilities_rank =
				'Lv: ' .. sv_skillLine.rank .. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[1][0] .. '\n' ..
				'Rank: ' .. sv_skillLine[1][1] .. '\n' ..
				'Rank: ' .. sv_skillLine[1][2] .. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[2][0] .. '\n' ..
				'Rank: ' .. sv_skillLine[2][1] .. '\n' ..
				'Rank: ' .. sv_skillLine[2][2] .. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[3][0] .. '\n' ..
				'Rank: ' .. sv_skillLine[3][1] .. '\n' ..
				'Rank: ' .. sv_skillLine[3][2] .. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[4][0] .. '\n' ..
				'Rank: ' .. sv_skillLine[4][1] .. '\n' ..
				'Rank: ' .. sv_skillLine[4][2] .. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[5][0] .. '\n' ..
				'Rank: ' .. sv_skillLine[5][1] .. '\n' ..
				'Rank: ' .. sv_skillLine[5][2] .. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[6][0] .. '\n' ..
				'Rank: ' .. sv_skillLine[6][1] .. '\n' ..
				'Rank: ' .. sv_skillLine[6][2]
			else
				addon.selectedSkillLine_abilities_name = notDiscovered
				addon.selectedSkillLine_abilities_rank = ''
			end
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
