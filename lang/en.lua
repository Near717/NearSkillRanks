local strings = {
    SI_BINDING_NAME_NSR_toggle        = 'Toggle window',
    SI_BINDING_NAME_NSR_toggle2       = 'Toggle quick window',

    NEARSR_nodata			= 'No data is available for the selected character.\nPlease log in with that character first.',
    NEARSR_notdiscovered	= 'Skill line not discovered',

    NEARSR_quick            = 'Show skill line ranks quick list',
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end
