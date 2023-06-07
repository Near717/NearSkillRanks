NEAR_SR.func = {}
local addon = NEAR_SR
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
    for _, v in ipairs(t_skillType) do
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
