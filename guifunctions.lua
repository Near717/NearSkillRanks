local addon = NEAR_SR
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

NEAR_SR.gui = {}

function NEAR_SR.gui.Init()
	addon.gui.CreateList_Char()
	addon.gui.CreateList_SkillType()
	addon.gui.CreateList_SkillLine()
	addon.gui.UpdateList_abilities()
end

-- Show or hide the window
function NEAR_SR.gui.ToggleWindow()
	NSR_GUI:ToggleHidden()
end

-- Hide the window
function NEAR_SR.gui.CloseWindow()
	NSR_GUI:SetHidden(true)
end

-- OnShow update window data
function NEAR_SR.gui.OnShow()
    NEAR_SR.gui.UpdateWindowData()
end

function NEAR_SR.gui.UpdateWindowData()
    addon.gui.UpdateList_SkillLine()
	addon.gui.UpdateList_abilities()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
addon.gui.selectedChar_charId = GetCurrentCharacterId()
addon.gui.selectedChar_classId = GetUnitClassId('player')
local selectedChar_name = nil
---------------------------------------------------------------------------------
local selected_skillType = SKILL_TYPE_CLASS
local selected_skillType_name = GetString(SI_SKILLTYPE1)
---------------------------------------------------------------------------------
local selected_skillLine = 1
local selected_skillLine_name = nil
---------------------------------------------------------------------------------
local selectedSkillLine_abilities_name = nil
local selectedSkillLine_abilities_rank = nil
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function SetSelectedChar(charName)
	for i = 1, #addon.charData do
		if charName == addon.charData[i].charName then
			addon.gui.selectedChar_charId = addon.charData[i].charId
			addon.gui.selectedChar_classId = addon.charData[i].classId
			break
		end
	end
end

function NEAR_SR.gui.CreateList_Char()
    local sv = addon.ASV.settings

	NSR_GUI_MAIN_skilldata.comboBox = NSR_GUI_MAIN_skilldata.comboBox or ZO_ComboBox_ObjectFromContainer(NSR_GUI_MAIN_skilldata:GetNamedChild("_CharList"))
	local NSR_comboBox = NSR_GUI_MAIN_skilldata.comboBox

	addon.charNames = {}
	addon.charData = {}
	for k,_ in ipairs(sv.charInfo) do
		addon.charNames[k] = sv.charInfo[k].charName
		addon.charData[k] = {
			charId = sv.charInfo[k].charId,
			charName = sv.charInfo[k].charName,
			classId = sv.charInfo[k].classId,
		}

		if GetCurrentCharacterId() == addon.charData[k].charId then
			selectedChar_name = addon.charData[k].charName
			addon.gui.selectedChar_charId = addon.charData[k].charId
            addon.gui.selectedChar_classId = addon.charData[k].classId
		end
	end

	local function OnItemSelect(_, choiceText, choice)
		SetSelectedChar(choiceText)

		addon.gui.UpdateList_SkillLine()
		addon.gui.UpdateList_abilities()

		-- PlaySound(SOUNDS.POSITIVE_CLICK)
	end

	NSR_comboBox:SetSortsItems(false)

	for k,_ in ipairs(addon.charNames) do
		NSR_comboBox:AddItem(NSR_comboBox:CreateItemEntry(addon.charNames[k], OnItemSelect))
		if addon.charNames[k] == selectedChar_name then
			NSR_comboBox:SetSelectedItem(addon.charNames[k])
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[ addon.gui.selected_skillType = SKILL_TYPE_CLASS
local selected_skillType = addon.gui.selected_skillType
local selected_skillType_name = GetString(SI_SKILLTYPE1) ]]

local function SetSelectedSkillType(stName)
	for i = 1, #addon.skillType_Data do
		if stName == addon.skillType_Data[i].name then
			selected_skillType = addon.skillType_Data[i].index
			break
		end
	end
end

function NEAR_SR.gui.CreateList_SkillType()
	NSR_GUI_MAIN_skilldata_SkillType.comboBox = NSR_GUI_MAIN_skilldata_SkillType.comboBox or ZO_ComboBox_ObjectFromContainer(NSR_GUI_MAIN_skilldata:GetNamedChild("_SkillType"))
	local NSR_comboBox = NSR_GUI_MAIN_skilldata_SkillType.comboBox

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

	addon.skillType_Names = {}
	addon.skillType_Data = {}
	for key, value in ipairs(t_skillType) do
		addon.skillType_Names[key] = value
		addon.skillType_Data[key] = {
			name = value,
			index = key,
		}
	end

	local function OnItemSelect(_, choiceText, choice)
		SetSelectedSkillType(choiceText)

		addon.gui.UpdateList_SkillLine(true)
		addon.gui.UpdateList_abilities()
		-- PlaySound(SOUNDS.POSITIVE_CLICK)
	end

	NSR_comboBox:SetSortsItems(false)

	for k,_ in ipairs(addon.skillType_Names) do
		NSR_comboBox:AddItem(NSR_comboBox:CreateItemEntry(addon.skillType_Names[k], OnItemSelect))
		if addon.skillType_Names[k] == selected_skillType_name then
			NSR_comboBox:SetSelectedItem(addon.skillType_Names[k])
		end
	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[ addon.gui.selected_skillLine = 1
local selected_skillLine = addon.gui.selected_skillLine
addon.gui.selected_skillLine_name = nil
local selected_skillLine_name = addon.gui.selected_skillLine_name ]]

local function SetSelectedSkillLine(stName)
	for i = 1, #addon.skillLine_Data do
		if stName == addon.skillLine_Data[i].name then
			selected_skillLine = addon.skillLine_Data[i].index
			break
		end
	end
end

function NEAR_SR.gui.UpdateList_SkillLine(setIndex)
	local NSR_comboBox = NSR_GUI_MAIN_skilldata_SkillLine.comboBox

	if setIndex then
		selected_skillLine = 1
		NSR_comboBox:SetSelectedItem(selected_skillLine_name)
	end

	-- purge previous data
	addon.skillLine_Names = nil
	addon.skillLine_Data = nil
	NSR_comboBox:ClearItems()

	addon.gui.CreateList_SkillLine()

	NSR_comboBox:UpdateItems()

end

function NEAR_SR.gui.CreateList_SkillLine()
	local selectedChar_charId = addon.gui.selectedChar_charId
	local selectedChar_classId = addon.gui.selectedChar_classId

	local sv = addon.ASV.settings
	local sv_char = addon.ASV.char[selectedChar_charId]

	NSR_GUI_MAIN_skilldata_SkillLine.comboBox = NSR_GUI_MAIN_skilldata_SkillLine.comboBox or ZO_ComboBox_ObjectFromContainer(NSR_GUI_MAIN_skilldata:GetNamedChild("_SkillLine"))
	local NSR_comboBox = NSR_GUI_MAIN_skilldata_SkillLine.comboBox

	addon.skillLine_Names = {}
	addon.skillLine_Data = {}
	-- check if there's data for that character
	if sv_char == nil then

		local unknown = 'No data'

		addon.skillLine_Names[1] = unknown
		addon.skillLine_Data[1] = {
			name = unknown,
			index = 1,
		}

		selected_skillLine = addon.skillLine_Data[1].index
		selected_skillLine_name = addon.skillLine_Data[1].name

	else

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

				addon.skillLine_Names[skillLineIndex] = skillLineData
				addon.skillLine_Data[skillLineIndex] = {
					name = skillLineData,
					index = skillLineIndex,
				}

				if selected_skillLine == addon.skillLine_Data[skillLineIndex].index then
					selected_skillLine_name = addon.skillLine_Data[skillLineIndex].name
				end

			elseif selected_skillType == SKILL_TYPE_CLASS then
				local sv_skillLine = sv_char[selected_skillType][selectedChar_classId][skillLineIndex]

				local skillLineName = addon.skilldata[selected_skillType][selectedChar_classId][skillLineIndex].name
				local skillLineRank = sv_skillLine.rank

				local skillLineData = color(selected_skillType, skillLineIndex) ..prefix.. skillLineRank ..mid.. skillLineName

				addon.skillLine_Names[skillLineIndex] = skillLineData
				addon.skillLine_Data[skillLineIndex] = {
					name = skillLineData,
					index = skillLineIndex,
				}

				if selected_skillLine == addon.skillLine_Data[skillLineIndex].index then
					selected_skillLine_name = addon.skillLine_Data[skillLineIndex].name
				end

			else
				--[[ Debug ]] if sv.debug then d('error at CreateList_SkillLine()') end
			end

		end
	end

	local function OnItemSelect(_, choiceText, choice)
		SetSelectedSkillLine(choiceText)

		addon.gui.UpdateList_abilities()
		-- PlaySound(SOUNDS.POSITIVE_CLICK)
	end

	NSR_comboBox:SetSortsItems(false)

	for k,_ in ipairs(addon.skillLine_Names) do
		NSR_comboBox:AddItem(NSR_comboBox:CreateItemEntry(addon.skillLine_Names[k], OnItemSelect))
		if addon.skillLine_Names[k] == selected_skillLine_name then
			NSR_comboBox:SetSelectedItem(addon.skillLine_Names[k])
		end
	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[ addon.gui.selectedSkillLine_abilities_name = nil
addon.gui.selectedSkillLine_abilities_rank = nil
local selectedSkillLine_abilities_name = addon.gui.selectedSkillLine_abilities_name
local selectedSkillLine_abilities_rank = addon.gui.selectedSkillLine_abilities_rank ]]

function NEAR_SR.gui.UpdateList_abilities()
	addon.gui.CreateList_abilities()

	NSR_GUI_MAIN_Abilities_Name:SetText(selectedSkillLine_abilities_name)
	NSR_GUI_MAIN_Abilities_Rank:SetText(selectedSkillLine_abilities_rank)
end

function NEAR_SR.gui.CreateList_abilities()
	local selectedChar_charId = addon.gui.selectedChar_charId
	local selectedChar_classId = addon.gui.selectedChar_classId

	local utils = addon.utils

	-- check if there is data for that character, if not, clear shown data and send warning message
	if addon.ASV.char[selectedChar_charId] == nil then
		d(utils.dbg.default .. GetString(NEARSR_nodata))

		selectedSkillLine_abilities_name = utils.color.red .. GetString(NEARSR_nodata) .. "|r"
		selectedSkillLine_abilities_rank = ''
		return
	end

	local notDiscovered = GetString(NEARSR_notdiscovered) .. "|r"
	local tab = '     '

	if selected_skillType == SKILL_TYPE_CLASS then
		local sv_skillLine = addon.ASV.char[selectedChar_charId][selected_skillType][selectedChar_classId][selected_skillLine]
		local sd_skillLine = addon.skilldata[selected_skillType][selectedChar_classId][selected_skillLine]

		if sv_skillLine.discovered == true then
			selectedSkillLine_abilities_name =
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

			selectedSkillLine_abilities_rank =
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
			selectedSkillLine_abilities_name = notDiscovered
			selectedSkillLine_abilities_rank = ''
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
				selectedSkillLine_abilities_name =
				sd_skillLine.name

				--------------------------------------------------

				selectedSkillLine_abilities_rank =
				'Lv: ' .. sv_skillLine.rank
			else
				selectedSkillLine_abilities_name = notDiscovered
				selectedSkillLine_abilities_rank = ''
			end

		--------------------------------------------------------------------------------
		-- 1 skills
		--------------------------------------------------------------------------------
		elseif selected_skillType == SKILL_TYPE_ARMOR then

			if sv_skillLine.discovered == true then
				selectedSkillLine_abilities_name =
				sd_skillLine.name.. '\n' ..
				-- '\n' ..
				'Name: ' .. sd_skillLine[1][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][2].name

				--------------------------------------------------

				selectedSkillLine_abilities_rank =
				'Lv: ' .. sv_skillLine.rank .. '\n' ..
				-- '\n' ..
				'Rank: ' .. sv_skillLine[1][0].. '\n' ..
				'Rank: ' .. sv_skillLine[1][1].. '\n' ..
				'Rank: ' .. sv_skillLine[1][2]
			else
				selectedSkillLine_abilities_name = notDiscovered
				selectedSkillLine_abilities_rank = ''
			end

		--------------------------------------------------------------------------------
		-- 2 skills
		--------------------------------------------------------------------------------
		elseif selected_skillType == SKILL_TYPE_WORLD and selected_skillLine == 4 then

			if sv_skillLine.discovered == true then
				selectedSkillLine_abilities_name =
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

				selectedSkillLine_abilities_rank =
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
				selectedSkillLine_abilities_name = notDiscovered
				selectedSkillLine_abilities_rank = ''
			end

		--------------------------------------------------------------------------------
		-- 5 skills
		--------------------------------------------------------------------------------
		elseif (selected_skillType == SKILL_TYPE_GUILD and (selected_skillLine == 2 or selected_skillLine == 3 or selected_skillLine == 6)) or
			(selected_skillType == SKILL_TYPE_AVA and (selected_skillLine == 1 or selected_skillLine == 3)) then

			if sv_skillLine.discovered == true then
				selectedSkillLine_abilities_name =
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

				selectedSkillLine_abilities_rank =
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
				selectedSkillLine_abilities_name = notDiscovered
				selectedSkillLine_abilities_rank = ''
			end

		--------------------------------------------------------------------------------
		-- 6 skills
		--------------------------------------------------------------------------------
		elseif selected_skillType == SKILL_TYPE_WEAPON or
			(selected_skillType == SKILL_TYPE_WORLD and (selected_skillLine == 5 or selected_skillLine == 6)) or
			(selected_skillType == SKILL_TYPE_GUILD and selected_skillLine == 4) then

			if sv_skillLine.discovered == true then
				selectedSkillLine_abilities_name =
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

				selectedSkillLine_abilities_rank =
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
				selectedSkillLine_abilities_name = notDiscovered
				selectedSkillLine_abilities_rank = ''
			end
		end

	end
end