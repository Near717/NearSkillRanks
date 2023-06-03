local strings = {
    SI_BINDING_NAME_NSR_toggle        = 'Toggle window',
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end
