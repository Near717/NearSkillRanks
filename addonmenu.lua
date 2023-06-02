local addon = NEAR_SR

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Addon settings panel
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
function NEAR_SR.SetupSettings()
	local LAM2 = LibAddonMenu2
	local color = addon.utils.color
	local sv = addon.ASV.settings

	local panelData = {
		type				= "panel",
		name 				= addon.title,
		displayName 		= addon.title,
		author 				= addon.author,
		version				= addon.version,
		slashCommand 		= "/sr",
		registerForRefresh	= true,
		registerForDefaults	= true,
	}
	LAM2:RegisterAddonPanel(addon.name, panelData)

	local optionsTable = {
        {
            type = 'header',
            name = 'Debug',
        },
        {
            type = 'checkbox',
            name = 'Debug',
            getFunc = function() return sv.debug end,
            setFunc = function(v) sv.debug = v end,
            default = addon.defaults.debug,
        },
    }
	LAM2:RegisterOptionControls(addon.name, optionsTable)

end
