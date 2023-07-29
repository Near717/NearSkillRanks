local addon = NEAR_SR
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

NEAR_SR.gui = {}

function NEAR_SR.gui.Init()
	addon.gui.CreateList_Char()
	addon.gui.CreateList_SkillType()
	addon.gui.CreateList_SkillLine()
	addon.gui.UpdateList_abilities()

	local control = GetControl("NSR_GUI_MAIN_skilldata_ShowSummary")
	control:SetText(GetString(NEARSR_quick))

	addon.gui.summary.CreateControls()
	addon.gui.summary.CreateLines()
	addon.gui.summary.CreateListChar()
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
---------------------------------------------------------------------------------
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
			'\n' ..
			'Name: ' .. sd_skillLine[1][0].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[1][1].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[1][2].name .. '\n' ..
			'\n' ..
			'Name: ' .. sd_skillLine[2][0].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[2][1].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[2][2].name .. '\n' ..
			'\n' ..
			'Name: ' .. sd_skillLine[3][0].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[3][1].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[3][2].name .. '\n' ..
			'\n' ..
			'Name: ' .. sd_skillLine[4][0].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[4][1].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[4][2].name .. '\n' ..
			'\n' ..
			'Name: ' .. sd_skillLine[5][0].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[5][1].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[5][2].name .. '\n' ..
			'\n' ..
			'Name: ' .. sd_skillLine[6][0].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[6][1].name .. '\n' .. tab ..
			'Name: ' .. sd_skillLine[6][2].name

			--------------------------------------------------

			selectedSkillLine_abilities_rank =
			'Lv: ' .. sv_skillLine.rank .. '\n' ..
			'\n' ..
			'Rank: ' .. sv_skillLine[1][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[1][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[1][2] .. '\n' ..
			'\n' ..
			'Rank: ' .. sv_skillLine[2][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[2][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[2][2] .. '\n' ..
			'\n' ..
			'Rank: ' .. sv_skillLine[3][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[3][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[3][2] .. '\n' ..
			'\n' ..
			'Rank: ' .. sv_skillLine[4][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[4][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[4][2] .. '\n' ..
			'\n' ..
			'Rank: ' .. sv_skillLine[5][0] .. '\n' ..
			'Rank: ' .. sv_skillLine[5][1] .. '\n' ..
			'Rank: ' .. sv_skillLine[5][2] .. '\n' ..
			'\n' ..
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
				'\n' ..
				'Name: ' .. sd_skillLine[1][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][2].name

				--------------------------------------------------

				selectedSkillLine_abilities_rank =
				'Lv: ' .. sv_skillLine.rank .. '\n' ..
				'\n' ..
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
				'\n' ..
				'Name: ' .. sd_skillLine[1][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][2].name .. '\n' ..
				'\n' ..
				'Name: ' .. sd_skillLine[2][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[2][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[2][2].name

				--------------------------------------------------

				selectedSkillLine_abilities_rank =
				'Lv: ' .. sv_skillLine.rank .. '\n' ..
				'\n' ..
				'Rank: ' .. sv_skillLine[1][0].. '\n' ..
				'Rank: ' .. sv_skillLine[1][1].. '\n' ..
				'Rank: ' .. sv_skillLine[1][2].. '\n' ..
				'\n' ..
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
				'\n' ..
				'Name: ' .. sd_skillLine[1][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][2].name .. '\n' ..
				'\n' ..
				'Name: ' .. sd_skillLine[2][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[2][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[2][2].name .. '\n' ..
				'\n' ..
				'Name: ' .. sd_skillLine[3][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[3][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[3][2].name .. '\n' ..
				'\n' ..
				'Name: ' .. sd_skillLine[4][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[4][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[4][2].name .. '\n' ..
				'\n' ..
				'Name: ' .. sd_skillLine[5][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[5][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[5][2].name

				--------------------------------------------------

				selectedSkillLine_abilities_rank =
				'Lv: ' .. sv_skillLine.rank .. '\n' ..
				'\n' ..
				'Rank: ' .. sv_skillLine[1][0].. '\n' ..
				'Rank: ' .. sv_skillLine[1][1].. '\n' ..
				'Rank: ' .. sv_skillLine[1][2].. '\n' ..
				'\n' ..
				'Rank: ' .. sv_skillLine[2][0].. '\n' ..
				'Rank: ' .. sv_skillLine[2][1].. '\n' ..
				'Rank: ' .. sv_skillLine[2][2].. '\n' ..
				'\n' ..
				'Rank: ' .. sv_skillLine[3][0].. '\n' ..
				'Rank: ' .. sv_skillLine[3][1].. '\n' ..
				'Rank: ' .. sv_skillLine[3][2].. '\n' ..
				'\n' ..
				'Rank: ' .. sv_skillLine[4][0].. '\n' ..
				'Rank: ' .. sv_skillLine[4][1].. '\n' ..
				'Rank: ' .. sv_skillLine[4][2].. '\n' ..
				'\n' ..
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
				'\n' ..
				'Name: ' .. sd_skillLine[1][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[1][2].name .. '\n' ..
				'\n' ..
				'Name: ' .. sd_skillLine[2][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[2][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[2][2].name .. '\n' ..
				'\n' ..
				'Name: ' .. sd_skillLine[3][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[3][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[3][2].name .. '\n' ..
				'\n' ..
				'Name: ' .. sd_skillLine[4][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[4][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[4][2].name .. '\n' ..
				'\n' ..
				'Name: ' .. sd_skillLine[5][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[5][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[5][2].name .. '\n' ..
				'\n' ..
				'Name: ' .. sd_skillLine[6][0].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[6][1].name .. '\n' .. tab ..
				'Name: ' .. sd_skillLine[6][2].name

				--------------------------------------------------

				selectedSkillLine_abilities_rank =
				'Lv: ' .. sv_skillLine.rank .. '\n' ..
				'\n' ..
				'Rank: ' .. sv_skillLine[1][0] .. '\n' ..
				'Rank: ' .. sv_skillLine[1][1] .. '\n' ..
				'Rank: ' .. sv_skillLine[1][2] .. '\n' ..
				'\n' ..
				'Rank: ' .. sv_skillLine[2][0] .. '\n' ..
				'Rank: ' .. sv_skillLine[2][1] .. '\n' ..
				'Rank: ' .. sv_skillLine[2][2] .. '\n' ..
				'\n' ..
				'Rank: ' .. sv_skillLine[3][0] .. '\n' ..
				'Rank: ' .. sv_skillLine[3][1] .. '\n' ..
				'Rank: ' .. sv_skillLine[3][2] .. '\n' ..
				'\n' ..
				'Rank: ' .. sv_skillLine[4][0] .. '\n' ..
				'Rank: ' .. sv_skillLine[4][1] .. '\n' ..
				'Rank: ' .. sv_skillLine[4][2] .. '\n' ..
				'\n' ..
				'Rank: ' .. sv_skillLine[5][0] .. '\n' ..
				'Rank: ' .. sv_skillLine[5][1] .. '\n' ..
				'Rank: ' .. sv_skillLine[5][2] .. '\n' ..
				'\n' ..
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


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- skill line summary functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

NEAR_SR.gui.summary = {}
local first_time = true
local selected_page = 1
---------------------------------------------------------------------------------

-- Show or hide the window
function NEAR_SR.gui.summary.ToggleWindow()
	NSR_SUM:ToggleHidden()
end

-- OnShow update window data
function NEAR_SR.gui.summary.OnShow()

	if first_time then
		-- add a margin bellow
		local control = GetControl("NSR_SUM")
		local current = control:GetHeight()
		control:SetHeight(current + 10)

		first_time = false
	end

	NEAR_SR.gui.summary.UpdateList(selected_page)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

function NEAR_SR.gui.summary.CreateListChar()

	for i, charData in ipairs(addon.charData) do
		local name = charData.charName

		local control = GetControl("NSR_SUM_MAIN_List_Row" .. i .. "_Name")
		control:SetText(name)

		if charData.charId == GetCurrentCharacterId() then
			local r, g, b, a = 0.4, 0.698, 1, 1
			control:SetColor(r,g,b,a) -- #66b2ff
		end

	end
end

function NEAR_SR.gui.summary.UpdateList(page)
	selected_page = page

	-- Determine which control to show based on the selected page
	local showPage1 = (page == 1)

	-- Show/hide the appropriate controls
	local controlSkills1 = GetControl("NSR_SUM_HEADER_Skills1")
	local controlSkills2 = GetControl("NSR_SUM_HEADER_Skills2")
	controlSkills1:SetHidden(not showPage1)
	controlSkills2:SetHidden(showPage1)

	-- Update page textures based on the selected page
	local controlPage1 = GetControl("NSR_SUM_PAGE_Page1")
	local controlPage2 = GetControl("NSR_SUM_PAGE_Page2")
	if showPage1 then
		controlPage1:SetNormalTexture("/esoui/art/guild/tabicon_roster_down.dds")
		controlPage2:SetNormalTexture("/esoui/art/guild/tabicon_roster_up.dds")
	else
		controlPage1:SetNormalTexture("/esoui/art/guild/tabicon_roster_up.dds")
		controlPage2:SetNormalTexture("/esoui/art/guild/tabicon_roster_down.dds")
	end

	-- Update controls information based on selected page
	addon.gui.summary.CreateList(page)

end

function NEAR_SR.gui.summary.CreateList(page)

	local function updateRanks(skillTypes)
		for i, charData in ipairs(addon.charData) do
			local charId = charData.charId
			local classId = charData.classId
			local i2 = 0

			for _, skillType in ipairs(skillTypes) do
				local charSkillData = addon.ASV.char[charId] and addon.ASV.char[charId][skillType]
            	if not charSkillData then
            	    charSkillData = {} -- Define an empty table if the data is not available
            	end

				for skillLineIndex = 1, t_skillLineMax[skillType] do
					local rank
					if skillType == SKILL_TYPE_CLASS then
						if charSkillData[classId] and charSkillData[classId][skillLineIndex] then
							rank = charSkillData[classId][skillLineIndex].discovered and charSkillData[classId][skillLineIndex].rank or "-"
						else
							rank = "NA"
						end
					else
						if charSkillData[skillLineIndex] then
							rank = charSkillData[skillLineIndex].discovered and charSkillData[skillLineIndex].rank or "-"
						else
							rank = "NA"
						end
					end

					local r, g, b, a
					if type(rank) == "number" then
						local skillLineMaxRank = addon.func.GetSkillLineMaxRank(skillType, skillLineIndex)
						local progress = rank / skillLineMaxRank
						if progress == 1 then
							r, g, b, a = 0.75, 0.75, 0.75, 1
						else
							r, g, b, a = 1 - progress, 0.7 * progress, 0, 1
						end
					else
						r, g, b, a = 0.267, 0.267, 0.267, 1
					end

					i2 = i2 + 1
					local control = GetControl("NSR_SUM_MAIN_List_Row" .. i .. "_Skill" .. i2)
					control:SetText(rank)
					control:SetColor(r,g,b,a)

					-- Exit the loop early if we've reached the end of the available skills
					if i2 == 19 then
						break
					end
				end
			end

			-- Clear remaining skill cells if fewer than 19 skills are present
			for i2 = i2 + 1, 19 do
				local control = GetControl("NSR_SUM_MAIN_List_Row" .. i .. "_Skill" .. i2)
				control:SetText("")
			end
		end
	end

	if page == 1 then
		local skillTypes = {SKILL_TYPE_CLASS, SKILL_TYPE_WEAPON, SKILL_TYPE_ARMOR, addon.SKILL_TYPE_TRADESKILL}
		updateRanks(skillTypes)
	elseif page == 2 then
		local skillTypes = {SKILL_TYPE_WORLD, SKILL_TYPE_GUILD, SKILL_TYPE_AVA}
		updateRanks(skillTypes)
	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

function NEAR_SR.gui.summary.CreateLines()

	for i = 0, 19 do
		local parent = "NSR_SUM_HEADER"
		local control = GetControl(parent)
		control:CreateControl(parent .. "_line" .. i, CT_LINE)

		control = control:GetNamedChild("_line" .. i)
		control:SetColor(0.267, 0.267, 0.267, 1.0)
		control:SetPixelRoundingEnabled(true)
		control:SetThickness(2)

		local offsetX = i == 0 and 200 or i * 30 + 200
		control:SetAnchor(TOPLEFT, GetControl("NSR_SUM_HEADER"), TOPLEFT, offsetX, 0)
		control:SetAnchor(BOTTOMLEFT, GetControl("NSR_SUM_MAIN"), BOTTOMLEFT, offsetX, 0)
	end

	for i = 0, #addon.charData do
		local parent = "NSR_SUM_MAIN"
		local control = GetControl(parent)
		control:CreateControl(parent .. "_line" .. i, CT_LINE)

		control = control:GetNamedChild("_line" .. i)
		control:SetColor(0.267, 0.267, 0.267, 1.0)
		control:SetPixelRoundingEnabled(true)
		control:SetThickness(2)

		local offsetY = i == 0 and 0 or i * 30
		control:SetAnchor(TOPLEFT, GetControl("NSR_SUM_MAIN"), TOPLEFT, 10, offsetY)
		control:SetAnchor(TOPRIGHT, GetControl("NSR_SUM_MAIN"), TOPRIGHT, 0, offsetY)
	end

end

function NEAR_SR.gui.summary.CreateControls()

	CreateControl("NSR_SUM_MAIN_".."List", GetControl("NSR_SUM_MAIN"), CT_CONTROL)
	local control = GetControl("NSR_SUM_MAIN_List")
    control:SetAnchor(TOPLEFT, GetControl("NSR_SUM_MAIN"), TOPLEFT, 0, 0)
	control:SetResizeToFitDescendents(true)

	local previous_control = control

	for i = 1, #addon.charData do
		CreateControl("NSR_SUM_MAIN_List_Row" .. i, GetControl("NSR_SUM_MAIN_List"), CT_CONTROL)

    	local targetControl = previous_control
    	local targetPos = i == 1 and TOPLEFT or BOTTOMLEFT
		local offsetX = i == 1 and 20 or 0
    	control = GetControl("NSR_SUM_MAIN_List_Row" .. i)
    	control:SetAnchor(TOPLEFT, targetControl, targetPos, offsetX, 0)
		control:SetResizeToFitDescendents(true)
		control:SetDimensionConstraints(0, 30)

		previous_control = control
	end

	previous_control = nil

	for i = 1, #addon.charData do
		CreateControl("NSR_SUM_MAIN_List_Row" .. i .. "_Name", GetControl("NSR_SUM_MAIN_List_Row" .. i), CT_LABEL)
		local targetControl = i == 1 and GetControl("NSR_SUM_MAIN_List_Row" .. i) or previous_control
    	local targetPos = i == 1 and TOPLEFT or BOTTOMLEFT
		control = GetControl("NSR_SUM_MAIN_List_Row" .. i .. "_Name")
    	control:SetAnchor(TOPLEFT, targetControl, targetPos, 0, 0)
		control:SetDimensions(180, 30)
		control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
		control:SetVerticalAlignment(TEXT_ALIGN_CENTER)
		control:SetFont("ZoFontGameMedium")

		previous_control = control

		local previous_control_skill = nil

		for i2 = 1, 19 do
			CreateControl("NSR_SUM_MAIN_List_Row" .. i .. "_Skill" .. i2, GetControl("NSR_SUM_MAIN_List_Row" .. i), CT_LABEL)
			targetControl = previous_control_skill or previous_control
			control = GetControl("NSR_SUM_MAIN_List_Row" .. i .. "_Skill" .. i2)
			control:SetAnchor(TOPLEFT, targetControl, TOPRIGHT, 0, 0)
			control:SetDimensions(30, 30)
			control:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
			control:SetVerticalAlignment(TEXT_ALIGN_CENTER)
			control:SetFont("ZoFontGameMedium")

			previous_control_skill = control
		end
	end

end
