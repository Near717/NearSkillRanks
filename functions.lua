NEAR_SR.func = {}
local addon = NEAR_SR
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

---@param skillLineId integer
---@param skillIndex luaindex
---@param morphChoice integer
---@return rank
function NEAR_SR.func.GetMorphInfo(skillLineId, skillIndex, morphChoice)
    local skillType, skillLineIndex = GetSkillLineIndicesFromSkillLineId(skillLineId)

    -- local abilityInfo = {}
    -- local aI = abilityInfo
    -- aI.name, aI.textureName, aI.earnedRank, aI.passive, aI.ultimate, aI.purchased, aI.progressionIndex, aI.rank = GetSkillAbilityInfo(skillType, skillLineIndex,skillIndex)

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
    SKILL_TYPE_RACIAL,
    SKILL_TYPE_TRADESKILL,
}


function NEAR_SR.func.UpdateData(skillType)
    local dbg = addon.utils.dbg
    local c = addon.utils.color

    local unitTag = "player"

    if skillType ~= SKILL_TYPE_CLASS then
        -- get the skill lines from that skill type
        for _, skillLine in ipairs(addon.skilldata[skillType]) do
            -- define skill line data

            local skillLineId = skillLine.id
            local skillLineName = skillLine.name
            local skillLineRank, skillLineDiscovered = addon.func.GetSkillLineInfo(skillLineId)

            d(
                c.white .. '----------------------------------------' .. "\n          " ..
                c.lightGrey .. "skillLineName: |r" .. skillLineName ..
                c.lightGrey .. " skillLineId: |r" .. skillLineId .. "\n          " ..
                c.lightGrey .. "skillLineRank: |r" .. skillLineRank ..
                c.lightGrey .. " skillLineDiscovered: |r" .. tostring(skillLineDiscovered) .. "\n          " ..
                c.white .. '----------------------------------------'
            )

            -- define ability data

            local skillIndex
            for i = 1, 6, 1 do
                if skillLine[i] ~= nil then
                    skillIndex = i

                    local morphName_0 = skillLine[i][0].name
                    local morphName_1 = skillLine[i][1].name
                    local morphName_2 = skillLine[i][2].name

                    local morphRank_0 = addon.func.GetMorphInfo(skillLineId, skillIndex, 0)
                    local morphRank_1 = addon.func.GetMorphInfo(skillLineId, skillIndex, 1)
                    local morphRank_2 = addon.func.GetMorphInfo(skillLineId, skillIndex, 2)

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
            end
        end
    else
        -- skillType == SKILL_TYPE_CLASS so we need to get the class id from the character

        local classId = GetUnitClassId(unitTag)

        -- get the skill lines from skill type class and specified class
        for _, skillLine in ipairs(addon.skilldata[skillType][classId]) do
            -- define skill line data

            local skillLineId = skillLine.id
            local skillLineName = skillLine.name
            local skillLineRank, skillLineDiscovered = addon.func.GetSkillLineInfo(skillLineId)

            d(
                c.white .. '----------------------------------------' .. "\n          " ..
                c.lightGrey .. "skillLineName: |r" .. skillLineName ..
                c.lightGrey .. " skillLineId: |r" .. skillLineId .. "\n          " ..
                c.lightGrey .. "skillLineRank: |r" .. skillLineRank ..
                c.lightGrey .. " skillLineDiscovered: |r" .. tostring(skillLineDiscovered) .. "\n          " ..
                c.white .. '----------------------------------------'
            )

            -- define ability data

            local skillIndex
            for i = 1, 6, 1 do
                if skillLine[i] ~= nil then
                    skillIndex = i

                    local morphName_0 = skillLine[i][0].name
                    local morphName_1 = skillLine[i][1].name
                    local morphName_2 = skillLine[i][2].name

                    local morphRank_0 = addon.func.GetMorphInfo(skillLineId, skillIndex, 0)
                    local morphRank_1 = addon.func.GetMorphInfo(skillLineId, skillIndex, 1)
                    local morphRank_2 = addon.func.GetMorphInfo(skillLineId, skillIndex, 2)

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
            end
        end
    end
end
