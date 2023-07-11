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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
local t_skillType = {
    SKILL_TYPE_CLASS,
    SKILL_TYPE_WEAPON,
    SKILL_TYPE_ARMOR,
    SKILL_TYPE_WORLD,
    SKILL_TYPE_GUILD,
    SKILL_TYPE_AVA,
    -- SKILL_TYPE_RACIAL,
    addon.SKILL_TYPE_TRADESKILL,
}

function NEAR_SR.func.Init()
    addon.func.UpdateCharList()
    for _, v in ipairs(t_skillType) do
        addon.func.CreateCharData(v)
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
function NEAR_SR.func.UpdateCharList()
    local sv = addon.ASV.settings
    for i = 1, GetNumCharacters() do
        local name, _, _, classId, _, _, id, _ = GetCharacterInfo(i)
        sv.charInfo[i] = { charId = id, charName = zo_strformat("<<1>>", name), classId = classId, }
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
function NEAR_SR.func.CreateCharData(skillType)
    local funcName = 'CreateCharData'
    local dbg      = addon.utils.dbg
    local sv       = addon.ASV.settings
    local c        = addon.utils.color

    --[[ Debug ]] if sv.debug then d(dbg.open) d(dbg.lightGrey .. 'start of ' .. funcName) end

    local charId = GetCurrentCharacterId()
    local classId = GetUnitClassId("player")

    -- if addon.ASV.char[charId] ~= nil and type(addon.ASV.char[charId][skillType]) == "table" then return end -- character already has data for this skilltype, exit early and use events to update later
    -- if type(addon.ASV.char[charId][skillType]) == "table" then return end -- character already has data for this skilltype, exit early and use events to update later

    addon.ASV.char[charId] = addon.defaults_char -- add default table for charId

    local svc = addon.ASV.char[charId]

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
            for skillIndex = 1, 6, 1 do
                if skillLine[skillIndex] ~= nil then

                    local morphRank_0 = addon.func.GetMorphInfo(skillLineId, skillIndex, 0)
                    local morphRank_1 = addon.func.GetMorphInfo(skillLineId, skillIndex, 1)
                    local morphRank_2 = addon.func.GetMorphInfo(skillLineId, skillIndex, 2)

                    --[[ Debug ]]
                    if sv.debug then
                        local morphName_0 = skillLine[skillIndex][0].name
                        local morphName_1 = skillLine[skillIndex][1].name
                        local morphName_2 = skillLine[skillIndex][2].name
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

        -- purge other classes from that character's info
        if svc[skillType] ~= nil then
            for key, _ in pairs(svc[skillType]) do
                if key ~= classId then
                    svc[skillType][key] = nil
                end
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
                local skillIndex = i
                -- if skillLine[i] ~= nil then

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
                -- end
            end
        end
    end
    --[[ Debug ]] if sv.debug then d(dbg.grey .. 'end of ' .. funcName) d(dbg.close) end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

function NEAR_SR.func.UpdateCharData(updatedRankType, skillType, skillLineIndex, skillIndex)
    local funcName = 'UpdateCharData'
    local dbg      = addon.utils.dbg
    local sv       = addon.ASV.settings
    local c        = addon.utils.color

    --[[ Debug ]] if sv.debug then d(dbg.open) d(dbg.lightGrey .. 'start of ' .. funcName) end

    local charId = GetCurrentCharacterId()
    local classId = GetUnitClassId("player")

    -- warn if trying to update but the tables are empty and exit early, otherwise continue
    if addon.ASV.char[charId] == nil then d(dbg.lightGrey .. 'Something went wrong trying to update character skill data, character table is empty') return end

    local svc = addon.ASV.char[charId]

    if skillType ~= SKILL_TYPE_CLASS then
        if updatedRankType == 'skillLine' then
            local skillLineRank, advised, active, skillLineDiscovered = GetSkillLineDynamicInfo(skillType, skillLineIndex)

            --[[ Debug ]]
            if sv.debug then
                d(
                    c.white .. '----------------------------------------' .. "\n          " ..
                    c.lightGrey .. "skillLineName: |r" .. addon.skilldata[skillType][skillLineIndex].name ..
                    c.lightGrey .. " skillLineId: |r" .. addon.skilldata[skillType][skillLineIndex].id .. "\n          " ..
                    c.lightGrey .. "skillLineRank: |r" .. skillLineRank ..
                    c.lightGrey .. " skillLineDiscovered: |r" .. tostring(skillLineDiscovered) .. "\n          " ..
                    c.white .. '----------------------------------------'
                )
            end

            -- overwrite SKILL data on saved variable > skillType > skillLine
            if type(skillLineIndex) == "number" then
                svc[skillType][skillLineIndex].rank = skillLineRank
                svc[skillType][skillLineIndex].discovered = skillLineDiscovered
            end

        elseif updatedRankType == 'morph' then
            local skillLineId = addon.skilldata[skillType][skillLineIndex].id

            local morphRank_0 = addon.func.GetMorphInfo(skillLineId, skillIndex, 0)
            local morphRank_1 = addon.func.GetMorphInfo(skillLineId, skillIndex, 1)
            local morphRank_2 = addon.func.GetMorphInfo(skillLineId, skillIndex, 2)

            --[[ Debug ]]
            if sv.debug then
                local morphName_0 = addon.skilldata[skillType][skillLineIndex][skillIndex][0].name
                local morphName_1 = addon.skilldata[skillType][skillLineIndex][skillIndex][1].name
                local morphName_2 = addon.skilldata[skillType][skillLineIndex][skillIndex][2].name
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

            -- overwrite ABILITY data on saved variable > skillType > skillLine > skillIndex
            if type(skillIndex) == "number" then
                svc[skillType][skillLineIndex][skillIndex] = newabilitydata
            end

        else d(dbg.lightGrey .. 'Something went wrong trying to define what to update, updatedRankType is undefined or not "skillLine" nor "morph"')
        end

    else -- skillType == SKILL_TYPE_CLASS so we need to get the class id from the character

        if updatedRankType == 'skillLine' then
            local skillLineRank, advised, active, skillLineDiscovered = GetSkillLineDynamicInfo(skillType, skillLineIndex)

            --[[ Debug ]]
            if sv.debug then
                d(
                    c.white .. '----------------------------------------' .. "\n          " ..
                    c.lightGrey .. "skillLineName: |r" .. addon.skilldata[skillType][classId][skillLineIndex].name ..
                    c.lightGrey .. " skillLineId: |r" .. addon.skilldata[skillType][classId][skillLineIndex].id .. "\n          " ..
                    c.lightGrey .. "skillLineRank: |r" .. skillLineRank ..
                    c.lightGrey .. " skillLineDiscovered: |r" .. tostring(skillLineDiscovered) .. "\n          " ..
                    c.white .. '----------------------------------------'
                )
            end

            -- overwrite SKILL data on saved variable > skillType > classId > skillLine
            if type(skillLineIndex) == "number" then
                svc[skillType][classId][skillLineIndex].rank = skillLineRank
                svc[skillType][classId][skillLineIndex].discovered = skillLineDiscovered
            end

        elseif updatedRankType == 'morph' then
            local skillLineId = addon.skilldata[skillType][classId][skillLineIndex].id

            local morphRank_0 = addon.func.GetMorphInfo(skillLineId, skillIndex, 0)
            local morphRank_1 = addon.func.GetMorphInfo(skillLineId, skillIndex, 1)
            local morphRank_2 = addon.func.GetMorphInfo(skillLineId, skillIndex, 2)

            --[[ Debug ]]
            if sv.debug then
                local morphName_0 = addon.skilldata[skillType][classId][skillLineIndex][skillIndex][0].name
                local morphName_1 = addon.skilldata[skillType][classId][skillLineIndex][skillIndex][1].name
                local morphName_2 = addon.skilldata[skillType][classId][skillLineIndex][skillIndex][2].name
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

            -- overwrite ABILITY data on saved variable > skillType > classId > skillLine > skillIndex
            if type(skillIndex) == "number" then
                svc[skillType][classId][skillLineIndex][skillIndex] = newabilitydata
            end

        else d(dbg.lightGrey .. 'Something went wrong trying to define what to update, updatedRankType is undefined or not "skillLine" nor "morph"')
        end

    end

    --[[ Debug ]] if sv.debug then d(dbg.grey .. 'end of ' .. funcName) d(dbg.close) end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
function NEAR_SR.func.OnMorphRankUpdate(event, progressionIndex, rank, maxRank, morph)
    local skillType, skillLineIndex, skillIndex = GetSkillAbilityIndicesFromProgressionIndex(progressionIndex)

    addon.func.UpdateCharData('morph', skillType, skillLineIndex, skillIndex)
end

function NEAR_SR.func.OnSkillRankUpdate(event, skillType, skillLineIndex, skillLineRank)
    if skillType == SKILL_TYPE_RACIAL then return end -- racial is not being tracked so exit early
    if skillType == SKILL_TYPE_TRADESKILL then skillType = addon.SKILL_TYPE_TRADESKILL end
    addon.func.UpdateCharData('skillLine', skillType, skillLineIndex)
end

function NEAR_SR.func.OnSkillLineAdded(event, skillType, skillLineIndex, advised)
    if skillType == SKILL_TYPE_RACIAL then return end -- racial is not being tracked so exit early
    if skillType == SKILL_TYPE_TRADESKILL then skillType = addon.SKILL_TYPE_TRADESKILL end
    addon.func.UpdateCharData('skillLine', skillType, skillLineIndex)
end
