local strings = {
    SI_BINDING_NAME_NSR_toggle        = 'Toggle window',

    NEARSR_nodata			= 'There is no data for the selected character, please login there first.',
    NEARSR_notdiscovered	= 'Skill line not discovered',
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end
