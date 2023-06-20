local strings = {
    NEARSR_nodata = 'There is no data for the selected character, please login there first.',
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end
