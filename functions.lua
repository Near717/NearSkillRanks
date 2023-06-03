NEAR_SR.func = {}
local addon = NEAR_SR
local gs = GetString()
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

---@param skillLineId integer
---@param skillIndex luaindex
---@param morphChoice integer
---@return rank
function NEAR_SR.func.GetMorphInfo(skillLineId, skillIndex, morphChoice)
    local skillType, skillLineIndex = GetSkillLineIndicesFromSkillLineId(skillLineId)

    local morphRank = GetSkillLineProgressionAbilityRank(skillType, skillLineIndex, skillIndex, morphChoice)

    return morphRank
end

---@param skillLineId integer
---@return rank luaindex, discovered boolean
function NEAR_SR.func.GetSkillLineInfo(skillLineId)
    local skillType, skillLineIndex = GetSkillLineIndicesFromSkillLineId(skillLineId)

    local skillLineInfo = {}
    local sL = skillLineInfo
    sL.rank, sL.advised, sL.active, sL.discovered = GetSkillLineDynamicInfo(skillType, skillLineIndex)
    -- sL.lastRankXP, sL.nextRankXP, sL.currentXP = GetSkillLineXPInfo(skillType, skillLineIndex)

    return sL.rank, sL.discovered
end

local t_skillType = {
    SKILL_TYPE_CLASS,
    SKILL_TYPE_WEAPON,
    SKILL_TYPE_ARMOR,
    SKILL_TYPE_WORLD,
    SKILL_TYPE_GUILD,
    SKILL_TYPE_AVA,
    -- SKILL_TYPE_RACIAL,
    SKILL_TYPE_TRADESKILL,
}

function NEAR_SR.func.UpdateAllData()
    addon.func.UpdateCharList()
    --Create the character select box.
	NEAR_SR.func.CreateCharList()

    for i, v in ipairs(t_skillType) do
        addon.func.UpdateData(v)
    end
end


function NEAR_SR.func.UpdateData(skillType)
    local funcName = 'Initialize'
    local dbg      = addon.utils.dbg
    local sv       = addon.ASV.settings
    local svc      = addon.ASV.char
    local c        = addon.utils.color

    --[[ Debug ]] if sv.debug then d(dbg.open) d(dbg.lightGrey .. 'start of ' .. funcName) end

    local unitTag = "player"

    if skillType ~= SKILL_TYPE_CLASS then
        -- get the skill lines from that skill type
        for skillLineIndex, skillLine in ipairs(addon.skilldata[skillType]) do
            -- define skill line data
            local skillLineId = skillLine.id
            local skillLineRank, skillLineDiscovered = addon.func.GetSkillLineInfo(skillLineId)

            --[[ Debug ]]
            if sv.debug then
                local skillLineName = skillLine.name
                d(
                    c.white .. '----------------------------------------' .. "\n          " ..
                    c.lightGrey .. "skillLineName: |r" .. skillLineName ..
                    c.lightGrey .. " skillLineId: |r" .. skillLineId .. "\n          " ..
                    c.lightGrey .. "skillLineRank: |r" .. skillLineRank ..
                    c.lightGrey .. " skillLineDiscovered: |r" .. tostring(skillLineDiscovered) .. "\n          " ..
                    c.white .. '----------------------------------------'
                )
            end

            local newskilldata = {
                rank = skillLineRank,
                discovered = skillLineDiscovered,
            }

            -- insert new SKILL data into saved variable > skillType > skillLine
            if type(skillLineIndex) == "number" then
                svc[skillType][skillLineIndex] = newskilldata
            end

            ----------------------------------------------------------------------------------------------------
            -- define ability data
            for i = 1, 6, 1 do
                if skillLine[i] ~= nil then
                    local skillIndex = i

                    local morphRank_0 = addon.func.GetMorphInfo(skillLineId, skillIndex, 0)
                    local morphRank_1 = addon.func.GetMorphInfo(skillLineId, skillIndex, 1)
                    local morphRank_2 = addon.func.GetMorphInfo(skillLineId, skillIndex, 2)

                    --[[ Debug ]]
                    if sv.debug then
                        local morphName_0 = skillLine[i][0].name
                        local morphName_1 = skillLine[i][1].name
                        local morphName_2 = skillLine[i][2].name
                        d(
                            c.grey .. '----------------------------------------' .. "\n          " ..
                            c.lightGrey .. "morphName_0: |r" .. morphName_0 ..
                            c.lightGrey .. " morphRank_0: |r" .. morphRank_0 .. "\n          " ..
                            c.lightGrey .. "morphName_1: |r" .. morphName_1 ..
                            c.lightGrey .. " morphRank_1: |r" .. morphRank_1 .. "\n          " ..
                            c.lightGrey .. "morphName_2: |r" .. morphName_2 ..
                            c.lightGrey .. " morphRank_2: |r" .. morphRank_2
                        )
                    end

                    local newabilitydata = {
                        [0] = morphRank_0,
                        [1] = morphRank_1,
                        [2] = morphRank_2,
                    }

                    -- insert new ABILITY data into saved variable > skillType > skillLine > skillIndex
                    svc[skillType][skillLineIndex][skillIndex] = newabilitydata
                end
            end
        end
    else -- skillType == SKILL_TYPE_CLASS so we need to get the class id from the character

        local classId = GetUnitClassId(unitTag)

        -- purge other classes from that character's info
        for key, _ in pairs(svc[skillType]) do
            if key ~= classId then
                svc[skillType][key] = nil
            end
        end

        -- get the skill lines from skill type class and specified class
        for skillLineIndex, skillLine in ipairs(addon.skilldata[skillType][classId]) do
            -- define skill line data
            local skillLineId = skillLine.id
            local skillLineRank, skillLineDiscovered = addon.func.GetSkillLineInfo(skillLineId)

            --[[ Debug ]]
            if sv.debug then
                local skillLineName = skillLine.name

                d(
                    c.white .. '----------------------------------------' .. "\n          " ..
                    c.lightGrey .. "skillLineName: |r" .. skillLineName ..
                    c.lightGrey .. " skillLineId: |r" .. skillLineId .. "\n          " ..
                    c.lightGrey .. "skillLineRank: |r" .. skillLineRank ..
                    c.lightGrey .. " skillLineDiscovered: |r" .. tostring(skillLineDiscovered) .. "\n          " ..
                    c.white .. '----------------------------------------'
                )
            end

            local newskilldata = {
                rank = skillLineRank,
                discovered = skillLineDiscovered,
            }

            -- insert new SKILL data into saved variable > charId > skillType > skillLine
            if type(skillLineIndex) == "number" then
                svc[skillType][classId][skillLineIndex] = newskilldata
            end

            ----------------------------------------------------------------------------------------------------
            -- define ability data
            for i = 1, 6, 1 do
                if skillLine[i] ~= nil then
                    local skillIndex = i

                    local morphRank_0 = addon.func.GetMorphInfo(skillLineId, skillIndex, 0)
                    local morphRank_1 = addon.func.GetMorphInfo(skillLineId, skillIndex, 1)
                    local morphRank_2 = addon.func.GetMorphInfo(skillLineId, skillIndex, 2)

                    --[[ Debug ]]
                    if sv.debug then
                        local morphName_0 = skillLine[i][0].name
                        local morphName_1 = skillLine[i][1].name
                        local morphName_2 = skillLine[i][2].name

                        d(
                            c.grey .. '----------------------------------------' .. "\n          " ..
                            c.lightGrey .. "morphName_0: |r" .. morphName_0 ..
                            c.lightGrey .. " morphRank_0: |r" .. morphRank_0 .. "\n          " ..
                            c.lightGrey .. "morphName_1: |r" .. morphName_1 ..
                            c.lightGrey .. " morphRank_1: |r" .. morphRank_1 .. "\n          " ..
                            c.lightGrey .. "morphName_2: |r" .. morphName_2 ..
                            c.lightGrey .. " morphRank_2: |r" .. morphRank_2
                        )
                    end

                    local newabilitydata = {
                        [0] = morphRank_0,
                        [1] = morphRank_1,
                        [2] = morphRank_2,
                    }

                    -- insert new ABILITY data into saved variable > charId > skillType > skillLine > skillIndex
                    svc[skillType][classId][skillLineIndex][skillIndex] = newabilitydata
                end
            end
        end
    end
    --[[ Debug ]] if sv.debug then d(dbg.grey .. 'end of ' .. funcName) d(dbg.close) end
end



-------------------------------------------------------------------------------------------------------------------------------------------------------------------
function NEAR_SR.func.UpdateCharList()
    local sv = addon.ASV.settings
    for i = 1, GetNumCharacters() do
        local name, _, _, classId, _, _, id, _ = GetCharacterInfo(i)
        sv.charInfo[i] = { charId = id, charName = zo_strformat("<<1>>", name), classId = classId, }
    end
end

local selectedChar = GetCurrentCharacterId()
addon.selectedChar_classId = GetUnitClassId('player')
local currentCharName = nil

local function SetSelectedChar(charName)
	for i = 1, #addon.charData do
		if charName == addon.charData[i].charName then
			selectedChar = addon.charData[i].charId
			break
		end
	end
end

function NEAR_SR.func.CreateCharList()
    local sv = addon.ASV.settings

	NSR_GUI_Header_CharList.comboBox = NSR_GUI_Header_CharList.comboBox or ZO_ComboBox_ObjectFromContainer(NSR_GUI_Header_CharList)
	local NSR_comboBox = NSR_GUI_Header_CharList.comboBox

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
			currentCharName = addon.charData[k].charName
			selectedChar = addon.charData[k].charId
            addon.selectedChar_classId = addon.charData[k].classId
		end
	end

	local function OnItemSelect(_, choiceText, choice)
		SetSelectedChar(choiceText)
		addon.gui.UpdateWindowData()
		-- PlaySound(SOUNDS.POSITIVE_CLICK)
	end

	NSR_comboBox:SetSortsItems(false)

	for k,_ in ipairs(addon.charNames) do
		NSR_comboBox:AddItem(NSR_comboBox:CreateItemEntry(addon.charNames[k], OnItemSelect))
		if addon.charNames[k] == currentCharName then
			NSR_comboBox:SetSelectedItem(addon.charNames[k])
		end
	end
end


function NEAR_SR.func.CreateSkillList()
    local classId = addon.selectedChar_classId

    -- local skillLineName = addon.skilldata[SKILL_TYPE_CLASS][classId][1].name
    --     NSR_GUI_Main_SkillType_1_SKILLLINE_1.label:SetText(skillLineName)
    -- skillLineName = addon.skilldata[SKILL_TYPE_CLASS][classId][2].name
    --     NSR_GUI_Main_SkillType_1_SKILLLINE_2.label:SetText(skillLineName)
    -- skillLineName = addon.skilldata[SKILL_TYPE_CLASS][classId][3].name
    --     NSR_GUI_Main_SkillType_1_SKILLLINE_3.label:SetText(skillLineName)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
NEAR_SR.gui = {}

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

function NEAR_SR.gui.GetText(skillType, skillLineIndex)
    if skillType == SKILL_TYPE_CLASS then
        local classId = addon.selectedChar_classId
        return NEAR_SR.skilldata[skillType][classId][skillLineIndex].name
    else
        return NEAR_SR.skilldata[skillType][skillLineIndex].name
    end
end

function NEAR_SR.gui.UpdateWindowData()
    d('UpdateWindowData')
    addon.func.CreateSkillList()
end


function NEAR_SR.gui.skilltype(skillType)
    d("NEAR_SR.gui.skilltype(): "..tostring(skillType))
    -- local controls = {
    --     [1] = NSR_GUI_Main_SkillType_1,
    --     [2] = NSR_GUI_Main_SkillType_2,
    --     [3] = NSR_GUI_Main_SkillType_3,
    --     [4] = NSR_GUI_Main_SkillType_4,
    --     [5] = NSR_GUI_Main_SkillType_5,
    --     [6] = NSR_GUI_Main_SkillType_6,
    --     [7] = NSR_GUI_Main_SkillType_7,
    --     [8] = NSR_GUI_Main_SkillType_8,
    -- }

    -- local color_normal = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_NORMAL))
    -- local color_selected = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))

    -- NSR_GUI_Main_SkillType_1.label:SetColor("FFefebbe")

    -- for key, control in ipairs(controls) do
    --     if skillType == key then
    --         control.label:SetColor(color_selected)
    --     else
    --         control.label:SetColor(color_normal)
    --     end
    -- end

end
